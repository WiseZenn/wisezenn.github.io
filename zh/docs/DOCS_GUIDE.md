# WiseZenn's Blog - 博客使用指南

## 关键文档

- [架构与改动指南](ARCHITECTURE_CHANGE_GUIDE.md)
- [改动决策树](CHANGE_DECISION_TREE.md)
- [维护运行手册](MAINTENANCE_RUNBOOK.md)
- [文档治理规范](DOCUMENTATION_GOVERNANCE.md)
- [Prompt 文档说明](prompt/PROMPT_GUIDE.md)
- [博客文章模板（标准）](templates/BLOG_POST_FRONTMATTER_TEMPLATE.md)
- [博客文章模板（双语版）](templates/BLOG_FRONTMATTER_GUIDE.md)
- [系列页模板（英文）](templates/SERIES_PAGE_TEMPLATE_EN.md)
- [系列页模板（中文）](templates/SERIES_PAGE_TEMPLATE_ZH.md)
- [系列文章 Front Matter 模板](templates/POST_IN_SERIES_FRONTMATTER_TEMPLATE.md)
- [图床使用指南](IMAGE_HOSTING.md)

## 推荐阅读顺序

### 如果你是内容作者

1. 本文档（docs/DOCS_GUIDE.md）
2. 图床使用指南（IMAGE_HOSTING.md）

### 如果你是开发者或维护者

1. 架构与改动指南（ARCHITECTURE_CHANGE_GUIDE.md）
2. 改动决策树（CHANGE_DECISION_TREE.md）
3. 维护运行手册（MAINTENANCE_RUNBOOK.md）
4. 文档治理规范（DOCUMENTATION_GOVERNANCE.md）
5. AI 改动提示词模板（prompt/AI_CHANGE_PROMPT.md）
6. 本文档（docs/DOCS_GUIDE.md）中的日常命令

## 目录职责说明

1. `docs/prompt/`
  - 存放 AI 行为规范和协作说明（规则级输入）。
2. `docs/prompt/templates/`
  - 存放 AI 任务请求表单（任务级输入）。
3. `docs/templates/`
  - 存放博客内容创作模板（内容级输入）。

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

访问 http://localhost:8040 查看网站。

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

## 项目结构（精简）

最常用目录与职责：

1. `_posts/`：博客文章正文。
2. `_series/`：系列落地页（按 `series_key` 聚合）。
3. `_includes/`：可复用模板片段。
4. `_layouts/`：页面布局骨架。
5. `_sass/`：样式与视觉 token。
6. `scripts/`：构建、预览、发布、结构校验脚本。
7. `docs/prompt/`：AI 协作规范与任务请求模板。
8. `docs/templates/`：内容创作模板（博客/系列 front matter）。

高频入口：

1. 架构说明：[ARCHITECTURE_CHANGE_GUIDE.md](ARCHITECTURE_CHANGE_GUIDE.md)
2. 改动决策：[CHANGE_DECISION_TREE.md](CHANGE_DECISION_TREE.md)
3. 运维校验：[MAINTENANCE_RUNBOOK.md](MAINTENANCE_RUNBOOK.md)
4. Prompt 协作说明：[prompt/PROMPT_GUIDE.md](prompt/PROMPT_GUIDE.md)

---

## 写博客

### 创建新文章

在 `_posts/` 目录下创建文件，文件名格式：

```
YYYY-MM-DD-文章标题.md
```

例如：`2025-01-31-my-first-post.md`

### 文章模板

- 标准文章模板: [templates/BLOG_POST_FRONTMATTER_TEMPLATE.md](templates/BLOG_POST_FRONTMATTER_TEMPLATE.md)
- 双语文章模板: [templates/BLOG_FRONTMATTER_GUIDE.md](templates/BLOG_FRONTMATTER_GUIDE.md)
- 系列文章模板: [templates/POST_IN_SERIES_FRONTMATTER_TEMPLATE.md](templates/POST_IN_SERIES_FRONTMATTER_TEMPLATE.md)

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

### Q: Ctrl+K 可以打开，但搜索不到内容？

1. 确认 `_config.yml` 中 `search_enabled: true`。
2. Ctrl+K 搜索现在按页面语言隔离：中文页只显示中文内容，英文页只显示英文内容。
3. 搜索分组标签和 placeholder 也会按当前语言显示（中文页显示中文标签）。
4. 修改了文章或页面后，需要重新构建并发布，`/assets/js/search-data.js` 才会更新。
5. 建议优先使用 `scripts/build.ps1` 或 `scripts/deploy.ps1` 触发完整重建。
6. 如果是 WeChat 条目，搜索结果会触发页面内二维码弹窗（`#wechat`），不是新窗口跳转。

---

## 有用的链接

- [al-folio 官方文档](https://github.com/alshedivat/al-folio)
- [Jekyll 文档](https://jekyllrb.com/docs/)
- [jsDelivr 文档](https://www.jsdelivr.com/documentation)
- [Markdown 指南](https://www.markdownguide.org/)
