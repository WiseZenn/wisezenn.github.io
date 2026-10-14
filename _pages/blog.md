---
layout: default
permalink: /blog/
title: Blog
lang: en
lang-ref: blog
nav: true
nav_order: 1
pagination:
  enabled: true
  collection: posts
  permalink: /page/:num/
  # paginate-v2 slices site.posts (both languages) and the template filters by
  # language *afterwards*, so a per_page of 5 left only 2-3 posts per page. Keep
  # this >= the total post count until pagination can be made language-aware.
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
