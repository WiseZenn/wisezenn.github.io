---
layout: post
title: From Single Commands to Agent Manuals: My Prompt Engineering Practices
date: 2026-04-08 23:00:00 +0800
categories: [DevOps & Workflow]
tags: [Prompt Engineering, AI Agent, System Architecture, Vibe Coding]
description: A practical post-mortem on stopping AI from writing spaghetti code using global architecture docs and system constraints.
lang: en
lang-ref: post-prompt-architecture-workflow-01
toc: 
  sidebar: left
series_key: geek-survival-guide
series_order: 2
---

For the longest time, I was highly skeptical of "Prompt Engineering." 

I always thought that as long as you described your requirements clearly and assigned a role to the AI, you were good to go. The myriad of complex prompt tutorials, "Chain of Thought" (CoT) techniques, and the very title of "Prompt Engineer" felt overhyped. As someone writing scripts and building personal projects, I simply didn't think I needed that level of complexity.

However, after spending the last six months heavily relying on various AI tools for a relatively large personal website project, my perspective has completely flipped.

### The AI Tool Landscape: Quirks and Pain Points

While pushing my project forward, I essentially test-drove all the mainstream tools. They all have their strengths, but also their fatal flaws:

- **Copilot (including CodeX)**: Great for inline completion, but in the IDE Chat, it suffers from severe context amnesia. It frequently loses track of what we were just discussing.
- **Gemini 3.1 Pro (AI Studio)**: Excellent for high-level direction. I often use it to scaffold ideas and draft initial Markdown plans. However, its web-based UI and quota limits make it hard to use for larger local codebases.
- **Antigravity (via Claude)**: Its "Plan" mode is stunning. It can take a simple prompt and expand it into a comprehensive `Implementation Plan.md`. For sheer project execution, I prefer it over Gemini. The dealbreaker? Network instability. Once the project scales or requirements stack up, it drops connections constantly.

Eventually, the actual execution almost always falls back to the VSCode Copilot Agent. Instead of just using it as an autocomplete tool or a code encyclopedia, I now use the Agent features to directly edit, generate, and debug code.

But as the Agent took over more responsibilities, **three infuriating pain points emerged**:

1. **The Version Control Black Hole**: Sure, there's an undo feature, but it's rarely clean. When an AI goes rogue and messes up multiple files, reverting is a nightmare. (I've had to force myself to `git commit` obsessively just to survive).
2. **Context Amnesia & The "Hotfix Menace"**: As the conversation grows, the Agent forgets previous changes. Instead of refactoring or maintaining architectural integrity, it defaults to slapping on localized hotfixes. It treats symptoms, not the disease.
3. **Over-engineering Simple Problems**: Without strict boundaries and a clear technical roadmap, Agents tend to overcomplicate simple logic. Code lines explode, the project rapidly rots into spaghetti code, and refactoring/reviewing becomes impossibly expensive.

### The Epiphany: Claude's Leak and the True Nature of Prompts

The turning point came when Claude's system prompts leaked recently. Reading through those, along with other viral system prompts, it hit me: **Advanced prompting isn't about teaching the AI how to talk; it's about injecting global behavioral constraints and rules into the Agent.**

Combining this with my pain points, I completely overhauled my workflow.

First, I forced the AI to scan the core files of my project and generate a **Global Architecture Document**. Previously, I avoided this to save Tokens. But I changed my mindset: if Tokens are expensive, make the AI take "notes" like a human developer. Once that architecture doc is set, it becomes the "Constitution" of the project.

I then wrote a set of constraints for the AI:
- **Before touching any code**: You must read and update the architecture document.
- **No blind hotfixes**: When facing a bug, think about architectural refactoring first, not just adding another `if-else`. 
- **Operational SOP**: When adding a feature, follow a strict template detailing scope, constraints, acceptance criteria, and log the changes.

By leveraging Github Actions and these rules, I created a set of **Copilot Repository Instructions**. It’s basically a hardcore instruction manual for the AI. Now, every action is traceable. Surprisingly, Token consumption dropped because the AI knows exactly where to look instead of guessing.

### Architecture is King in the AI Era

The biggest takeaway from this entire process? **If you nail the prompt inputs and set up a solid constraint document (like `CLAUDE.md`), the AI's ability to understand and implement code is lightyears ahead of us. But—and this is a massive "but"—AI still sucks at system architecture.**

We used to say architecture was important; now, it's a matter of life and death for a project.

Architecture requires high cohesion, loose coupling, systemic thinking, human intuition, and a bird's-eye view. **In a poorly structured project, AI will only accelerate the mess. In a cleanly architected, modular project, AI gives you superpowers.**

The core value of a senior engineer is shifting from "manually writing features" to "designing systems that allow AI to work efficiently." Hardcore skills like system design, modularization, and scalability haven't depreciated—if anything, they are more valuable today than ever. AI can write test cases in seconds, but defining boundaries and structuring directories still requires a human brain.

### Looking Ahead: Ideas Over Code

I realize I might just be catching up to what big tech companies are already doing internally, but arriving at this realization firsthand was crucial for me. 

My current prompt workflow is still somewhat basic. If I pivot to robotics or embedded systems, I'll definitely need domain-specific constraints. What does a system prompt look like for a 0-to-1 project? That requires more experimentation. 

I'm also looking into setting up a local LLM-powered Wiki to internalize these workflows. Next up, I plan to take this "vibe coding" experience and apply it to some hardware/software integration projects in robotics. 

The barrier to writing code has been flattened by AI. Moving forward, the only truly scarce resource is crazy, rigorously thought-out ideas.