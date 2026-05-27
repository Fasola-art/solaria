# Operations

## Add A Shared Skill

```sh
~/.agents/bin/create-skill my-skill --description "Use when ..." --codex --resources references,scripts
```

Then edit:

```text
~/.agents/skills/my-skill/SKILL.md
```

Run:

```sh
~/.agents/bin/skill-health-check --write
~/.agents/bin/trigger-eval
```

## Add A Persona

```sh
~/.agents/bin/create-persona product-reviewer --role "Product reviewer" --skills prd-create,simulate,quality-gate
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

## Check External Sources

```sh
~/.agents/bin/check-external-skill-updates --report
```

Review reports before importing changes. Do not blindly pull external skill repos into the runtime path.

## Trigger Eval

Static validation:

```sh
~/.agents/bin/trigger-eval
```

Model-based dry-run:

```sh
~/.agents/bin/model-trigger-eval --limit 3
```

Model-based execution:

```sh
~/.agents/bin/model-trigger-eval --case research-current-market --run
```

