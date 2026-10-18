---
layout: post
title: "AI 辅助工作流：从炼丹到 PPT 和发布"
date: 2026-09-02 12:00:00 +0800
categories: ["DevOps & Workflow"]
tags: ["AI Workflow", "Codex", "python-pptx", "Deep Learning", "Automation"]
description: "把 AI 辅助工作分成顾问、生成文件和自动执行三个层次，用训练、PPT、课表和发布说明边界。"
lang: zh
lang-ref: post-agent-onboarding-05
series_key: geek-survival-guide
series_order: 7
toc:
  sidebar: left
giscus_comments: true
---

“用 AI 提高效率”这句话太笼统了。实际用下来，我觉得可以把 AI 辅助工作分成三个层次：

1. **把 AI 当顾问**：在网页端对话，让它帮你梳理思路、比较方案；
2. **让 AI 生成文件**：它输出一个可以直接用的 `.ics`、`.pptx`、脚本或文档；
3. **让 Agent 跑循环**：它自己读结果、改参数、跑下一轮，直到任务完成。

这三个层次的门槛和收益不一样，下面用四个具体场景说明。

## 咨询与方案

这一层最简单：打开网页端，把问题描述清楚，让模型帮你拆解。

我的习惯是先在网页端把思路捋顺，再把结论整理成一份 Markdown 任务书，交给后面的工具执行。网页端的好处是不消耗 Agent 的执行额度，适合长对话、反复追问、比较不同方案。

如果对某个领域不熟，可以用“采访式”的 Prompt，让模型先问你，而不是直接给答案：

```text
你是 xxx（立人设），我想要［梳理思路］，请在开始任务之前，通过采访的方式来了解我的想法和意图。采访时请注意：
1、先结构后细节，一步步递进。
2、一个问题一个问题的问，而不是一次性问完所有问题。
3、当我的回答不清楚时，可以追问。目标是彻底理解我的想法。
4、整体不要超过 20 个问题。
完成采访后，请围绕我想要的结果，帮我梳理思路。
```

采访结束后，让它输出一份 Markdown，写清楚目标、约束、步骤和验收标准。这份文档就是后面交给 Agent 的“任务书”。

## 文件生成

有些事情只需要 AI 帮你生成一个文件。生成完，你自己检查、使用、再修改。

### python-pptx 汇报

以前让 Agent 排版 PPT，基本是 computer use：截图、识别、拖拽、点击。能完成，但慢，而且很消耗 Token。

最近我换了一个思路：**直接让 AI 写 `python-pptx` 脚本，用代码生成 PPT。** 这样不需要打开 PowerPoint，不需要模拟鼠标，生成过程是确定性的，改起来也方便。

安装：

```bash
pip install python-pptx
```

官方文档和示例在 [python-pptx 文档](https://python-pptx.readthedocs.io/)。一个最小示例：

```python
from pptx import Presentation
from pptx.util import Inches, Pt

prs = Presentation()
prs.slide_width = Inches(13.333)
prs.slide_height = Inches(7.5)

slide = prs.slides.add_slide(prs.slide_layouts[6])

# 左侧放结果图
slide.shapes.add_picture(
    "results/curve.png",
    Inches(0.6), Inches(1.2),
    width=Inches(6.2),
)

# 右侧放文字说明
box = slide.shapes.add_textbox(
    Inches(7.2), Inches(1.2), Inches(5.2), Inches(2.4)
)
box.text_frame.text = "实验结果"
p = box.text_frame.add_paragraph()
p.text = "关键指标：..."
p.font.size = Pt(18)

prs.save("report.pptx")
```

如果有一批实验结果，可以让 Agent 批量生成：每组实验一页，统一放图、放指标表、放结论；最后再人工调整配色、字体和留白。

`python-pptx` 支持添加幻灯片、文本框、图片、表格、形状和常见图表，也能读取和修改已有的 `.pptx`。它不支持动画、切换效果和 SmartArt，复杂排版最后还是要在 PowerPoint 里收尾。但用来做“把结果整理成初稿”这一步，已经够用了。

我最近用它批量生成实验汇报，效果比让 Agent 通过 computer use 拖拽稳定很多：不会点错位置，也不会因为窗口大小变化而排版错乱，而且同一套脚本可以反复用。

这个思路也可以推广到 Word、Excel、PDF：与其让 Agent 在图形界面里点，不如让它生成一个脚本或结构化文件，再用对应的库渲染。

### 课表转日历

以前要把课表录入日历，只能一门一门手动加，遇到单双周、调休更麻烦。

现在可以把课表截图或 Excel 丢给 AI，让它生成一个 `.ics` 日历文件。需要告诉它的信息包括：

- 第一周从哪天开始；
- 每门课的时间、地点、周次；
- 是否单双周；
- 提前多久提醒；
- 是否需要重复到学期结束。

生成之后，先在手机上检查一遍：单双周对不对、持续时间对不对、有没有漏课。确认没问题，再把 `.ics` 文件导入日历。

在 iPhone 上，可以先打开日历 App，长按 `.ics` 文件拖进去，系统会自动识别并导入。导入后手机和手表都会按设置提醒，比手动录入省事很多。

这件事的重点不是让 AI 接管日历，而是让它把图片或表格翻译成一个正确的 ICS 文件。导入、提醒和同步交给系统完成，AI 只负责最费眼的那一步。

## 自动执行

第三层才真正用到 Agent 的“执行”能力：它不只是生成一个文件，而是根据结果决定下一步，持续跑下去。

### 深度学习训练

深度学习训练是一个典型的“重复、耗时、结果需要归档”的任务：改参数、跑训练、看指标、再改参数。手工做不是不会，而是很枯燥，而且容易在复制粘贴时出错。

我的做法是先把训练脚本改造成“配置驱动”的形式：

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

然后给 Agent 一份任务说明：

```markdown
# 训练任务

## 目标
遍历以下参数组合，运行 `train.py`，保存每次的输出和指标。

## 参数
- learning_rate: 1e-3, 3e-4, 1e-4
- batch_size: 32, 64
- seed: 42

## 要求
1. 每组参数输出到 `runs/<参数组合>/`；
2. 保留训练日志和最终指标；
3. 每次运行前检查上一次是否成功；
4. 全部跑完后生成 `summary.csv`，列出每组的关键指标；
5. 不要修改 `train.py`，除非运行报错。
```

Agent 可以据此写一个批量运行脚本，按顺序执行、失败重试、记录日志。比如下面这个 runner，就是它可能会生成的东西：

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

这里只是最小版本。实际使用时，可以加上失败重试、跳过已完成的 run、读取指标后自动汇总等逻辑。

真正跑起来之后，Agent 还可以做更多事：

- 读取每个 run 的 `metrics.json`，汇总成表格；
- 发现某个 run 失败，自动重试或跳过；
- 根据当前结果，提出下一组参数的调整建议；
- 把最终结果整理成一份 Markdown 报告。

汇总表可以长这样，方便快速比较：

```csv
run,learning_rate,batch_size,val_loss,val_acc,status
lr0.001_bs32_seed42,0.001,32,0.342,0.891,ok
lr0.0003_bs64_seed42,0.0003,64,0.318,0.903,ok
```

如果已经用了 TensorBoard、W&B 之类的工具，也可以让 Agent 直接读导出的指标，不必自己解析日志。关键是指标口径一致：同一个验证集、同一个评价函数、同一个停止条件。

有一次我让 Agent 连续跑了一天一夜的训练，Token 费用只有几块钱，真正省下的是盯着屏幕和整理结果的时间。

但这里有几个前提：

- **验证集和评价指标要固定**，否则不同 run 之间没法比较；
- **日志、配置、随机种子要保存**，否则结果无法复现；
- **Agent 提出的下一轮参数要人工确认**，它可以探索，但不能替你做研究判断；
- **结果要抽查**，它可能把“跑完了”当成“跑对了”。

### 博客发布

我发布博客的流程，基本已经交给 Agent 了。

我只需要把写好的初稿放进指定文件夹，后面的步骤可以自动完成：

1. 从草稿里提取图片；
2. 按文章名重命名图片；
3. 上传到图床仓库；
4. 把 Markdown 里的本地路径替换成 CDN 链接；
5. 检查语法、分段和标题；
6. 添加 front matter、分类和标签；
7. 提交到 GitHub，触发自动发布。

这套流程不是一次写完的，而是每次遇到重复操作就补一步，慢慢长出来的。现在它也不完美，标题和摘要有时还需要手动改，但已经省掉了大量机械劳动。

更重要的是，这套流程是**可进化**的。下次遇到新的重复步骤，比如自动生成封面图、自动检查死链，都可以继续加进去。

## Codex 的定位

Codex 既可以当第一层的顾问，也可以当第三层的执行器。

安装：

```bash
npm install -g @openai/codex
codex login
```

网页端适合想清楚，CLI 适合执行。我通常先在网页端把思路捋顺，输出一份 Markdown 计划，再交给 CLI 的 Agent 分步执行。这样既利用了网页端的思考空间，又避免了在 CLI 里反复长对话、浪费上下文。

需要注意的是，Codex 的 Agent 能力通常需要 ChatGPT Plus，具体额度和模型权限以官方页面为准。如果只是偶尔用，可以先用网页端；使用强度上来了，再考虑付费。

Codex 有一个沙盒机制。执行命令时，如果权限不够，它会先失败一次，再提权重试。在自动模式下，这个流程会反复出现：先执行、提示权限不够、再提权、再执行。看起来有点烦，但这是安全设计的一部分。

Windows 上的终端兼容性也会影响体验。PowerShell 5.1 的编码和 Agent 工具配合不好，容易出现乱码、命令反复执行、额度白白消耗。可以装上 PowerShell 7，并把默认终端切换过去；能在 WSL 或 Linux 环境里跑的任务，也可以放到那边。

这些内容我在[Windows 开发环境与版本管理](https://wisezenn.github.io/zh/blog/2026/windows-dev-env-zh/)里写过，这里不展开。

## 人工边界

最后列几件我仍然会自己做、或者至少会深度参与的事：

- 需要审美判断的最终设计；
- 涉及重要结论的数据分析；
- 对外发布的正式内容；
- 涉及隐私、权限和合规的操作；
- 没有明确验收标准的探索性任务。

如果任务要跑在公用服务器或集群上，还要注意：

- **API Key 不要明文保存**，用专用 Key、限制额度、用完轮换；
- **只给最小权限**，让 Agent 只在目标文件夹里工作；
- **先确认网络策略**，有些内网环境不能访问外部 API，有些环境不允许把数据发到外部；
- **可以考虑 SSH 桥接**，在自己电脑上运行 Agent，通过 SSH 操作远程目录。

AI 适合接管流程，不适合接管判断。把边界划清楚，它才是帮手，而不是风险源。

## 层次选择

一个简单的判断方法是：

- 只需要一个答案或方案 → 第一层，网页端对话；
- 需要一个文件、脚本或文档 → 第二层，让 AI 生成；
- 需要根据结果反复执行 → 第三层，让 Agent 跑循环。

第二层能解决的事，不必硬做成第三层。很多时候，让 AI 生成一个正确的 `.ics` 或 `.pptx`，比让它模拟鼠标点半天更高效，也更可靠。
