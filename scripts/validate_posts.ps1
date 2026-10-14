# =============================================================================
# WiseZenn's Blog - Pre-Publish Post Validation
# Catches the failure modes that are invisible until the page is live:
# unescaped kramdown pipes, truncated link targets, missing CDN images,
# broken en/zh pairing, duplicate series_order, future dates Jekyll skips.
# =============================================================================

param(
    [string[]]$Paths,   # explicit post files; defaults to all of _posts/*.md
    [switch]$Changed,   # only posts touched in the working tree
    [switch]$CheckImages, # verify every CDN image exists in WiseZenn/Blog-assets
    [switch]$Quiet      # only print the summary
)

$ErrorActionPreference = "Stop"
$ProjectRoot = Split-Path -Parent $PSScriptRoot
$PostsDir = Join-Path $ProjectRoot "_posts"

$AssetRepo = "WiseZenn/Blog-assets"
$AssetBranch = "main"
$CdnImagePattern = "^https://cdn\.jsdelivr\.net/gh/$([regex]::Escape($AssetRepo))@$AssetBranch/(.+)$"

$RequiredKeys = @("layout", "title", "date", "categories", "tags", "description", "lang", "lang-ref")
$Issues = New-Object System.Collections.Generic.List[object]

function Add-Issue {
    param(
        [ValidateSet("ERROR", "WARN")][string]$Level,
        [string]$File,
        [string]$Rule,
        [string]$Message,
        [int]$Line = 0
    )
    $Issues.Add([pscustomobject]@{
        Level = $Level; File = $File; Line = $Line; Rule = $Rule; Message = $Message
    })
}

function Get-ChangedPostFiles {
    $previous = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    try {
        $files = @()
        $files += git diff --name-only 2>$null
        $files += git diff --name-only --cached 2>$null
        $files += git ls-files --others --exclude-standard 2>$null
        return $files |
            Where-Object { $_ -match "^_posts/.*\.md$" } |
            ForEach-Object { Join-Path $ProjectRoot $_ } |
            Where-Object { Test-Path $_ } |
            Sort-Object -Unique
    }
    finally {
        $ErrorActionPreference = $previous
    }
}

# --- Per-file checks -------------------------------------------------------

function Test-PostFile {
    param([string]$Path)

    $name = Split-Path $Path -Leaf
    $lines = [System.IO.File]::ReadAllLines($Path, [System.Text.UTF8Encoding]::new($false))

    if ($lines.Count -eq 0 -or $lines[0].Trim() -ne "---") {
        Add-Issue ERROR $name "frontmatter" "文件开头不是 YAML frontmatter（第一行应为 ---）"
        return
    }

    $end = -1
    for ($i = 1; $i -lt $lines.Count; $i++) {
        if ($lines[$i].Trim() -eq "---") { $end = $i; break }
    }
    if ($end -lt 0) {
        Add-Issue ERROR $name "frontmatter" "frontmatter 没有闭合的 ---"
        return
    }

    # --- frontmatter ---
    $meta = @{}
    for ($i = 1; $i -lt $end; $i++) {
        if ($lines[$i] -match "^([A-Za-z_][A-Za-z0-9_-]*):\s*(.*)$") {
            $meta[$Matches[1]] = $Matches[2].Trim()
        }
    }

    foreach ($key in $RequiredKeys) {
        if (-not $meta.ContainsKey($key) -or [string]::IsNullOrWhiteSpace($meta[$key])) {
            Add-Issue ERROR $name "frontmatter" "缺少必需字段：$key"
        }
    }

    if ($meta.ContainsKey("lang") -and $meta["lang"] -notin @("en", "zh")) {
        Add-Issue ERROR $name "frontmatter" "lang 只能是 en 或 zh，当前为 '$($meta['lang'])'"
    }

    if ($meta.ContainsKey("date")) {
        $dateRaw = $meta["date"].Trim('"').Trim("'")
        if ($dateRaw -notmatch "^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} [+-]\d{4}$") {
            Add-Issue ERROR $name "frontmatter" "date 格式应为 YYYY-MM-DD HH:MM:SS +0800，当前为 '$dateRaw'"
        }
        else {
            $parsed = [datetimeoffset]::ParseExact($dateRaw, "yyyy-MM-dd HH:mm:ss zzz", $null)
            if ($parsed -gt [datetimeoffset]::Now) {
                Add-Issue WARN $name "frontmatter" "date 在未来（$dateRaw），Jekyll 会静默跳过这篇文章"
            }
        }
    }

    if ($meta.ContainsKey("title")) {
        $titleRaw = $meta["title"]
        $unquoted = $titleRaw -notmatch '^".*"$' -and $titleRaw -notmatch "^'.*'$"
        if ($unquoted -and $titleRaw -match ": ") {
            Add-Issue ERROR $name "frontmatter" "title 含冒号但没加引号，YAML 会解析失败"
        }
    }

    $hasSeries = $meta.ContainsKey("series_key") -and $meta["series_key"]
    $hasOrder = $meta.ContainsKey("series_order") -and $meta["series_order"]
    if ($hasSeries -and -not $hasOrder) {
        Add-Issue WARN $name "frontmatter" "有 series_key 但没有 series_order"
    }
    if ($hasOrder -and -not $hasSeries) {
        Add-Issue WARN $name "frontmatter" "有 series_order 但没有 series_key"
    }
    if ($hasOrder -and $meta["series_order"] -notmatch "^\d+$") {
        Add-Issue ERROR $name "frontmatter" "series_order 必须是整数，当前为 '$($meta['series_order'])'"
    }

    if ($meta.ContainsKey("description")) {
        $desc = $meta["description"].Trim('"').Trim("'")
        $limit = if ($meta["lang"] -eq "zh") { 60 } else { 20 }
        $count = if ($meta["lang"] -eq "zh") { $desc.Length } else { ($desc -split "\s+").Count }
        if ($count -gt $limit) {
            $unit = if ($meta["lang"] -eq "zh") { "字" } else { "词" }
            Add-Issue WARN $name "frontmatter" "description 偏长（$count $unit，建议不超过 $limit）"
        }
    }

    # --- body ---
    $inFence = $false
    for ($i = $end + 1; $i -lt $lines.Count; $i++) {
        $lineNumber = $i + 1
        $line = $lines[$i]

        if ($line -match '^\s*```') { $inFence = -not $inFence; continue }
        if ($inFence) { continue }

        # Inline code is literal; ignore it so examples do not trip the rules.
        $probe = [regex]::Replace($line, '`[^`]*`', "")

        foreach ($m in [regex]::Matches($probe, "(!?)\[([^\]]*)\]\(([^)]+)\)")) {
            $isImage = $m.Groups[1].Value -eq "!"
            $text = $m.Groups[2].Value
            $target = $m.Groups[3].Value.Trim()
            $url = ($target -split "\s+")[0]

            if ($text -match "(?<!\\)\|") {
                Add-Issue ERROR $name "kramdown-pipe" "链接文本里的 | 没有转义，kramdown 会当成表格分隔符" $lineNumber
            }

            if ($isImage) {
                if ($url -notmatch "^https?://") {
                    Add-Issue ERROR $name "image-local-path" "图片还在引用本地路径：$url" $lineNumber
                }
                elseif ($url -match "cdn\.jsdelivr\.net" -and $url -notmatch $CdnImagePattern) {
                    Add-Issue WARN $name "image-cdn-path" "jsDelivr 链接不符合本仓库图床格式：$url" $lineNumber
                }
            }
            else {
                if ($url -notmatch "^(https?://|mailto:|#|/)") {
                    Add-Issue ERROR $name "link-target" "链接目标不是合法 URL（是否被截断？）：$url" $lineNumber
                }
            }
        }
    }

    # A post scaffolded by new-post.ps1 starts as a placeholder; publishing it
    # as-is would put an empty page online.
    $bodyStart = $end + 1
    $bodyLines = if ($bodyStart -le $lines.Count - 1) { @($lines[$bodyStart..($lines.Count - 1)]) } else { @() }
    $bodyText = [regex]::Replace(($bodyLines -join "`n"), "<!--.*?-->", "", "Singleline").Trim()
    if (-not $bodyText) {
        Add-Issue WARN $name "empty-body" "正文为空或只剩占位注释，确认内容是否已经写完"
    }
}

# --- Cross-file checks -----------------------------------------------------

function Test-PostSet {
    param([string[]]$Files)

    $byRef = @{}
    $bySeriesOrder = @{}

    foreach ($path in $Files) {
        $name = Split-Path $path -Leaf
        $lines = [System.IO.File]::ReadAllLines($path, [System.Text.UTF8Encoding]::new($false))
        if ($lines.Count -eq 0 -or $lines[0].Trim() -ne "---") { continue }

        $end = -1
        for ($i = 1; $i -lt $lines.Count; $i++) {
            if ($lines[$i].Trim() -eq "---") { $end = $i; break }
        }
        if ($end -lt 0) { continue }

        $meta = @{}
        for ($i = 1; $i -lt $end; $i++) {
            if ($lines[$i] -match "^([A-Za-z_][A-Za-z0-9_-]*):\s*(.*)$") {
                $meta[$Matches[1]] = $Matches[2].Trim()
            }
        }

        $entry = [pscustomobject]@{
            File   = $name
            Series = $meta["series_key"]
            Order  = $meta["series_order"]
        }

        if ($meta["lang-ref"]) {
            $ref = $meta["lang-ref"].Trim('"').Trim("'")
            if (-not $byRef.ContainsKey($ref)) { $byRef[$ref] = @{} }
            $lang = $meta["lang"]
            if ($lang) {
                if ($byRef[$ref].ContainsKey($lang)) {
                    Add-Issue ERROR $name "lang-ref-duplicate" "lang-ref '$ref' 在 $lang 版本中重复（另一个是 $($byRef[$ref][$lang].File)）"
                }
                else {
                    $byRef[$ref][$lang] = $entry
                }
            }
        }

        # The en/zh pair of one article shares a series slot on purpose, so the
        # conflict check is per language: two different zh posts cannot both be #5.
        if ($meta["series_key"] -and $meta["series_order"] -match "^\d+$") {
            $slot = "$($meta['series_key'])#$($meta['series_order'])#$($meta['lang'])"
            if ($bySeriesOrder.ContainsKey($slot)) {
                Add-Issue ERROR $name "series-order-duplicate" "系列 $($meta['series_key']) 的 series_order=$($meta['series_order']) 在 $($meta['lang']) 版本中已被 $($bySeriesOrder[$slot]) 占用"
            }
            else {
                $bySeriesOrder[$slot] = $name
            }
        }
    }

    foreach ($ref in $byRef.Keys) {
        $langs = $byRef[$ref]
        if ($langs.ContainsKey("zh") -and -not $langs.ContainsKey("en")) {
            Add-Issue WARN $langs["zh"].File "lang-ref-pairing" "lang-ref '$ref' 只有中文版，缺英文版"
        }
        elseif ($langs.ContainsKey("en") -and -not $langs.ContainsKey("zh")) {
            Add-Issue WARN $langs["en"].File "lang-ref-pairing" "lang-ref '$ref' 只有英文版，缺中文版"
        }
        elseif ($langs.ContainsKey("en") -and $langs.ContainsKey("zh")) {
            $en = $langs["en"]
            $zh = $langs["zh"]
            if ($en.Series -ne $zh.Series -or $en.Order -ne $zh.Order) {
                Add-Issue WARN $zh.File "series-pair-mismatch" "中英版本的系列信息不一致（en: $($en.Series)/$($en.Order)，zh: $($zh.Series)/$($zh.Order)）"
            }
        }
    }
}

# --- CDN image existence ---------------------------------------------------

function Test-CdnImages {
    param([string[]]$Files)

    if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
        Add-Issue WARN "-" "cdn-image-check" "找不到 gh，跳过 CDN 图片检查"
        return
    }

    # Not anchored: inside a file the URL sits mid-line, after "![alt](".
    $urlPattern = "https://cdn\.jsdelivr\.net/gh/$([regex]::Escape($AssetRepo))@$AssetBranch/([^)\s]+)"

    $wanted = @{}
    foreach ($path in $Files) {
        $name = Split-Path $path -Leaf
        $content = [System.IO.File]::ReadAllText($path, [System.Text.UTF8Encoding]::new($false))
        foreach ($m in [regex]::Matches($content, $urlPattern)) {
            $rel = $m.Groups[1].Value
            $folder = Split-Path $rel -Parent
            if (-not $folder) { $folder = "." }
            $fileName = Split-Path $rel -Leaf
            if (-not $wanted.ContainsKey($folder)) { $wanted[$folder] = @{} }
            $wanted[$folder][$fileName] = $name
        }
    }

    $script:CdnImagesChecked = 0
    foreach ($folder in $wanted.Keys) {
        $script:CdnImagesChecked += $wanted[$folder].Keys.Count
        $previous = $ErrorActionPreference
        $ErrorActionPreference = "Continue"
        $remote = @()
        try {
            $json = gh api "repos/$AssetRepo/contents/${folder}?ref=$AssetBranch" 2>$null
            if ($LASTEXITCODE -eq 0 -and $json) {
                $remote = @(($json | ConvertFrom-Json) | Where-Object { $_.type -eq "file" } | Select-Object -ExpandProperty name)
            }
        }
        finally {
            $ErrorActionPreference = $previous
        }

        foreach ($fileName in $wanted[$folder].Keys) {
            if ($remote -notcontains $fileName) {
                Add-Issue ERROR $wanted[$folder][$fileName] "cdn-image-missing" "引用的图片不在图床仓库里：$folder/$fileName（先跑 scripts/upload-images.ps1）"
            }
        }
    }
}

# --- Main ------------------------------------------------------------------

Push-Location $ProjectRoot
try {
    # "pwsh -File ... -Paths a.md,b.md" arrives as one comma-joined token.
    $Paths = @($Paths | ForEach-Object { $_ -split "," } | ForEach-Object { $_.Trim() } | Where-Object { $_ })

    if ($Paths) {
        $targets = $Paths | ForEach-Object { (Resolve-Path $_).Path }
    }
    elseif ($Changed) {
        $targets = @(Get-ChangedPostFiles)
        if ($targets.Count -eq 0) {
            Write-Host "[INFO] 没有改动的文章需要校验。" -ForegroundColor Yellow
            exit 0
        }
    }
    else {
        $targets = @(Get-ChildItem $PostsDir -Filter "*.md" -File | Select-Object -ExpandProperty FullName)
    }

    foreach ($path in $targets) { Test-PostFile -Path $path }
    Test-PostSet -Files $targets
    if ($CheckImages) { Test-CdnImages -Files $targets }

    $errors = @($Issues | Where-Object { $_.Level -eq "ERROR" })
    $warnings = @($Issues | Where-Object { $_.Level -eq "WARN" })

    if (-not $Quiet) {
        foreach ($issue in ($Issues | Sort-Object File, Line)) {
            $location = if ($issue.Line -gt 0) { "$($issue.File):$($issue.Line)" } else { $issue.File }
            $color = if ($issue.Level -eq "ERROR") { "Red" } else { "Yellow" }
            Write-Host ("[{0}] {1,-42} {2}" -f $issue.Level, $location, $issue.Message) -ForegroundColor $color
        }
    }

    if ($CheckImages) {
        Write-Host "`n[INFO] 已核对 $($script:CdnImagesChecked) 个 CDN 图片引用。" -ForegroundColor Gray
    }

    Write-Host ""
    if ($errors.Count -eq 0 -and $warnings.Count -eq 0) {
        Write-Host "[OK] 校验通过：$($targets.Count) 个文件，没有发现问题。" -ForegroundColor Green
        exit 0
    }

    $summary = "[SUMMARY] 校验了 $($targets.Count) 个文件：$($errors.Count) 个错误，$($warnings.Count) 个警告"
    if ($errors.Count -gt 0) {
        Write-Host $summary -ForegroundColor Red
        exit 1
    }
    Write-Host $summary -ForegroundColor Yellow
    exit 0
}
finally {
    Pop-Location
}
