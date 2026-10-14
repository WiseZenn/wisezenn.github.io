---
layout: post
title: "PowerShell 7 安装与 UTF-8 编码配置"
date: 2026-10-14 20:43:00 +0800
categories: ["Tools & Resources"]
tags: ["PowerShell", "UTF-8", "Windows Terminal", "VS Code"]
description: "在 Windows 上安装 PowerShell 7，配置 UTF-8 编码并设为默认终端。"
lang: zh
lang-ref: post-powershell-7-setup-01
series_key: geek-survival-guide
series_order: 5
toc:
  sidebar: left
giscus_comments: true
---

Codex 和 Windows 自带的 PowerShell 一直不太合得来，编码是其中一个比较典型的问题。具体表现是 Codex 会反复执行同一条命令，来回几次，额度就白白消耗掉了。

后来刷到 PowerShell 7 的兼容性更好，原生支持 UTF-8，就打算换过去。Windows 默认装的是 5.1 版本，先用 `$PSVersionTable` 看一眼当前版本：

![Windows PowerShell 5.1 版本信息](https://cdn.jsdelivr.net/gh/WiseZenn/Blog-assets@main/powershell-7-setup/powershell-7-setup-version-check.png)

## 安装 PowerShell 7

用 winget 搜一下最新版本：

```powershell
winget search --id Microsoft.PowerShell --exact
```

安装：

```powershell
winget install --id Microsoft.PowerShell --source winget
```

如果提示安装失败，多半是网络问题，把梯子开关一下再试通常就好了。

![winget 安装 PowerShell 7](https://cdn.jsdelivr.net/gh/WiseZenn/Blog-assets@main/powershell-7-setup/powershell-7-setup-winget-install.png)

### 用 msi 安装

也可以直接下 msi 安装包，参考[在 Windows 上安装 PowerShell 7 - PowerShell \| Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/scripting/install/install-powershell-on-windows?view=powershell-7.6)。

安装包地址：https://github.com/PowerShell/PowerShell/releases/download/v7.6.6/PowerShell-7.6.6-win-x64.msi

装完打开 pwsh 看默认编码。这里注意，`powershell` 命令打开的还是 5.x，`pwsh` 打开的才是 7.x，两个版本是并存的，后面再改默认终端。刚装好时编码也不是 UTF-8，用 `chcp` 看一下，输出的不是 65001 就不是 UTF-8。

## 设置 UTF-8 编码

在 PowerShell 里执行下面这段（复制粘贴回车就行）：

```powershell
$dir = Split-Path $PROFILE -Parent
if (!(Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force }

@'
$utf8 = [System.Text.UTF8Encoding]::new($false)
[Console]::InputEncoding = $utf8
[Console]::OutputEncoding = $utf8
$OutputEncoding = $utf8
$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'
$PSDefaultParameterValues['Set-Content:Encoding'] = 'utf8'
$PSDefaultParameterValues['Add-Content:Encoding'] = 'utf8'
$env:PYTHONUTF8 = '1'
$env:PYTHONIOENCODING = 'utf-8'
'@ | Out-File -FilePath $PROFILE -Encoding utf8

. $PROFILE
```

![写入 $PROFILE 设置 UTF-8 编码](https://cdn.jsdelivr.net/gh/WiseZenn/Blog-assets@main/powershell-7-setup/powershell-7-setup-utf8-profile.png)

这样 PowerShell 的默认编码就是 UTF-8 了，能少遇到不少乱码。

## 设为默认终端

重启终端，点开标签页右侧的菜单：

![终端配置文件菜单](https://cdn.jsdelivr.net/gh/WiseZenn/Blog-assets@main/powershell-7-setup/powershell-7-setup-terminal-profiles.png)

可以看到多了一个 PowerShell：上面那个 `Windows PowerShell` 是 5.1 版本，下面这个 `PowerShell` 是 7 版本。

然后进设置改默认配置，选最下面的 `PowerShell`：

![选择默认配置文件](https://cdn.jsdelivr.net/gh/WiseZenn/Blog-assets@main/powershell-7-setup/powershell-7-setup-default-profile.png)

想区分得清楚一点，可以往下滑，把 `PowerShell` 的名字改成 `PowerShell 7`：

![重命名配置文件](https://cdn.jsdelivr.net/gh/WiseZenn/Blog-assets@main/powershell-7-setup/powershell-7-setup-rename-profile.png)

保存之后重启终端，打开的就是 PowerShell 7 了。

![重启后的终端](https://cdn.jsdelivr.net/gh/WiseZenn/Blog-assets@main/powershell-7-setup/powershell-7-setup-restart-terminal.png)

## VS Code 和 Codex

Codex 一般不用改，它跟随系统默认，在设置里看到默认是 PowerShell 就不用动。

![Codex 设置中的默认终端](https://cdn.jsdelivr.net/gh/WiseZenn/Blog-assets@main/powershell-7-setup/powershell-7-setup-codex-settings.png)

VS Code 需要调一下，还是先执行 `$PSVersionTable` 看默认版本：

![VS Code 中的 PowerShell 版本](https://cdn.jsdelivr.net/gh/WiseZenn/Blog-assets@main/powershell-7-setup/powershell-7-setup-vscode-version.png)

按 `Ctrl + Shift + P` 打开命令面板，输入 `Terminal: Select Default Profile` 后回车：

![VS Code 命令面板](https://cdn.jsdelivr.net/gh/WiseZenn/Blog-assets@main/powershell-7-setup/powershell-7-setup-vscode-command-palette.png)

还是找不带 `Windows` 的那个 `PowerShell`，路径结尾是 `pwsh.exe`。如果没有这个选项，重启一下 VS Code——如果在安装 PowerShell 7 之前就启动了它，配置文件不会自动重新读取。

![选择 pwsh 配置文件](https://cdn.jsdelivr.net/gh/WiseZenn/Blog-assets@main/powershell-7-setup/powershell-7-setup-vscode-pwsh-profile.png)

然后新开一个终端（别用原来那个，可以在终端右上角把它删掉），再执行一次 `$PSVersionTable`，版本就变了。

![VS Code 新终端中的版本](https://cdn.jsdelivr.net/gh/WiseZenn/Blog-assets@main/powershell-7-setup/powershell-7-setup-vscode-verify.png)

## 参考链接

- [在 Windows 上安装 PowerShell 7 - PowerShell \| Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/scripting/install/install-powershell-on-windows?view=powershell-7.6)
- [修改 Powershell 7 默认编码为 UTF-8 \| 开水的博客](https://blog.kaish.cn/posts/2026/fix-powershell-7-utf8-encoding-issue/)
- [让 Codex 在 Windows 上默认使用 PowerShell 7 - 学习笔记](https://liuch4ng.github.io/tools/codex-powershell7/#powershell-7)
