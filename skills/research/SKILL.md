---
name: research
description: "범용 조사/딥리서치 스킬 v6.0. 질문을 조사 과제로 재정의한 뒤, 카테고리를 먼저 고정하지 않고 open-world discovery로 실제 시장 표현, 로컬 용어, 보상 구조, 모집 구조를 수집한다. 이후 candidate normalization, dynamic taxonomy, evidence search, coverage ledger, opportunity design으로 구조화한다. 현재 트렌드, 한국+글로벌 조사, 숨은 사례, 비표준 수익화, 신규 기회 모델 탐색이 필요할 때 사용. `/research` 또는 `ds` 호출, '조사해줘', '알아봐', '트렌드', '수익화 방법', '최대한 많이' 요청에 사용."
context_requires:
  must: []
  optional:
    - references/core-workflow.md
    - references/canonical-schemas.md
    - references/output-templates.md
---

# Research Skill v6.0

이 스킬의 기준 문서는 `orchestrator/orchestrator.md`다. 상위 문서, 에이전트 역할, config, prompts, protocol은 모두 같은 discovery-first 용어를 사용해야 한다.

핵심 원칙은 간단하다.

- 분류보다 발견을 먼저 한다
- 카테고리가 아니라 후보를 먼저 모은다
- 로컬 용어와 비표준 표현을 버리지 않는다
- 나중에 taxonomy를 동적으로 만든다
- `놓치기 쉬운 관점`뿐 아니라 `아직 분류되지 않은 후보`도 결과에 남긴다
- 수익화/사업/전략 주제에서는 조사 기반 기회 모델까지 설계한다

## 언제 사용하는가

다음 요청이면 기본적으로 이 스킬을 사용한다.

- 어떤 주제를 체계적으로 조사하고 정리해야 할 때
- `최대한 많이`, `빠짐없이`, `모든 방식`, `사례까지`처럼 완전성이 중요할 때
- `현재`, `최신`, `요즘`, `트렌드`, `뜨는`처럼 시점 민감한 조사가 필요할 때
- 수익화, 기회 탐색, 전략, 비교, 시장, 기술, 구매 판단처럼 구조화가 필요한 질문일 때
- 기존 사례 정리와 신규 아이디어 설계를 같이 해야 할 때
- 카테고리에 없는 로컬/비표준 항목까지 찾아야 할 때

조사 결과를 PM 산출물(고객 페르소나·TAM/SAM/SOM·경쟁 배틀카드·고객 여정지도)로 정형화해야 하면, research가 수집을 마친 뒤 `jarvis-pm`으로 핸드오프한다 — research는 수집 SSOT, jarvis-pm은 후처리(정형화) 담당.

구조화 데이터(상품 가격·검색어 트렌드 지수·지원사업/공모전 공고 목록)나 정기 수집·모니터링이 필요하면, research가 직접 스크래핑하지 말고 `jarvis-scrape`의 CLI 스크립트를 `Bash`로 실행한다 — 예: `python3 ~/.claude/skills/jarvis-scrape/lib/item_research.py "<아이템>"`. research는 1회성 조사·종합, jarvis-scrape는 구조화 데이터 수집·소스 adapter의 SSOT다 (research가 데이터 소스를 다시 구현하지 않는다).

## Canonical Pipeline

모든 깊이는 아래 단일 파이프라인 위에서 동작한다.

1. Request Intake
2. Question Reframing
3. Discovery Planning
4. Open-World Discovery
5. Candidate Normalization
6. Dynamic Taxonomy
7. Evidence Search
8. Analysis + Coverage Ledger
9. Targeted Gap Search
10. Synthesis
11. Opportunity Design
12. Self-Verify + Output Routing
13. Wiki Ingest

`deep/full`은 다른 시스템이 아니라, 같은 파이프라인에서 후보 탐색 폭과 증거 검증 강도를 높인 depth profile이다.

## 단계별 기본 동작

### 1. Request Intake

원문 질문, 범위, 지역, 플랫폼, 타깃, 최신성/완전성/신규 아이디어 요구 여부를 먼저 정리한다.

### 2. Question Reframing

검색 전에 질문을 조사 과제로 다시 쓴다.

- 조사 대상
- 범위
- 목적
- 성공 기준
- 제외할 것

### 3. Discovery Planning

카테고리를 만들기 전에 아래를 설계한다.

- seed term sets
- discovery axes
- locale bias
- query families
- normalization hints
- gap budget

상세는 [references/core-workflow.md](references/core-workflow.md)를 본다.

### 4. Open-World Discovery

먼저 시장에서 실제 쓰는 표현과 패턴을 넓게 모은다.

- 로컬 용어
- 업계 표현
- 커뮤니티 표현
- 보상 구조
- 모집 구조
- 실제 행위 단위

이 단계에서는 카테고리에 끼워 넣지 않는다.

### 5. Candidate Normalization

표현이 다른 유사 항목을 묶고, 하나처럼 보이지만 수익 흐름이 다른 항목은 분리한다.

### 6. Dynamic Taxonomy

정규화된 후보를 바탕으로 taxonomy를 동적으로 만든다. `ResearchMap`은 이 단계의 파생 산출물로만 취급한다.

### 7. Evidence Search

후보별로 아래를 조사한다.

- 정의와 작동 방식
- 대표 사례
- 근거 데이터 또는 관찰
- 적용 조건
- 한계와 리스크
- 플랫폼/정책 제약

### 8. Analysis + Coverage Ledger

신뢰도, 관련성, 최신성, 독립성뿐 아니라 아래를 함께 본다.

- 어떤 discovery axis에서 무엇을 찾았는가
- 어떤 후보가 근거 약한가
- 어떤 후보가 unresolved 상태인가
- 어떤 후보를 suppress했는가

### 9. Targeted Gap Search

갭 검색은 카테고리 보강이 아니라 아래를 메우기 위해 사용한다.

- 근거가 약한 후보
- 중복 여부가 불명확한 후보
- 로컬/비표준인데 반복 등장한 후보
- 최신성 검증이 필요한 후보

### 10. Synthesis

기본 결과물은 다음을 포함한다.

- 한줄 결론
- 질문 재정의
- discovery snapshot
- 발견된 후보 맵
- 정규화된 모델 구조
- 로컬/비표준/숨은 방식
- 근거가 약하지만 반복 등장한 후보
- 해석과 시사점
- 다음 액션과 후속 질문
- 출처

템플릿은 [references/output-templates.md](references/output-templates.md)를 본다.

### 11. Opportunity Design

수익화/사업/전략/제품 주제에서는 조사된 후보와 패턴을 재조합해 새 모델을 만든다. 상상이 아니라 근거 기반 합성만 허용한다.

### 12. Self-Verify + Output Routing

아래를 마지막에 점검한다.

- 질문에 직접 답했는가
- discovery-first 흐름이 실제로 적용됐는가
- unresolved candidates가 숨겨지지 않았는가
- exhaustive 요청에서 candidate suppression이 명시됐는가
- high-risk disclaimer가 필요한가
- output mode가 질문과 맞는가

### 13. Wiki Ingest

조사 종료 직후 결과를 wiki에 자동 저장한다. 외부 hook 없이 SKILL 본문이 SSOT — research 호출 후 자비스가 본 stage를 그대로 실행한다.

**자동 동작**:
- 산출물 → `~/workspace/wiki/syntheses/<topic-slug>.md` 신설 (frontmatter `type: Synthesis`·`source: research-<topic-slug>`·`created`·`updated`·`coverage` 자동 계산·`aliases` 등록)
- 인용 URL → `~/workspace/wiki/raw/links.md` append (중복 grep skip)
- 후속 발동: `auto_update_crossref` (양방향 link)·`auto_validate_ontology` (6단계 검증)·`wiki/log.md` 1줄 append

**idempotent**: 동일 topic-slug + 동일 날짜 매치 시 skip (frontmatter `source` 비교). 동일 주제 재리서치는 `auto_check_existing_research`(§wiki-auto.md §3-3) 사전 알림 처리.

**스킵 조건**:
- `@wiki off` 활성 세션
- 사용자 발화에 "이번엔 wiki 저장 안 함" 또는 명시 거부
- 결과가 추측 위주·source 0건 (`coverage: low` + sources 0)

**세부 정책**: `~/.claude/rules/wiki-auto.md` §3-1 `auto_ingest_wiki` 트리거 (c) "/research 종료 시" + §13-6 "매번 자동" 정합.

## Depth Profiles

- `quick`: discovery planning + compact discovery + concise synthesis
- `standard`: 기본 경로. candidate normalization과 dynamic taxonomy까지 수행
- `deep`: 표준 경로 + deep reading 강화 + targeted gap search 적극화 + self-verify 강화
- `full`: deep의 모든 단계 + 더 넓은 후보 탐색 폭 + 더 엄격한 coverage ledger

## 참조 파일 로딩 가이드

- 기준 파이프라인: `orchestrator/orchestrator.md`
- 공통 스키마: [references/canonical-schemas.md](references/canonical-schemas.md)
- 코어 절차: [references/core-workflow.md](references/core-workflow.md)
- 인터뷰 규칙: [references/interview-patterns.md](references/interview-patterns.md)
- discovery/coverage 정책: [references/coverage-rules.md](references/coverage-rules.md)
- current trend 규칙: [references/trend-scan.md](references/trend-scan.md)
- 출력 형식: [references/output-templates.md](references/output-templates.md)
- 도메인 프리셋: [references/presets.md](references/presets.md), [references/domain-presets.md](references/domain-presets.md)
- 검색 융합(RRF 2단계): [references/retrieval-fusion.md](references/retrieval-fusion.md)
- 무료 API·한국어 source: [references/free-api-sources.yaml](references/free-api-sources.yaml) + `references/free-api-sources/`
- 심층 경로: [references/advanced-orchestration.md](references/advanced-orchestration.md), `agents/index.md`

## 간단한 호출 예시

```yaml
/research 현재 트렌드를 조사해서 수익화 방법을 찾아줘
ds 블로그 수익화 찾아줘
ds 블로그 수익화 방법을 최대한 많이 조사해줘
ds compare Cursor vs Windsurf
ds deep AI 코딩 도구 시장 진입 가능성
ds full 생성형 AI 기반 PDF 도구 수익화 모델
```

## 품질 기준

- 질문을 조사 과제로 재정의했는가
- 카테고리보다 후보 수집이 먼저 수행됐는가
- `최대한 많이` 요청에서 concrete examples와 local variants가 포함됐는가
- `현재 트렌드` 요청에서 최신성 창이 명시됐는가
- `놓치기 쉬운 관점`과 `unresolved candidates`가 모두 실질적인가
- 신규 아이디어가 조사된 패턴에 근거하는가
- `deep/full`에서 gap search와 self-verify가 수행됐는가

## 주의사항

- 의료/법률/투자/암호화폐는 기존 면책 규칙을 유지한다
- 최신성이 중요한 요청은 반드시 현재 자료를 확인한다
- 비교 리서치는 감상보다 평가축과 근거를 우선한다
- 수익화 아이디어는 상상이 아니라 구조적 재조합이어야 한다
- 같은 개념을 서로 다른 이름으로 중복 정의하지 않는다
