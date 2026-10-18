---
layout: post
title: "Learning and Research in the Age of AI"
date: 2026-09-23 12:00:00 +0800
categories: ["DevOps & Workflow"]
tags: ["Learning", "Research Workflow", "AI Agent", "Skill"]
description: "AI lowers the barrier to building, not understanding. A workflow around concepts, a base code library, reproduction, and output."
lang: en
lang-ref: post-agent-onboarding-07
series_key: geek-survival-guide
series_order: 8
toc:
  sidebar: left
giscus_comments: true
---

AI makes it easier to build something, and easier to skip understanding it.

Reproducing a paper or writing a numerical program used to take weeks. Now you can describe the requirement and get a runnable first version from an agent in a short time. Lower barriers are good, but if you skip the fundamentals, you won't know where to start when something breaks.

My take: **build the fundamentals, keep enough breadth, and let the agent handle execution and trial and error.**

## A concept map

The most important part of learning a field is not memorizing APIs. It is understanding the paradigms.

Object orientation, resource management, parallel computing, numerical stability, memory hierarchy: these do not become obsolete when you switch frameworks. You don't need to write high-performance code on day one, but you should know these problems exist and which tool fits which problem.

That is what lets you describe constraints to an agent and judge whether its proposal is reasonable.

For learning order, I suggest official docs and classic textbooks first, blogs and videos second. Official docs are current and consistent. Blogs vary in quality; they are good for intuition, not as a sole source.

"Learn slowly and you learn fast" has some truth in the AI era. Models change quickly. An API you spend days memorizing may be different tomorrow. Concepts, paradigms, and debugging instincts age much more slowly.

## A base code library

Every field has a set of basic algorithms and procedures. Implementing them, verifying them, and keeping your own code library is a valuable investment.

Use an agent for this, but don't hand over the whole process:

1. Work out the inputs, outputs, and edge cases yourself.
2. Have the agent generate a first version.
3. Derive the key formulas yourself and check that the implementation matches.
4. Write tests and verify with simple cases.
5. Then let the agent optimize, refactor, and document.

The library does not need to be large. It needs to be something you actually understand. When a new problem appears, you can adapt this base instead of starting from zero.

Reading existing code from your lab or team is also useful. Many details never make it into a paper but live in the code: how boundaries are handled, how parameters are chosen, how things are accelerated. Have the agent help you understand the code, then explain it back in your own words. That is a strong way to learn.

## Reproducing papers

Reading a paper and reproducing it are two different kinds of understanding.

When you read, you see the author's cleaned-up logic: problem, method, experiment, conclusion. When you reproduce, you hit the details the author left out: how the data was preprocessed, how parameters were chosen, what to do when results look bad. Those details are often the real craft.

My process:

1. Pick a paper related to your direction with a manageable amount of code.
2. Read the abstract, method, and experimental setup first.
3. Have the agent scaffold a reproduction.
4. Get the baseline running yourself, then align with the paper step by step.
5. Record the gaps and analyze why they exist.
6. Change one or two parameters or conditions and see what happens.

The reproduction does not have to match exactly. Often the gap is where a new question starts. Why does this setting work and that one not? Those questions turn you from someone who reads papers into someone who does research.

## Turning ideas into code

Once you have an idea, my advice is: **don't worry about whether someone has done it. Implement it first.**

The reason is simple. The cost of an implementation is now mostly tokens and time, not months of programming. You can have an agent build a prototype and run a few experiments to see whether the idea holds. Then check the literature and compare.

This order has two benefits:

- you understand the problem more deeply because you start from implementation and results, not from someone else's conclusions;
- even if someone has done it, you can explain how your approach differs.

Reading the literature still matters. Checking before implementation tends to lock you into someone else's framing; checking after makes the real differences easier to see.

If the idea doesn't work, it wasn't wasted. Review why it failed and which assumption was wrong. That experience is often more valuable than a survey that looks plausible.

## Information retrieval

AI search is convenient, but I don't rely on it completely.

A few reasons:

- model databases have limited coverage; many papers and sources are inaccessible;
- search results can be biased, including by commercial incentives;
- models can invent citations, especially reference details and DOIs;
- consuming only recommended content makes it easy to end up in an echo chamber.

My habit: use AI to generate keywords and suggest directions, then search the databases myself and read the abstracts and conclusions. AI can speed up the process, but it cannot replace judgment.

Read broadly too. Books outside your field and articles from other areas often provide a different angle. Many innovations come from transfer and combination, and transfer requires knowing what exists elsewhere.

## Turning routines into skills

After using agents for a while, you notice that many tasks repeat: reading papers, reviewing code, organizing notes, writing weekly updates. These routines can become skills.

A literature-reading skill can fix the output structure:

- research question;
- contribution;
- method;
- experimental setup;
- main conclusions;
- limitations and directions for extension.

A code-review skill can fix the review order:

- is the architecture reasonable;
- are edge cases handled;
- is error handling complete;
- do tests cover the critical paths;
- are there obvious performance problems.

A skill does not need to be complex at first. Write down the prompt you already use, run it a few times, see where it is unstable, and improve it. Once the routine is stable, consider turning it into a reusable skill or plugin.

Don't over-package. Models change, and workflows should change with them. If a skill requires extra explanation and correction every time, it probably no longer fits the current model.

## Keep publishing

I think output is the most important part of the learning loop.

Writing a blog, building a personal site, or organizing notes forces you to turn fuzzy understanding into clear expression. If you can't explain it, you probably haven't understood it yet. The output also becomes a digital asset: when you ask an agent to help later, your notes, code, and documents are reusable context.

A personal site does not need to wait until you are "ready." Pick a template, host it on GitHub Pages, and publish the first post. Once you have the habit of output, your input gets more direction too.

## Closing

AI is powerful, but its power rests on existing knowledge. Expanding the boundary still requires a human to ask the question, choose the direction, and own the result.

So: let the agent be your execution assistant, discussion partner, and review tool. Don't let it think for you.

Stay curious. Stay skeptical. Keep thinking.
