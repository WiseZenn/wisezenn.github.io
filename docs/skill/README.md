# Skills & Commands

本项目自定义的 Claude Code 命令和技能。

## 可用命令

| 命令 | 说明 | 文件 |
|------|------|------|
| `/blog-image-upload` | 处理 Blog 图片：提取、重命名、复制、替换 CDN URL | [.claude/commands/blog-image-upload.md](../../.claude/commands/blog-image-upload.md) |

## 目录说明

- `.claude/commands/` — Claude Code 可识别的 slash command 定义（实际执行的命令）
- `docs/prompt/templates/` — Prompt 模板（需要手动粘贴使用的模板，如 Blog 优化）
- `docs/skill/` — 本目录，命令的参考文档

## Prompt 模板 vs Slash Command

| | Prompt 模板 | Slash Command |
|--|-----------|---------------|
| 位置 | `docs/prompt/templates/` | `.claude/commands/` |
| 使用方式 | 手动粘贴内容给 Claude | 直接 `/命令名` 调用 |
| 适合任务 | 需要人工判断的创造性工作 | 规则固定的重复操作 |
| 示例 | Blog优化模板（润色、翻译） | blog-image-upload（图片搬家） |
