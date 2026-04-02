# Prompt Documentation Guide

This folder is for AI collaboration inputs only.

## Responsibility Boundary

1. `AI_CHANGE_PROMPT.md`
   - Purpose: behavioral rules for the AI agent.
   - Contains: process rules, guardrails, validation/report expectations.
   - Does not contain: task-specific requirements for one concrete change.
2. `templates/TASK_REQUEST_TEMPLATE_*.md`
   - Purpose: requirement forms for one concrete task.
   - Contains: scope, constraints, acceptance criteria, expected output.
   - Does not contain: global behavioral rules that belong to `AI_CHANGE_PROMPT.md`.

## Recommended Usage Order

1. Start with `AI_CHANGE_PROMPT.md`.
2. Fill one task template under `templates/`.
3. Submit both to the AI assistant in the same session.