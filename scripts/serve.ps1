# =============================================================================
# WiseZenn's Blog - Quick Start Script (PowerShell)
# Shortcut: Start local development server
# =============================================================================

# Set console output encoding to UTF-8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

$ProjectRoot = Split-Path -Parent $PSScriptRoot
Set-Location $ProjectRoot

Write-Host "Starting WiseZenn's Blog local development server..." -ForegroundColor Cyan
Write-Host "Visit: http://localhost:8040" -ForegroundColor Yellow
Write-Host "Press Ctrl+C to stop" -ForegroundColor Yellow
Write-Host ""

docker compose up
