# Architecture and Change Guide

This is the primary architecture reference for this repository. It explains structure, ownership boundaries, and safe change patterns for both human contributors and AI coding agents.

## 1. Purpose and Non-Goals

Purpose:

1. Keep customization centralized.
2. Keep bilingual behavior consistent.
3. Prevent drift from repeated one-off patches.
4. Provide deterministic change entry points.

Non-goals:

1. Re-document all upstream al-folio behavior.
2. Replace script-level inline comments.
3. Introduce CI-level policy in this document.

## 2. High-Level Architecture

Core stack:

1. Jekyll (static generation)
2. al-folio (theme baseline)
3. jekyll-polyglot (en/zh)
4. Sass modules (compiled through assets/css/main.scss)
5. Docker Compose for local runtime/build parity

Branch and publish model:

1. Source branch: main
2. Publish branch/worktree: gh-pages mounted at _gh-pages/

## 3. Source-of-Truth Map

Use this map before editing.

1. Site/global runtime config: _config.yml
2. Bilingual text and date formats: _data/i18n.yml
3. Shared blog index logic: _includes/blog_index_content.liquid
4. Language switch routing logic: _includes/lang_switch_url.liquid
5. Blog heatmap rendering logic: _includes/blog_heatmap.liquid
6. Global layout shell and TOC columns: _layouts/default.liquid
7. Post metadata/taxonomy rules: _layouts/post.liquid
8. Book review taxonomy parity: _layouts/book-review.liquid
9. Repository card markup: _includes/repository/repo.liquid
10. Global style entrypoint: assets/css/main.scss
11. Centralized customization layer: _sass/_custom.scss
12. Structural guardrails: scripts/validate_structure.ps1

## 4. Rendering Pipeline

Request-to-page rendering sequence:

1. _layouts/default.liquid wraps page content.
2. _includes/header.liquid and _includes/footer.liquid provide global chrome.
3. Page-specific layout is rendered (for example _layouts/post.liquid).
4. Shared include fragments are injected (for example blog index content).
5. Styles compile from assets/css/main.scss.
6. _sass/_custom.scss is loaded last to ensure predictable overrides.

## 5. Current Design Decisions

1. Blog index pages are wrappers only.
   - _pages/blog.md and _pages/blog_zh.md should not host duplicated listing logic.
2. Heatmap language is intentionally fixed to English.
3. Taxonomy display is unified style.
   - Prefer categories.
   - Fallback to tags.
   - Shared icon style.
4. TOC sidebar is generated client-side from h2-h5.
5. Typography and spacing customization is centralized in _sass/_custom.scss.
6. Series section heading uses global heading font, while series card internals use series card font token.
7. Series identity uses stable key-based matching.
   - Required field: series_key (for both series pages and posts).

## 6. Change Boundaries

When changing a concern, edit these files first.

1. Typography tokens and visual tuning:
   - _sass/_custom.scss
2. Blog list behavior (series cards, featured cards, taxonomy strip):
   - _includes/blog_index_content.liquid
3. Post metadata and taxonomy block:
   - _layouts/post.liquid
4. Language switch target behavior:
   - _includes/lang_switch_url.liquid
5. TOC width/columns/content split:
   - _layouts/default.liquid
6. Heatmap labels/locale logic:
   - _includes/blog_heatmap.liquid
7. Series page and series post matching rules:
   - _layouts/series.liquid
   - _series/*.md and _posts/*.md front matter fields (series_key/series/series_order)

## 7. Governance Rules (Anti-Drift)

1. Do not duplicate business logic between language pages.
2. Do not spread typography rules across many Sass partials.
3. Use semantic classes before broad selectors.
4. Update both post and book-review taxonomy rules together.
5. Keep language-dependent copy in _data/i18n.yml unless explicitly fixed-language by product decision.
6. Update docs when architecture decisions change.

## 8. Operational Playbooks

Use detailed playbooks here:

1. Decision tree by change type:
   - docs/CHANGE_DECISION_TREE.md
2. Validation, release checks, troubleshooting:
   - docs/MAINTENANCE_RUNBOOK.md

## 9. Minimal Verification Standard

Before merge/deploy, run:

1. scripts/validate_structure.ps1
2. docker compose run --rm jekyll bash -c "bundle exec jekyll build --config _config.yml"

Then spot-check:

1. About/home page in en and zh
2. Blog index in en and zh
3. One post page with TOC sidebar
4. Repositories page
5. CV page

## 10. Onboarding Order For New Contributors (Human or AI)

Read in this order:

1. _config.yml
2. _data/i18n.yml
3. _layouts/default.liquid
4. _includes/blog_index_content.liquid
5. _layouts/post.liquid
6. _sass/_custom.scss
7. docs/CHANGE_DECISION_TREE.md
8. docs/MAINTENANCE_RUNBOOK.md

This sequence provides enough context to make coherent, low-risk changes quickly.
