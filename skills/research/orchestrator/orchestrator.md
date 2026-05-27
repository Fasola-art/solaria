# Research Orchestrator v6.0

이 문서는 `research` 스킬의 단일 SSOT다. 상위 `SKILL.md`, `agents/index.md`, 각 에이전트 `config.yaml`, `prompts.md`, `protocols/*.yaml`은 이 문서와 같은 단계 이름, 같은 데이터 계약, 같은 depth profile을 사용해야 한다.

## 설계 목표

- 모든 조사 요청을 discovery-first 단일 파이프라인으로 처리한다
- `deep/full`을 별도 시스템이 아니라 같은 파이프라인의 강화 모드로 다룬다
- `trend scan`을 별도 카테고리 수집이 아니라 discovery 모드로 흡수한다
- `coverage expansion`을 후행 보강이 아니라 discovery와 analysis 전반에 녹인다
- `ResearchMap`을 진입 객체가 아니라 `DynamicTaxonomy`의 파생 뷰로 강등한다

## Canonical Pipeline

```text
Request Intake
  -> Question Reframing
  -> Discovery Planning
  -> Open-World Discovery
  -> Candidate Normalization
  -> Dynamic Taxonomy
  -> Evidence Search
  -> Analysis + Coverage Ledger
  -> Targeted Gap Search
  -> Synthesis
  -> Opportunity Design
  -> Self-Verify + Output Routing
  -> Wiki Ingest
```

## Stage Map

| Stage | 기본 여부 | 주 담당 | 산출물 |
| --- | --- | --- | --- |
| Request Intake | 항상 | Interviewer | `DiscoveryIntent` |
| Question Reframing | 항상 | Interviewer | 재정의된 조사 과제 |
| Discovery Planning | 항상 | Planner | `DiscoveryPlan` |
| Open-World Discovery | 항상 | Searcher | `CandidateRecord[]`, 초기 `CoverageLedger` |
| Candidate Normalization | 항상 | Analyzer | `CandidateGraph`, 병합/분리 판단 |
| Dynamic Taxonomy | 항상 | Planner + Analyzer | `DynamicTaxonomy` |
| Evidence Search | 항상 | Searcher | 후보별 근거 소스 |
| Analysis + Coverage Ledger | 항상 | Analyzer | `evaluated_sources`, `CoverageLedger` |
| Targeted Gap Search | 조건부 | Query Refiner + Searcher | `refined_queries`, 약한 후보 보강 |
| Synthesis | 항상 | Synthesizer | `SynthesisResultV6` |
| Opportunity Design | 조건부 | Synthesizer | opportunity models |
| Self-Verify + Output Routing | 항상 | Synthesizer + Orchestrator | 최종 검증, output mode |
| Wiki Ingest | 항상 | Orchestrator | `wiki/syntheses/<topic-slug>.md` 신설·`auto_update_crossref`·`auto_validate_ontology` |

## Stage Contracts

### 1. Request Intake

추출 항목:

- 원문 질문
- 이미 명시된 범위, 지역, 플랫폼, 타깃
- 최신성 요구 여부
- 완전성 요구 여부
- 신규 아이디어 요구 여부
- 깊이 신호

산출물은 초기 `DiscoveryIntent`다.

### 2. Question Reframing

모든 조사 요청은 검색 전에 아래 형태로 다시 쓴다.

- 조사 대상
- 범위
- 목적
- 성공 기준
- 제외할 것

### 3. Discovery Planning

Planner는 `DiscoveryPlan`을 필수 산출물로 만든다.

`DiscoveryPlan` 최소 필드:

- `seed_term_sets`
- `discovery_axes`
- `locale_bias`
- `query_families`
- `normalization_hints`
- `gap_budget`
- `research_type_primary`
- `research_type_tags`

### 4. Open-World Discovery

목표는 카테고리를 찾는 것이 아니라 후보를 찾는 것이다.

- 로컬 표현 수집
- 커뮤니티 표현 수집
- 보상 구조 수집
- 모집 구조 수집
- 실제 행위 단위 수집
- trend request에서는 최신 신호 수집

여기서는 카테고리에 끼워 넣지 않는다.

### 5. Candidate Normalization

Analyzer는 아래를 수행한다.

- 표현만 다른 동일 후보 병합
- 하나처럼 보이지만 다른 수익 흐름이면 분리
- `unclassified_candidates` 생성
- `merge_candidates`, `split_candidates` 판단

### 6. Dynamic Taxonomy

Planner와 Analyzer는 정규화된 후보를 보고 taxonomy를 동적으로 만든다.

- `emergent_categories`
- `subtypes`
- `local_only_models`
- `unclassified_candidates`
- `orphans`

`ResearchMap`이 필요하다면 이 taxonomy를 보고 나중에 렌더링한다.

### 7. Evidence Search

후보별로 아래를 조사한다.

- 정의와 작동 방식
- 대표 사례
- 근거 데이터 또는 관찰
- 적용 조건
- 한계와 리스크
- 플랫폼/정책 제약

### 8. Analysis + Coverage Ledger

Analyzer는 아래를 함께 평가한다.

- credibility
- relevance
- freshness
- independence
- candidate evidence sufficiency
- discovery axis coverage
- suppression 여부

출력은 `evaluated_sources`와 `CoverageLedger`다.

### 9. Targeted Gap Search

Query Refiner는 아래를 입력으로 받는다.

- `CoverageLedger.weak_axes`
- `CoverageLedger.evidence_weak_candidates`
- `DynamicTaxonomy.unclassified_candidates`
- 최신성 검증 필요 후보

목표는 카테고리 보강이 아니라 약한 후보와 미해결 후보를 정확히 메우는 것이다.

### 10. Synthesis

Synthesizer는 기본적으로 아래 순서를 지킨다.

1. direct answer
2. question reframing
3. discovery snapshot
4. candidate map
5. normalized model structure
6. local/emergent/hidden models
7. unresolved candidates
8. implications
9. next actions
10. follow-up questions
11. sources

### 11. Opportunity Design

조건:

- 사용자가 새 방법/아이디어/기회를 요청함
- 수익화/사업/전략/제품 설계 주제
- 기존 모델 정리만으로는 답이 부족함

규칙:

- 후보와 패턴의 재조합만 허용
- 필요한 자산, 리스크, 실행 난이도, 1주 실험안을 같이 낸다
- established models와 emergent models를 분리한다

### 12. Self-Verify + Output Routing

마지막 검증 항목:

- 질문에 직접 답했는가
- discovery-first 순서가 지켜졌는가
- unresolved candidates가 숨겨지지 않았는가
- exhaustive 요청에서 suppressed candidates가 기록됐는가
- high-risk domain disclaimer가 들어갔는가
- chosen output mode가 질문과 맞는가

## Depth Profiles

### quick

- compact discovery
- 후보 수집 폭 제한
- targeted gap search 기본 비활성화

### standard

- 기본 모드
- discovery + normalization + dynamic taxonomy 필수

### deep

- standard + deep reading 강화 + targeted gap search 적극화 + self-verify 강화

### full

- deep + 더 넓은 후보 탐색 폭 + 더 엄격한 coverage ledger + 더 긴 evidence chain

## Search Execution Policy

검색 품질(recall)은 이 스킬의 핵심이다. 모든 에이전트는 아래를 지킨다.

### Effort Scaling

작업 복잡도에 맞춰 검색 노력을 배분한다(과소·과대 모두 비효율).

- 단순 사실 조회: 도구 호출 3-10회
- 직접 비교 / 다면 조사: 도구 호출 10-15회
- 완전성 요청(`최대한 많이`·`빠짐없이`) / `deep`·`full`: 더 넓게, depth profile에 따라

### Multi-Source + Fusion

- 한 쿼리를 한 출처에만 던지지 않는다 — WebSearch + 무료 API + 한국 도메인 + GitHub 병행.
- 무료 API는 `agents/searcher/config.yaml`의 `free_api.domain_mapping`을 따른다.
- 여러 출처·여러 쿼리 변형 결과는 RRF로 병합·dedup한다 — [references/retrieval-fusion.md](../references/retrieval-fusion.md).

### 검색 루프

검색은 단발이 아니다. 검색 → 읽기 → 앎 갱신 → 더 나은 질문으로 재검색을 반복한다.
재검색 트리거·cap은 Query Refiner가 관리한다(quick 0 / standard 1 / deep 2 / full 3).

### Source Quality

- SEO 최적화된 저품질 글보다 학술 PDF·공식 문서·1차 출처를 우선한다.
- 한국어 쿼리는 영어 키워드 직역을 금지한다 — 한국어 자연 표현을 만든다.

## Canonical Data Contracts

기준 정의는 [references/canonical-schemas.md](../references/canonical-schemas.md)에 둔다. 핵심 객체는 아래 여섯 개다.

- `DiscoveryIntent`
- `DiscoveryPlan`
- `CandidateRecord`
- `CandidateGraph`
- `DynamicTaxonomy`
- `CoverageLedger`
- `SynthesisResultV6`

## Agent Routing

- Interviewer: Intake, Reframing
- Planner: Discovery Planning, Dynamic Taxonomy shaping
- Searcher: Open-World Discovery, Evidence Search, Targeted Gap Search execution
- Deep Reader: high-value source reading
- Analyzer: Candidate Normalization, Evidence Evaluation, Coverage Ledger
- Query Refiner: weak candidate / unresolved candidate refinement
- Synthesizer: Synthesis, Opportunity Design, Self-Verify, Output Routing

## Legacy Compatibility Mapping

기존 개념은 아래처럼 흡수한다.

- `trend scan` -> `Open-World Discovery.mode = trend-sensitive`
- `coverage expansion` -> `DiscoveryPlan.discovery_axes` + `CoverageLedger`
- `ResearchMap` -> `DynamicTaxonomy` derived view
- `SearchPlan` -> `DiscoveryPlan`
- `Action Layer` -> `output_mode`
- `Follow-through` -> `next_actions`, `follow_up_questions`

## Failure Handling

- source scarcity: 부분 결론 + unresolved candidates 명시
- stale evidence: 최신성 부족 경고 + 재확인 필요 후보 표시
- low discovery coverage: `CoverageLedger.weak_axes` 명시
- conflicting evidence: 양측 제시 + candidate confidence 하향
- high-risk domain: 면책 + 전문가 상담 권고

## Load Order

1. `SKILL.md`
2. `references/canonical-schemas.md`
3. `agents/index.md`
4. 필요한 `references/*`
5. 필요한 에이전트 `config.yaml`
6. 필요한 에이전트 `prompts.md`
7. 필요한 `protocols/*.yaml`
