---
layout: post
title: "Windows 开发环境与版本管理"
date: 2026-08-15 12:00:00 +0800
categories: ["Tools & Resources"]
tags: ["Windows", "Node.js", "Git", "GitHub", "PowerToys"]
description: "从 Node.js、PowerToys 到 Git、GitHub CLI，搭一套够用的 Windows 开发环境。"
lang: zh
lang-ref: post-agent-onboarding-02
series_key: dev-env-setup
series_order: 3
toc:
  sidebar: left
giscus_comments: true
---

装环境最容易陷入两个极端：要么什么都不装，要么看到一篇教程就跟着装一堆。前者会导致后面到处卡命令，后者则是装完自己都不知道每个工具是干什么的。

这篇文章把“Windows 上让 Agent 跑起来”需要的最小工具链串起来，再把 Git 和 GitHub 的版本管理补上。目标是：够用、能验证、以后好维护。

| 工具 | 作用 | 建议 |
| --- | --- | --- |
| Node.js / npm | 运行很多 AI 命令行工具 | 必装 |
| PowerToys | 图形化管理环境变量 | 强烈建议 |
| Windows Terminal | 更好用的终端 | 建议 |
| Git | 版本管理 | 必装 |
| GitHub CLI | 让 Agent 直接操作 GitHub | 建议 |
| PowerShell 7 | 更好的编码兼容性 | 建议 |
| VS Code | 编辑器和远程开发 | 按需 |
| WSL | 在 Windows 上使用 Linux | 按需 |

## Node.js 安装

Node.js 是一个免费的、跨平台的 JavaScript 运行环境。它本身和 Agent 没有直接关系，但很多 AI 命令行工具都通过 `npm` 分发，所以先装它会省掉后面的麻烦。

到 [Node.js 官网](https://nodejs.org/zh-cn/download) 下载 Windows 安装程序。安装时不需要勾选 `Automatically install the necessary tools`，那一项会额外装一堆编译工具，对大多数 Agent 使用场景没必要。

![Node.js 安装界面](https://cdn.jsdelivr.net/gh/WiseZenn/Blog-assets@main/windows-dev-env/windows-dev-env-nodejs-installer.png)

装完打开终端验证：

```bash
node -v
npm -v
```

能正常输出版本号就说明安装成功。如果提示“命令未识别”，通常是 PATH 没有配置好，可以先用 PowerToys 检查环境变量。

## PowerToys 环境变量

PowerToys 是微软出的一套 Windows 小工具集合，默认会启动，在右下角托盘里点开就能看到面板。我主要用它里面的**环境变量**功能。

![PowerToys 面板](https://cdn.jsdelivr.net/gh/WiseZenn/Blog-assets@main/windows-dev-env/windows-dev-env-powertoys-panel.png)

很多开发工具安装完不会自动把可执行文件加到 PATH，终端就找不到命令。以前要一层层点开系统设置，现在在 PowerToys 里可以直接编辑用户变量和系统变量：

![PowerToys 环境变量](https://cdn.jsdelivr.net/gh/WiseZenn/Blog-assets@main/windows-dev-env/windows-dev-env-powertoys-env-vars.png)

1. 打开 PowerToys，选择“环境变量”；
2. 在“用户变量”里找到 `Path`，点击编辑；
3. 新建一行，把工具的可执行文件目录粘贴进去；
4. 保存后重启终端。

一个常见例子是 Claude Code 安装后提示 `~/.local/bin` 没有加入 PATH。把对应的目录加进去，终端就能识别 `claude` 命令了。

## 终端配置

Windows 自带的终端能用，但标签页、字体、配色和配置都不太顺手。Windows Terminal 可以直接在 Microsoft Store 里搜索安装，装完把默认终端配置成 PowerShell 7 即可。

安装 PowerShell 7、配置 UTF-8 的步骤可以参考 [在 Windows 上安装 PowerShell 7](https://learn.microsoft.com/zh-cn/powershell/scripting/install/install-powershell-on-windows?view=powershell-7.6)，这里不重复。

简单说，PowerShell 7 对 UTF-8 的支持更好，和 Codex 这类 Agent 工具的兼容性也比 Windows 自带的 5.1 版本稳定。装完用 `pwsh` 打开 7.x，`powershell` 打开的仍然是 5.x，两个版本可以并存。

## Git 安装

Agent 一次可能改十几个文件，出了问题靠记忆回退很不现实。Git 的价值就在这里：每次改动都有记录，随时可以对比、回退、开分支。

到 [Git 官网](https://git-scm.com/install/windows) 下载安装包。安装过程中有几个选项值得注意：

- **默认编辑器**：默认的 Vim 对新手不友好，可以改成 VS Code（注意不要选 Insiders 版本）；
- **初始分支名**：选择自定义并填 `main`，现在大多数新仓库都用 `main` 作为主分支；
- **PATH 配置**：选择推荐选项，安装后就能直接在终端里使用 Git；
- **换行符转换**：选择第一个选项，避免提交时出现莫名其妙的换行错误；
- **凭据管理器**：选择 Git Credential Manager，第一次输入账号密码后会加密保存，后面提交和推送不用反复输入。

装完验证：

```bash
git --version
```

### Git 基本概念

Git 的概念很多，刚开始只需要抓住四个：

- **仓库（repository）**：一个项目文件夹，Git 会记录里面文件的变化；
- **提交（commit）**：一次有说明的存档，相当于给当前状态拍一张快照；
- **分支（branch）**：从主线上分出来的一条独立开发线；
- **合并（merge）**：把分支上的改动并回主线。

最重要的使用习惯是：**开发新功能或做实验时，先开一个分支，不要直接改 `main`。**

分支上的改动是独立的，不会影响主干。你可以在分支上反复修改、验证，没问题了再合并回去；如果实验失败，直接丢弃分支就行，主干仍然是干净的。这样代码不会乱，出了问题也容易定位是哪一次改动引入的。

![Git 分支示意](https://cdn.jsdelivr.net/gh/WiseZenn/Blog-assets@main/windows-dev-env/windows-dev-env-git-branches.png)

你不需要背 `git commit`、`git push`、`git merge` 这些命令。把需求说清楚，让 Agent 去执行就好。但你要知道现在在哪个分支、这次改动应该提交到哪里、合并前有没有验证过。

## 相对路径

这一条和 Git 没有直接关系，但它是项目管理里最容易踩的坑之一。

写代码或 Markdown 时，引用外部文件尽量用相对路径，比如：

```text
./assets/image.png
```

而不是：

```text
D:\Candy\Agent\assets\image.png
```

绝对路径的问题在于，它把文件绑定到了某台电脑的某个位置。你把项目文件夹移动到桌面，或者换一台电脑，路径就失效了。相对路径只关心“文件相对于当前项目在哪里”，整个文件夹一起移动、打包、发给别人，都不会断。

Typora 的图片路径就是一个典型例子。如果先粘贴图片再保存文档，Typora 可能把图片存到 C 盘的默认目录，并且写成绝对路径。当时看着没问题，等重装系统或换电脑，图片就全挂了。具体的设置步骤我放在[Typora 与 Markdown 写作配置](https://wisezenn.github.io/zh/blog/2026/typora-markdown-zh/)里，这里只记住一个原则：**先保存文档，再插入图片，路径用 `./assets/`。**

## GitHub 的用途

GitHub 是世界上最大的开源社区，里面有很多人贡献的代码。对 Agent 工作流来说，它至少有三个价值：

1. **找参考实现**：很多工作不需要从零开始，可以先找同类项目，再让 Agent 基于它改；
2. **管理自己的代码**：公开项目可以展示，私有项目可以只给自己看；
3. **作为协作和交付的入口**：Issue、PR、Release、Actions 都围绕仓库展开。

找参考项目时，可以先用关键词搜索，也可以让 Agent 用 GitHub CLI 去检索。找到合适的仓库后，不要直接让 Agent 大改，先让它读一遍 README、目录结构和核心文件，说明这个项目是怎么组织的，再决定从哪里下手。

![GitHub 搜索](https://cdn.jsdelivr.net/gh/WiseZenn/Blog-assets@main/windows-dev-env/windows-dev-env-github-search.png)

如果你不想公开自己的项目，用私有仓库就行。GitHub 的私有库同样可以做版本管理，只有你自己能看到。

需要特别注意：**不要把 API Key、密码、个人隐私写进仓库。** 哪怕是私有库，也建议用环境变量或本地配置文件，并把敏感文件加进 `.gitignore`。公开仓库更要小心，一旦推送上去，即使后来删除，也可能已经被缓存或 fork。

### Code 与 Releases

打开一个仓库，绿色的 `Code` 按钮里有两个常用选项：

![GitHub Code 按钮](https://cdn.jsdelivr.net/gh/WiseZenn/Blog-assets@main/windows-dev-env/windows-dev-env-github-code-button.png)

- **Download ZIP**：把整个仓库打包下载，适合只想看代码、不打算长期同步的情况；
- **HTTPS / SSH 地址**：配合 `git clone` 把仓库下载到本地，后续可以拉取更新、提交改动。

`git clone` 需要先安装 Git。一般选 HTTPS 就够了，认证更简单。

不是所有仓库都只提供源码。有些项目会把代码打包成可执行程序，放在右下角的 `Releases` 里。

![GitHub Releases](https://cdn.jsdelivr.net/gh/WiseZenn/Blog-assets@main/windows-dev-env/windows-dev-env-github-releases.png)

点进最新版本，页面上面通常是更新说明，滑到最下面的 `Assets` 才是安装包。

![Release Assets](https://cdn.jsdelivr.net/gh/WiseZenn/Blog-assets@main/windows-dev-env/windows-dev-env-github-release-assets.png)

文件名一般会包含：

- 版本号，比如 `v3.19`；
- 操作系统，比如 `Windows`、`Linux`、`macOS`；
- 芯片架构，比如 `x64`、`arm64`。

Windows 用户大多数情况下下载 `Windows x64` 的 `.msi` 或 `.exe` 就行。ARM 设备（比如部分轻薄本）才需要选 `arm64`。如果只是想用这个软件，直接下安装包，不用下源码。

## GitHub CLI

没有 GitHub CLI 时，Agent 想参考一个开源项目，只能让你手动下载，或者去网页上抓。装了 `gh` 之后，它可以直接搜索仓库、查看文件、克隆代码、创建仓库、提 Issue 和 PR。

安装：

```bash
winget install --id GitHub.cli
```

登录授权：

```bash
gh auth login
```

交互选项里，平台选 `GitHub.com`，协议选 `HTTPS`，然后按提示在浏览器里输入一次性验证码。

![GitHub CLI 登录选项](https://cdn.jsdelivr.net/gh/WiseZenn/Blog-assets@main/windows-dev-env/windows-dev-env-gh-auth-options.png)

![GitHub CLI 一次性验证码](https://cdn.jsdelivr.net/gh/WiseZenn/Blog-assets@main/windows-dev-env/windows-dev-env-gh-auth-code.png)

登录成功后，Agent 就能在终端里直接使用 GitHub 的能力了。

HTTPS 和 SSH 的区别主要在认证方式。SSH 需要配置公钥和私钥，安全性更高，适合长期使用；HTTPS 更简单，对个人项目足够了。

## 版本管理实践

有了 Agent 之后，我很少自己敲 Git 命令了。常见的做法是：

- 让 Agent 为新功能开一个分支；
- 每完成一小步就提交一次，提交信息写清楚改了什么；
- 合并前让 Agent 跑测试、检查 diff；
- 如果改坏了，直接回退到上一个提交或丢弃分支。

但“交给 Agent”不等于“完全不看”。至少要看一眼这次改了哪些文件、提交信息是否准确、有没有把不该提交的东西带进去。版本管理是安全网，不是自动驾驶。

如果你在用 Claude Code 或 Codex，可以在项目里放一份 `CLAUDE.md` 或 `AGENTS.md`，把提交规范、分支策略、测试命令写进去。这样 Agent 每次动手前都会先读到这些约束，比每次口头交代更可靠。

## WSL 与远程开发

如果你的方向会涉及 Linux 工具链、服务器部署或者一些只在 Linux 上跑的实验，可以装 WSL：

```bash
wsl --install
```

然后在 WSL 里安装 Ubuntu 等发行版。VS Code 可以连接 WSL，也可以连接远程服务器：左下角打开远程窗口，选择 `Connect to WSL` 或 `Remote-SSH`，就能像编辑本地文件一样编辑远程目录。

WSL 的完整配置我写在[WSL2 开发环境配置笔记](https://wisezenn.github.io/zh/blog/2026/wsl2-dev-environment-zh/)里了。

## 安装检查清单

- [ ] `node -v` 和 `npm -v` 能正常输出版本号
- [ ] PowerToys 能打开环境变量面板
- [ ] `git --version` 正常
- [ ] `gh auth status` 显示已登录
- [ ] `pwsh` 打开的是 PowerShell 7.x
- [ ] Windows Terminal 默认配置为 PowerShell 7
- [ ] 新项目统一使用项目内的相对路径

环境不是目的。能稳定地让 Agent 跑起来，比装了多少工具重要得多。
