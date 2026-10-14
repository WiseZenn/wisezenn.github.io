---
layout: default
permalink: /blog/
title: 博客
lang: zh
lang-ref: blog
nav: true
nav_order: 1
pagination:
  enabled: true
  collection: posts
  permalink: /page/:num/
  # 见 blog.md 的说明：paginate-v2 先按 per_page 切片、模板再按语言过滤，
  # 所以 5 篇/页实际每页只剩 2-3 篇。在分页支持按语言切分之前，保持 >= 文章总数。
  per_page: 20
  sort_field: date
  sort_reverse: true
  trail:
    before: 1 # The number of links before the current page
    after: 3 # The number of links after the current page
chart:
  echarts: true
---
{% include blog_index_content.liquid %}
