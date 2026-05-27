# Skill System Scenario Review

Date: 2026-05-27

## Scope

Reviewed the implemented shared skill management system across central storage, Claude/Codex exposure, hook enforcement, trigger evaluation, usage logging, external source tracking, and quality checks.

## Scenarios

### 1. Shared Skill Creation

Command:

```sh
~/.agents/bin/create-skill zz-scenario-skill-095338 --codex --resources references,scripts
```

Expected:

- Creates the source skill under `~/.agents/skills`.
- Creates Claude and Codex symlinks.
- Creates requested resource directories.
- `skill-health-check --write` remains clean.

Result:

- Central `SKILL.md`: pass
- `references/` and `scripts/`: pass
- Claude symlink: pass
- Codex symlink: pass
- Cleanup restored health check to `skills: 104`, `errors: 0`, `warnings: 0`.

### 2. Hook Path Guard

Expected:

- Direct writes to `~/.claude/skills/<local>/SKILL.md` request approval.
- Direct writes to `~/.codex/skills/<local>/SKILL.md` request approval.
- Writes under `~/.agents/skills` pass.
- Writes through allowed symlinked skill paths pass.
- Codex system/runtime skill paths pass.

Result:

- Direct Claude path returned `permissionDecision: ask`: pass
- Direct Codex path returned `permissionDecision: ask`: pass
- `~/.agents/skills/.../SKILL.md` returned no block output: pass
- `~/.claude/skills/skill-management/SKILL.md` symlink path returned no block output: pass
- `~/.codex/skills/.system/.../SKILL.md` returned no block output: pass

### 3. Codex Global Hook Config

Expected:

- `~/.codex/config.toml` includes valid `hooks.PreToolUse` and `hooks.PostToolUse`.
- Codex strict config validation passes.

Result:

- `codex --strict-config doctor --summary --ascii`: pass
- Doctor summary: `13 ok | 1 idle | 0 warn | 0 fail`.

### 4. Trigger Evaluation

Expected:

- Static trigger eval validates all case references.
- Model trigger eval can generate a dry-run plan.
- At least one actual Codex model trigger run succeeds.

Result:

- `trigger-eval`: `cases: 16`, `errors: 0`
- `model-trigger-eval --limit 2`: dry-run pass
- Prior actual run saved at `~/.agents/evals/trigger/runs/20260527T005155Z-codex.json`: `passes: 1`, `failures: 0`

### 5. Usage Log Sync

Expected:

- A usage event with known skill/persona/route ids updates the correct ontology buckets.
- Dry-run does not mutate ontology files.

Result:

- Dry-run event count: `1`
- Updated buckets: `skills: 2`, `personas: 1`, `routes: 1`
- Unknown ids: none

### 6. External Source Tracking

Expected:

- External source checker can compare baseline commits without importing changes automatically.

Result:

- Muratcan source: unchanged
- Matt Pocock source: unchanged
- GSAP source: unchanged
- Report generated at `~/.agents/external-skills/reports/2026-05-27-external-update-check.md`

### 7. Quality Gates

Expected:

- Registry and ontology remain valid.
- Script and reference checks remain clean.

Result:

- `skill-health-check --write`: `skills: 104`, `errors: 0`, `warnings: 0`
- `validate-skill-scripts`: `scripts: 31`, `warnings: 0`
- `check-reference-toc --min-lines 100`: `checked: 76`, `warnings: 0`, `changed: 0`
- Main JSON files parse successfully.

## Verdict

The implemented system passed the scenario review. No blocking issue was found.

## Residual Risks

- Hook behavior was verified through direct hook input simulation and Codex strict config validation. Full live blocking behavior depends on Codex invoking hooks for future file-write tool calls.
- Model trigger eval currently has one successful live case. Broader scoring should be run gradually because it consumes model calls.
- Usage logging is explicit/manual unless a runtime hook or agent workflow calls `skill-usage-log`.
