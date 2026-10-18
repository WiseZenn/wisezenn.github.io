---
layout: post
title: "AI-Assisted Workflows: Training Runs, Slides, and Publishing"
date: 2026-09-02 12:00:00 +0800
categories: ["DevOps & Workflow"]
tags: ["AI Workflow", "Codex", "python-pptx", "Deep Learning", "Automation"]
description: "Three levels of AI assistance: advice, generated files, and agent loops, illustrated with training, slides, calendars, and publishing."
lang: en
lang-ref: post-agent-onboarding-05
series_key: geek-survival-guide
series_order: 7
toc:
  sidebar: left
giscus_comments: true
---

"Use AI to be more productive" is too vague to act on. In practice, I find AI assistance falls into three levels:

1. **AI as an advisor**: talk to it in a web chat to clarify the problem and compare options.
2. **AI as a file generator**: it produces a usable `.ics`, `.pptx`, script, or document.
3. **AI as an agent loop**: it reads results, changes parameters, and runs the next round until the task is done.

The three levels have different costs and payoffs. Four concrete examples below.

## Advice and planning

This is the simplest level: open a web chat, describe the problem, and let the model break it down.

My habit is to sort out the thinking in the web chat first, then write the conclusion into a Markdown task brief for the next tool. The web chat does not consume agent execution quota, which makes it good for long conversations, follow-up questions, and comparing approaches.

If you don't know a domain well, use an interview-style prompt that makes the model ask you questions instead of jumping to an answer:

```text
You are xxx (set a role). I want to [clarify my thinking]. Before starting, interview me to understand my ideas and intent. Please follow these rules:
1. Structure first, details later. Move step by step.
2. Ask one question at a time, not all at once.
3. If my answer is unclear, follow up. The goal is to fully understand what I mean.
4. Keep the interview under 20 questions.
After the interview, help me organize my thinking around the outcome I want.
```

When the interview is done, have it write a Markdown brief with the goal, constraints, steps, and acceptance criteria. That brief is the task packet you hand to the agent.

## File generation

Some work only needs AI to produce a file. You check it, use it, and revise it yourself.

### python-pptx reports

I used to have agents lay out slides through computer use: screenshots, recognition, drag, click. It works, but it is slow and burns tokens.

Then I changed the approach: **have the AI write a `python-pptx` script and generate the deck with code.** No PowerPoint window, no simulated mouse, deterministic output, and easy to revise.

Install:

```bash
pip install python-pptx
```

The docs and examples are at [python-pptx documentation](https://python-pptx.readthedocs.io/). A minimal example:

```python
from pptx import Presentation
from pptx.util import Inches, Pt

prs = Presentation()
prs.slide_width = Inches(13.333)
prs.slide_height = Inches(7.5)

slide = prs.slides.add_slide(prs.slide_layouts[6])

# Result chart on the left
slide.shapes.add_picture(
    "results/curve.png",
    Inches(0.6), Inches(1.2),
    width=Inches(6.2),
)

# Text on the right
box = slide.shapes.add_textbox(
    Inches(7.2), Inches(1.2), Inches(5.2), Inches(2.4)
)
box.text_frame.text = "Results"
p = box.text_frame.add_paragraph()
p.text = "Key metric: ..."
p.font.size = Pt(18)

prs.save("report.pptx")
```

If you have a batch of experiments, have the agent generate one slide per run with a consistent layout for figures, metric tables, and conclusions. Adjust colors, fonts, and spacing by hand afterward.

`python-pptx` can add slides, text boxes, images, tables, shapes, and common charts, and it can read and modify existing `.pptx` files. It does not support animations, transitions, or SmartArt. Complex layout still needs a final pass in PowerPoint. For turning results into a first draft, it is more than enough.

I recently used it to batch-generate experiment reports. It was much more stable than having an agent drag things around through computer use: no misclicks, no layout breaking when the window size changes, and the same script can be rerun.

The idea generalizes to Word, Excel, and PDF: instead of making the agent click through a GUI, have it generate a script or structured file, then render it with the right library.

### Timetable to calendar

Entering a class schedule into a calendar used to mean adding every class by hand. Odd/even weeks and holiday adjustments made it worse.

Now I can give the screenshot or Excel file to an AI and ask for an `.ics` calendar file. It needs to know:

- which date the first week starts;
- each class's time, location, and week range;
- whether it meets on odd or even weeks;
- how far in advance to remind;
- whether it repeats until the end of the semester.

Check it on your phone before importing: odd/even weeks, duration, and missing classes. Once it looks right, import the `.ics`.

On iPhone, open Calendar, long-press the `.ics` file, and drag it in. The system recognizes and imports it. Phone and watch reminders then follow the schedule, which is much less work than typing everything manually.

The point is not to let AI take over the calendar. It is to translate an image or spreadsheet into a correct ICS file. Importing, reminders, and syncing stay with the system; AI only handles the part that is hard on the eyes.

## Automation

The third level is where the agent's execution ability actually matters: it does not just generate one file, it decides the next step from the result and keeps going.

### Deep learning training

Deep learning training is a classic repeat, wait, and archive task: change a parameter, run training, check metrics, change another parameter. It is not hard, just tedious, and copy-paste mistakes are easy.

I start by making the training script config-driven:

```text
project/
├── train.py
├── configs/
│   ├── base.yaml
│   └── sweep_001.yaml
├── runs/
│   └── <run_name>/
│       ├── config.json
│       ├── train.log
│       ├── metrics.json
│       └── checkpoints/
└── summary.csv
```

Then I give the agent a task brief:

```markdown
# Training task

## Goal
Run `train.py` over the following parameter combinations and save each run's output and metrics.

## Parameters
- learning_rate: 1e-3, 3e-4, 1e-4
- batch_size: 32, 64
- seed: 42

## Requirements
1. Write each run to `runs/<combination>/`.
2. Keep the training log and final metrics.
3. Check whether the previous run succeeded before starting the next one.
4. When everything is done, generate `summary.csv` with the key metric for each run.
5. Do not modify `train.py` unless the run fails.
```

The agent can then write a batch runner that executes the grid, retries failures, and keeps logs. The runner below is the kind of thing it might produce:

```python
import itertools
import json
import subprocess
from pathlib import Path

grid = {
    "learning_rate": [1e-3, 3e-4, 1e-4],
    "batch_size": [32, 64],
}

for lr, bs in itertools.product(grid["learning_rate"], grid["batch_size"]):
    run_dir = Path("runs") / f"lr{lr}_bs{bs}_seed42"
    run_dir.mkdir(parents=True, exist_ok=True)

    config = {"learning_rate": lr, "batch_size": bs, "seed": 42}
    (run_dir / "config.json").write_text(json.dumps(config, indent=2))

    subprocess.run([
        "python", "train.py",
        "--lr", str(lr),
        "--batch-size", str(bs),
        "--seed", "42",
        "--output", str(run_dir),
    ], check=True)
```

This is the minimal version. In practice, add retries, skip completed runs, and generate a summary from the metrics.

Once it is running, the agent can do more:

- read each run's `metrics.json` and build a comparison table;
- retry or skip a failed run;
- propose the next parameter set based on the current results;
- turn the final results into a Markdown report.

A summary table can look like this:

```csv
run,learning_rate,batch_size,val_loss,val_acc,status
lr0.001_bs32_seed42,0.001,32,0.342,0.891,ok
lr0.0003_bs64_seed42,0.0003,64,0.318,0.903,ok
```

If you already use TensorBoard or W&B, have the agent read the exported metrics instead of parsing logs. The important thing is consistency: same validation set, same metric, same stopping rule.

Once I had an agent run training for a day and a night. The token cost was a few dollars. The real saving was not staring at the screen and organizing results.

A few preconditions:

- **Fix the validation set and metric**, or runs cannot be compared.
- **Save logs, configs, and random seeds**, or results cannot be reproduced.
- **Approve the agent's next parameter suggestion yourself.** It can explore, but it cannot make your research judgment.
- **Spot-check the results.** It may confuse "finished" with "correct."

### Blog publishing

My blog publishing flow is mostly handed to an agent now.

I drop the finished draft into a folder, and the rest runs automatically:

1. extract images from the draft;
2. rename them by article name;
3. upload them to the asset repository;
4. replace local paths in Markdown with CDN URLs;
5. check syntax, paragraphs, and headings;
6. add front matter, categories, and tags;
7. commit to GitHub and trigger the deploy.

The flow was not designed in one sitting. It grew one step at a time, whenever a repeated operation showed up. It is not perfect: titles and summaries still need manual edits sometimes. But it removes a lot of mechanical work.

More importantly, the flow is **evolvable**. Next time a new repeated step appears, such as generating cover images or checking dead links, it can be added.

## Where Codex fits

Codex can be the advisor at level one or the executor at level three.

Install:

```bash
npm install -g @openai/codex
codex login
```

The web chat is good for thinking; the CLI is good for execution. I usually clarify the plan in the web chat, output a Markdown plan, and hand it to the CLI agent to execute step by step. That uses the web chat's room for thinking without wasting CLI context on a long back-and-forth.

Codex's agent capability usually requires ChatGPT Plus. Check the official page for current quota and model access. If you only use it occasionally, start with the web chat and pay when usage grows.

Codex has a sandbox. If a command lacks permission, it fails once, then retries with elevated permission. In automatic mode this repeats: run, permission error, elevate, run again. It is annoying, but it is part of the safety design.

Windows terminal compatibility also affects the experience. PowerShell 5.1's encoding does not work well with agent tools, which leads to garbled output, repeated commands, and wasted quota. Install PowerShell 7 and switch the default terminal; tasks that can run in WSL or Linux are often smoother there too.

I covered the setup in [Windows Dev Environment and Version Control](https://wisezenn.github.io/blog/2026/windows-dev-env-en/).

## Human boundaries

A few things I still do myself, or at least stay deeply involved in:

- final design decisions that need taste;
- data analysis that supports important conclusions;
- content published externally;
- operations involving privacy, permissions, or compliance;
- exploratory tasks without clear acceptance criteria.

If the work runs on a shared server or cluster, also pay attention to:

- **Do not store API keys in plaintext.** Use a dedicated key, cap the quota, and rotate it.
- **Give the minimum permissions.** Let the agent work only in the target folder.
- **Check the network policy first.** Some internal environments cannot reach external APIs; some do not allow data to leave.
- **Consider SSH bridging.** Run the agent on your machine and operate the remote directory over SSH.

AI is good at taking over process, not judgment. Draw the boundary clearly and it stays a helper instead of a risk.

## Choosing a level

A simple test:

- need an answer or a plan → level one, web chat;
- need a file, script, or document → level two, generate it;
- need to run repeatedly based on results → level three, agent loop.

Not everything at level two needs to become level three. Generating a correct `.ics` or `.pptx` is often faster and more reliable than simulating a mouse for ten minutes.
