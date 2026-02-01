# =============================================================================
# WiseZenn's Blog - 一键发布脚本 (PowerShell)
# 将构建产物发布到 gh-pages 分支
# =============================================================================

param(
    [string]$Message = "Deploy site updates"  # 提交信息
)

$ErrorActionPreference = "Stop"
$ProjectRoot = Split-Path -Parent $PSScriptRoot
$GhPagesDir = Join-Path $ProjectRoot "_gh-pages"
$SiteDir = Join-Path $ProjectRoot "_site"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " WiseZenn's Blog - 一键发布" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# 检查 Docker 是否运行
try {
    docker info | Out-Null
} catch {
    Write-Host "[ERROR] Docker Desktop 未运行，请先启动 Docker Desktop" -ForegroundColor Red
    exit 1
}

Set-Location $ProjectRoot

# Step 1: 生产环境构建
Write-Host "`n[Step 1/5] 生产环境构建..." -ForegroundColor Green

# 清理旧的构建产物
if (Test-Path $SiteDir) {
    Remove-Item -Recurse -Force $SiteDir
}

$env:JEKYLL_ENV = "production"
docker compose run --rm webserver bash -c "bundle exec jekyll build --config _config.yml"

if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] 构建失败！" -ForegroundColor Red
    exit 1
}

# Step 2: 检查构建产物
Write-Host "[Step 2/5] 检查构建产物..." -ForegroundColor Green
if (-not (Test-Path $SiteDir)) {
    Write-Host "[ERROR] 构建产物不存在: $SiteDir" -ForegroundColor Red
    exit 1
}

$fileCount = (Get-ChildItem -Recurse $SiteDir | Measure-Object).Count
Write-Host "[INFO] 构建产物包含 $fileCount 个文件" -ForegroundColor Yellow

# Step 3: 同步到 gh-pages worktree
Write-Host "[Step 3/5] 同步到 gh-pages 分支..." -ForegroundColor Green

# 检查 worktree 是否存在
if (-not (Test-Path $GhPagesDir)) {
    Write-Host "[INFO] 创建 gh-pages worktree..." -ForegroundColor Yellow
    git worktree add $GhPagesDir gh-pages
}

# 清理 gh-pages 目录（保留 .git）
Get-ChildItem -Path $GhPagesDir -Exclude ".git" | Remove-Item -Recurse -Force

# 复制构建产物
Copy-Item -Path "$SiteDir\*" -Destination $GhPagesDir -Recurse -Force

# 添加 .nojekyll 文件（告诉 GitHub Pages 不要再次构建）
New-Item -Path "$GhPagesDir\.nojekyll" -ItemType File -Force | Out-Null

# Step 4: 提交更改
Write-Host "[Step 4/5] 提交更改..." -ForegroundColor Green
Set-Location $GhPagesDir

git add -A
$changes = git status --porcelain
if ($changes) {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    git commit -m "$Message - $timestamp"
    Write-Host "[INFO] 提交成功" -ForegroundColor Green
} else {
    Write-Host "[INFO] 没有需要提交的更改" -ForegroundColor Yellow
}

# Step 5: 推送到远程仓库
Write-Host "[Step 5/5] 推送到 GitHub..." -ForegroundColor Green
git push origin gh-pages

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n========================================" -ForegroundColor Green
    Write-Host " 发布成功！" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "`n[INFO] 网站将在几分钟后上线:" -ForegroundColor Yellow
    Write-Host "       https://wisezenn.github.io" -ForegroundColor Cyan
} else {
    Write-Host "`n[ERROR] 推送失败！" -ForegroundColor Red
    exit 1
}

# 返回主目录
Set-Location $ProjectRoot
