# Solaria

**A skill operations layer for Claude, Codex, and local AI workflows.**

[한국어 문서](docs/README.ko.md) · [Operations](docs/operations.md) · [Config snippets](docs/config-snippets.md)

Solaria gives AI power users one place to create, route, validate, and govern reusable agent skills. If your Claude and Codex setups have started to grow into separate folders, duplicate instructions, one-off personas, and fragile local rules, Solaria turns that sprawl into an operating layer.

Think of each skill as a small sun. Personas, workflows, routes, and evaluations orbit around it. Solaria keeps that system mapped, connected, and healthy.

## Why Solaria

AI skills are easy to create and hard to maintain. The first few are helpful. The next few become hard to trigger reliably. Eventually every runtime has its own copy, every workflow has a slightly different rule, and no one remembers which persona, route, or validation case belongs to what.

Solaria solves that by making `~/.agents/skills` the shared source of truth, then layering practical operations around it:

- **Central skill management** for Claude, Codex, and shared local agents
- **Persona + ontology mapping** so skills are connected to roles, routes, and workflows
- **Research-first creation** so new skills, personas, and workflows are checked against existing local context before they are added
- **Current-session activation** so newly created or changed skills can be loaded immediately without waiting for Claude/Codex to refresh native trigger metadata
- **Trigger evaluation** to test when skills should and should not activate
- **Health checks** to detect broken symlinks, duplicate skills, invalid metadata, and direct Codex local skills
- **External source tracking** for imported skill systems like GSAP, Matt Pocock skills, and context-engineering references
- **Runtime governance** with hooks where supported and post-run detection where hooks are not enough

## Quick Start

Clone the repository:

```sh
git clone https://github.com/mane23-ai/solaria.git
cd solaria
```

Preview the install:

```sh
./install.sh --dry-run
```

Install into `~/.agents`:

```sh
./install.sh
```

Validate:

```sh
~/.agents/bin/skill-health-check --write
~/.agents/bin/trigger-eval
```

The installer backs up an existing `~/.agents` directory before copying Solaria files. It also links `skill-management` into Claude and Codex unless you opt out.

## What You Get

```text
bin/                 automation commands
skills/              shared SKILL.md-based skills
personas/            persona definitions
ontology/            skills/personas/workflows/routes graph data
research/            creation briefs generated before new skill/persona/workflow creation
evals/trigger/       static and model trigger eval cases
external-skills/     import plan and external update reports
reports/             scenario reviews and live observations
docs/                installation and config notes
skills-registry.json generated operational registry
```

## Core Workflows

### Research-First Creation

Solaria treats skill creation as an operational change, not a scratchpad action. Before adding a new skill, persona, or workflow, use the existing `research` skill to inspect local Solaria state:

```text
~/.agents/skills
~/.agents/personas
~/.agents/ontology/*.json
~/.agents/skills-registry.json
```

Save the result as a creation brief:

```text
~/.agents/research/creation-briefs/YYYYMMDD-HHMMSS-<target-id>.json
```

The creation commands require that brief by default. For tests and migrations only, pass `--skip-research-brief "<reason>"`; the reason is recorded in activation output and ontology metadata.

Create a shared skill:

```sh
~/.agents/bin/create-skill my-skill \
  --description "Use when ..." \
  --research-brief ~/.agents/research/creation-briefs/20260527-110000-my-skill.json \
  --codex \
  --resources references,scripts
```

Create a persona:

```sh
~/.agents/bin/create-persona product-reviewer \
  --role "Product reviewer" \
  --skills prd-create,simulate,quality-gate \
  --research-brief ~/.agents/research/creation-briefs/20260527-110000-product-reviewer.json
```

Create a workflow:

```sh
~/.agents/bin/create-workflow idea-to-prd-lite \
  --step market-researcher:research \
  --step product-strategist:prd-create \
  --research-brief ~/.agents/research/creation-briefs/20260527-110000-idea-to-prd-lite.json
```

Load a skill, persona, or workflow into the current conversation:

```sh
~/.agents/bin/session-skill-load my-skill
~/.agents/bin/session-skill-load idea-to-prd --type workflow
~/.agents/bin/session-skill-load --prompt "Draft a PRD and stress-test the launch risks"
```

Newly created skills are exposed to future Claude/Codex sessions through the registry and symlinks. For the current session, use the activation packet printed by `create-skill`, `create-persona`, or `session-skill-load`; the agent should read the returned file path directly instead of waiting for native auto-trigger metadata to refresh.

Workflow activation returns the step graph plus each step's skill/persona paths, so a running session can execute the workflow immediately:

```json
{
  "activated_type": "workflow",
  "id": "idea-to-prd",
  "steps": [
    {
      "skill": "research",
      "skill_path": "~/.agents/skills/research/SKILL.md",
      "persona": "market-researcher",
      "persona_path": "~/.agents/personas/market-researcher.md"
    }
  ]
}
```

Validate the system:

```sh
~/.agents/bin/skill-health-check --write
~/.agents/bin/trigger-eval
~/.agents/bin/validate-skill-scripts
~/.agents/bin/check-reference-toc --min-lines 100
```

Run model-based trigger evaluation:

```sh
~/.agents/bin/model-trigger-eval --limit 3
~/.agents/bin/model-trigger-eval --case research-current-market --run
```

Record usage:

```sh
~/.agents/bin/skill-usage-log \
  --skill research \
  --persona fact-checker \
  --route analyze-competitors

~/.agents/bin/sync-skill-usage
```

## Claude And Codex

Solaria exposes shared skills through symlinks:

```sh
~/.claude/skills/skill-management -> ~/.agents/skills/skill-management
~/.codex/skills/skill-management  -> ~/.agents/skills/skill-management
```

Claude hook enforcement can be wired to block direct runtime skill edits.

Codex hook enforcement is currently best effort. A live observation on 2026-05-27 showed that `codex exec` with `apply_patch` can create a direct local skill under `~/.codex/skills` without invoking the configured guard. For Codex, Solaria relies on:

1. Rules that instruct skills to be created under `~/.agents/skills`.
2. Hook config where supported.
3. Mandatory post-run `skill-health-check --write` to detect direct local Codex skills.

See [Config snippets](docs/config-snippets.md) for local setup details.

## Current Snapshot

Fresh install validation in an isolated `$HOME`:

- `skill-health-check --write`: `skills: 63`, `errors: 0`, `warnings: 0`
- `trigger-eval`: `cases: 16`, `errors: 0`

Latest development-machine validation before packaging, including local Claude/Codex runtime skills:

- `skill-health-check --write`: `skills: 104`, `errors: 0`, `warnings: 0`
- `trigger-eval`: `cases: 16`, `errors: 0`
- Codex strict config doctor: `13 ok | 1 idle | 0 warn | 0 fail`

See [scenario review](reports/2026-05-27-skill-system-scenario-review.md) and [Codex live hook observation](reports/2026-05-27-codex-live-hook-observation.md).


## Windows (PowerShell)

macOS/Linux 는 `install.sh`, Windows 는 `install.ps1` 을 사용한다(동작 동일).

```powershell
powershell -File install.ps1 -DryRun   # 미리보기(변경 없음)
powershell -File install.ps1           # ~/.agents 에 설치
```

옵션: `-NoBackup`, `-NoClaude`, `-NoCodex`.

- 심볼릭 링크는 개발자 모드 또는 관리자 권한이 필요하며, 실패 시 디렉토리 정션(Junction)으로 자동 대체된다.
- 훅 `bin/skill-path-guard`, `bin/skill-change-log` 의 Windows 버전은 `.ps1` 로 제공된다(jq 불필요).
- `.ps1` 파일은 Windows PowerShell 5.1 호환을 위해 UTF-8 BOM 으로 저장되어 있다.