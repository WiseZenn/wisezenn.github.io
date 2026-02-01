#!/bin/bash
# =============================================================================
# WiseZenn's Blog - 本地构建脚本 (Bash)
# 使用 Docker 构建 Jekyll 静态网站
# =============================================================================

set -e

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SERVE=false
PRODUCTION=false

# 解析参数
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --serve) SERVE=true ;;
        --production) PRODUCTION=true ;;
        *) echo "Unknown parameter: $1"; exit 1 ;;
    esac
    shift
done

echo "========================================"
echo " WiseZenn's Blog - 本地构建"
echo "========================================"

# 检查 Docker 是否运行
if ! docker info > /dev/null 2>&1; then
    echo "[ERROR] Docker 未运行，请先启动 Docker"
    exit 1
fi

cd "$PROJECT_ROOT"

if [ "$SERVE" = true ]; then
    echo ""
    echo "[INFO] 启动本地开发服务器..."
    echo "[INFO] 访问 http://localhost:8080 查看网站"
    echo "[INFO] 按 Ctrl+C 停止服务器"
    echo ""
    docker compose up
else
    echo ""
    echo "[INFO] 开始构建静态网站..."
    
    # 清理旧的构建产物
    rm -rf _site
    
    # 设置环境变量
    if [ "$PRODUCTION" = true ]; then
        export JEKYLL_ENV=production
    else
        export JEKYLL_ENV=development
    fi
    
    # 使用 Docker 构建
    docker compose run --rm webserver bash -c "bundle exec jekyll build --config _config.yml"
    
    echo ""
    echo "[SUCCESS] 构建完成！"
    echo "[INFO] 构建产物位于: _site/"
fi
