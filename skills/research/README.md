# research-skill

Standalone `research` skill extracted from a local Codex/Claude skills workspace.

## Overview

This repository contains the `research` skill as a self-contained package. The current version uses a discovery-first research pipeline built around:

- Question reframing
- Open-world discovery
- Candidate normalization
- Dynamic taxonomy
- Evidence search
- Coverage ledger
- Opportunity design

## Layout

- `SKILL.md`: top-level skill definition
- `orchestrator/`: canonical pipeline and fallback routing
- `agents/`: role definitions, configs, prompts, protocols
- `references/`: workflow, schemas, templates, source references
- `quality/`: verification, rubric, disclaimer, freshness rules
- `methodology/`: supporting evaluation frameworks
- `safeguards/`: fallback and risk-handling rules
- `mcp/`: MCP integration notes

## Notes

This repo is intended to track the skill independently from the larger workspace.
