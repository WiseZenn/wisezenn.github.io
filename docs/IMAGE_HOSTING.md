# WiseZenn's Blog - 图床使用指南

## 图床仓库

- **仓库地址:** https://github.com/WiseZenn/Blog-assets
- **CDN 加速:** jsDelivr
- **路径约定:** 仓库根目录下 `/<文章slug>/`，例如 `powershell-7-setup/powershell-7-setup-version-check.png`

> 这个约定由 `scripts/validate_posts.ps1` 和 `scripts/upload-images.ps1` 共同维护。
> 旧的 `images/posts/YYYY/MM/` 目录树已废弃——**不要**再把存储路径设成 `images/`。

---

## 🚀 推荐方案：脚本上传

`scripts/upload-images.ps1` 会把 `_cdn-assets/<slug>/` 里的图片传到图床仓库，已存在的文件自动跳过：

```powershell
# 用 GitHub API 直传（默认，不需要 PicGo 在运行）
pwsh -File scripts/upload-images.ps1 -Slug powershell-7-setup

# 或者用 PicGo
pwsh -File scripts/upload-images.ps1 -Slug powershell-7-setup -Via Gui   # 驱动 PicGo 图形界面
pwsh -File scripts/upload-images.ps1 -Slug powershell-7-setup -Via Cli   # picgo 命令行

# 只看会做什么，不真传
pwsh -File scripts/upload-images.ps1 -Slug powershell-7-setup -List
```

三种后端的区别：

| 后端 | 依赖 | 存储路径怎么定 |
|------|------|----------------|
| `Api` | `gh` 已登录 | 脚本按 slug 直接指定，最省心 |
| `Gui` | PicGo 正在运行、服务端已开启 | 读 PicGo 当前设置，**必须等于 slug**，不一致脚本会直接报错 |
| `Cli` | `npm i -g picgo` | 脚本每次从 PicGo 的配置现取仓库/token，只把路径覆盖成 slug |

图片从哪来：草稿里的截图先由 `/blog-image-upload` 或 `scripts/new-post.ps1` 归集到 `_cdn-assets/<slug>/` 并重命名，再执行上面的命令。

---

## PicGo 配置（供 `-Via Gui` 用）

### 1. 下载安装 PicGo

- **下载地址**: https://github.com/Molunerfinn/PicGo/releases
- 选择适合你系统的版本（Windows 选 `.exe`）

### 2. 生成 GitHub Token

1. 打开 https://github.com/settings/tokens
2. 点击 **"Generate new token (classic)"**
3. 填写 Note（如 `PicGo`）
4. **勾选 `repo`** 权限（完整仓库访问权限）
5. 点击 **Generate token**
6. **立即复制 Token**（只显示一次！）

### 3. 配置 PicGo

打开 PicGo → 图床设置 → **GitHub**：

| 配置项 | 值 |
|--------|-----|
| 设定仓库名 | `WiseZenn/Blog-assets` |
| 设定分支名 | `main` |
| 设定 Token | `粘贴你刚才生成的 Token` |
| 指定存储路径 | `<当前文章的 slug>/`，例如 `powershell-7-setup/` |
| 设定自定义域名 | `https://cdn.jsdelivr.net/gh/WiseZenn/Blog-assets@main` |

点击 **确定** → **设为默认图床**。

> ⚠️ **存储路径每次写文章都要改**，改成当前文章的 slug。用 `-Via Cli` 可以让脚本自动覆盖，不用手改。

### 4. 推荐设置

- ✅ **开机自启**
- ✅ **上传后自动复制 URL**（PicGo 的「设置 → 服务端」也要打开，`-Via Gui` 依赖它）
- ❌ **不要开「时间戳重命名」**——文章里的链接是按固定文件名写的，重命名后会全部 404

---

## 目录结构

```
Blog-assets/
├── powershell-7-setup/          # 一篇文章一个文件夹，名字 = 文章 slug
│   ├── powershell-7-setup-version-check.png
│   └── powershell-7-setup-utf8-profile.png
├── wsl2-dev-environment/
├── github-student-pack/
└── claude-deepseek-v4-guide/
```

## jsDelivr CDN 链接格式

```
https://cdn.jsdelivr.net/gh/WiseZenn/Blog-assets@main/<slug>/<文件名>
```

| 文件位置 | CDN 链接 |
|---------|---------|
| `powershell-7-setup/powershell-7-setup-version-check.png` | `https://cdn.jsdelivr.net/gh/WiseZenn/Blog-assets@main/powershell-7-setup/powershell-7-setup-version-check.png` |

## 在 Markdown 中使用

### 基本图片

```markdown
![描述](https://cdn.jsdelivr.net/gh/WiseZenn/Blog-assets@main/<slug>/<文件名>.png)
```

### 带样式的图片（al-folio 支持）

```liquid
{% include figure.liquid
    path="https://cdn.jsdelivr.net/gh/WiseZenn/Blog-assets@main/<slug>/<文件名>.png"
    class="img-fluid rounded z-depth-1"
    alt="描述"
%}
```

## 图片上传流程

### 方法一：脚本（推荐 ⭐）

见上方 **"推荐方案：脚本上传"**。

### 方法二：PicGo 手工拖拽

改好存储路径后，把 `_cdn-assets/<slug>/` 里的文件拖进 PicGo 窗口即可。仅在没有 `gh`、也不想装 `picgo` CLI 时使用。

### 方法三：Git 命令行

```bash
git clone https://github.com/WiseZenn/Blog-assets.git
cd Blog-assets
mkdir -p <slug> && cp /path/to/images/* <slug>/
git add . && git commit -m "Add: <slug> 文章图片" && git push origin main
```

### 方法四：GitHub 网页上传

打开 https://github.com/WiseZenn/Blog-assets，进入 `<slug>/` 目录，"Add file" → "Upload files"。

## 图片优化建议

1. **压缩图片**：上传前使用 [TinyPNG](https://tinypng.com/) 压缩
2. **合适尺寸**：博客正文图片建议宽度不超过 1200px
3. **文件命名**：英文、小写、短横线分隔，格式为 `<slug>-<描述>.png`，例如 `powershell-7-setup-utf8-profile.png`

## 缓存说明

jsDelivr 会缓存文件，如果更新了同名文件但看不到变化：

1. **等待缓存刷新**（通常 24 小时内）
2. **使用版本号**：`@v1.0.1` 替代 `@main`
3. **使用文件哈希**：上传新文件时使用不同文件名

> 注意：jsDelivr 也会缓存 404。如果刚上传的图仍报 404，用
> `gh api repos/WiseZenn/Blog-assets/contents/<slug>` 确认文件确实在仓库里，
> 那就是 CDN 缓存问题，等一会儿即可。

## 迁移到别的图床

因为文件名固定，换图床只需全局替换前缀：

```
查找: https://cdn.jsdelivr.net/gh/WiseZenn/Blog-assets@main/
替换: https://your-new-cdn.com/
```

替换前先跑一次 `pwsh -File scripts/validate_posts.ps1 -CheckImages` 留个底。
