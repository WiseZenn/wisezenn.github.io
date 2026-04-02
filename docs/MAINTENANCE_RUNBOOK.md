# Maintenance Runbook

This runbook defines operational checks for local development, pre-release validation, and troubleshooting.

## 1. Standard Local Workflow

1. Clean previous build artifacts before audit/review:
   - Remove-Item -Recurse -Force _site (PowerShell)
   - or rm -rf _site (bash)
2. Start local environment:
   - scripts/serve.ps1 (PowerShell)
   - or docker compose up
3. Make change in source-of-truth file.
4. Run structural checks:
   - scripts/validate_structure.ps1
5. Run full build once:
   - docker compose run --rm jekyll bash -c "bundle exec jekyll build --config _config.yml"
6. Perform manual verification checklist.

## 2. Manual Verification Checklist

1. Home and navigation:
   - Language toggle works.
   - Brand/nav typography remains expected.
2. Blog index (en and zh):
   - Header/subtitle render correctly.
   - Series cards and featured cards render without broken styles.
   - Taxonomy strip uses unified strategy.
3. Single blog post:
   - Metadata and taxonomy are correct.
   - TOC sidebar appears and shows nested headings.
   - Content width and TOC spacing look balanced on desktop.
   - Comment area behavior is correct:
     - If giscus is fully configured, the comment widget loads.
     - If required giscus IDs are missing, the configuration warning block is shown.
4. Repositories page:
   - Card typography and hover behavior are correct.
5. CV page:
   - No unintended card typography spillover.
6. Heatmap:
   - Labels and locale remain fixed English by design.
7. Series pages:
   - Series landing pages render in both en and zh.
   - Post ordering follows series_order.
   - Bilingual pairing works via lang-ref.

## 3. Pre-Release Checklist

1. scripts/validate_structure.ps1 passes.
2. Full Jekyll build passes.
3. No new problems in editor diagnostics for touched files.
4. Docs reflect behavior changes:
   - docs/ARCHITECTURE_CHANGE_GUIDE.md
   - docs/CHANGE_DECISION_TREE.md
   - docs/DOCS_GUIDE.md and root README if navigation changed.

## 4. Troubleshooting

## 4.1 TOC Sidebar Missing

1. Confirm page front matter includes:
   - toc:
     sidebar: left or right
2. Confirm default layout still renders #toc-sidebar.
3. Confirm assets/js/common.js custom TOC builder was not broken.
4. Inspect browser console for JS errors.

## 4.2 Unexpected Typography Regressions

1. Inspect _sass/_custom.scss for overly broad selectors.
2. Ensure scoped selectors use semantic classes (repo-card, series-card).
3. Rebuild assets and hard-refresh browser cache.

## 4.3 Language Toggle Links Wrong

1. Verify lang and lang-ref fields exist in paired pages/posts.
2. Validate _includes/lang_switch_url.liquid fallback logic.
3. Confirm about/home pages have lang-ref mapping.

## 4.4 Script or Lint Warnings

1. Use approved PowerShell verbs.
2. Keep script docs in sync with actual ports/commands.
3. Avoid interactive prompts in automation paths.

## 4.5 Series Page Missing Posts

1. Prefer series_key in both _series and _posts front matter.
2. Ensure series_key values are exactly identical (case-sensitive).
3. Confirm lang is aligned with the active language page.

## 4.6 Giscus Comments Not Showing

1. Check `_config.yml` has all required fields under `giscus`:
   - `repo`
   - `repo_id`
   - `category_id`
2. Confirm post or book page has comments enabled (by defaults or per-page front matter):
   - `giscus_comments: true`
3. Run a full build and inspect the rendered page source for `/assets/js/giscus-setup.js`.

## 5. Release Notes Template

Use this short template in PRs/releases:

1. Scope: what user-visible behavior changed
2. Architecture touchpoints: files that were source of truth
3. Validation: commands and manual pages checked
4. Risks: known limitations or deferred follow-ups

A consistent release note format improves continuity for both humans and AI agents.
