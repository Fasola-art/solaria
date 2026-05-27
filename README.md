# Solaria

Shared Claude/Codex skill management system centered on `~/.agents/skills`.

Solaria is a shared skill operations layer for Claude, Codex, personas, ontology, trigger evaluation, and runtime governance. The name frames skills as small suns in an agent operating system: each capability has its own orbit, and Solaria keeps the system mapped, routed, and healthy.

This repository captures the current implementation for:

- Central skill source of truth under `skills/`
- Claude/Codex exposure rules
- Skill registry and ontology metadata
- Persona, route, and workflow relationships
- Trigger evaluation cases and model eval tooling
- External skill source tracking
- Health checks and post-run enforcement

## Layout

```text
bin/                 automation commands
skills/              shared SKILL.md-based skills
personas/            persona definitions
ontology/            skills/personas/workflows/routes graph data
evals/trigger/       static and model trigger eval cases
external-skills/     import plan and external update reports
reports/             scenario reviews and live observations
docs/                installation and config notes
skills-registry.json generated operational registry
```

## Install Locally

Use this repo as the source for `~/.agents`:

```sh
mkdir -p ~/.agents
rsync -a --delete \
  --exclude '.git/' \
  --exclude 'docs/' \
  ./bin ./skills ./personas ./ontology ./evals ./external-skills ./reports ./skills-registry.json \
  ~/.agents/
```

Then expose shared skills through runtime symlinks as needed:

```sh
ln -sfn ../../.agents/skills/skill-management ~/.claude/skills/skill-management
ln -sfn ../../.agents/skills/skill-management ~/.codex/skills/skill-management
```

## Core Commands

```sh
~/.agents/bin/create-skill <name> --codex --resources references,scripts
~/.agents/bin/create-persona <id> --role "Role name" --skills research,quality-gate
~/.agents/bin/skill-health-check --write
~/.agents/bin/trigger-eval
~/.agents/bin/model-trigger-eval --limit 3
~/.agents/bin/model-trigger-eval --case research-current-market --run
~/.agents/bin/validate-skill-scripts
~/.agents/bin/check-reference-toc --min-lines 100
~/.agents/bin/check-external-skill-updates --report
~/.agents/bin/skill-usage-log --skill research --persona fact-checker
~/.agents/bin/sync-skill-usage
```

## Current Status

Latest local validation before packaging:

- `skill-health-check --write`: `skills: 104`, `errors: 0`, `warnings: 0`
- `trigger-eval`: `cases: 16`, `errors: 0`
- Codex strict config doctor: `13 ok | 1 idle | 0 warn | 0 fail`

See `reports/` for scenario review and live Codex hook observation.

## Enforcement Notes

Claude hook enforcement is configured through Claude rules/hooks.

Codex hook enforcement is currently best effort. Live observation on 2026-05-27 showed that `codex exec` with `apply_patch` can create a direct local skill under `~/.codex/skills` without invoking the configured guard. For Codex, rely on:

1. Rules that instruct skills to be created under `~/.agents/skills`.
2. Hook config where supported.
3. Mandatory post-run `skill-health-check --write` to detect direct local Codex skills.
