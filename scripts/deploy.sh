#!/bin/bash
# =============================================================================
# WiseZenn's Blog - 一键发布脚本 (Bash)
# 将构建产物发布到 gh-pages 分支
# =============================================================================

set -e

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
GH_PAGES_DIR="$PROJECT_ROOT/_gh-pages"
SITE_DIR="$PROJECT_ROOT/_site"
MESSAGE="${1:-Deploy site updates}"

echo "========================================"
echo " WiseZenn's Blog - 一键发布"
echo "========================================"

# 检查 Docker 是否运行
if ! docker info > /dev/null 2>&1; then
    echo "[ERROR] Docker 未运行，请先启动 Docker"
    exit 1
fi

cd "$PROJECT_ROOT"

# Step 1: 生产环境构建
echo ""
echo "[Step 1/5] 生产环境构建..."

rm -rf "$SITE_DIR"
export JEKYLL_ENV=production
docker compose run --rm webserver bash -c "bundle exec jekyll build --config _config.yml"

# Step 2: 检查构建产物
echo "[Step 2/5] 检查构建产物..."
if [ ! -d "$SITE_DIR" ]; then
    echo "[ERROR] 构建产物不存在: $SITE_DIR"
    exit 1
fi

FILE_COUNT=$(find "$SITE_DIR" -type f | wc -l)
echo "[INFO] 构建产物包含 $FILE_COUNT 个文件"

# Step 3: 同步到 gh-pages worktree
echo "[Step 3/5] 同步到 gh-pages 分支..."

if [ ! -d "$GH_PAGES_DIR" ]; then
    echo "[INFO] 创建 gh-pages worktree..."
    git worktree add "$GH_PAGES_DIR" gh-pages
fi

# 清理 gh-pages 目录（保留 .git）
find "$GH_PAGES_DIR" -mindepth 1 -maxdepth 1 ! -name '.git' -exec rm -rf {} +

# 复制构建产物
cp -r "$SITE_DIR/"* "$GH_PAGES_DIR/"

# 添加 .nojekyll 文件
touch "$GH_PAGES_DIR/.nojekyll"

# Step 4: 提交更改
echo "[Step 4/5] 提交更改..."
cd "$GH_PAGES_DIR"

git add -A
if git diff --staged --quiet; then
    echo "[INFO] 没有需要提交的更改"
else
    TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
    git commit -m "$MESSAGE - $TIMESTAMP"
    echo "[INFO] 提交成功"
fi

# Step 5: 推送到远程仓库
echo "[Step 5/5] 推送到 GitHub..."
git push origin gh-pages

echo ""
echo "========================================"
echo " 发布成功！"
echo "========================================"
echo ""
echo "[INFO] 网站将在几分钟后上线:"
echo "       https://wisezenn.github.io"

cd "$PROJECT_ROOT"
