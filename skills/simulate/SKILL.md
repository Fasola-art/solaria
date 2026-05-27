---
name: simulate
description: Simulate and stress-test plans, strategies, product ideas, technical designs, and workflows before execution. Use when the user asks to 검증, 시뮬레이션, stress test, compare options, find risks, challenge a plan, or improve a plan before implementation.
version: "1.0.0"
trigger: "/simulate"
aliases: ["/sim", "/시뮬"]
---

# Simulate

Use this skill to test a plan before execution, identify weak assumptions, improve the plan, and re-check the result.

## Modes

- `quick`: fast feasibility/risk pass.
- `deep`: full 4-dimension review.
- `compare`: compare two or more options.
- `perspective`: evaluate from multiple stakeholder perspectives.
- `stress`: test extreme constraints and failure modes.

## Core Workflow

1. Identify the plan, decision, or strategy being evaluated.
2. Select the minimum useful mode and context.
3. Evaluate feasibility, dependencies, risk, and impact.
4. Identify gaps that would materially change the outcome.
5. Patch the plan or propose specific improvements.
6. Re-run a short verification pass on the improved plan.

## References

- Read `references/full-guide.md` for the legacy detailed framework, mode rules, scoring, and examples.
- Read `references/red-blue-analysis.md` when adversarial review or red-team/blue-team analysis is needed.
- Read `references/matt-grill-me.md` when the user wants a relentless interview, plan challenge, or design stress test through one-question-at-a-time grilling.

## Persona Fit

Prefer these personas when available:

- `product-strategist` for product or business plans.
- `qa-reviewer` for execution risk and acceptance checks.
- `fact-checker` when factual assumptions drive the plan.
