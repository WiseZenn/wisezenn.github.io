---
layout: default
permalink: /blog/
title: 博客
lang: zh
nav: true
nav_order: 1
pagination:
  enabled: true
  collection: posts
  permalink: /page/:num/
  per_page: 5
  sort_field: date
  sort_reverse: true
  trail:
    before: 1 # The number of links before the current page
    after: 3 # The number of links after the current page
chart:
  echarts: true
---

<div class="post">

{% assign blog_name_size = site.blog_name | size %}
{% assign blog_description_size = site.blog_description | size %}

{% if blog_name_size > 0 or blog_description_size > 0 %}

  <div class="header-bar">
    <h1>我的博客</h1>
    <h2>这里记录了我的技术探索、生活随笔和一些胡思乱想。</h2>
  </div>
  {% endif %}

{% assign active_posts = site.posts | where: "lang", site.active_lang %}
{% assign all_tags = "" %}
{% assign all_categories = "" %}
{% for post in active_posts %}
  {% for tag in post.tags %}
    {% assign tag_str = tag | append: "|||" %}
    {% unless all_tags contains tag_str %}
      {% assign all_tags = all_tags | append: tag_str %}
    {% endunless %}
  {% endfor %}
  {% for cat in post.categories %}
    {% assign cat_str = cat | append: "|||" %}
    {% unless all_categories contains cat_str %}
      {% assign all_categories = all_categories | append: cat_str %}
    {% endunless %}
  {% endfor %}
{% endfor %}
{% assign all_tags_uniq = all_tags | split: "|||" | sort %}
{% assign all_cats_uniq = all_categories | split: "|||" | sort %}

{% if all_tags_uniq.size > 0 or all_cats_uniq.size > 0 %}
  <div class="tag-category-list mb-3">
    <ul class="p-0 m-0">
      {% for tag in all_tags_uniq %}
        {% if tag != "" %}
        <li>
          <i class="fa-solid fa-hashtag fa-sm"></i> <a href="{{ site.baseurl }}/zh/blog/tag/{{ tag | slugify }}">{{ tag }}</a>
        </li>
        {% unless forloop.last %}
          <p>&bull;</p>
        {% endunless %}
        {% endif %}
      {% endfor %}
      
      {% if all_cats_uniq.size > 0 and all_tags_uniq.size > 0 %}
        <p>&bull;</p>
      {% endif %}
      
      {% for category in all_cats_uniq %}
        {% if category != "" %}
        <li>
          <i class="fa-solid fa-tag fa-sm"></i> <a href="{{ site.baseurl }}/zh/blog/category/{{ category | slugify }}">{{ category }}</a>
        </li>
        {% unless forloop.last %}
          <p>&bull;</p>
        {% endunless %}
        {% endif %}
      {% endfor %}
    </ul>
  </div>
{% endif %}

  <!-- Blog Heatmap -->
  <div id="blog-heatmap" style="height: 200px; width: 100%;"></div>
  {% include blog_heatmap.liquid %}

  <!-- Series Section -->
  {% assign current_series = site.series | where: "lang", site.active_lang | sort: "importance" %}
  {% if current_series.size > 0 %}
    <h3 class="mt-4"><strong>系列专栏</strong></h3>
    <div class="row row-cols-1 row-cols-md-2 g-4 mb-5">
      {% for s in current_series %}
        <div class="col">
          <a href="{{ s.url | relative_url }}">
            <div class="card hoverable h-100">
              <div class="row g-0">
                <div class="col-md-12">
                  <div class="card-body">
                    <h4 class="card-title">{{ s.title }}</h4>
                    <p class="card-text">{{ s.description }}</p>
                  </div>
                </div>
              </div>
            </div>
          </a>
        </div>
      {% endfor %}
    </div>
  {% endif %}

{% assign featured_posts = site.posts | where: "lang", site.active_lang | where: "featured", "true" %}
{% if featured_posts.size > 0 %}
  <br>

  <div class="container featured-posts">
    {% assign is_even = featured_posts.size | modulo: 2 %}
    <div class="row row-cols-{% if featured_posts.size <= 2 or is_even == 0 %}2{% else %}3{% endif %}">
      {% for post in featured_posts %}
        <div class="col mb-4">
          <a href="{{ post.url | relative_url }}">
            <div class="card hoverable">
              <div class="row g-0">
                <div class="col-md-12">
                  <div class="card-body">
                    <div class="float-right">
                      <i class="fa-solid fa-thumbtack fa-fw"></i>
                    </div>
                    <h3 class="card-title text-lowercase">{{ post.title }}</h3>
                    <p class="card-text">{{ post.description }}</p>

                    {% if post.external_source == blank %}
                      {% assign read_time = post.content | number_of_words | divided_by: 180 | plus: 1 %}
                    {% else %}
                      {% assign read_time = post.feed_content | strip_html | number_of_words | divided_by: 180 | plus: 1 %}
                    {% endif %}
                    {% assign year = post.date | date: "%Y" %}

                    <p class="post-meta">
                      {{ read_time }} 分钟阅读 &nbsp; &middot; &nbsp;
                      <a href="{{ year | prepend: '/blog/' | prepend: site.baseurl}}">
                        <i class="fa-solid fa-calendar fa-sm"></i> {{ year }} </a>
                    </p>
                  </div>
                </div>
              </div>
            </div>
          </a>
        </div>
      {% endfor %}
    </div>
  </div>
  <hr>

{% endif %}

  <ul class="post-list">

    {% if page.pagination.enabled %}
      {% assign postlist = paginator.posts | where: "lang", site.active_lang %}
    {% else %}
      {% assign postlist = site.posts | where: "lang", site.active_lang %}
    {% endif %}

    {% for post in postlist %}

    {% if post.external_source == blank %}
      {% assign read_time = post.content | number_of_words | divided_by: 180 | plus: 1 %}
    {% else %}
      {% assign read_time = post.feed_content | strip_html | number_of_words | divided_by: 180 | plus: 1 %}
    {% endif %}
    {% assign year = post.date | date: "%Y" %}
    {% assign tags = post.tags | join: "" %}
    {% assign categories = post.categories | join: "" %}

    <li>
{%- if post.thumbnail -%}
<div class="row">
          <div class="col-sm-9">
{%- endif -%}
        <h3>
        {% if post.redirect == blank %}
          <a class="post-title" href="{{ post.url | relative_url }}">{{ post.title }}</a>
        {% elsif post.redirect contains '://' %}
          <a class="post-title" href="{{ post.redirect }}" target="_blank">{{ post.title }}</a>
          <svg width="2rem" height="2rem" viewBox="0 0 40 40" xmlns="http://www.w3.org/2000/svg">
            <path d="M17 13.5v6H5v-12h6m3-3h6v6m0-6-9 9" class="icon_svg-stroke" stroke="#999" stroke-width="1.5" fill="none" fill-rule="evenodd" stroke-linecap="round" stroke-linejoin="round"></path>
          </svg>
        {% else %}
          <a class="post-title" href="{{ post.redirect | relative_url }}">{{ post.title }}</a>
        {% endif %}
      </h3>
      <p>{{ post.description }}</p>
      <p class="post-meta">
        {{ read_time }} 分钟阅读 &nbsp; &middot; &nbsp;
        {{ post.date | date: '%Y年%m月%d日' }}
        {% if post.external_source %}
        &nbsp; &middot; &nbsp; 发表在 {{ post.external_source }}
        {% endif %}
      </p>
      <p class="post-tags">
        <a href="{{ year | prepend: '/blog/' | prepend: site.baseurl}}">
          <i class="fa-solid fa-calendar fa-sm"></i> {{ year }} </a>

          {% if tags != "" %}
          &nbsp; &middot; &nbsp;
            {% for tag in post.tags %}
            <a href="{{ tag | slugify | prepend: '/blog/tag/' | prepend: site.baseurl}}">
              <i class="fa-solid fa-hashtag fa-sm"></i> {{ tag }}</a>
              {% unless forloop.last %}
                &nbsp;
              {% endunless %}
              {% endfor %}
          {% endif %}

          {% if categories != "" %}
          &nbsp; &middot; &nbsp;
            {% for category in post.categories %}
            <a href="{{ category | slugify | prepend: '/blog/category/' | prepend: site.baseurl}}">
              <i class="fa-solid fa-tag fa-sm"></i> {{ category }}</a>
              {% unless forloop.last %}
                &nbsp;
              {% endunless %}
              {% endfor %}
          {% endif %}
      </p>
{%- if post.thumbnail -%}
      </div>
      <div class="col-sm-3">
        <img class="card-img" src="{{ post.thumbnail | relative_url }}" style="object-fit: cover; height: 90%" alt="image">
      </div>
    </div>
{%- endif -%}
    </li>

    {% endfor %}

  </ul>

  {% if page.pagination.enabled %}
  {% include pagination.liquid %}
  {% endif %}

</div>
