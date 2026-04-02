# Post Front Matter for Series

Use this template for posts that belong to a series.

```yaml
---
layout: post
title: "<Post Title>"
date: YYYY-MM-DD HH:MM:SS +0800
categories: [<Category1>, <Category2>]
tags: [<tag1>, <tag2>]
series_key: <series-key>
series_order: <number>
lang: en # or zh
lang-ref: <paired-post-id>
description: "<One-line description>"
toc:
  sidebar: left
---
```

Rules:

1. Use `series_key` as the stable identifier.
2. Keep `series_order` numeric and gap-friendly (0, 10, 20...) for easy insertion.
3. `lang-ref` must match the paired bilingual post.
