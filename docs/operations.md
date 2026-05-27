# Operations

This guide shows the daily workflows Solaria is meant to support after installation.

## Install Or Update Solaria

Preview changes:

```sh
./install.sh --dry-run
```

Install with backup:

```sh
./install.sh
```

Install without creating Claude/Codex symlinks:

```sh
./install.sh --no-claude --no-codex
```

After install:

```sh
~/.agents/bin/skill-health-check --write
~/.agents/bin/trigger-eval
```

## Create A Shared Skill

Create the central skill and expose it to Codex:

```sh
~/.agents/bin/create-skill my-skill \
  --description "Use when the user needs ..." \
  --research-brief ~/.agents/research/creation-briefs/20260527-110000-my-skill.json \
  --codex \
  --resources references,scripts
```

Before running this command, use the existing `research` skill to inspect local Solaria state and write a creation brief under:

```text
~/.agents/research/creation-briefs/
```

Use `--skip-research-brief "<reason>"` only for test fixtures and migrations.

Edit only the central source:

```text
~/.agents/skills/my-skill/SKILL.md
```

Then validate:

```sh
~/.agents/bin/skill-health-check --write
~/.agents/bin/trigger-eval
```

## Add A Persona

```sh
~/.agents/bin/create-persona product-reviewer \
  --role "Product reviewer" \
  --skills prd-create,simulate,quality-gate \
  --research-brief ~/.agents/research/creation-briefs/20260527-110000-product-reviewer.json
```

Personas are execution perspectives, not tone presets. Connect them to skills through ontology and trigger eval cases when they should be selected repeatedly.

## Add A Workflow

```sh
~/.agents/bin/create-workflow idea-to-prd-lite \
  --step market-researcher:research \
  --step product-strategist:prd-create \
  --research-brief ~/.agents/research/creation-briefs/20260527-110000-idea-to-prd-lite.json
```

Workflows are ontology step graphs. Each `--step` is `persona:skill` and steps are stored in the order provided.

## Use A New Skill In The Current Session

Claude and Codex may not refresh native skill trigger metadata inside an already-running conversation. Solaria handles this with explicit session activation:

```sh
~/.agents/bin/session-skill-load my-skill
~/.agents/bin/session-skill-load idea-to-prd --type workflow
~/.agents/bin/session-skill-load --prompt "사용자 요청"
```

`create-skill` and `create-persona` also print an activation packet by default. The active agent should read the returned `SKILL.md`, persona file, or workflow step graph directly and apply it immediately. Native auto-trigger behavior is expected to be reliable in the next session after symlinks and registry updates are visible.

Activation events are recorded in:

```text
~/.agents/runtime/session-activations.jsonl
```

## Add Trigger Eval Coverage

Edit:

```text
~/.agents/evals/trigger/core-cases.json
```

Validate references:

```sh
~/.agents/bin/trigger-eval
```

Preview model eval prompts:

```sh
~/.agents/bin/model-trigger-eval --limit 3
```

Run one model eval case:

```sh
~/.agents/bin/model-trigger-eval --case research-current-market --run
```

## Record Usage

```sh
~/.agents/bin/skill-usage-log \
  --skill research \
  --persona fact-checker \
  --route analyze-competitors \
  --intent "market scan"

~/.agents/bin/sync-skill-usage
```

This updates usage metadata in ontology files such as `last_used` and `usage_count`.

## Check External Sources

```sh
~/.agents/bin/check-external-skill-updates --report
```

Review generated reports before importing changes. Do not directly pull external repositories into Claude or Codex runtime skill paths.

## Codex Safety Loop

Codex hook enforcement is currently best effort. After any Codex session that creates or edits skills, run:

```sh
~/.agents/bin/skill-health-check --write
```

If it reports `codex-direct-local-skill`, move that skill into `~/.agents/skills` and expose it with a symlink.
