# 博客重构执行计划 (Blogging System Refactoring Plan)

## 目标
将现有的基于 `al-folio` 主题的个人博客升级为支持中英双语、系列分类展示，并采用 Medium 风格排版的现代化博客系统。

## 第一阶段：双语系统分离（当前阶段）
> 目标：实现全站中英文独立路由，右上角语言切换，分离中英文博客数据和热力图。

1. **环境与配置调整**：
   - 在 `Gemfile` 中引入 `jekyll-polyglot` 插件。
   - 在 `_config.yml` 中配置多语言支持（`languages: ['en', 'zh']`，`default_lang: 'en'`）。
2. **导航栏改造**：
   - 修改 `_includes/header.liquid`。
   - 在导航栏最右侧加入 `EN / 中文` 切换按钮。
   - 动态识别当前路由并进行语言重定向。
3. **内容模型区分**：
   - 为现有博客 Markdown 文件（`_posts/`）的 Front Matter 增加 `lang` 属性。
   - 修改博客列表页（`_layouts/blog.liquid` 或对应页面）过滤对应语言的文章。
4. **全站页面与导航栏多语言化 (新增)**：
   - 为主导航页（如 `about.md`, `blog.md`, `cv.md`）创建对应的中文实体文件（如 `about_zh.md`, `blog_zh.md`），设置 `lang: zh`，并将 `title` 改为中文。
   - 利用 Polyglot 的同 `permalink` 覆盖机制，让页面在切换到中文时，展示中文界面内容及中文导航栏名称。
   - 对于写死在 `_config.yml` 或 `header.liquid` 中的硬编码文本（如网站副标题），通过 `{% if site.active_lang == "zh" %}` 进行双语渲染分支处理。
5. **热力图双语隔离**：
   - 修改 `_includes/blog_heatmap.liquid`。
   - 确保 `site.posts` 在计算热力点时能依据 `site.active_lang` 过滤出仅属于当前语言的文章。

## 第二阶段：引入“系列 (Series)”和“标签 (Tags)”体系（当前阶段）
> 目标：博客页面能在热力图之后以“卡片”形式按系列展示文章，并支持标签过滤。

1. **注册集合 (Collections)**：
   - 在 `_config.yml` 中新增 `collections: series`，建立 `_series/` 文件夹。
2. **系列展示模块开发**：
   - 在 `_pages/blog.md`（或对应列表模板）的热力图区域下方，新增系列（Series）的水平网格卡片布局。
   - 设计风格对标现有的项目（Projects）卡片。
3. **专用落地页**：
   - 新建 `_layouts/series.liquid`，当用户点击系列卡片时，展示属于该系列的所有博文列表。
4. **标签功能整合**：
   - 强化文章详情和列表页的 Tag 系统，建立 `tags.md` 用于按照 Tag 筛选展现。

## 第三阶段：Medium 风格 UI 与排版翻新
> 目标：重设字体、留白和博客列表布局，获得接近 Medium 的高度悦目阅读体验。

1. **排版基础 (Typography)**：
   - 调整 `_sass/_typography.scss`。
   - 对文章正文（`post-content`）引入 Medium 惯用的衬线（Serif）字体或更易读的视网膜显示字体。
   - 标题部分使用无衬线（Sans-serif）大号加粗。
2. **布局框架留白**：
   - 修改正文最大宽度为更舒适的 `680px` 到 `740px`。
   - 减少或去除原有主题的生硬边框与过小的行距 (`line-height`)。
3. **博客列表组件重写**：
   - 去掉厚重的卡片阴影，采用极简的左排版（标题+简介+阅读时间），右小图侧栏。
   - 加入微小的灰色分隔线分割文章条目。

---
*注：每一步执行后都会在本地进行测试，保证不会影响到个人主页、简历页面、Publications 和 Projects 的原有生态。*
