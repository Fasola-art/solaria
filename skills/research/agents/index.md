# Research Multi-Agent System v6.0

`research` 스킬의 모든 에이전트는 discovery-first canonical pipeline을 공유한다. 이 문서는 각 에이전트가 어느 단계의 owner인지, 어떤 객체를 주고받는지, 어떤 깊이에서 활성화되는지를 요약한다.

## Agent Set

- `interviewer`: request intake, question reframing
- `planner`: discovery planning, dynamic taxonomy shaping
- `searcher`: open-world discovery, evidence search, targeted gap search execution
- `deep_reader`: top-source full-content reading
- `analyzer`: candidate normalization, source evaluation, coverage ledger
- `query_refiner`: weak candidate / unresolved candidate refinement query generation
- `synthesizer`: synthesis, opportunity design, self-verify, output routing

## Stage Ownership

| Stage | Primary Owner | Secondary Owner | Core Object |
| --- | --- | --- | --- |
| Request Intake | Interviewer | - | `DiscoveryIntent` |
| Question Reframing | Interviewer | Planner | `DiscoveryIntent.reframed_question` |
| Discovery Planning | Planner | Interviewer | `DiscoveryPlan` |
| Open-World Discovery | Searcher | Planner | `CandidateRecord[]` |
| Candidate Normalization | Analyzer | Searcher | `CandidateGraph` |
| Dynamic Taxonomy | Planner | Analyzer | `DynamicTaxonomy` |
| Evidence Search | Searcher | Deep Reader | candidate-specific evidence |
| Analysis + Coverage Ledger | Analyzer | Deep Reader | `CoverageLedger` |
| Targeted Gap Search | Query Refiner | Searcher | `refined_queries`, weak candidate evidence |
| Synthesis | Synthesizer | Analyzer | `SynthesisResultV6` |
| Opportunity Design | Synthesizer | Planner | `opportunity_models` |
| Self-Verify + Output Routing | Synthesizer | Orchestrator | final report |

## Always-On vs Conditional

### Always-On

- interviewer
- planner
- searcher
- analyzer
- synthesizer

### Conditional by Depth or Need

- `deep_reader`: standard 이상에서 필요 시
- `query_refiner`: deep/full 또는 unresolved candidate가 많을 때
- `searcher.targeted_gap_search`: evidence_weak candidates가 있을 때
- `synthesizer.opportunity_design`: monetization/strategy/opportunity request일 때

## Depth Profiles

### quick

- interviewer: 질문 최소화
- planner: compact `DiscoveryPlan`
- searcher: compact discovery only
- analyzer: 최소 정규화 + 기본 평가
- synthesizer: concise report

### standard

- quick + candidate normalization + dynamic taxonomy 필수
- deep_reader는 필요 시 활성화

### deep

- standard + deep_reader 강화
- query_refiner + targeted gap search 활성화
- synthesizer self-verify 강화

### full

- deep + 더 넓은 후보 fan-out
- coverage ledger 엄격화
- unresolved candidate를 더 보수적으로 유지

## Shared Objects

에이전트 간 통신은 아래 객체를 기준으로 한다.

- `DiscoveryIntent`
- `DiscoveryPlan`
- `CandidateRecord`
- `CandidateGraph`
- `DynamicTaxonomy`
- `CoverageLedger`
- `SynthesisResultV6`

상세 필드는 [../references/canonical-schemas.md](../references/canonical-schemas.md)를 따른다.

## Handoff Rules

- Interviewer는 category list를 만들지 않는다.
- Planner는 `seed_term_sets`와 `discovery_axes` 없이 Searcher를 보내지 않는다.
- Searcher는 category label보다 raw candidate와 evidence를 먼저 넘긴다.
- Deep Reader는 candidate를 바꾸지 않고 evidence density만 보강한다.
- Analyzer는 merge/split/orphan 판정을 기록한다.
- Query Refiner는 약한 후보 보강만 수행한다.
- Synthesizer는 established/emergent/local/unresolved를 섞지 않는다.

## Output Modes

- `standard_report`
- `comparison_report`
- `trend_monetization_report`
- `decision_guide`
- `opportunity_map`
- `strategy_brief`

이 모드들은 `Synthesis` 단계의 표현 방식이지 별도 파이프라인이 아니다.

## Supporting Files

- 공통 규칙: `../orchestrator/orchestrator.md`
- 코어 절차: `../references/core-workflow.md`
- discovery/coverage: `../references/coverage-rules.md`
- current trend: `../references/trend-scan.md`
- output templates: `../references/output-templates.md`
- quality rubric: `../quality/rubric-system.yaml`
