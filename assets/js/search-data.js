// get the ninja-keys element
const ninja = document.querySelector('ninja-keys');
const pageLangAttr = (document.documentElement.getAttribute('lang') || '').toLowerCase();
const currentLang = pageLangAttr.startsWith('zh') || /^\/zh(\/|$)/.test(window.location.pathname) ? 'zh' : 'en';
const searchI18n = {
  en: {
    navigation: "Navigation",
    dropdown: "Dropdown",
    posts: "Posts",
    socials: "Socials",
    theme: "Theme",
    series: "Series",
  },
  zh: {
    navigation: "导航",
    dropdown: "下拉菜单",
    posts: "文章",
    socials: "社交",
    theme: "主题",
    series: "系列",
  },
};
const sectionLabels = searchI18n[currentLang] || searchI18n.en;
const localizeInternalPath = (path) => {
  if (!path || !path.startsWith('/')) return path;
  if (currentLang !== 'zh') return path;
  if (path === '/') return '/zh/';
  if (path.startsWith('/zh/')) return path;
  return `/zh${path}`;
};
const navTitleMap = {
  en: {
    'nav-about': 'about',
    'nav-blog': 'blog',
    'nav-repositories': 'repositories',
    'nav-courses': 'courses',
    'nav-cv': 'CV',
    'nav-bookshelf': 'bookshelf',
  },
  zh: {
    'nav-about': '关于',
    'nav-blog': '博客',
    'nav-repositories': '仓库',
    'nav-courses': '课程',
    'nav-cv': '简历',
    'nav-bookshelf': '书架',
  },
};

// add the home and posts menu items
const allNinjaItems = [{
    id: "nav-about",
    title: "About",
    lang: '*',
    section: sectionLabels.navigation,
    handler: () => {
      window.location.href = localizeInternalPath("/");
    },
  },{id: "nav-blog",
          title: "Blog",
          lang: '*',
          description: "",
          section: sectionLabels.navigation,
          handler: () => {
            window.location.href = localizeInternalPath("/blog/");
          },
        },{id: "nav-repositories",
          title: "Repositories",
          lang: '*',
          description: "This is WiseZenn&#39;s repository, which contains interesting projects and personal experiments.",
          section: sectionLabels.navigation,
          handler: () => {
            window.location.href = localizeInternalPath("/repositories/");
          },
        },{id: "nav-courses",
          title: "Courses",
          lang: '*',
          description: "Course materials, resources, and notes for sharing.",
          section: sectionLabels.navigation,
          handler: () => {
            window.location.href = localizeInternalPath("/courses/");
          },
        },{id: "nav-cv",
          title: "CV",
          lang: '*',
          description: "CV of WiseZenn(Continuously Updating)",
          section: sectionLabels.navigation,
          handler: () => {
            window.location.href = localizeInternalPath("/cv/");
          },
        },{id: "nav-bookshelf",
          title: "Bookshelf",
          lang: '*',
          description: "",
          section: sectionLabels.navigation,
          handler: () => {
            window.location.href = localizeInternalPath("/books/");
          },
        },{id: "post-powershell-7-安装与-utf-8-编码配置",
        
          title: "PowerShell 7 安装与 UTF-8 编码配置",
        
        lang: "zh",
        description: "在 Windows 上安装 PowerShell 7，配置 UTF-8 编码并设为默认终端。",
        section: sectionLabels.posts,
        handler: () => {
          
            window.location.href = "/blog/2026/powershell-7-setup-zh/";
          
        },
      },{id: "post-powershell-7-on-windows-utf-8-encoding-and-default-terminal-setup",
        
          title: "PowerShell 7 on Windows: UTF-8 Encoding and Default Terminal Setup",
        
        lang: "en",
        description: "Setting up PowerShell 7 on Windows: UTF-8 encoding and default terminal switch.",
        section: sectionLabels.posts,
        handler: () => {
          
            window.location.href = "/blog/2026/powershell-7-setup-en/";
          
        },
      },{id: "post-ai-时代的学习与科研工作流",
        
          title: "AI 时代的学习与科研工作流",
        
        lang: "zh",
        description: "AI 降低了动手门槛，但没有降低理解门槛。记录一套以概念、代码库、复现和输出为核心的学习方法。",
        section: sectionLabels.posts,
        handler: () => {
          
            window.location.href = "/blog/2026/ai-learning-zh/";
          
        },
      },{id: "post-learning-and-research-in-the-age-of-ai",
        
          title: "Learning and Research in the Age of AI",
        
        lang: "en",
        description: "AI lowers the barrier to building, not understanding. A workflow around concepts, a base code library, reproduction, and output.",
        section: sectionLabels.posts,
        handler: () => {
          
            window.location.href = "/blog/2026/ai-learning-en/";
          
        },
      },{id: "post-ai-辅助工作流-从炼丹到-ppt-和发布",
        
          title: "AI 辅助工作流：从炼丹到 PPT 和发布",
        
        lang: "zh",
        description: "把 AI 辅助工作分成顾问、生成文件和自动执行三个层次，用训练、PPT、课表和发布说明边界。",
        section: sectionLabels.posts,
        handler: () => {
          
            window.location.href = "/blog/2026/ai-workflow-zh/";
          
        },
      },{id: "post-ai-assisted-workflows-training-runs-slides-and-publishing",
        
          title: "AI-Assisted Workflows: Training Runs, Slides, and Publishing",
        
        lang: "en",
        description: "Three levels of AI assistance: advice, generated files, and agent loops, illustrated with training, slides, calendars, and publishing.",
        section: sectionLabels.posts,
        handler: () => {
          
            window.location.href = "/blog/2026/ai-workflow-en/";
          
        },
      },{id: "post-windows-开发环境与版本管理",
        
          title: "Windows 开发环境与版本管理",
        
        lang: "zh",
        description: "从 Node.js、PowerToys 到 Git、GitHub CLI，搭一套够用的 Windows 开发环境。",
        section: sectionLabels.posts,
        handler: () => {
          
            window.location.href = "/blog/2026/windows-dev-env-zh/";
          
        },
      },{id: "post-windows-dev-environment-and-version-control",
        
          title: "Windows Dev Environment and Version Control",
        
        lang: "en",
        description: "A minimal Windows toolchain for agents: Node.js, PowerToys, Git, GitHub, and version control that keeps changes recoverable.",
        section: sectionLabels.posts,
        handler: () => {
          
            window.location.href = "/blog/2026/windows-dev-env-en/";
          
        },
      },{id: "post-zotero-llm-让-agent-参与文献阅读",
        
          title: "Zotero + LLM：让 Agent 参与文献阅读",
        
        lang: "zh",
        description: "把 DeepSeek、Copilot 和 Codex 接进 Zotero，让摘要和笔记建立在真实文献之上。",
        section: sectionLabels.posts,
        handler: () => {
          
            window.location.href = "/blog/2026/zotero-llm-zh/";
          
        },
      },{id: "post-zotero-llm-let-an-agent-read-with-you",
        
          title: "Zotero + LLM: Let an Agent Read With You",
        
        lang: "en",
        description: "Connect DeepSeek, Copilot, and Codex to Zotero so summaries and notes are grounded in your actual library.",
        section: sectionLabels.posts,
        handler: () => {
          
            window.location.href = "/blog/2026/zotero-llm-en/";
          
        },
      },{id: "post-wsl2-开发环境配置笔记",
        
          title: "WSL2 开发环境配置笔记",
        
        lang: "zh",
        description: "WSL2 下 CUDA 13、cuDNN、Miniconda、PyTorch、ROS2 Jazzy 环境配置记录。",
        section: sectionLabels.posts,
        handler: () => {
          
            window.location.href = "/blog/2026/wsl2-dev-environment-zh/";
          
        },
      },{id: "post-wsl2-dev-environment-setup-notes",
        
          title: "WSL2 Dev Environment Setup Notes",
        
        lang: "en",
        description: "Setting up a deep learning dev environment in WSL2: CUDA 13, cuDNN, Miniconda, PyTorch, ROS2 Jazzy.",
        section: sectionLabels.posts,
        handler: () => {
          
            window.location.href = "/blog/2026/wsl2-dev-environment-en/";
          
        },
      },{id: "post-ubuntu-双系统安装指北",
        
          title: "Ubuntu 双系统安装指北",
        
        lang: "zh",
        description: "Ubuntu 双系统安装全流程：准备工作、分区方案、安装步骤、系统删除。",
        section: sectionLabels.posts,
        handler: () => {
          
            window.location.href = "/blog/2026/ubuntu-dual-boot-guide-zh/";
          
        },
      },{id: "post-ubuntu-dual-boot-a-practical-walkthrough",
        
          title: "Ubuntu Dual Boot: A Practical Walkthrough",
        
        lang: "en",
        description: "A step-by-step guide to installing Ubuntu alongside Windows, from preparation to uninstallation.",
        section: sectionLabels.posts,
        handler: () => {
          
            window.location.href = "/blog/2026/ubuntu-dual-boot-guide-en/";
          
        },
      },{id: "post-typora-与-markdown-写作配置",
        
          title: "Typora 与 Markdown 写作配置",
        
        lang: "zh",
        description: "把 Typora 调成顺手的写作环境，并整理常用的 Markdown 语法和写作技巧。",
        section: sectionLabels.posts,
        handler: () => {
          
            window.location.href = "/blog/2026/typora-markdown-zh/";
          
        },
      },{id: "post-typora-and-markdown-a-writing-setup",
        
          title: "Typora and Markdown: A Writing Setup",
        
        lang: "en",
        description: "A practical Typora setup and the Markdown patterns I use most: themes, relative image paths, callouts, math, tables, and Mermaid.",
        section: sectionLabels.posts,
        handler: () => {
          
            window.location.href = "/blog/2026/typora-markdown-en/";
          
        },
      },{id: "post-opencli-把网站变成-agent-的-cli",
        
          title: "OpenCLI：把网站变成 Agent 的 CLI",
        
        lang: "zh",
        description: "不用写爬虫，也不用让大模型盯着浏览器点击。OpenCLI 把网站和登录态变成确定性命令，让 Agent 直接取数据。",
        section: sectionLabels.posts,
        handler: () => {
          
            window.location.href = "/blog/2026/opencli-zh/";
          
        },
      },{id: "post-opencli-turn-websites-into-a-cli-for-agents",
        
          title: "OpenCLI: Turn Websites into a CLI for Agents",
        
        lang: "en",
        description: "Skip the scraper and the browser-clicking model. OpenCLI turns websites and logged-in sessions into deterministic commands.",
        section: sectionLabels.posts,
        handler: () => {
          
            window.location.href = "/blog/2026/opencli-en/";
          
        },
      },{id: "post-agent-入门-从对话到执行",
        
          title: "Agent 入门：从对话到执行",
        
        lang: "zh",
        description: "从聊天机器人到能动手的 Agent：理解 LLM、壳与手脚的分工，以及 CLI 为什么成为 Agent 的主场。",
        section: sectionLabels.posts,
        handler: () => {
          
            window.location.href = "/blog/2026/agent-intro-zh/";
          
        },
      },{id: "post-agent-basics-from-chat-to-execution",
        
          title: "Agent Basics: From Chat to Execution",
        
        lang: "en",
        description: "What an agent actually is, how the model, shell, and tools fit together, and why CLI is its natural interface.",
        section: sectionLabels.posts,
        handler: () => {
          
            window.location.href = "/blog/2026/agent-intro-en/";
          
        },
      },{id: "post-claude配置deepseek-v4不完全指南",
        
          title: "Claude配置DeepSeek v4不完全指南",
        
        lang: "zh",
        description: "Claude Code配置DeepSeek V4全流程：API申请、CC Switch配置、桌面端/CLI/VS Code插件安装与优化。",
        section: sectionLabels.posts,
        handler: () => {
          
            window.location.href = "/blog/2026/claude-deepseek-v4-guide-zh/";
          
        },
      },{id: "post-claude-code-deepseek-v4-an-unofficial-setup-guide",
        
          title: "Claude Code + DeepSeek V4: An Unofficial Setup Guide",
        
        lang: "en",
        description: "A step-by-step guide to using DeepSeek V4 through Claude Code: API setup, CC Switch, and VS Code/Desktop/CLI installation.",
        section: sectionLabels.posts,
        handler: () => {
          
            window.location.href = "/blog/2026/claude-deepseek-v4-guide-en/";
          
        },
      },{id: "post-github学生包审核越来越严-我踩过的坑和一份可复现流程",
        
          title: "GitHub学生包审核越来越严？我踩过的坑和一份可复现流程",
        
        lang: "zh",
        description: "GitHub学生包申请全流程：学信网认证翻译、IP避坑、Copilot Pro领取实操。",
        section: sectionLabels.posts,
        handler: () => {
          
            window.location.href = "/blog/2026/github-student-pack-guide-zh/";
          
        },
      },{id: "post-github-student-pack-rejections-a-repeatable-process-that-worked-for-me",
        
          title: "GitHub Student Pack Rejections? A Repeatable Process That Worked for Me",
        
        lang: "en",
        description: "A practical guide to GitHub Student Pack: CHSI verification, PDF translation, and Copilot setup.",
        section: sectionLabels.posts,
        handler: () => {
          
            window.location.href = "/blog/2026/github-student-pack-guide-en/";
          
        },
      },{id: "post-我的agent实践记录",
        
          title: "我的Agent实践记录",
        
        lang: "zh",
        description: "记录自己关于Agent使用的一些想法。",
        section: sectionLabels.posts,
        handler: () => {
          
            window.location.href = "/blog/2026/prompt-engineering-practices-zh/";
          
        },
      },{id: "post-taming-ai-agents-architecture-workflows-and-vibe-coding",
        
          title: "Taming AI Agents: Architecture, Workflows, and Vibe Coding",
        
        lang: "en",
        description: "A deep dive into shifting from basic prompts to architecture-driven agent workflows, and why system design matters more than ever.",
        section: sectionLabels.posts,
        handler: () => {
          
            window.location.href = "/blog/2026/prompt-engineering-practices-en/";
          
        },
      },{id: "post-数值分析系列-0-写在前面",
        
          title: "数值分析系列：0-写在前面",
        
        lang: "zh",
        description: "数值分析系列开篇：写在前面的话。探讨这门课的 What、Why、How，以及为什么在 AI 时代我们依然需要掌握底层理论。",
        section: sectionLabels.posts,
        handler: () => {
          
            window.location.href = "/blog/2026/intro-numerical-analysis-zh/";
          
        },
      },{id: "post-numerical-analysis-series-0-introduction",
        
          title: "Numerical Analysis Series: 0-Introduction",
        
        lang: "en",
        description: "Introduction to the Numerical Analysis series: The What, Why, and How. Why mastering the underlying theory matters even in the AI era.",
        section: sectionLabels.posts,
        handler: () => {
          
            window.location.href = "/blog/2026/intro-numerical-analysis-en/";
          
        },
      },{id: "series-dev-environment-setup-notes",
          title: 'Dev Environment Setup Notes',
          lang: "*",
          description: "From dual-boot to WSL2 — documenting configurations, pitfalls, and best practices for setting up development environments. Windows 开发环境与版本管理",
          section: "" + sectionLabels.series + "",handler: () => {
              window.location.href = localizeInternalPath("/series/dev-env-setup/");
            },},{id: "series-geek-survival-guide",
          title: 'Geek Survival Guide',
          lang: "*",
          description: "A practical series on AI-native development workflows, prompt constraints, and architecture-first engineering habits. PowerShell 7 安装与 UTF-8 编码配置",
          section: "" + sectionLabels.series + "",handler: () => {
              window.location.href = localizeInternalPath("/series/geek-survival-guide/");
            },},{id: "series-numerical-analysis-series",
          title: 'Numerical Analysis Series',
          lang: "*",
          description: "A comprehensive guide to Computational Methods and Numerical Analysis. 数值分析系列：0-写在前面",
          section: "" + sectionLabels.series + "",handler: () => {
              window.location.href = localizeInternalPath("/series/numerical-analysis/");
            },},{id: "series-productivity-toolbox",
          title: 'Productivity Toolbox',
          lang: "*",
          description: "A practical collection of tools for information gathering, literature reading, writing, and automation. Zotero + LLM：让 Agent 参与文献阅读",
          section: "" + sectionLabels.series + "",handler: () => {
              window.location.href = localizeInternalPath("/series/productivity-toolbox/");
            },},{
        id: 'social-email',
        title: 'email',
        lang: '*',
        section: sectionLabels.socials,
        handler: () => {
          const socialTarget = "mailto:%77%69%73%65%7A%65%6E%6E.%6D%65@%67%6D%61%69%6C.%63%6F%6D";
          if (socialTarget.startsWith('#')) {
            const trigger = document.querySelector(`a[href="${socialTarget}"]`);
            if (trigger) {
              trigger.click();
            } else {
              window.location.hash = socialTarget;
            }
          } else {
            window.open(socialTarget, "_blank");
          }
        },
      },{
        id: 'social-github',
        title: 'GitHub',
        lang: '*',
        section: sectionLabels.socials,
        handler: () => {
          const socialTarget = "https://github.com/WiseZenn";
          if (socialTarget.startsWith('#')) {
            const trigger = document.querySelector(`a[href="${socialTarget}"]`);
            if (trigger) {
              trigger.click();
            } else {
              window.location.hash = socialTarget;
            }
          } else {
            window.open(socialTarget, "_blank");
          }
        },
      },{
        id: 'social-wechat',
        title: 'WeChat',
        lang: '*',
        section: sectionLabels.socials,
        handler: () => {
          const socialTarget = "#wechat";
          if (socialTarget.startsWith('#')) {
            const trigger = document.querySelector(`a[href="${socialTarget}"]`);
            if (trigger) {
              trigger.click();
            } else {
              window.location.hash = socialTarget;
            }
          } else {
            window.open(socialTarget, "_blank");
          }
        },
      },{
        id: 'social-cv',
        title: 'CV',
        lang: '*',
        section: sectionLabels.socials,
        handler: () => {
          const socialTarget = "/assets/pdf/CV_Blog.pdf";
          if (socialTarget.startsWith('#')) {
            const trigger = document.querySelector(`a[href="${socialTarget}"]`);
            if (trigger) {
              trigger.click();
            } else {
              window.location.hash = socialTarget;
            }
          } else {
            window.open(socialTarget, "_blank");
          }
        },
      },{
        id: 'social-rss',
        title: 'RSS Feed',
        lang: '*',
        section: sectionLabels.socials,
        handler: () => {
          const socialTarget = "/feed.xml";
          if (socialTarget.startsWith('#')) {
            const trigger = document.querySelector(`a[href="${socialTarget}"]`);
            if (trigger) {
              trigger.click();
            } else {
              window.location.hash = socialTarget;
            }
          } else {
            window.open(socialTarget, "_blank");
          }
        },
      },{
      id: 'light-theme',
      title: 'Change theme to light',
      lang: '*',
      description: 'Change the theme of the site to Light',
      section: sectionLabels.theme,
      handler: () => {
        setThemeSetting("light");
      },
    },
    {
      id: 'dark-theme',
      title: 'Change theme to dark',
      lang: '*',
      description: 'Change the theme of the site to Dark',
      section: sectionLabels.theme,
      handler: () => {
        setThemeSetting("dark");
      },
    },
    {
      id: 'system-theme',
      title: 'Use system default theme',
      lang: '*',
      description: 'Change the theme of the site to System Default',
      section: sectionLabels.theme,
      handler: () => {
        setThemeSetting("system");
      },
    },];

ninja.data = allNinjaItems.filter((item) => {
  if (!item.lang || item.lang === '*') return true;
  return item.lang === currentLang;
}).map((item) => {
  const localizedTitle = (navTitleMap[currentLang] || {})[item.id];
  if (!localizedTitle) return item;
  return { ...item, title: localizedTitle };
});
