---
layout: post
title: "Agent Basics: From Chat to Execution"
date: 2026-05-13 12:00:00 +0800
categories: ["DevOps & Workflow"]
tags: ["AI Agent", "CLI", "GitHub CLI", "Workflow"]
description: "What an agent actually is, how the model, shell, and tools fit together, and why CLI is its natural interface."
lang: en
lang-ref: post-agent-onboarding-01
series_key: geek-survival-guide
series_order: 6
toc:
  sidebar: left
giscus_comments: true
---

Most people meet an LLM through a chat box. You ask, it answers, and occasionally it writes a piece of code or edits a paragraph. At that stage the AI is basically a knowledge base: useful for suggestions and outlines, but you still do the work.

Agents change that. The AI starts doing the work: reading files, running commands, editing code, calling tools, and sometimes finishing an entire workflow while you sleep. "Tell me how" and "do it for me" are very different product categories.

## The structure of an agent

An agent has roughly three layers:

- **The model is the brain**: DeepSeek, GPT, GLM, and similar models handle understanding and reasoning.
- **The agent tool is the shell**: Claude Code, Codex, and friends organize the conversation, tool calls, memory, and permissions.
- **CLI, filesystem, and browser are the hands and feet**: they execute commands, read and write files, and access the web.

So an agent is "LLM + shell + hands." It is not a simple sum, though. The shell contains a lot of details: how prompts are organized, how tools are exposed, how memory is stored, how multiple agents coordinate. Those details explain why the same model feels so different in different tools.

It also explains something I keep noticing: when your plan is clear, the brain matters less. If the plan is specific enough, a slightly weaker model can still execute it well. The real difference usually comes from how good the hands are and how comfortable the shell feels.

## Theory and architecture

An agent can execute for you, but it cannot define the problem for you.

If you only half-understand a domain, you will struggle to describe what you want, let alone judge whether the result is correct. When the code breaks, you will not know whether it is an environment issue, a logic issue, or the model making things up. Your theoretical depth sets the ceiling on what you can do with an agent.

AI is very good inside existing knowledge. It is much weaker when the direction is new and requires deep customization; there you usually need to provide the framework. It can combine, transfer, and optimize within a known space. It cannot invent a new field out of nothing. Your domain knowledge is the rope that keeps it pointed in the right direction.

So my attitude is simple: use AI as a tool, but don't give up thinking just because the tool exists.

## Skills, plugins, and workflows

After using agents for a while, you run into two concepts: skills and plugins.

- **A skill** is packaged capability. Under the hood it is still a set of prompts, tools, and procedures, just made reusable.
- **A plugin** is more like a toolbox. It bundles a group of skills related to one piece of software so the agent can operate that software.

Take literature reading. There is a fairly stable routine: find the contribution, look at the theory and method, then check the experiments and limitations. That routine can become a skill. Code review is similar: architecture first, then edge cases, then tests. That can also be a skill.

I would not install a pile of plugins on day one. Many plugins help when the model is not strong enough, because they add external constraints and keep it from wandering. But once the model can plan well, those constraints can become shackles: every step needs a plan and a retrospective, execution slows down, and tokens burn. Tools should evolve with model capability. What fits today is what matters.

The next layer up is the workflow. Claude Code's Workflow mode splits a task across multiple agents: one writes the plan, one writes code, one reviews, one handles documentation, and another summarizes. It feels like a small team and considers more angles, at the cost of much higher token usage. Good for complex tasks, overkill for everything else.

## Why CLI matters

We are used to graphical interfaces: open a page, find the search box, click a button, read the result. That is natural for humans because we are good at visual recognition.

Agents are not. To use a GUI, an agent has to understand pixels, recognize buttons, and simulate clicks. Every step is slow and expensive. A command line is deterministic: one command in, structured output out. No screenshots, no guessing.

Take GitHub. A human opens the site, types a query, clicks into a repository, and browses files one by one. If an agent does the same, it either relies on a multimodal model to read screenshots or parses the page structure. Neither is stable.

With CLI, it looks like this:

```bash
gh repo list
gh repo view owner/repo
gh api repos/owner/repo/contents
```

The output is structured text. The agent can read it, reason about it, and move to the next step without screenshots, OCR, or hunting for buttons.

Shopping works the same way. A human opens an app and immediately sees the search box. An agent has to simulate clicks and recognize product cards. Give it a shopping CLI and it only needs keywords and filters, then receives structured results. The efficiency is not in the same league.

CLI is a barrier for humans and the most natural interface for agents.

### How CLI came back

The first programmers used CLIs. Then GUIs took over because software had to serve ordinary users, and graphical interfaces were easier to understand. Now agents have pulled CLI back to the center.

This is not just nostalgia. Today's CLIs are different:

- better interaction: completion, color, progress bars;
- structured output such as JSON;
- proper authentication and permission management;
- direct use from scripts, pipes, and CI/CD.

CLI is the last mile for agents. Many tools only expose a GUI, so agents have to use computer use to simulate mouse and keyboard. If those tools exposed a CLI, a complicated sequence of clicks would become a single command.

Word formatting is a good example. Today an agent basically clicks and drags its way through it. If every style had a command, formatting would become "select a range, apply a command." That requires software vendors to open their interfaces, so it will not happen everywhere soon, but the direction is clear.

## GitHub CLI

GitHub CLI is one of my favorite CLI tools. Install it:

```bash
winget install --id GitHub.cli
```

Log in:

```bash
gh auth login
```

Choose `GitHub.com`, pick `HTTPS`, and enter the one-time code in the browser. After that, the agent can operate GitHub directly from the terminal.

A few common commands:

```bash
gh auth status
gh repo clone owner/repo
gh repo create my-project --private
gh api repos/owner/repo/contents
gh pr list
gh issue list
```

Without GitHub CLI, an agent that wants to reference an open-source project has to wait for you to download it or scrape the web page. You don't want to stop every time and download a copy by hand.

With it, the agent can search, read, and modify on its own. The whole flow gets much smoother.

One terminal tip: `Ctrl+C` usually interrupts the current program, it does not copy. To copy, select text and right-click; to paste, right-click where you want it. Once it becomes a habit, it is faster than reaching for keyboard shortcuts.

## Why consumer apps won't open up CLI

If CLI is so useful, why don't WeChat, Didi, or food delivery apps offer one?

It is not only security. Consumer apps make money from being the entry point and from attention. Users open the app, see the feed, recommendations, and ads, and the platform monetizes that traffic. A CLI with only chat, ride-hailing, or ordering would mean users no longer open the app. The ads disappear and the platform loses its position as the entry point.

That is why 2C products are naturally cautious about CLI. They are more likely to open up partially: expose some capabilities, partner with third parties, or put the entry point inside a phone maker's system-level agent and charge licensing fees.

2B works differently. Enterprise software charges subscriptions and service fees, and ads make it look unprofessional. Tools like Feishu and WeCom exist to improve collaboration, so they have more incentive to offer CLI, APIs, and automation. Online docs are the same: enterprises need version sync, clear communication, and permission management, and APIs do all of that better.

This is why CLI adoption will not happen evenly. It will mature first in developer tools, enterprise software, and parts of content platforms, then spread to other areas.

I also don't think one agent will take over every app. More likely we get partial access, partnerships, and on-device agents coexisting. Anyone who tries to flip the table gets attacked by everyone else. History keeps showing that entry points can be rebuilt, but they are very hard for one company to own completely.

## A minimal starting path

If you are new to agents, I would go in this order:

1. Install one CLI agent, such as Claude Code or Codex, and connect a model you can afford with enough quota.
2. Pick a task you already have to do and that repeats, such as organizing files, running a parameter sweep, or batch-editing images.
3. Write down the goal, boundaries, and acceptance criteria in plain language, then hand it to the agent.
4. Check the result before deciding whether to turn the step into a workflow.

Don't chase full automation on day one. Getting one small task working end to end is worth more than bookmarking a pile of tutorials.

How to set up the environment, how to turn the browser into a CLI, and how to read literature with an agent are topics for later posts. For this one, remember a single line:

**The LLM thinks and decides. The CLI executes and fetches data.**

An agent is not magic and it is not a button that replaces thinking. It is more like a very capable colleague who needs clear instructions. You define the problem, set the direction, and check the result. It makes the repetitive part faster.

Done is better than perfect. Get the idea running first.
