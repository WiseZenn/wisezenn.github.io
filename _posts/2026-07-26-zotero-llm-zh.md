---
layout: post
title: "Zotero + LLM：让 Agent 参与文献阅读"
date: 2026-07-26 12:00:00 +0800
categories: ["Tools & Resources"]
tags: ["Zotero", "LLM", "Literature Review", "Codex"]
description: "把 DeepSeek、Copilot 和 Codex 接进 Zotero，让摘要和笔记建立在真实文献之上。"
lang: zh
lang-ref: post-agent-onboarding-04
series_key: productivity-toolbox
series_order: 2
toc:
  sidebar: left
giscus_comments: true
---

读文献的痛点，很多时候不是“读不完”，而是读完记不住、整理不动、写综述时找不到依据。

LLM for Zotero 这个插件把模型接进 Zotero，让 Agent 能读取你的文献库、标签、高亮和笔记。相比直接把 PDF 丢给网页端对话，它最大的优势是**有上下文**：模型知道你已经收藏了什么、标记了什么、读过什么，回答会更贴近你的资料，也更少胡编。

文献从哪里来是另一半问题。如果检索和下载还没有理顺，可以先用 OpenCLI 把真实网页和数据库里的内容拿下来，再导入 Zotero。这部分我写在[OpenCLI：把网站变成 Agent 的 CLI](https://wisezenn.github.io/zh/blog/2026/opencli-zh/)里。

> 插件和模型版本变化很快，下面的界面和模型名以我使用的版本为准。遇到对不上的地方，优先看官方文档。

## 插件安装

先到 GitHub 下载最新版本：

[Releases · yilewang/llm-for-zotero](https://github.com/yilewang/llm-for-zotero/releases)

然后在 Zotero 里打开“工具 → 插件”，选择“从文件安装插件”，选中下载的 `.xpi` 文件，重启 Zotero。

更详细的说明可以看官方文档：

[llm-for-zotero 文档](https://yilewang.github.io/llm-for-zotero/zh)

## DeepSeek 配置

打开插件的设置，新建一个 Provider：

- `auth mode` 选择 `API Key`；
- `Provider` 选择 `DeepSeek`；
- API 地址会自动填好；
- 填入之前申请的 DeepSeek API Key；
- `model name` 填 `deepseek-v4-pro`；
- 点击测试，出现 success 就表示配置成功。

再新建一个模型 `deepseek-v4-flash`，作为日常使用的轻量选项。模型名和版本变化很快，具体以 [DeepSeek API 文档](https://api-docs.deepseek.com/zh-cn/)为准。

![DeepSeek 配置](https://cdn.jsdelivr.net/gh/WiseZenn/Blog-assets@main/zotero-llm/zotero-llm-deepseek-config.png)

DeepSeek 的优点是便宜、稳定，适合大量阅读和摘要。现在最新模型的多模态能力已经补足，插件端如果跟上，就可以直接读图和截图；如果你的插件版本还没支持，先用它读文字为主的论文也没问题。

## GitHub Copilot 配置

如果你有 Copilot 的额度，也可以把它作为补充：

- `auth mode` 选择 `GitHub Copilot`；
- 按提示登录 GitHub 并授权；
- `model name` 可以尝试 `gpt-4.1`、`gpt-4o`。

Copilot 免费额度和可选模型都在收紧，但用来做截图识别、看图、简单问答还是够用的。实际使用中，它对论文里的图表识别效果不错，也不怎么消耗额度。

![GitHub Copilot 授权](https://cdn.jsdelivr.net/gh/WiseZenn/Blog-assets@main/zotero-llm/zotero-llm-copilot-auth.png)

## Agent 模式

前面的配置主要解决“对话”问题。更有意思的是 Agent 模式。

目前插件主要通过 Codex CLI 接入 Agent 能力，需要 ChatGPT Plus，并且会消耗 Codex 的额度。先安装 Codex：

```bash
npm install -g @openai/codex
codex login
```

然后在插件里勾选并测试 Agent 配置，最下面可以设置笔记的导出位置。

![Agent 配置与测试](https://cdn.jsdelivr.net/gh/WiseZenn/Blog-assets@main/zotero-llm/zotero-llm-agent-config.png)

![笔记导出路径](https://cdn.jsdelivr.net/gh/WiseZenn/Blog-assets@main/zotero-llm/zotero-llm-note-export.png)

Agent 模式的价值在于，它不只看当前这一篇论文，而是能读取整个文献库：

- 你收藏了哪些文献；
- 你打了什么标签；
- 你在阅读时高亮了哪些句子；
- 你写了哪些笔记。

这些都会成为输入的一部分。于是你可以让它：

- 按主题整理文献库，找出重复或遗漏；
- 基于已有文献生成研究背景，而不是凭空编；
- 把高亮和笔记导出成 Markdown，方便二次整理；
- 把对话过程整理成笔记，提取有效信息。

相比直接网页端问答，这种方式少了大量“找文献、贴文献”的手工步骤，也更容易追溯依据。

## 阅读流程 Skill

如果你经常用同一套方式读论文，可以把它固化成 Skill：

1. 先看研究问题是什么；
2. 再看创新点和前人工作的差异；
3. 然后看理论、方法和实验设计；
4. 最后看局限、适用条件和可扩展方向。

这套流程可以写成一段提示词，也可以做成 Skill。以后每读一篇论文，Agent 都按同样的结构输出，比较起来会方便很多。

同理，代码审查、数据分析、写作润色都可以有自己的 Skill。Skill 的本质是把经验封装起来，让 Agent 在特定任务上表现得更稳定。

但不要过度封装。模型能力在变，流程也要跟着变。一个 Skill 如果让你每次都要额外解释、额外修正，那它可能已经不适合当前的模型了。

## 人工复核

Agent 可以帮你读得更快，但不能替你思考。

我用这类工具有一个原则：**及时复核，人工审查。**

每次生成内容后，至少快速过一遍，看它有没有曲解原文、有没有编造引用、有没有把不确定的结论说得很肯定。如果一次生成太多，宁可让它少生成一点，也要保证自己真的看完。

原因不只是正确性。AI 生成内容的速度远远超过人的阅读速度，很容易变成“收藏了很多、什么都没记住”。如果只是做一个麻木的记录者，笔记再多也不会转化成自己的理解。

所以我会把 Agent 的输出当作草稿，而不是终稿。真正有价值的部分，是我在阅读和修改过程中形成的判断。

## 文献导入

除了插件本身，EndNote Click 这类浏览器插件也能帮上忙。配置好之后，在数据库页面可以直接把文献导入 Zotero，比手动下载 PDF 再拖进去省事。

另外，LLM for Zotero 也支持网页端对话模式，适合单篇论文的快速问答；如果是整个文献库的整理，还是用 Agent 模式更合适。

## 使用边界

Zotero + LLM 很好用，但有几件事需要自己把握：

- 模型可能编造引用或曲解原文，重要结论要回到原文核对；
- 插件和模型版本变化很快，旧教程可能对不上新界面；
- 文献库里有个人信息或未发表内容时，不要随便把整库数据传给第三方服务；
- Agent 生成的综述、背景和笔记只能当草稿，不能直接当成自己的研究结论。

工具越方便，越需要自己划边界。Agent 可以帮你读得更快，但不能替你思考。
