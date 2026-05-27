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
  --codex \
  --resources references,scripts
```

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
  --skills prd-create,simulate,quality-gate
```

Personas are execution perspectives, not tone presets. Connect them to skills through ontology and trigger eval cases when they should be selected repeatedly.

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

