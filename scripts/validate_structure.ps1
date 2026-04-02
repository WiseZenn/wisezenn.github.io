# =============================================================================
# WiseZenn's Blog - Quick Structure Validation (PowerShell)
# Checks high-value consistency rules after refactoring.
# =============================================================================

$ErrorActionPreference = "Stop"
$ProjectRoot = Split-Path -Parent $PSScriptRoot

function Assert-FileExists {
    param([string]$Path)

    if (-not (Test-Path $Path)) {
        throw "Missing required file: $Path"
    }
}

function Assert-NoPattern {
    param(
        [string]$Path,
        [string]$Pattern,
        [string]$Message
    )

    $matches = Select-String -Path $Path -Pattern $Pattern -SimpleMatch
    if ($matches) {
        throw $Message
    }
}

function Assert-ContainsPattern {
    param(
        [string]$Path,
        [string]$Pattern,
        [string]$Message
    )

    $matches = Select-String -Path $Path -Pattern $Pattern -SimpleMatch
    if (-not $matches) {
        throw $Message
    }
}

Push-Location $ProjectRoot
try {
    Assert-FileExists "_data/i18n.yml"
    Assert-FileExists "_includes/blog_index_content.liquid"

    Assert-NoPattern "scripts/build.ps1" "webserver" "scripts/build.ps1 still references deprecated compose service name 'webserver'."
    Assert-NoPattern "scripts/build.sh" "webserver" "scripts/build.sh still references deprecated compose service name 'webserver'."
    Assert-NoPattern "scripts/deploy.sh" "webserver" "scripts/deploy.sh still references deprecated compose service name 'webserver'."

    Assert-ContainsPattern "_includes/blog_index_content.liquid" "site.data.i18n" "blog index include is not using centralized i18n data."
    Assert-ContainsPattern "_includes/blog_heatmap.liquid" "site.data.i18n" "blog heatmap include is not using centralized i18n data."

    Write-Host "[OK] Structure validation passed." -ForegroundColor Green
}
finally {
    Pop-Location
}
