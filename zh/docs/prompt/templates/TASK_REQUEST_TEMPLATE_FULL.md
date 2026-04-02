# AI Task Requirement Prompt (Full Template)

Purpose:
This is the full template for medium or complex tasks that may affect layout, architecture, scripts, or multiple pages.

How to use:
1. Copy the section Template - Task Request.
2. Fill all required fields.
3. Keep this file focused on task requirements only.
4. Put global AI behavior rules in docs/prompt/AI_CHANGE_PROMPT.md.
5. Submit both files to AI in the same session.

---

## Context Snapshot (Optional)

Use this section only for task-specific context that helps execution.

Project context:
- [Optional] Stack or runtime assumptions relevant to this task only.

Existing constraints for this task:
- [Optional] Known architecture boundaries specific to this change.

Reference docs for this task:
- [Optional] Any docs the AI should read first.

---

## Template - Task Request

Task title:
- [Required] One-line summary

Business goal:
- [Required] Why this change is needed
- [Required] Expected user-visible result

Scope:
- [Required] In scope
- [Required] Out of scope

Target pages or flows:
- [Required] Example URLs or page types

Detailed requirements:
1. [Required] Requirement 1
2. [Required] Requirement 2
3. [Optional] Requirement 3

Design and UX constraints:
- [Optional] Typography constraints
- [Optional] Layout constraints
- [Optional] Motion/interaction constraints
- [Optional] Mobile responsiveness constraints

Architecture constraints:
- [Required] Do not duplicate logic across language pages
- [Required] Prefer existing source-of-truth files
- [Required] Do not spread typography patches into multiple Sass partials
- [Required] Keep taxonomy strategy consistent between post and book-review

Localization constraints:
- [Required] Whether this change is bilingual or fixed English
- [Required] If bilingual, update _data/i18n.yml and consuming templates

Compatibility and risk constraints:
- [Required] Must not break pages: About, CV, Repositories, Blog index, single post
- [Optional] Additional safety constraints

Deliverables:
- [Required] Code changes
- [Required] Documentation updates required
- [Required] Final summary format (what, why, docs, validation)

Acceptance criteria:
1. [Required] Functional criterion
2. [Required] Visual criterion
3. [Required] Regression criterion

Validation checklist:
1. [Required] Run scripts/validate_structure.ps1
2. [Required] If layout/include/script changed, run full Jekyll build:
   - docker compose run --rm jekyll bash -c "bundle exec jekyll build --config _config.yml"
3. [Required] Manual verification pages:
   - Home/about
   - Blog index (en and zh)
   - One blog post with TOC sidebar
   - Repositories
   - CV

Documentation update policy:
- [Required] If architecture-impacting files changed, update at least one:
  - docs/ARCHITECTURE_CHANGE_GUIDE.md
  - docs/CHANGE_DECISION_TREE.md
  - docs/MAINTENANCE_RUNBOOK.md
   - docs/DOCS_GUIDE.md

Output format required from AI:
1. Changed files list
2. Why each file changed
3. Validation commands and results
4. Docs updated
5. Risks and follow-ups

---

## Versioning

Version: 1.1
Last updated: 2026-04-02
Owner: Repository maintainers
