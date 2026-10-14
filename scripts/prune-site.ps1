# =============================================================================
# WiseZenn's Blog - Prune Dead Weight From Build Output
# polyglot mirrors the whole assets tree into /zh/, but it only rewrites href=
# (never src=), so /zh/assets/{js,img,video,...} end up as byte-identical copies
# that no page loads - about 64 MB per build.
# Each candidate is checked against the actual HTML before anything is removed;
# a directory that is referenced anywhere is left alone.
# =============================================================================

[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$SiteDir,   # defaults to <project root>/_site
    [switch]$Quiet
)

$ErrorActionPreference = "Stop"
$ProjectRoot = Split-Path -Parent $PSScriptRoot
if (-not $SiteDir) { $SiteDir = Join-Path $ProjectRoot "_site" }
$SiteDir = (Resolve-Path $SiteDir).Path

$LangDir = Join-Path $SiteDir "zh"
if (-not (Test-Path $LangDir)) {
    if (-not $Quiet) { Write-Host "[INFO] 没有 zh 树，跳过剪枝。" -ForegroundColor Yellow }
    exit 0
}

# Only these are candidates. fonts/ and webfonts/ are deliberately absent: the
# CSS reaches them through relative url() paths, which never show up in HTML.
$Candidates = @("js", "img", "video", "plotly", "audio", "jupyter", "rendercv", "json", "bibliography")

function Get-ReferencedAssetDirs {
    $referenced = @{}
    foreach ($file in (Get-ChildItem $SiteDir -Recurse -Filter "*.html" -File)) {
        $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.UTF8Encoding]::new($false))
        foreach ($m in [regex]::Matches($content, "/zh/assets/([A-Za-z0-9_-]+)/")) {
            $referenced[$m.Groups[1].Value] = $true
        }
    }
    return $referenced
}

$referenced = Get-ReferencedAssetDirs
$freedBytes = 0
$removed = @()
$kept = @()

foreach ($name in $Candidates) {
    $target = Join-Path (Join-Path $LangDir "assets") $name
    if (-not (Test-Path $target)) { continue }

    if ($referenced.ContainsKey($name)) {
        $kept += $name
        continue
    }

    $bytes = (Get-ChildItem $target -Recurse -File | Measure-Object -Property Length -Sum).Sum
    if ($PSCmdlet.ShouldProcess($target, "Remove unreferenced language-tree copy")) {
        Remove-Item $target -Recurse -Force
        $freedBytes += $bytes
        $removed += $name
    }
}

if (-not $Quiet) {
    if ($removed.Count -gt 0) {
        Write-Host ("[OK] 剪掉 zh/assets 下 {0} 个无引用目录，释放 {1:N1} MB：{2}" -f `
            $removed.Count, ($freedBytes / 1MB), ($removed -join ", ")) -ForegroundColor Green
    }
    else {
        Write-Host "[INFO] zh/assets 下没有可剪的目录。" -ForegroundColor Yellow
    }
    if ($kept.Count -gt 0) {
        Write-Host "[INFO] 保留（产物中有引用）：$($kept -join ', ')" -ForegroundColor Gray
    }
}
