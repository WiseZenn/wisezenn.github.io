---
layout: post
title: "PowerShell 7 on Windows: UTF-8 Encoding and Default Terminal Setup"
date: 2026-10-14 20:43:00 +0800
categories: ["Tools & Resources"]
tags: ["PowerShell", "UTF-8", "Windows Terminal", "VS Code"]
description: "Setting up PowerShell 7 on Windows: UTF-8 encoding and default terminal switch."
lang: en
lang-ref: post-powershell-7-setup-01
series_key: geek-survival-guide
series_order: 5
toc:
  sidebar: left
giscus_comments: true
---

Codex and the PowerShell that ships with Windows don't get along. The symptom I kept hitting was encoding: Codex would re-run the same command over and over, burning quota for nothing.

PowerShell 7 is more compatible and speaks UTF-8 natively, so I switched. Windows still ships 5.1 by default — check what you're on first:

```powershell
$PSVersionTable
```

![Windows PowerShell 5.1 version info](https://cdn.jsdelivr.net/gh/WiseZenn/Blog-assets@main/powershell-7-setup/powershell-7-setup-version-check.png)

## Install PowerShell 7

Search for the latest version with winget:

```powershell
winget search --id Microsoft.PowerShell --exact
```

Then install:

```powershell
winget install --id Microsoft.PowerShell --source winget
```

If the install fails, it's usually the network — flip your VPN on or off and try again.

![winget install output](https://cdn.jsdelivr.net/gh/WiseZenn/Blog-assets@main/powershell-7-setup/powershell-7-setup-winget-install.png)

### Or install from MSI

There's also an MSI installer. Microsoft's docs cover it here: [Installing PowerShell on Windows \| Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/scripting/install/install-powershell-on-windows?view=powershell-7.6).

Direct download: https://github.com/PowerShell/PowerShell/releases/download/v7.6.6/PowerShell-7.6.6-win-x64.msi

Once it's in, open pwsh and check the encoding. Note that `powershell` still opens 5.x while `pwsh` opens 7.x — the two versions live side by side, and the default terminal is still the old one. A fresh install isn't on UTF-8 either; run `chcp`, and if it doesn't print 65001, you're not there yet.

## Set UTF-8 Encoding

Run this in PowerShell (paste it in and hit enter):

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

![Writing the UTF-8 settings into $PROFILE](https://cdn.jsdelivr.net/gh/WiseZenn/Blog-assets@main/powershell-7-setup/powershell-7-setup-utf8-profile.png)

PowerShell now defaults to UTF-8, which cuts down on mojibake.

## Make It the Default Terminal

Restart the terminal and open the menu on the right side of the tab bar:

![Terminal profile menu](https://cdn.jsdelivr.net/gh/WiseZenn/Blog-assets@main/powershell-7-setup/powershell-7-setup-terminal-profiles.png)

There's a new PowerShell entry. The `Windows PowerShell` one is 5.1; `PowerShell` below it is 7.

Open Settings to change the default profile — pick the `PowerShell` entry at the bottom:

![Selecting the default profile](https://cdn.jsdelivr.net/gh/WiseZenn/Blog-assets@main/powershell-7-setup/powershell-7-setup-default-profile.png)

If you want to tell them apart at a glance, scroll down and rename the profile to `PowerShell 7`:

![Renaming the profile](https://cdn.jsdelivr.net/gh/WiseZenn/Blog-assets@main/powershell-7-setup/powershell-7-setup-rename-profile.png)

Save, restart the terminal, and you're on PowerShell 7.

![Terminal after restart](https://cdn.jsdelivr.net/gh/WiseZenn/Blog-assets@main/powershell-7-setup/powershell-7-setup-restart-terminal.png)

## VS Code and Codex

Codex usually needs nothing — it follows the system default, so if Settings already shows PowerShell, leave it.

![Codex terminal settings](https://cdn.jsdelivr.net/gh/WiseZenn/Blog-assets@main/powershell-7-setup/powershell-7-setup-codex-settings.png)

VS Code does need a change. Run `$PSVersionTable` again to see what it's using:

![PowerShell version inside VS Code](https://cdn.jsdelivr.net/gh/WiseZenn/Blog-assets@main/powershell-7-setup/powershell-7-setup-vscode-version.png)

Hit `Ctrl + Shift + P` and type `Terminal: Select Default Profile`:

![VS Code command palette](https://cdn.jsdelivr.net/gh/WiseZenn/Blog-assets@main/powershell-7-setup/powershell-7-setup-vscode-command-palette.png)

Pick the `PowerShell` entry without `Windows` in the name — the one whose path ends in `pwsh.exe`. If it's not in the list, restart VS Code: if it was already running when you installed PowerShell 7, it won't pick up the new profile on its own.

![Choosing the pwsh profile](https://cdn.jsdelivr.net/gh/WiseZenn/Blog-assets@main/powershell-7-setup/powershell-7-setup-vscode-pwsh-profile.png)

Open a fresh terminal (delete the old one from the panel's top-right corner) and run `$PSVersionTable` one more time — the version has changed.

![Version check in the new VS Code terminal](https://cdn.jsdelivr.net/gh/WiseZenn/Blog-assets@main/powershell-7-setup/powershell-7-setup-vscode-verify.png)

## References

- [Installing PowerShell on Windows \| Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/scripting/install/install-powershell-on-windows?view=powershell-7.6)
- [Fixing PowerShell 7's default encoding to UTF-8](https://blog.kaish.cn/posts/2026/fix-powershell-7-utf8-encoding-issue/)
- [Making Codex use PowerShell 7 by default on Windows](https://liuch4ng.github.io/tools/codex-powershell7/#powershell-7)
