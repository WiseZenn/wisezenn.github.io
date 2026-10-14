# Skills & Commands

本项目自定义的 Claude Code 命令和技能。

## 可用命令

| 命令 | 说明 | 文件 |
|------|------|------|
| `/blog-image-upload` | 处理 Blog 图片：提取、重命名、复制、替换 CDN URL | [.claude/commands/blog-image-upload.md](../../.claude/commands/blog-image-upload.md) |

## 发布流程脚本

| 脚本 | 说明 |
|------|------|
| [scripts/new-post.ps1](../../scripts/new-post.ps1) | 从草稿生成中英双版文章骨架：frontmatter、lang-ref、series_order、图片重命名与 CDN 替换 |
| [scripts/upload-images.ps1](../../scripts/upload-images.ps1) | 把 `_cdn-assets/<slug>/` 的图片传到图床仓库。`-Via Api`（gh 接口）/ `-Via Gui`（PicGo 图形界面）/ `-Via Cli`（picgo 命令行） |
| [scripts/validate_posts.ps1](../../scripts/validate_posts.ps1) | 发布前校验：管道符、坏链、本地图片路径、空正文、未来日期、series_order 冲突、中英配对、CDN 图片是否存在 |
| [scripts/publish.ps1](../../scripts/publish.ps1) | 一键发布：校验 → 构建 → 部署 → 验证线上 URL |

## 目录说明

- `.claude/commands/` — Claude Code 可识别的 slash command 定义（实际执行的命令）
- `_scripts/` — 可独立执行的 Node.js 脚本（不依赖 Claude）
- `docs/prompt/templates/` — Prompt 模板（需要手动粘贴使用的模板，如 Blog 优化）
- `docs/skill/` — 本目录，命令和脚本的参考文档

## Prompt 模板 vs Slash Command vs 脚本

| | Prompt 模板 | Slash Command | 脚本 |
|--|-----------|---------------|------|
| 位置 | `docs/prompt/templates/` | `.claude/commands/` | `_scripts/` |
| 使用方式 | 手动粘贴内容给 Claude | 直接 `/命令名` 调用 | `node script.js <args>` |
| 适合任务 | 需要人工判断的创造性工作 | 规则固定的重复操作 | 需要浏览器/渲染能力的操作 |
| 示例 | Blog优化模板（润色、翻译） | blog-image-upload（图片搬家） | — |
