# WiseZenn's Blog - 博客使用指南

## 快速开始

### 1. 启动本地开发服务器

```powershell
# Windows PowerShell
.\scripts\serve.ps1
```

```bash
# Linux/Mac
./scripts/build.sh --serve
```

访问 http://localhost:8080 查看网站。

### 2. 一键发布到 GitHub Pages

```powershell
# Windows PowerShell
.\scripts\deploy.ps1 -Message "更新博客内容"
```

```bash
# Linux/Mac
./scripts/deploy.sh "更新博客内容"
```

网站将发布到: https://wisezenn.github.io

---

## 项目架构

```
WiseZenn's Blog/
├── _config.yml          # 主配置文件
├── _posts/              # 博客文章
├── _pages/              # 静态页面
├── _projects/           # 项目展示
├── _bibliography/       # 学术论文
├── _data/               # 数据文件（CV、社交链接等）
├── _includes/           # 可复用组件
├── _layouts/            # 页面布局模板
├── _sass/               # 样式文件
├── assets/              # 静态资源（本地）
├── _site/               # 构建产物（自动生成）
├── _gh-pages/           # Git Worktree（gh-pages 分支）
├── scripts/             # 构建和发布脚本
│   ├── build.ps1        # 构建脚本 (PowerShell)
│   ├── build.sh         # 构建脚本 (Bash)
│   ├── deploy.ps1       # 发布脚本 (PowerShell)
│   ├── deploy.sh        # 发布脚本 (Bash)
│   └── serve.ps1        # 快速启动服务器
└── docs/                # 项目文档
    ├── README.md        # 本文件
    └── IMAGE_HOSTING.md # 图床使用指南
```

---

## 写博客

### 创建新文章

在 `_posts/` 目录下创建文件，文件名格式：

```
YYYY-MM-DD-文章标题.md
```

例如：`2025-01-31-my-first-post.md`

### 文章 Front Matter 模板

```yaml
---
layout: post
title: 文章标题
date: 2025-01-31 10:00:00
description: 文章简短描述
tags: [标签1, 标签2]
categories: [分类]
giscus_comments: true  # 启用评论
related_posts: true    # 显示相关文章
thumbnail: https://cdn.jsdelivr.net/gh/WiseZenn/Blog-assets@main/images/posts/2025/01/thumbnail.jpg
---

正文内容...
```

### 使用图片

参考 [IMAGE_HOSTING.md](IMAGE_HOSTING.md) 了解如何使用图床。

---

## 配置修改

### 个人信息

编辑 `_config.yml`:

```yaml
title: "WiseZenn's Blog"
first_name: Wise
last_name: Zenn
description: >
  你的个人简介...
```

### 社交链接

编辑 `_data/socials.yml`:

```yaml
email: your@email.com
github_username: WiseZenn
# 更多选项...
```

### 导航菜单

编辑 `_pages/` 中的各个页面文件的 `nav` 和 `nav_order` 属性。

---

## Git 工作流

### 分支说明

- **main**: 源代码分支
- **gh-pages**: 构建产物分支（通过 Git Worktree 挂载到 `_gh-pages/`）

### 日常工作流

```bash
# 1. 编辑内容
# 2. 本地预览
.\scripts\serve.ps1

# 3. 满意后发布
.\scripts\deploy.ps1 -Message "你的提交信息"

# 4. 推送源代码（可选，备份用）
git add .
git commit -m "feat: 添加新文章"
git push origin main
```

---

## 图床架构

| 仓库 | 用途 |
|------|------|
| wisezenn.github.io | 博客源代码 + gh-pages 部署 |
| Blog-assets | 图片/视频等静态资源 |

**CDN 地址格式:**
```
https://cdn.jsdelivr.net/gh/WiseZenn/Blog-assets@main/<路径>
```

---

## 常见问题

### Q: 构建失败怎么办？

1. 确保 Docker Desktop 正在运行
2. 检查 `_config.yml` 语法（特别是冒号后需要空格）
3. 运行 `docker compose down` 后重试

### Q: 网站没有样式？

检查 `_config.yml` 中的 `url` 和 `baseurl`:
```yaml
url: https://wisezenn.github.io
baseurl:  # 留空
```

### Q: 图片不显示？

1. 确认图片已上传到 Blog-assets 仓库
2. 确认 CDN 链接格式正确
3. 等待 jsDelivr 缓存更新（通常几分钟）

---

## 有用的链接

- [al-folio 官方文档](https://github.com/alshedivat/al-folio)
- [Jekyll 文档](https://jekyllrb.com/docs/)
- [jsDelivr 文档](https://www.jsdelivr.com/documentation)
- [Markdown 指南](https://www.markdownguide.org/)
