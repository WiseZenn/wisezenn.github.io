# Agent 指北聚合方案（v3）

## 一、这版改了什么

根据你的反馈，把第一版的 10 篇压缩成 **7 篇**，并新增一个工具类专栏：

- 合并“Agent 观念 + CLI”，把《关于CLI的想法》整理进去；
- 合并“Windows 环境 + Git/GitHub”，放进 `dev-env-setup`；
- **OpenCLI 与 Zotero 不再合并**，拆成两篇；
- 新建 **`productivity-toolbox`（效率工具箱）**，放 OpenCLI、Zotero、Typora 三篇工具文；
- 合并“Codex + 自动化场景”，重写成“AI 辅助工作流”；
- Typora 篇补 Markdown 使用技巧；
- 主标题恢复为之前那组；小标题统一改成技术博客式的名词短语，不用口语化动词，也不用“标题：解释”写法；
- 内部链接按发布时间排序：早发布的文章不链接晚发布的文章；引用其他文章时用 Markdown 链接，不加《》；
- 学习篇去掉 C++/CUDA/MPI 资源清单；
- Claude Code 日常技巧补进已有的《Claude配置DeepSeek v4不完全指南》，发布日期保持 2026-05-08 不变。

## 二、新结构

| # | 草稿文件 | 标题 | 专栏 | 合并来源 | 日期 |
| --- | --- | --- | --- | --- | --- |
| 01 | `agent-onboarding-01-agent-and-cli.md` | Agent 入门：从对话到执行 | `geek-survival-guide` | 原 01 + 04 + 《关于CLI的想法》 | 2026-05-13 |
| 02 | `agent-onboarding-02-windows-git.md` | Windows 开发环境与版本管理 | `dev-env-setup` | 原 02 + 03 | 2026-08-15 |
| 03 | `agent-onboarding-03-opencli.md` | OpenCLI：把网站变成 Agent 的 CLI | `productivity-toolbox` | 原 05 + 两篇 OpenCLI 笔记 | **2026-05-18** |
| 04 | `agent-onboarding-04-zotero-llm.md` | Zotero + LLM：让 Agent 参与文献阅读 | `productivity-toolbox` | 原 07 | 2026-07-26 |
| 05 | `agent-onboarding-05-ai-workflow.md` | AI 辅助工作流：从炼丹到 PPT 和发布 | `geek-survival-guide` | 原 06 + 09 | 2026-09-02 |
| 06 | `agent-onboarding-06-typora-markdown.md` | Typora 与 Markdown 写作配置 | `productivity-toolbox` | 原 08 + Markdown 技巧 | 2026-06-27 |
| 07 | `agent-onboarding-07-learning-research.md` | AI 时代的学习与科研工作流 | `geek-survival-guide` | 原 10（去掉 C++/CUDA/MPI） | 2026-09-23 |

## 三、专栏归属

新建 **`productivity-toolbox`（效率工具箱）**，中英文系列页都已创建：

- `_series/productivity-toolbox_zh.md`
- `_series/productivity-toolbox.md`

归属如下：

- **`productivity-toolbox`（效率工具箱）**：OpenCLI、Zotero + LLM、Typora + Markdown。定位是“进入日常工作流的工具”，讲安装、用法和边界。
- **`dev-env-setup`（开发环境搭建记录）**：Windows 环境、Git/GitHub。保留原有的开发环境定位。
- **`geek-survival-guide`（极客生存指南）**：Agent 观念、AI 辅助工作流、学习与科研。保留原有的 AI 实践定位。

## 四、各篇的改造重点

### 01 Agent 入门：从对话到执行

- 讲清 LLM、壳、手脚的关系；
- 补入 CLI 的核心论点：人适合 GUI，Agent 适合 CLI；
- 用 GitHub CLI、购物、微信、打车、飞书/企微等例子说明 2C 与 2B 的差异；
- 保留“LLM 负责思考，CLI 负责执行”的主线；
- 结尾给出一个最小上手路径。

### 02 Windows 开发环境与版本管理

- 保留 Node.js、PowerToys、Windows Terminal、Git、GitHub CLI 的最小清单；
- 补入 Git 分支、相对路径、GitHub Code/Releases 的使用；
- PowerShell 7、WSL2 只链接已有文章，不重复安装步骤。

### 03 OpenCLI：把网站变成 Agent 的 CLI

- 整合 OpenCLI 的安装、浏览器插件、常用命令、微信/知乎/B站/抖音下载、自定义 adapter、CDP、私域聊天记录；
- 补入“个人信息流”和“文献检索”两条使用路径；
- 日期固定为 2026-05-18。

### 04 Zotero + LLM：让 Agent 参与文献阅读

- 插件安装、DeepSeek/Copilot 配置、Agent 模式、笔记导出；
- 补入 Skill 沉淀和“及时复核、人工审查”的原则；
- 和 OpenCLI 互相链接：OpenCLI 负责找，Zotero 负责读和记。

### 05 AI 辅助工作流：从炼丹到 PPT 和发布

- 按“三个层次”重写：
  1. 把 AI 当顾问：网页端梳理思路；
  2. 让 AI 生成文件：ICS 课表、python-pptx 汇报；
  3. 让 Agent 跑循环：深度学习炼丹、博客发布。
- 深度学习部分写具体流程：配置文件、运行目录、日志、指标汇总、人工验收；
- PPT 部分改用 `python-pptx`，给出可运行的最小示例；
- 课表部分作为普通的“AI 生成文件”场景，不再特意强调“不需要 Agent”；
- 保留远程服务器的 API Key、权限和网络边界。

### 06 Typora 与 Markdown 写作配置

- 保留主题、相对路径、callout、快捷键、专注模式、公式兼容；
- 新增 Markdown 技巧：目录、表格、代码块、任务列表、脚注、Mermaid、frontmatter、表格里的 `|` 转义。

### 07 AI 时代的学习与科研工作流

- 去掉 C++/CUDA/MPI 资源清单；
- 保留概念地图、基础代码库、复现论文、idea 落地、信息检索、Skill 沉淀、持续输出；
- 例子保持通用，不出现具体专业方向。

## 五、已用 Search / Fetch 补足的内容

- `python-pptx` 的当前用法：官方 Quickstart 和 Shapes 文档；
- OpenCLI 当前 README：安装方式、浏览器桥、`opencli list` / `opencli doctor` 等命令；
- Claude Code 文档：`CLAUDE.md`、`/model`、`/effort`、`/resume` 等命令的当前说明。

这些内容只用于校正写法和补充细节，文章仍然以第一人称经验为主，不写成官方文档翻译。

## 六、发布前待办

- 发布日期已全部确定（见上表）；
- 配图已完成并上传 CDN；
- 7 篇已移到 `_posts`，文件名按发布日期命名；
- 7 篇英文版已补齐，中英文 `lang-ref`、日期、系列顺序已配对；
- 核对 DeepSeek 模型名、Codex 额度、Zotero 插件界面等时效内容；
- 根据需要微调 `geek-survival-guide` 的系列简介，让它覆盖 Agent 工具链和自动化工作流。

## 七、还需要你确认

1. 新专栏名用“效率工具箱”（`productivity-toolbox`）是否合适；
2. Typora 放在效率工具箱是否符合你的预期；
3. 05 的“三个层次”结构是否符合你的预期。
