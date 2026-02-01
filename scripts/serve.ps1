# =============================================================================
# WiseZenn's Blog - 快速启动脚本 (PowerShell)
# 快捷方式：启动本地开发服务器
# =============================================================================

$ProjectRoot = Split-Path -Parent $PSScriptRoot
Set-Location $ProjectRoot

Write-Host "启动 WiseZenn's Blog 本地开发服务器..." -ForegroundColor Cyan
Write-Host "访问: http://localhost:8080" -ForegroundColor Yellow
Write-Host "按 Ctrl+C 停止" -ForegroundColor Yellow
Write-Host ""

docker compose up
