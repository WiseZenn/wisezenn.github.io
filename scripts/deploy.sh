#!/bin/bash
# =============================================================================
# WiseZenn's Blog - One-Click Deploy Script (Bash)
# Deploy build artifacts to gh-pages branch
# =============================================================================

set -e

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
GH_PAGES_DIR="$PROJECT_ROOT/_gh-pages"
SITE_DIR="$PROJECT_ROOT/_site"
MESSAGE="${1:-Deploy site updates}"

echo "========================================"
echo " WiseZenn's Blog - One-Click Deploy"
echo "========================================"

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "[ERROR] Docker is not running. Please start Docker."
    exit 1
fi

cd "$PROJECT_ROOT"

# Step 1: Production Build
echo ""
echo "[Step 1/5] Building for production..."

rm -rf "$SITE_DIR"
export JEKYLL_ENV=production
docker compose run --rm webserver bash -c "bundle exec jekyll build --config _config.yml"

# Step 2: Check Build Artifacts
echo "[Step 2/5] Checking build artifacts..."
if [ ! -d "$SITE_DIR" ]; then
    echo "[ERROR] Build artifacts not found: $SITE_DIR"
    exit 1
fi

FILE_COUNT=$(find "$SITE_DIR" -type f | wc -l)
echo "[INFO] Build contains $FILE_COUNT files"

# Step 3: Sync to gh-pages branch
echo "[Step 3/5] Syncing to gh-pages branch..."

if [ ! -d "$GH_PAGES_DIR" ]; then
    echo "[INFO] Creating gh-pages worktree..."
    git worktree add "$GH_PAGES_DIR" gh-pages
fi

# Clean gh-pages directory (keep .git)
find "$GH_PAGES_DIR" -mindepth 1 -maxdepth 1 ! -name '.git' -exec rm -rf {} +

# Copy build artifacts
cp -r "$SITE_DIR/"* "$GH_PAGES_DIR/"

# Add .nojekyll file
touch "$GH_PAGES_DIR/.nojekyll"

# Step 4: Commit Changes
echo -e "\033[0;32m[Step 4/5] Committing changes...\033[0m"
cd "$GH_PAGES_DIR"

git add -A
if [ -n "$(git status --porcelain)" ]; then
    TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
    
    # Ask for custom commit message
    read -p "Enter optional commit message (Press Enter for default): " CUSTOM_MSG
    
    if [ -n "$CUSTOM_MSG" ]; then
        COMMIT_MSG="Deploy: $CUSTOM_MSG - $TIMESTAMP"
    else
        COMMIT_MSG="$MESSAGE - $TIMESTAMP"
    fi

    git commit -m "$COMMIT_MSG"
    echo -e "\033[0;32m[INFO] Commit successful: $COMMIT_MSG\033[0m"
else
    echo -e "\033[0;33m[INFO] No changes to commit\033[0m"
fi

# Step 5: Push to Remote
echo "[Step 5/5] Pushing to GitHub..."
git push origin gh-pages

echo ""
echo "========================================"
echo " Deploy Successful!"
echo "========================================"
echo ""
echo "[INFO] Site will be live in a few minutes:"
echo "       https://wisezenn.github.io"

cd "$PROJECT_ROOT"
