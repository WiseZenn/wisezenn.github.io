# =============================================================================
# WiseZenn's Blog - 本地构建脚本 (PowerShell)
# 使用 Docker 构建 Jekyll 静态网站
# =============================================================================

param(
    [switch]$Serve,      # 启动本地开发服务器
    [switch]$Production  # 生产环境构建
)

$ErrorActionPreference = "Stop"
$ProjectRoot = Split-Path -Parent $PSScriptRoot

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " WiseZenn's Blog - 本地构建" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# 检查 Docker 是否运行
try {
    docker info | Out-Null
} catch {
    Write-Host "[ERROR] Docker Desktop 未运行，请先启动 Docker Desktop" -ForegroundColor Red
    exit 1
}

Set-Location $ProjectRoot

if ($Serve) {
    Write-Host "`n[INFO] 启动本地开发服务器..." -ForegroundColor Green
    Write-Host "[INFO] 访问 http://localhost:8080 查看网站" -ForegroundColor Yellow
    Write-Host "[INFO] 按 Ctrl+C 停止服务器`n" -ForegroundColor Yellow
    docker compose up
} else {
    Write-Host "`n[INFO] 开始构建静态网站..." -ForegroundColor Green
    
    # 清理旧的构建产物
    if (Test-Path "_site") {
        Remove-Item -Recurse -Force "_site"
    }
    
    # 使用 Docker 构建
    $env:JEKYLL_ENV = if ($Production) { "production" } else { "development" }
    
    docker compose run --rm webserver bash -c "
        bundle exec jekyll build --config _config.yml
    "
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "`n[SUCCESS] 构建完成！" -ForegroundColor Green
        Write-Host "[INFO] 构建产物位于: _site/" -ForegroundColor Yellow
    } else {
        Write-Host "`n[ERROR] 构建失败！" -ForegroundColor Red
        exit 1
    }
}
