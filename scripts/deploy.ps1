# =============================================================================
# WiseZenn's Blog - One-Click Deploy Script (PowerShell)
# Deploy build artifacts to gh-pages branch
# =============================================================================

param(
    [string]$Message = "Deploy site updates"  # Commit message
)

$ErrorActionPreference = "Stop"
$ProjectRoot = Split-Path -Parent $PSScriptRoot
$GhPagesDir = Join-Path $ProjectRoot "_gh-pages"
$SiteDir = Join-Path $ProjectRoot "_site"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " WiseZenn's Blog - One-Click Deploy" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# Check if Docker is running
try {
    docker info | Out-Null
} catch {
    Write-Host "[ERROR] Docker Desktop is not running. Please start Docker Desktop." -ForegroundColor Red
    exit 1
}

Set-Location $ProjectRoot

# Step 1: Production Build
Write-Host "`n[Step 1/5] Building for production..." -ForegroundColor Green

# Clean up old build artifacts
if (Test-Path $SiteDir) {
    Remove-Item -Recurse -Force $SiteDir
}

$env:JEKYLL_ENV = "production"
docker compose run --rm jekyll bash -c "bundle exec jekyll build --config _config.yml"

if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Build failed!" -ForegroundColor Red
    exit 1
}

# Step 2: Check Build Artifacts
Write-Host "[Step 2/5] Checking build artifacts..." -ForegroundColor Green
if (-not (Test-Path $SiteDir)) {
    Write-Host "[ERROR] Build artifacts not found: $SiteDir" -ForegroundColor Red
    exit 1
}

$fileCount = (Get-ChildItem -Recurse $SiteDir | Measure-Object).Count
Write-Host "[INFO] Build contains $fileCount files" -ForegroundColor Yellow

# Step 3: Sync to gh-pages branch
Write-Host "[Step 3/5] Syncing to gh-pages branch..." -ForegroundColor Green

# Check if worktree exists
if (-not (Test-Path $GhPagesDir)) {
    Write-Host "[INFO] Creating gh-pages worktree..." -ForegroundColor Yellow
    git worktree add $GhPagesDir gh-pages
}

# Clean gh-pages directory (keep .git)
Get-ChildItem -Path $GhPagesDir -Exclude ".git" | Remove-Item -Recurse -Force

# Copy build artifacts
Copy-Item -Path "$SiteDir\*" -Destination $GhPagesDir -Recurse -Force

# Add .nojekyll file (tells GitHub Pages not to rebuild)
New-Item -Path "$GhPagesDir\.nojekyll" -ItemType File -Force | Out-Null

# Step 4: Commit Changes
Write-Host "[Step 4/5] Committing changes..." -ForegroundColor Green
Set-Location $GhPagesDir

git add -A
$changes = git status --porcelain
if ($changes) {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    git commit -m "$Message - $timestamp"
    Write-Host "[INFO] Commit successful" -ForegroundColor Green
} else {
    Write-Host "[INFO] No changes to commit" -ForegroundColor Yellow
}

# Step 5: Push to Remote
Write-Host "[Step 5/5] Pushing to GitHub..." -ForegroundColor Green
git push origin gh-pages

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n========================================" -ForegroundColor Green
    Write-Host " Deploy Successful!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "`n[INFO] Site will be live in a few minutes:" -ForegroundColor Yellow
    Write-Host "       https://wisezenn.github.io" -ForegroundColor Cyan
} else {
    Write-Host "`n[ERROR] Push failed!" -ForegroundColor Red
    exit 1
}

# 返回主目录
Set-Location $ProjectRoot
