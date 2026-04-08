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
        },{id: "post-从单句指令到agent操作手册-我的prompt工程实践记录",
        
          title: "从单句指令到Agent操作手册：我的Prompt工程实践记录",
        
        lang: "zh",
        description: "放弃让AI无脑写代码，通过全局架构文档和系统提示词重新掌控开发节奏的实战复盘。",
        section: sectionLabels.posts,
        handler: () => {
          
            window.location.href = "/blog/2026/prompt-engineering-practices-zh/";
          
        },
      },{id: "post-from-single-commands-to-agent-manuals-my-prompt-engineering-practices",
        
          title: "From Single Commands to Agent Manuals: My Prompt Engineering Practices",
        
        lang: "en",
        description: "A practical post-mortem on stopping AI from writing spaghetti code using global architecture docs and system constraints.",
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
      },{id: "series-geek-survival-guide",
          title: 'Geek Survival Guide',
          lang: "*",
          description: "A practical series on AI-native development workflows, prompt constraints, and architecture-first engineering habits. 从单句指令到Agent操作手册：我的Prompt工程实践记录",
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
