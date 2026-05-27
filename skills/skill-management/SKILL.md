---
name: skill-management
description: Manage shared agent skills across Claude and Codex. Use when creating, updating, moving, auditing, importing, validating, deduplicating, or centralizing SKILL.md-based skills; when connecting skills to personas, ontology, workflows, or routes; or when deciding whether a skill belongs in ~/.agents/skills, ~/.claude/skills, or ~/.codex/skills.
---

# Skill Management

Use this skill before creating, modifying, moving, importing, or auditing any `SKILL.md`-based skill.

## Source of Truth

Use `~/.agents/skills/<skill-name>` as the source of truth for shared skills.

Expose shared skills to runtimes with symlinks:

- Claude: `~/.claude/skills/<skill-name> -> ../../.agents/skills/<skill-name>`
- Codex: `~/.codex/skills/<skill-name> -> ../../.agents/skills/<skill-name>` only when explicit Codex exposure is needed.

Do not move or edit Codex system skills in `~/.codex/skills/.system`.

Keep Claude-only skills in `~/.claude/skills` only when they depend on Claude hooks, Claude plugins, Jarvis runtime behavior, or Claude-specific MCP/channel assumptions. Mark them `claude-only` in the registry.

## Required Tools

Prefer the central scripts:

- Create a shared skill with `~/.agents/bin/create-skill <skill-name>`.
- Validate skill structure with `~/.agents/bin/skill-health-check`.
- Validate trigger eval references with `~/.agents/bin/trigger-eval`.
- Log manual usage events with `~/.agents/bin/skill-usage-log`.
- Sync usage logs into ontology with `~/.agents/bin/sync-skill-usage`.
- Check external source repositories with `~/.agents/bin/check-external-skill-updates`.
- Validate bundled skill scripts with `~/.agents/bin/validate-skill-scripts`.
- Check long references for tables of contents with `~/.agents/bin/check-reference-toc`.
- Run model-based trigger checks with `~/.agents/bin/model-trigger-eval`.
- Create persona files manually only if `create-persona` is unavailable; update ontology immediately.

## Registry and Ontology

Update these files when adding or changing skills:

- `~/.agents/skills-registry.json`: operational state, source path, runtime exposure, validation status.
- `~/.agents/ontology/skills.json`: skill capability relationships.
- `~/.agents/ontology/personas.json`: persona entities and skill relationships.
- `~/.agents/ontology/workflows.json`: reusable skill/persona execution sequences.
- `~/.agents/ontology/routes.json`: intent to skill/persona/workflow mapping.

Treat a skill as a capability entity. Treat a persona as the role, judgment criteria, and responsibility model used while applying skills. Skills and personas are many-to-many.

## Safe Change Workflow

1. Run `~/.agents/bin/skill-health-check --json` to capture current state.
2. If moving or replacing existing skills, create a backup under `~/.agents/migration-backups/<timestamp>/`.
3. Compare duplicates before merging. Never overwrite a skill with the same `name` without reading both `SKILL.md` files and checking resources.
4. Keep `SKILL.md` concise. Move detailed, conditional, or long material into `references/`.
5. Re-run `~/.agents/bin/skill-health-check` after changes.

## Enforcement and Logs

Claude uses `~/.agents/bin/skill-path-guard` as a PreToolUse hook. It requests approval before direct `SKILL.md` writes under `~/.claude/skills` or `~/.codex/skills` unless the path is an allowed symlink or Codex system/runtime exception.

Codex has the same hook configured, but live `codex exec` observation on 2026-05-27 showed that `apply_patch` can create `~/.codex/skills/<name>/SKILL.md` without invoking the guard. Treat Codex hook enforcement as best effort until this is revalidated after Codex updates. Always run `~/.agents/bin/skill-health-check --write` after Codex skill work; it flags direct Codex local skills that should have been created in `~/.agents/skills`.

Claude uses `~/.agents/bin/skill-change-log` as a PostToolUse hook to append skill file changes to `~/.agents/runtime/skill-changes.jsonl`.

Use `~/.agents/bin/skill-usage-log --skill <id> --persona <id> --workflow <id> --route <id>` when a workflow should be explicitly recorded outside automatic runtime logs.

Run `~/.agents/bin/sync-skill-usage` after meaningful sessions to update `usage_count` and `last_used` fields in `skills.json`, `personas.json`, `workflows.json`, and `routes.json`.

Run `~/.agents/bin/check-external-skill-updates --write --report` when refreshing external source baselines. Review the generated report before importing changes.

Run `~/.agents/bin/validate-skill-scripts` before relying on bundled scripts. Use `--run-help` only for trusted scripts because it executes each candidate with `--help`.

Run `~/.agents/bin/check-reference-toc --min-lines 100 --write` after adding large reference files so long references remain skimmable.

Run `~/.agents/bin/model-trigger-eval --limit 3` first to inspect prompts. Add `--run` only when you intentionally want Codex to evaluate trigger behavior through `codex exec` in read-only mode. Reports are saved under `~/.agents/evals/trigger/runs/`.

## Skill Quality Rules

- `name` should be lowercase hyphen-case and match the directory name unless there is a documented runtime reason.
- `description` must explain what the skill does and when to use it. Include concrete trigger contexts.
- Keep `SKILL.md` under 500 lines when practical.
- Put deterministic or repeated operations in `scripts/`.
- Put detailed reference material in `references/`.
- External skills must be audited before import; do not install them directly into Claude or Codex runtime paths.

## External References

- Read `references/context-evaluation.md` when designing skill health gates, regression tests, trigger evals, or quality rubrics.
- Read `references/context-filesystem.md` when deciding how to store large tool outputs, scratchpads, handoff state, or cross-agent context outside the prompt.
- Read `references/matt-grill-with-docs.md` when skill development needs terminology discipline, `CONTEXT.md`, ADRs, or plan grilling against documented decisions.

## Persona Rules

Personas are not tone presets. Define responsibilities, decision criteria, strengths, and failure modes.

Use personas to select execution perspective:

- `research` can pair with `fact-checker`, `market-researcher`, or `academic-researcher`.
- `prd-create` can pair with `product-strategist`.
- `quality-gate` can pair with `qa-reviewer`.

Use workflows when a task needs multiple skill/persona pairs in sequence.
