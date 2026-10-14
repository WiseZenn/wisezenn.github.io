# =============================================================================
# WiseZenn's Blog - Upload Staged Images To The CDN Repository
# Pushes files from _cdn-assets/<slug>/ to WiseZenn/Blog-assets, replacing the
# manual drag-into-PicGo step. Three backends:
#   -Via Api   GitHub Contents API through gh (no PicGo needed, full path control)
#   -Via Gui   the running PicGo GUI, driven through its local HTTP server
#   -Via Cli   the picgo CLI, with a per-run config pinning the target folder
# =============================================================================

param(
    [string]$Slug,   # upload a single _cdn-assets/<slug>/ folder
    [switch]$All,    # upload every folder under _cdn-assets/
    [switch]$Force,  # overwrite files that already exist in the repository
    [switch]$List,   # only report what would happen, upload nothing
    [ValidateSet("Api", "Gui", "Cli")][string]$Via = "Api",
    [string]$PicGoServer = "http://127.0.0.1:36677",
    [switch]$AllowAnyPath # PicGo mode: accept the GUI's configured folder as-is
)

$ErrorActionPreference = "Stop"
$ProjectRoot = Split-Path -Parent $PSScriptRoot
$StagingDir = Join-Path $ProjectRoot "_cdn-assets"

$AssetRepo = "WiseZenn/Blog-assets"
$AssetBranch = "main"
$CdnBase = "https://cdn.jsdelivr.net/gh/$AssetRepo@$AssetBranch"
$PicGoData = Join-Path $env:APPDATA "picgo\data.json"

# --- GitHub API backend ----------------------------------------------------

function Assert-GhReady {
    if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
        throw "GitHub CLI (gh) not found in PATH. Install it, or use -Via Gui / -Via Cli."
    }
    $null = gh auth status 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "gh is not authenticated. Run 'gh auth login' first."
    }
}

# Returns @{ name = sha } for every file already in the remote folder.
# A missing folder (404) yields an empty map: nothing has been uploaded yet.
function Get-RemoteIndex {
    param([string]$Folder)

    $previous = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    try {
        $json = gh api "repos/$AssetRepo/contents/${Folder}?ref=$AssetBranch" 2>$null
        if ($LASTEXITCODE -ne 0 -or -not $json) { return @{} }

        $index = @{}
        foreach ($entry in ($json | ConvertFrom-Json)) {
            if ($entry.type -eq "file") { $index[$entry.name] = $entry.sha }
        }
        return $index
    }
    finally {
        $ErrorActionPreference = $previous
    }
}

function Push-FileViaApi {
    param(
        [string]$LocalPath,
        [string]$Folder,
        [string]$Name,
        [string]$Sha
    )

    $payload = @{
        message = "Add $Folder/$Name"
        content = [Convert]::ToBase64String([System.IO.File]::ReadAllBytes($LocalPath))
        branch  = $AssetBranch
    }
    if ($Sha) { $payload.sha = $Sha }

    # The Contents API needs the body as JSON; a 100 KB screenshot base64-encodes
    # past the Windows command-line limit, so it goes through a temp file.
    $bodyPath = Join-Path ([System.IO.Path]::GetTempPath()) ("gh-upload-" + [guid]::NewGuid().ToString("N") + ".json")
    try {
        [System.IO.File]::WriteAllText(
            $bodyPath,
            ($payload | ConvertTo-Json -Compress),
            [System.Text.UTF8Encoding]::new($false)
        )
        gh api --method PUT "repos/$AssetRepo/contents/$Folder/$Name" --input $bodyPath | Out-Null
        return ($LASTEXITCODE -eq 0)
    }
    finally {
        Remove-Item $bodyPath -Force -ErrorAction SilentlyContinue
    }
}

# --- PicGo backend ---------------------------------------------------------

# Reads the GUI's uploader settings. The token lives in this file too; it is
# never printed, only kept in memory for the comparison below.
function Get-PicGoConfig {
    if (-not (Test-Path $PicGoData)) {
        throw "找不到 PicGo 配置：$PicGoData（PicGo 装过并且运行过一次才会有）"
    }
    $data = Get-Content $PicGoData -Raw -Encoding UTF8 | ConvertFrom-Json
    $bed = $data.picBed
    if ($bed.current -ne "github") {
        throw "PicGo 当前图床是 '$($bed.current)'，不是 github。请在 PicGo 里切换图床。"
    }
    return [pscustomobject]@{
        Repo      = $bed.github.repo
        Branch    = $bed.github.branch
        Path      = "$($bed.github.path)".Trim()
        CustomUrl = "$($bed.github.customUrl)".TrimEnd("/")
    }
}

function Assert-PicGoReady {
    param([string]$Folder)

    # The server answers 500 for an empty list, so any HTTP reply means it is up.
    try {
        $null = Invoke-WebRequest -Uri "$PicGoServer/upload" -Method Post -Body '{"list":[]}' `
            -ContentType "application/json" -TimeoutSec 8 -SkipHttpErrorCheck
    }
    catch {
        throw "PicGo 的 HTTP 服务没响应（$PicGoServer）。确认 PicGo 正在运行，且「设置 → 服务端」是开启状态。"
    }

    $config = Get-PicGoConfig
    if ($config.Repo -ne $AssetRepo) {
        throw "PicGo 配的仓库是 $($config.Repo)，脚本期望 $AssetRepo。"
    }

    $configured = $config.Path.Trim("/")
    $expected = $Folder.Trim("/")
    if ($configured -ne $expected) {
        if (-not $AllowAnyPath) {
            throw @"
PicGo 的存储路径是 '$configured'，但这次要传的是 '$expected'。
请在 PicGo「图床设置 → GitHub → 设定存储路径」里改成 '$expected'，然后重跑。
（确认就要传到 '$configured' 的话，加 -AllowAnyPath。）
"@
        }
        Write-Host "[WARN] PicGo 存储路径为 '$configured'，与 slug '$expected' 不一致（已用 -AllowAnyPath 放行）。" -ForegroundColor Yellow
    }
    return $config
}

function Invoke-PicGoGuiUpload {
    param([string[]]$Files)

    $body = @{ list = $Files } | ConvertTo-Json -Compress
    $response = Invoke-RestMethod -Uri "$PicGoServer/upload" -Method Post -Body $body `
        -ContentType "application/json" -TimeoutSec 180
    if (-not $response.success) {
        throw "PicGo 上传失败：$($response.message)"
    }
    return @($response.result)
}

# picgo-core keeps its own config, separate from the GUI's data.json. We derive
# one per run so the GUI stays the single place the token is maintained, and so
# the storage path can follow the slug instead of being edited by hand.
# The token is copied in memory and never written to the console.
function New-PicGoCliConfig {
    param([string]$Folder)

    $gui = Get-Content $PicGoData -Raw -Encoding UTF8 | ConvertFrom-Json
    $gh = $gui.picBed.github

    $config = [ordered]@{
        picBed = [ordered]@{
            uploader = "github"
            current  = "github"
            github   = [ordered]@{
                repo      = $gh.repo
                branch    = $gh.branch
                token     = $gh.token
                path      = "$Folder/"
                customUrl = $gh.customUrl
            }
        }
        picgoPlugins = [ordered]@{}
    }

    $path = Join-Path ([System.IO.Path]::GetTempPath()) "picgo-blog-automation.json"
    [System.IO.File]::WriteAllText($path, ($config | ConvertTo-Json -Depth 6), [System.Text.UTF8Encoding]::new($false))
    return $path
}

function Invoke-PicGoCliUpload {
    param([string[]]$Files, [string]$ConfigPath)

    if (-not (Get-Command picgo -ErrorAction SilentlyContinue)) {
        throw "PATH 里没有 picgo。安装：npm install -g picgo（安装后重开终端）。"
    }

    $output = & picgo upload @Files -c $ConfigPath --format json 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "picgo upload 执行失败（exit $LASTEXITCODE）：`n$($output -join "`n")"
    }

    # Progress lines can share stdout with the JSON, so take the last object.
    $text = ($output | Out-String)
    $start = $text.IndexOf("{")
    $end = $text.LastIndexOf("}")
    if ($start -lt 0 -or $end -le $start) {
        throw "无法从 picgo 的输出里解析 JSON：`n$text"
    }
    $parsed = $text.Substring($start, $end - $start + 1) | ConvertFrom-Json

    if ($parsed.result) { return @($parsed.result) }
    if ($parsed.url) { return @($parsed.url) }
    throw "picgo 返回里没有找到上传结果：`n$text"
}

# --- Main ------------------------------------------------------------------

Push-Location $ProjectRoot
try {
    # A crashed run could leave the generated config behind; it holds a token.
    $staleConfig = Join-Path ([System.IO.Path]::GetTempPath()) "picgo-blog-automation.json"
    if (Test-Path $staleConfig) { Remove-Item $staleConfig -Force }

    if ($Slug) {
        $folders = @($Slug)
    }
    elseif ($All) {
        $folders = @(Get-ChildItem $StagingDir -Directory | Select-Object -ExpandProperty Name)
    }
    else {
        throw "Specify a folder with -Slug <name>, or use -All to scan every folder under _cdn-assets/."
    }

    if ($Via -eq "Api") { Assert-GhReady }

    $uploaded = @()
    $skipped = @()
    $failed = @()

    foreach ($folder in $folders) {
        $localDir = Join-Path $StagingDir $folder
        if (-not (Test-Path $localDir)) { throw "Staging folder not found: $localDir" }

        $files = @(Get-ChildItem $localDir -File | Sort-Object Name)
        if ($files.Count -eq 0) {
            Write-Host "[WARN] $folder is empty, nothing to upload." -ForegroundColor Yellow
            continue
        }

        if ($Via -eq "Gui" -or $Via -eq "Cli") {
            $fullPaths = @($files | Select-Object -ExpandProperty FullName)

            if ($Via -eq "Gui") {
                $config = Assert-PicGoReady -Folder $folder
                Write-Host "`n[$folder] $($files.Count) file(s) via PicGo GUI -> $($config.Repo)/$($config.Path)" -ForegroundColor Cyan
            }
            else {
                $config = Get-PicGoConfig
                if ($config.Repo -ne $AssetRepo) {
                    throw "PicGo 配的仓库是 $($config.Repo)，脚本期望 $AssetRepo。"
                }
                Write-Host "`n[$folder] $($files.Count) file(s) via picgo CLI -> $AssetRepo/$folder/" -ForegroundColor Cyan
            }

            if ($List) {
                foreach ($file in $files) { Write-Host "  [LIST] would upload $($file.Name)" -ForegroundColor Yellow }
                continue
            }

            $configPath = $null
            try {
                if ($Via -eq "Cli") {
                    $configPath = New-PicGoCliConfig -Folder $folder
                    $urls = Invoke-PicGoCliUpload -Files $fullPaths -ConfigPath $configPath
                }
                else {
                    $urls = Invoke-PicGoGuiUpload -Files $fullPaths
                }
            }
            finally {
                if ($configPath -and (Test-Path $configPath)) { Remove-Item $configPath -Force }
            }

            $i = 0
            foreach ($file in $files) {
                $url = if ($i -lt $urls.Count) { $urls[$i] } else { $null }
                $i++
                if ($url) {
                    Write-Host "  [OK]   $($file.Name)" -ForegroundColor Green
                    Write-Host "         $url" -ForegroundColor DarkGray
                    $uploaded += "$folder/$($file.Name)"
                }
                else {
                    Write-Host "  [FAIL] $($file.Name)" -ForegroundColor Red
                    $failed += "$folder/$($file.Name)"
                }
            }
            continue
        }

        # --- GitHub API path ---
        $remote = Get-RemoteIndex -Folder $folder
        Write-Host "`n[$folder] local $($files.Count) file(s), remote $($remote.Count) file(s)" -ForegroundColor Cyan

        foreach ($file in $files) {
            $name = $file.Name
            $exists = $remote.ContainsKey($name)

            if ($exists -and -not $Force) {
                Write-Host "  [SKIP] $name (already on the CDN)" -ForegroundColor DarkGray
                $skipped += "$folder/$name"
                continue
            }

            if ($List) {
                $action = if ($exists) { "would overwrite" } else { "would upload" }
                Write-Host "  [LIST] $name - $action" -ForegroundColor Yellow
                continue
            }

            $verb = if ($exists) { "overwriting" } else { "uploading" }
            Write-Host "  ... $verb $name" -ForegroundColor Gray
            $sha = if ($exists) { $remote[$name] } else { $null }

            if (Push-FileViaApi -LocalPath $file.FullName -Folder $folder -Name $name -Sha $sha) {
                Write-Host "  [OK]   $name" -ForegroundColor Green
                $uploaded += "$folder/$name"
            }
            else {
                Write-Host "  [FAIL] $name" -ForegroundColor Red
                $failed += "$folder/$name"
            }
        }
    }

    if ($List) {
        Write-Host "`n[INFO] Dry run only, nothing was uploaded." -ForegroundColor Yellow
        exit 0
    }

    # Authoritative check: the API listing, not the CDN (jsDelivr caches 404s).
    $missing = @()
    foreach ($folder in ($folders | Select-Object -Unique)) {
        $localDir = Join-Path $StagingDir $folder
        if (-not (Test-Path $localDir)) { continue }
        $remote = Get-RemoteIndex -Folder $folder
        foreach ($file in (Get-ChildItem $localDir -File)) {
            if (-not $remote.ContainsKey($file.Name)) { $missing += "$folder/$($file.Name)" }
        }
    }

    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host " Uploaded: $($uploaded.Count)   Skipped: $($skipped.Count)   Failed: $($failed.Count)" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan

    if ($uploaded.Count -gt 0 -and $Via -eq "Api") {
        Write-Host "`n[INFO] New CDN URLs (jsDelivr may need a few minutes on first request):" -ForegroundColor Yellow
        foreach ($path in $uploaded) { Write-Host "  $CdnBase/$path" -ForegroundColor Gray }
    }
    if ($uploaded.Count -gt 0 -and $Via -ne "Api") {
        Write-Host "`n[INFO] PicGo 已返回每个文件的 CDN 地址（见上）。若文件名被重命名插件改过，记得同步更新文章里的链接。" -ForegroundColor Yellow
    }

    if ($missing.Count -gt 0) {
        Write-Host "`n[ERROR] These files are still missing from the repository:" -ForegroundColor Red
        foreach ($path in $missing) { Write-Host "  $path" -ForegroundColor Red }
        exit 1
    }

    if ($failed.Count -gt 0) { exit 1 }
    Write-Host "`n[OK] Repository matches _cdn-assets for the checked folder(s)." -ForegroundColor Green
}
finally {
    Pop-Location
}
