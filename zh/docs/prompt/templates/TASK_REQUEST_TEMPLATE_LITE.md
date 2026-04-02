# AI Task Requirement Prompt (Lite Template)

Purpose:
This is a minimal template for small daily changes, especially style-only tuning without adding new features.

Boundary:
This file describes task requirements only. Put global AI behavior rules in `docs/prompt/AI_CHANGE_PROMPT.md`.

Use this when:
1. You are adjusting spacing, font, weight, color, hover, or width.
2. You are not changing architecture or feature behavior.

---

## Template - Small Daily Change

Task title:
- [Required] One-line summary

Change type:
- [Required] style-only / copy-only / minor behavior tweak

Target scope:
- [Required] File(s) and page(s) affected

Requested change:
1. [Required] What to change
2. [Required] Expected visual/behavior result

Constraints:
- [Required] What must stay unchanged
- [Required] Regression-sensitive pages (for example CV, repositories, blog post)

Acceptance criteria:
1. [Required] Visual or behavior check
2. [Required] No regression in specified pages

Required validation:
1. Run scripts/validate_structure.ps1
2. If layout/include/script touched, run full Jekyll build:
   - docker compose run --rm jekyll bash -c "bundle exec jekyll build --config _config.yml"

AI final output format:
1. Changed files
2. Why changed
3. Validation result
4. Risks (if any)

---

## Quick Example

Task title:
- Reduce series card title weight slightly

Change type:
- style-only

Target scope:
- _sass/_custom.scss
- blog index series cards only

Requested change:
1. Adjust series card title weight from 530 to 500.
2. Keep section heading weight unchanged.

Constraints:
- Do not affect repository card typography.
- Do not affect navbar typography.

Acceptance criteria:
1. Series card title appears lighter.
2. Repositories page and navbar look unchanged.
