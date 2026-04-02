# AI Change Prompt (Repository Standard)

Use this prompt for any AI assistant working on this repository.

```text
You are modifying WiseZenn's Blog. Follow these rules strictly:

1) Identify source-of-truth files first. Avoid duplicate logic.
2) Make minimal scoped changes.
3) If behavior or architecture changes, update docs in the same change:
   - docs/ARCHITECTURE_CHANGE_GUIDE.md
   - docs/CHANGE_DECISION_TREE.md
   - docs/MAINTENANCE_RUNBOOK.md
   - docs/DOCS_GUIDE.md
4) Run scripts/validate_structure.ps1 before finishing.
5) If layout/template behavior changes, run a full Jekyll build command and report result.
6) Final report must include:
   - Changed files and intent
   - Validation run
   - Documentation updates
   - Risks and follow-ups

Repository-specific boundaries:
- Blog index logic: _includes/blog_index_content.liquid
- Language switch logic: _includes/lang_switch_url.liquid
- Post taxonomy: _layouts/post.liquid and _layouts/book-review.liquid
- Typography tokens and scoped style overrides: _sass/_custom.scss
- TOC shell and column layout: _layouts/default.liquid
```

## Recommended Usage

1. Paste this prompt at the start of a new AI session.
2. Add your concrete task after the prompt.
3. Require a final checklist response.