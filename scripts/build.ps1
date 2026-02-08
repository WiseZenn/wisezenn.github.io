# =============================================================================
# WiseZenn's Blog - Local Build Script (PowerShell)
# Build Jekyll static site using Docker
# =============================================================================

param(
    [switch]$Serve,      # Start local development server
    [switch]$Production  # Build for production
)

$ErrorActionPreference = "Stop"
$ProjectRoot = Split-Path -Parent $PSScriptRoot

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " WiseZenn's Blog - Local Build" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# Check if Docker is running
try {
    docker info | Out-Null
}
catch {
    Write-Host "[ERROR] Docker Desktop is not running. Please start Docker Desktop." -ForegroundColor Red
    exit 1
}

Set-Location $ProjectRoot

if ($Serve) {
    Write-Host "`n[INFO] Starting local development server..." -ForegroundColor Green
    Write-Host "[INFO] Visit http://localhost:8040 to view the site" -ForegroundColor Yellow
    Write-Host "[INFO] Press Ctrl+C to stop the server`n" -ForegroundColor Yellow
    docker compose up
}
else {
    Write-Host "`n[INFO] Starting static site build..." -ForegroundColor Green
    
    # Clean up old build artifacts
    if (Test-Path "_site") {
        Remove-Item -Recurse -Force "_site"
    }
    
    # Build using Docker
    $env:JEKYLL_ENV = if ($Production) { "production" } else { "development" }
    
    docker compose run --rm webserver bash -c "
        bundle exec jekyll build --config _config.yml
    "
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "`n[SUCCESS] Build completed!" -ForegroundColor Green
        Write-Host "[INFO] Build artifacts are located in: _site/" -ForegroundColor Yellow
    }
    else {
        Write-Host "`n[ERROR] Build failed!" -ForegroundColor Red
        exit 1
    }
}
