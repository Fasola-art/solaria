# Solaria 한국어 문서

**Claude, Codex, 로컬 AI 워크플로우를 위한 스킬 운영 레이어.**

Solaria는 흩어진 에이전트 스킬을 한곳에서 만들고, 연결하고, 검증하고, 운영하기 위한 시스템입니다. Claude와 Codex를 함께 쓰다 보면 스킬 폴더가 나뉘고, 같은 지침이 중복되고, 어떤 페르소나와 워크플로우가 어떤 스킬에 연결되는지 흐려집니다. Solaria는 이 문제를 `~/.agents/skills` 중심 구조로 정리합니다.

스킬은 작은 태양이고, 페르소나·온톨로지·워크플로우·평가 케이스는 그 주위를 도는 궤도입니다. Solaria는 이 구조를 지도처럼 관리합니다.

## 왜 필요한가

- Claude와 Codex 스킬을 한곳에서 중앙관리합니다.
- 스킬과 persona, workflow, route, ontology 관계를 같이 관리합니다.
- trigger eval로 어떤 요청에서 어떤 스킬이 호출되어야 하는지 검증합니다.
- health check로 중복, 깨진 symlink, 잘못된 metadata, Codex 직접 로컬 스킬 생성을 탐지합니다.
- 외부 스킬 repo를 무작정 pull하지 않고 audit 후 반영할 수 있게 추적합니다.

## 빠른 설치

```sh
git clone https://github.com/mane23-ai/solaria.git
cd solaria
./install.sh --dry-run
./install.sh
```

설치 후 검증:

```sh
~/.agents/bin/skill-health-check --write
~/.agents/bin/trigger-eval
```

기본 설치는 기존 `~/.agents`를 timestamp 백업한 뒤 Solaria 파일을 복사합니다. 또한 `skill-management` 스킬을 Claude와 Codex에 symlink로 연결합니다.

격리된 새 `$HOME` 기준 검증 결과는 `skills: 63`, `errors: 0`, `warnings: 0`입니다. 개발 머신에서는 Claude/Codex 로컬 런타임 스킬까지 포함되어 더 많은 스킬이 보일 수 있습니다.

## 자주 쓰는 명령

새 스킬 만들기:

```sh
~/.agents/bin/create-skill my-skill \
  --description "Use when ..." \
  --research-brief ~/.agents/research/creation-briefs/20260527-110000-my-skill.json \
  --codex \
  --resources references,scripts
```

새 페르소나 만들기:

```sh
~/.agents/bin/create-persona product-reviewer \
  --role "Product reviewer" \
  --skills prd-create,simulate,quality-gate \
  --research-brief ~/.agents/research/creation-briefs/20260527-110000-product-reviewer.json
```

새 스킬, 페르소나, 워크플로우를 만들기 전에는 기존 `research` 스킬로 로컬 Solaria 상태를 먼저 조사하고 creation brief를 남깁니다. 테스트나 마이그레이션 예외만 `--skip-research-brief "<reason>"`을 사용합니다.

새 워크플로우 만들기:

```sh
~/.agents/bin/create-workflow idea-to-prd-lite \
  --step market-researcher:research \
  --step product-strategist:prd-create \
  --research-brief ~/.agents/research/creation-briefs/20260527-110000-idea-to-prd-lite.json
```

현재 세션에서 바로 로드하기:

```sh
~/.agents/bin/session-skill-load my-skill
~/.agents/bin/session-skill-load idea-to-prd --type workflow
~/.agents/bin/session-skill-load --prompt "사용자 요청"
```

Claude/Codex의 네이티브 스킬 자동 트리거는 실행 중인 대화에서 즉시 갱신되지 않을 수 있습니다. 새로 만든 스킬, 페르소나, 워크플로우는 activation packet의 경로나 step graph를 직접 읽어서 현재 세션에 적용하고, 다음 세션에서는 symlink와 registry 기반 자동 인식을 기대합니다.

상태 검증:

```sh
~/.agents/bin/skill-health-check --write
~/.agents/bin/trigger-eval
~/.agents/bin/validate-skill-scripts
```

모델 기반 trigger eval:

```sh
~/.agents/bin/model-trigger-eval --limit 3
~/.agents/bin/model-trigger-eval --case research-current-market --run
```

사용 로그 기록:

```sh
~/.agents/bin/skill-usage-log \
  --skill research \
  --persona fact-checker \
  --route analyze-competitors

~/.agents/bin/sync-skill-usage
```

## 운영 원칙

- 공유 스킬의 원본은 `~/.agents/skills/<skill-name>`입니다.
- Claude/Codex에는 직접 복사하지 않고 symlink로 노출합니다.
- Codex hook은 현재 best-effort입니다. Codex로 스킬 작업을 한 뒤에는 반드시 `skill-health-check --write`를 실행합니다.
- 긴 지침은 `SKILL.md`에 모두 넣지 말고 `references/`로 분리합니다.
- 반복 작업은 `scripts/`로 옮깁니다.

## 더 보기

- [Operations](operations.md)
- [Config snippets](config-snippets.md)
- [Scenario review](../reports/2026-05-27-skill-system-scenario-review.md)
- [Codex live hook observation](../reports/2026-05-27-codex-live-hook-observation.md)
