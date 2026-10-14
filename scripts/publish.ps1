# =============================================================================
# WiseZenn's Blog - One-Click Publish
# validate -> build -> deploy -> verify the live URLs, stopping at the first
# problem instead of shipping a broken page.
# =============================================================================

param(
    [string]$Message,      # deploy commit message; defaults to the changed post title
    [switch]$All,          # validate every post instead of only the changed ones
    [switch]$SkipValidation,
    [switch]$NoVerify,     # skip waiting for the live URLs to come up
    [switch]$CommitSource  # also commit _posts/ and _cdn-assets/ on the current branch
)

$ErrorActionPreference = "Stop"
$ProjectRoot = Split-Path -Parent $PSScriptRoot
$SiteUrl = "https://wisezenn.github.io"
$VerifyTimeoutSeconds = 150

function Get-ChangedPostPaths {
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

# "/blog/2026/slug/" for en posts, "/zh/blog/2026/slug/" for zh ones.
function Get-LiveUrl {
    param([string]$Path)

    $name = Split-Path $Path -Leaf
    $slug = $name -replace "^\d{4}-\d{2}-\d{2}-", "" -replace "\.md$", ""

    $lang = "en"
    $year = (Get-Date).Year
    $lines = [System.IO.File]::ReadAllLines($Path, [System.Text.UTF8Encoding]::new($false))
    for ($i = 0; $i -lt [Math]::Min($lines.Count, 30); $i++) {
        if ($lines[$i] -match "^lang:\s*(\S+)") { $lang = $Matches[1].Trim('"') }
        if ($lines[$i] -match "^date:\s*(\d{4})-") { $year = $Matches[1] }
    }

    $prefix = if ($lang -eq "zh") { "/zh" } else { "" }
    return "$SiteUrl$prefix/blog/$year/$slug/"
}

function Wait-ForUrl {
    param([string]$Url, [int]$TimeoutSeconds)

    $deadline = (Get-Date).AddSeconds($TimeoutSeconds)
    $attempt = 0
    while ((Get-Date) -lt $deadline) {
        $attempt++
        try {
            $response = Invoke-WebRequest -Uri $Url -Method Head -TimeoutSec 15 -SkipHttpErrorCheck
            if ($response.StatusCode -eq 200) { return $attempt }
        }
        catch {
            # Not up yet; keep polling until the deadline.
        }
        Start-Sleep -Seconds 10
    }
    return 0
}

Push-Location $ProjectRoot
try {
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host " WiseZenn's Blog - Publish" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan

    $changedPosts = @(Get-ChangedPostPaths)
    if ($changedPosts.Count -eq 0) {
        Write-Host "[INFO] 没有检测到改动的文章；仍会构建并部署当前内容。" -ForegroundColor Yellow
    }
    else {
        Write-Host "[INFO] 改动的文章：$($changedPosts.Count) 篇" -ForegroundColor Yellow
        foreach ($post in $changedPosts) { Write-Host "       $(Split-Path $post -Leaf)" -ForegroundColor Gray }
    }

    # --- Step 1: validation ---
    if (-not $SkipValidation) {
        Write-Host "`n[Step 1/3] 发布前校验..." -ForegroundColor Green
        $validateArgs = @("-NoProfile", "-File", (Join-Path $PSScriptRoot "validate_posts.ps1"), "-CheckImages")
        if (-not $All) { $validateArgs += "-Changed" }

        & pwsh @validateArgs
        if ($LASTEXITCODE -ne 0) {
            Write-Host "`n[ERROR] 校验未通过，已中止发布。修复上面的问题后重试。" -ForegroundColor Red
            exit 1
        }
    }
    else {
        Write-Host "`n[Step 1/3] 已跳过校验（-SkipValidation）。" -ForegroundColor Yellow
    }

    # --- Step 2: build + deploy ---
    Write-Host "`n[Step 2/3] 构建并部署（scripts/deploy.ps1）..." -ForegroundColor Green
    $deployArgs = @("-NoProfile", "-File", (Join-Path $PSScriptRoot "deploy.ps1"), "-NonInteractive")
    if ($Message) { $deployArgs += @("-Message", $Message) }
    elseif ($changedPosts.Count -gt 0) {
        $title = (Select-String -Path $changedPosts[0] -Pattern '^title:\s*"?(.+?)"?\s*$' | Select-Object -First 1).Matches.Groups[1].Value
        if ($title) { $deployArgs += @("-Message", "Publish $title") }
    }

    & pwsh @deployArgs
    if ($LASTEXITCODE -ne 0) {
        Write-Host "`n[ERROR] 部署失败，已中止。" -ForegroundColor Red
        exit 1
    }

    # --- Step 3: verify the pages actually went live ---
    if (-not $NoVerify -and $changedPosts.Count -gt 0) {
        Write-Host "`n[Step 3/3] 等待线上页面生效（最多 $VerifyTimeoutSeconds 秒）..." -ForegroundColor Green
        $failed = @()
        foreach ($post in $changedPosts) {
            $url = Get-LiveUrl -Path $post
            $attempt = Wait-ForUrl -Url $url -TimeoutSeconds $VerifyTimeoutSeconds
            if ($attempt -gt 0) {
                Write-Host "  [OK]   $url" -ForegroundColor Green
            }
            else {
                Write-Host "  [FAIL] $url （超时未返回 200）" -ForegroundColor Red
                $failed += $url
            }
        }
        if ($failed.Count -gt 0) {
            Write-Host "`n[WARN] 有页面未能确认上线。GitHub Pages 偶尔会更慢，可稍后手动打开上面失败的链接确认。" -ForegroundColor Yellow
        }
    }
    elseif (-not $NoVerify) {
        Write-Host "`n[Step 3/3] 没有改动的文章，跳过线上验证。" -ForegroundColor Yellow
    }

    # --- Optional: commit the source side too ---
    if ($CommitSource) {
        Write-Host "`n[INFO] 提交源文件（_posts/）..." -ForegroundColor Green
        # _cdn-assets/ is gitignored on purpose: it is a local staging area and
        # the images' durable home is the Blog-assets repository.
        git add _posts
        $staged = git diff --cached --name-only
        if ($staged) {
            $sourceMessage = if ($Message) { $Message } else { "Publish site updates" }
            git commit -m "$sourceMessage" | Out-Null
            git push origin HEAD
            if ($LASTEXITCODE -ne 0) {
                Write-Host "[ERROR] 源文件推送失败。" -ForegroundColor Red
                exit 1
            }
            Write-Host "[OK] 源文件已提交并推送。" -ForegroundColor Green
        }
        else {
            Write-Host "[INFO] 源文件没有需要提交的改动。" -ForegroundColor Yellow
        }
    }

    Write-Host "`n========================================" -ForegroundColor Green
    Write-Host " 发布完成：$SiteUrl" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
}
finally {
    Pop-Location
}
