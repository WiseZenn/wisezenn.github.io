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
          description: "From dual-boot to WSL2 — documenting configurations, pitfalls, and best practices for setting up development environments. WSL2 开发环境配置笔记",
          section: "" + sectionLabels.series + "",handler: () => {
              window.location.href = localizeInternalPath("/series/dev-env-setup/");
            },},{id: "series-geek-survival-guide",
          title: 'Geek Survival Guide',
          lang: "*",
          description: "A practical series on AI-native development workflows, prompt constraints, and architecture-first engineering habits. Claude配置DeepSeek v4不完全指南",
          section: "" + sectionLabels.series + "",handler: () => {
              window.location.href = localizeInternalPath("/series/geek-survival-guide/");
            },},{id: "series-numerical-analysis-series",
          title: 'Numerical Analysis Series',
          lang: "*",
          description: "A comprehensive guide to Computational Methods and Numerical Analysis. 数值分析系列：0-写在前面",
          section: "" + sectionLabels.series + "",handler: () => {
              window.location.href = localizeInternalPath("/series/numerical-analysis/");
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
