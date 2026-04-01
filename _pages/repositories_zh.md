---
layout: page
permalink: /repositories/
lang: zh
title: 代码库
description: 这里展示了 WiseZenn 的开源仓库结构，包含了一些有趣的项目和个人实验性质的工作。
nav: true
nav_order: 3
---

{% if site.data.repositories.github_users %}

## GitHub users

<div class="repositories d-flex flex-wrap flex-md-row flex-column justify-content-between align-items-center">
  {% for user in site.data.repositories.github_users %}
    {% include repository/repo_user.liquid username=user %}
  {% endfor %}
</div>

---
{% endif %}

{% if site.data.repositories.github_repos %}

## GitHub repositories

<div class="repositories d-flex flex-wrap flex-md-row flex-column justify-content-between align-items-center">
  {% for repo in site.data.repositories.github_repos %}
    {% include repository/repo.liquid repository=repo %}
  {% endfor %}
</div>
{% endif %}