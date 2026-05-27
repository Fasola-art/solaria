# External Skill Merge Report - 2026-05-27

## Summary

Merged selected external skill ideas as references and workflow rules without overwriting local skills.

## Matt Pocock Skills

- `diagnose` -> `autofix`
  - Added reproduction-first diagnosis loop directly to `autofix`.
  - Preserved full source as `autofix/references/matt-diagnose.md`.
- `tdd` -> `test-driven-development`
  - Added vertical slice rule directly to `test-driven-development`.
  - Preserved full source as `test-driven-development/references/matt-tdd.md`.
- `handoff` -> `recover`
  - Preserved as `recover/references/matt-handoff.md`.
  - Added `handoff-current-session` route and `handoff-continuation` workflow.
- `grill-me` -> `simulate`
  - Preserved as `simulate/references/matt-grill-me.md`.
  - Added `grill-plan` route and `plan-grilling` workflow.
- `grill-with-docs` -> `skill-management`
  - Preserved as `skill-management/references/matt-grill-with-docs.md`.

## Context Engineering Skills

- `evaluation` -> `skill-management/references/context-evaluation.md`
- `filesystem-context` -> `skill-management/references/context-filesystem.md`
- `tool-design` -> `mcp-builder/references/context-tool-design.md`
- `context-compression` -> `recover/references/context-compression.md`
- `multi-agent-patterns` -> `team-common/references/context-multi-agent-patterns.md`

## GSAP Skills

Installed as shared skills:

- `gsap-core`
- `gsap-react`
- `gsap-scrolltrigger`
- `gsap-performance`
- `gsap-timeline`
- `gsap-plugins`
- `gsap-utils`

Added:

- `frontend-motion-build` workflow
- `build-frontend-motion` route
- trigger eval cases for React GSAP and ScrollTrigger tasks

## Validation

- `skill-health-check --write`: 0 errors, 0 warnings
- `trigger-eval`: 16 cases, 0 errors
