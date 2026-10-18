---
layout: post
title: "Zotero + LLM: Let an Agent Read With You"
date: 2026-07-26 12:00:00 +0800
categories: ["Tools & Resources"]
tags: ["Zotero", "LLM", "Literature Review", "Codex"]
description: "Connect DeepSeek, Copilot, and Codex to Zotero so summaries and notes are grounded in your actual library."
lang: en
lang-ref: post-agent-onboarding-04
series_key: productivity-toolbox
series_order: 2
toc:
  sidebar: left
giscus_comments: true
---

The hard part of reading papers is often not finishing them. It is remembering what you read, organizing it, and finding the right citation when you write a review.

The LLM for Zotero plugin connects a model to Zotero so an agent can read your library, tags, highlights, and notes. Compared with dropping a PDF into a web chat, the advantage is **context**: the model knows what you have collected, marked, and read. Its answers stay closer to your material and hallucinate less.

Where the papers come from is the other half of the problem. If search and download are still messy, use OpenCLI to pull real pages and database results first, then import them into Zotero. I wrote about that in [OpenCLI: Turn Websites into a CLI for Agents](https://wisezenn.github.io/blog/2026/opencli-en/).

> Plugins and model versions change quickly. The screens and model names below are from the version I used. If something doesn't match, check the official docs first.

## Installing the plugin

Download the latest release from GitHub:

[Releases · yilewang/llm-for-zotero](https://github.com/yilewang/llm-for-zotero/releases)

In Zotero, open Tools → Plugins, choose "Install Plugin From File," select the `.xpi`, and restart Zotero.

The official docs have more detail:

[llm-for-zotero documentation](https://yilewang.github.io/llm-for-zotero/zh)

## DeepSeek setup

Open the plugin settings and create a provider:

- set `auth mode` to `API Key`;
- set `Provider` to `DeepSeek`;
- the API URL is filled in automatically;
- paste the DeepSeek API key you created earlier;
- set `model name` to `deepseek-v4-pro`;
- click test; a success message means it works.

Add a second model, `deepseek-v4-flash`, as the lighter everyday option. Model names and versions change quickly; check the [DeepSeek API docs](https://api-docs.deepseek.com/zh-cn/) for the current names.

![DeepSeek configuration](https://cdn.jsdelivr.net/gh/WiseZenn/Blog-assets@main/zotero-llm/zotero-llm-deepseek-config.png)

DeepSeek is cheap and stable, which makes it good for reading and summarizing in volume. The latest models now have multimodal capability. If the plugin side keeps up, you can read figures and screenshots directly; if your plugin version does not support images yet, text-heavy papers are still fine.

## GitHub Copilot setup

If you have Copilot quota, it can serve as a supplement:

- set `auth mode` to `GitHub Copilot`;
- log in to GitHub and authorize when prompted;
- try `gpt-4.1` or `gpt-4o` as the model name.

Copilot's free quota and model selection keep shrinking, but it is still enough for screenshot recognition, figure questions, and simple Q&A. In practice it handles figures and charts in papers reasonably well and does not use much quota.

![GitHub Copilot authorization](https://cdn.jsdelivr.net/gh/WiseZenn/Blog-assets@main/zotero-llm/zotero-llm-copilot-auth.png)

## Agent mode

The setup above mainly solves chat. Agent mode is the more interesting part.

The plugin currently connects to agent capability through Codex CLI. It requires ChatGPT Plus and consumes Codex quota. Install Codex first:

```bash
npm install -g @openai/codex
codex login
```

Then enable and test the agent configuration in the plugin. The bottom of the settings page lets you choose where notes are exported.

![Agent configuration and test](https://cdn.jsdelivr.net/gh/WiseZenn/Blog-assets@main/zotero-llm/zotero-llm-agent-config.png)

![Note export path](https://cdn.jsdelivr.net/gh/WiseZenn/Blog-assets@main/zotero-llm/zotero-llm-note-export.png)

The value of agent mode is that it does not look at one paper in isolation. It can read the whole library:

- which papers you have collected;
- which tags you applied;
- which sentences you highlighted;
- which notes you wrote.

All of that becomes input. You can ask it to:

- organize the library by topic and find duplicates or gaps;
- draft a research background grounded in your papers instead of invented ones;
- export highlights and notes as Markdown for a second pass;
- turn the conversation into notes and extract the useful parts.

Compared with asking a web chat, this removes a lot of manual searching and pasting, and it is easier to trace a claim back to a source.

## A reading workflow skill

If you read papers the same way every time, turn that routine into a skill:

1. What is the research question?
2. What is the contribution, and how does it differ from prior work?
3. What theory, method, and experimental design are used?
4. What are the limitations, assumptions, and directions for extension?

That routine can be a prompt or a skill. Every paper then comes out in the same structure, which makes comparison much easier.

Code review, data analysis, and editing can have their own skills too. A skill packages experience so the agent behaves more consistently on a specific task.

Don't over-package. Models change, and so should the workflow. If a skill requires extra explanation and correction every time, it probably no longer fits the current model.

## Human review

An agent can help you read faster, but it cannot think for you.

My rule with these tools is simple: **review promptly and check by hand.**

After each generation, skim it at least once. Did it distort the source? Did it invent a citation? Did it state an uncertain conclusion as fact? If one output is too long, ask for less; make sure you actually read it.

The reason is not only correctness. AI writes much faster than humans read. It is easy to end up collecting a lot and remembering nothing. If you are just a numb recorder, more notes will not turn into understanding.

So I treat the agent's output as a draft, not a final answer. The valuable part is the judgment I form while reading and revising.

## Importing papers

Beyond the plugin, browser extensions such as EndNote Click help. Once configured, you can import a paper into Zotero directly from a database page instead of downloading the PDF and dragging it in.

LLM for Zotero also supports a web-chat mode, which is fine for quick questions about a single paper. For organizing a whole library, agent mode is the better fit.

## Limits

Zotero + LLM is useful, but a few things are still on you:

- the model may invent citations or misread the source; check important conclusions against the paper;
- plugins and models change quickly, so old tutorials may not match the current UI;
- if the library contains personal or unpublished material, don't send the whole library to a third-party service without thinking;
- agent-generated summaries, backgrounds, and notes are drafts, not research conclusions.

The more convenient the tool, the more important it is to draw your own line. An agent can help you read faster, but it cannot think for you.
