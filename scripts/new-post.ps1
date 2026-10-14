# =============================================================================
# WiseZenn's Blog - Scaffold A Post From A Draft
# Turns Drafts/<name>.md into a paired zh/en post: frontmatter, lang-ref,
# series_order, image renaming and CDN link rewriting.
# The prose is still yours; everything mechanical is not.
# =============================================================================

param(
    [Parameter(Mandatory = $true)][string]$Draft,
    [Parameter(Mandatory = $true)][string]$Slug,
    [string]$Series,
    [int]$Order = 0,                                   # 0 = append after the series' last entry
    [string]$Category = "Tools & Resources",
    [string[]]$Tags = @(),
    [string]$TitleZh,
    [string]$TitleEn,
    [string]$DescriptionZh = "",
    [string]$DescriptionEn = "",
    [string]$Date,                                     # "yyyy-MM-dd HH:mm:ss +0800"; default now
    [string]$AssetDir,                                 # default: <draft folder>/assets
    [string[]]$ImageNames = @(),                       # optional descriptive names, in draft order
    [switch]$KeepFirstHeading,
    [switch]$Force,
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"
$ProjectRoot = Split-Path -Parent $PSScriptRoot
$PostsDir = Join-Path $ProjectRoot "_posts"
$StagingDir = Join-Path $ProjectRoot "_cdn-assets"
$AssetRepo = "WiseZenn/Blog-assets"
$AssetBranch = "main"

Push-Location $ProjectRoot
try {
    # pwsh -File splits an array argument into loose tokens, so "a,b,c" is the
    # reliable way to pass these from the command line; accept both spellings.
    $Tags = @($Tags | ForEach-Object { $_ -split "," } | ForEach-Object { $_.Trim() } | Where-Object { $_ })
    $ImageNames = @($ImageNames | ForEach-Object { $_ -split "," } | ForEach-Object { $_.Trim() } | Where-Object { $_ })

    # --- Resolve inputs ---
    if (-not (Test-Path $Draft)) { throw "找不到草稿文件：$Draft" }
    $draftPath = (Resolve-Path $Draft).Path
    $draftDir = Split-Path $draftPath -Parent
    if (-not $AssetDir) { $AssetDir = Join-Path $draftDir "assets" }

    if ($Date) {
        if ($Date -notmatch "^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} [+-]\d{4}$") {
            throw "Date 格式应为 'yyyy-MM-dd HH:mm:ss +0800'，当前为 '$Date'"
        }
        $dateValue = $Date
    }
    else {
        $dateValue = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss") + " +0800"
    }
    $datePrefix = $dateValue.Substring(0, 10)

    $zhPath = Join-Path $PostsDir "$datePrefix-$Slug-zh.md"
    $enPath = Join-Path $PostsDir "$datePrefix-$Slug-en.md"
    if (-not $Force) {
        foreach ($p in @($zhPath, $enPath)) {
            if (Test-Path $p) { throw "已存在同名文章：$(Split-Path $p -Leaf)。需要覆盖请加 -Force。" }
        }
    }

    # --- Series order ---
    $orderValue = $Order
    if ($Series -and $Order -le 0) {
        $max = 0
        foreach ($file in (Get-ChildItem $PostsDir -Filter "*.md" -File)) {
            $lines = [System.IO.File]::ReadAllLines($file.FullName, [System.Text.UTF8Encoding]::new($false))
            $fileSeries = $null
            for ($i = 0; $i -lt [Math]::Min($lines.Count, 30); $i++) {
                if ($lines[$i] -match "^series_key:\s*(\S+)") { $fileSeries = $Matches[1].Trim('"') }
                if ($lines[$i] -match "^series_order:\s*(\d+)") {
                    if ($fileSeries -eq $Series -and [int]$Matches[1] -gt $max) { $max = [int]$Matches[1] }
                }
            }
        }
        $orderValue = $max + 1
        Write-Host "[INFO] 系列 $Series 的下一序号：$orderValue" -ForegroundColor Yellow
    }

    # --- Draft body + images ---
    $body = [System.IO.File]::ReadAllText($draftPath, [System.Text.UTF8Encoding]::new($false))

    $imageMatches = [regex]::Matches($body, '!\[[^\]]*\]\((?:\./)?assets/([^)]+)\)')
    $imageNames_ = @{}
    $sequence = 0
    $copied = @()
    $missing = @()

    $stagingForSlug = Join-Path $StagingDir $Slug
    if ($imageMatches.Count -gt 0 -and -not $DryRun) {
        New-Item -ItemType Directory -Force -Path $stagingForSlug | Out-Null
    }

    foreach ($m in $imageMatches) {
        $original = $m.Groups[1].Value
        if ($imageNames_.ContainsKey($original)) { continue }

        $sequence++
        $ext = [System.IO.Path]::GetExtension($original)
        if (-not $ext) { $ext = ".png" }
        $newName = if ($sequence -le $ImageNames.Count) { $ImageNames[$sequence - 1] } else { "{0}-{1:d2}{2}" -f $Slug, $sequence, $ext }
        $imageNames_[$original] = $newName

        $source = Join-Path $AssetDir $original
        if (-not (Test-Path $source)) {
            $missing += "$original（在 $AssetDir 里找不到）"
            continue
        }
        if (-not $DryRun) {
            Copy-Item $source (Join-Path $stagingForSlug $newName) -Force
        }
        $copied += "$original -> $Slug/$newName"
    }

    foreach ($original in $imageNames_.Keys) {
        $cdn = "https://cdn.jsdelivr.net/gh/$AssetRepo@$AssetBranch/$Slug/$($imageNames_[$original])"
        $body = $body -replace [regex]::Escape("(./assets/$original)"), "($cdn)"
        $body = $body -replace [regex]::Escape("(assets/$original)"), "($cdn)"
    }

    # --- Title / heading ---
    $lines = $body -split "`r?`n"
    $firstContent = -1
    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i].Trim()) { $firstContent = $i; break }
    }
    if ($firstContent -ge 0 -and $lines[$firstContent] -match "^#{1,3}\s+(.+)$") {
        if (-not $TitleZh) { $TitleZh = $Matches[1].Trim() }
        if (-not $KeepFirstHeading) {
            # $lines[0..-1] would yield "first and last", not an empty slice.
            $head = if ($firstContent -gt 0) { @($lines[0..($firstContent - 1)]) } else { @() }
            $tail = if ($firstContent -lt $lines.Count - 1) { @($lines[($firstContent + 1)..($lines.Count - 1)]) } else { @() }
            $body = (@($head) + @($tail) -join "`n").TrimStart([char]13, [char]10)
        }
    }
    if (-not $TitleZh) { $TitleZh = $Slug }
    if (-not $TitleEn) { $TitleEn = $TitleZh }

    # --- Write the two posts ---
    function New-Frontmatter {
        param([string]$Lang, [string]$Title, [string]$Description)

        $tagList = ($Tags | ForEach-Object { '"' + $_ + '"' }) -join ", "
        $sb = New-Object System.Text.StringBuilder
        [void]$sb.AppendLine("---")
        [void]$sb.AppendLine("layout: post")
        [void]$sb.AppendLine("title: `"$Title`"")
        [void]$sb.AppendLine("date: $dateValue")
        [void]$sb.AppendLine("categories: [`"$Category`"]")
        [void]$sb.AppendLine("tags: [$tagList]")
        [void]$sb.AppendLine("description: `"$Description`"")
        [void]$sb.AppendLine("lang: $Lang")
        [void]$sb.AppendLine("lang-ref: post-$Slug-01")
        if ($Series) {
            [void]$sb.AppendLine("series_key: $Series")
            [void]$sb.AppendLine("series_order: $orderValue")
        }
        [void]$sb.AppendLine("toc:")
        [void]$sb.AppendLine("  sidebar: left")
        [void]$sb.AppendLine("giscus_comments: true")
        [void]$sb.AppendLine("---")
        [void]$sb.AppendLine("")
        return $sb.ToString()
    }

    $enPlaceholder = "<!-- English version pending: translate $Slug-zh.md and replace this comment. -->"

    if ($DryRun) {
        Write-Host "`n[DRY RUN] 将要创建：" -ForegroundColor Yellow
        Write-Host "  $(Split-Path $zhPath -Leaf)"
        Write-Host "  $(Split-Path $enPath -Leaf)"
        Write-Host "`n[DRY RUN] 图片处理：" -ForegroundColor Yellow
        if ($copied.Count -eq 0) { Write-Host "  （草稿里没有本地图片）" }
        foreach ($c in $copied) { Write-Host "  $c" }
        foreach ($mi in $missing) { Write-Host "  [缺失] $mi" -ForegroundColor Yellow }
        exit 0
    }

    [System.IO.File]::WriteAllText($zhPath, (New-Frontmatter -Lang "zh" -Title $TitleZh -Description $DescriptionZh) + $body, [System.Text.UTF8Encoding]::new($false))
    [System.IO.File]::WriteAllText($enPath, (New-Frontmatter -Lang "en" -Title $TitleEn -Description $DescriptionEn) + $enPlaceholder, [System.Text.UTF8Encoding]::new($false))

    Write-Host "`n[OK] 已创建：" -ForegroundColor Green
    Write-Host "  _posts/$(Split-Path $zhPath -Leaf)"
    Write-Host "  _posts/$(Split-Path $enPath -Leaf)"

    if ($copied.Count -gt 0) {
        Write-Host "`n[OK] 图片已暂存到 _cdn-assets/$Slug/：" -ForegroundColor Green
        foreach ($c in $copied) { Write-Host "  $c" }
        Write-Host "`n[下一步] 上传图片：pwsh -File scripts/upload-images.ps1 -Slug $Slug" -ForegroundColor Yellow
    }
    if ($missing.Count -gt 0) {
        Write-Host "`n[WARN] 这些图片没找到，仍保留原路径，需要手工处理：" -ForegroundColor Yellow
        foreach ($mi in $missing) { Write-Host "  $mi" }
    }

    Write-Host "`n[下一步]" -ForegroundColor Yellow
    Write-Host "  1. 补全中文正文，填写英文版（现在是占位注释）"
    Write-Host "  2. 校验：pwsh -File scripts/validate_posts.ps1 -Paths _posts/$datePrefix-$Slug-zh.md,_posts/$datePrefix-$Slug-en.md -CheckImages"
    Write-Host "  3. 发布：pwsh -File scripts/publish.ps1"
}
finally {
    Pop-Location
}
