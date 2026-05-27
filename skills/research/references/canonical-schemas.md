# Canonical Schemas


## Contents

- [DiscoveryIntent](#discoveryintent)
- [DiscoveryPlan](#discoveryplan)
- [CandidateRecord](#candidaterecord)
- [CandidateGraph](#candidategraph)
- [DynamicTaxonomy](#dynamictaxonomy)
- [CoverageLedger](#coverageledger)
- [SourceRecord](#sourcerecord)
- [SynthesisResultV6](#synthesisresultv6)

`research` 스킬의 공통 데이터 계약이다. 상위 문서, 에이전트 config, prompts, protocols는 아래 이름과 필드를 우선 사용한다.

## DiscoveryIntent

```yaml
discovery_intent:
  user_query: "원문 질문"
  reframed_question: "조사 과제로 다시 쓴 문장"
  goal: "학습 / 비교 / 판단 / 기회 탐색 / 전략 / 수익화 등"
  scope: "대상 범위"
  success_criteria: "좋은 답변의 기준"
  exclusions: "제외할 것"
  region: "한국 / 글로벌 / 특정 국가"
  platform: "웹 / 앱 / 블로그 / 마켓 / 채널 등"
  target_user: "타깃 독자/고객/조직"
  assets: "이미 가진 자산"
  constraints: "시간 / 예산 / 규제 / 포맷 제약"
  freshness_needs: "current / recent / stable"
  exhaustiveness_needs: "compact / broad / exhaustive"
  innovation_needs: true
  depth_profile: "quick / standard / deep / full"
  output_mode: "standard_report / comparison_report / trend_monetization_report / decision_guide / opportunity_map / strategy_brief"
  high_risk_domain: false
```

## DiscoveryPlan

```yaml
discovery_plan:
  discovery_profile: "compact / broad / exhaustive / local-market-sensitive"
  seed_term_sets:
    - axis: "language"
      terms: ["체험단", "기자단"]
  discovery_axes:
    - reward_axis
    - recruitment_axis
    - action_axis
    - language_axis
    - policy_axis
    - locality_axis
  locale_bias: "kr-first / global-first / balanced"
  query_families:
    - discovery_queries
    - evidence_queries
    - validation_queries
  normalization_hints:
    merge_if_same_reward_and_action: true
    split_if_same_term_but_different_payout_model: true
  gap_budget:
    weak_candidate_slots: 5
    unresolved_candidate_slots: 3
  research_type_primary: "general_research / competitive_analysis / market_research / trend_research / monetization_research / strategy_research / opportunity_research / decision_research"
  research_type_tags:
    - "monetization_research"
```

## CandidateRecord

```yaml
candidate_record:
  candidate_id: "cand-001"
  raw_term: "체험단"
  normalized_label: "브랜드 체험 리뷰 캠페인"
  term_family: "sponsored_content"
  reward_type: "cash / product / coupon / points / lead / commission / mixed"
  recruitment_type: "brand_direct / agency / platform / community / network"
  action_type: "review / posting / referral / curation / lead_gen / group_buy / service"
  channel_type: "blog / newsletter / marketplace / community / social"
  locality: "kr / global / local-only"
  novelty: "mainstream / emergent / hidden / unresolved"
  evidence_count: 2
  confidence: "high / medium / low"
```

## CandidateGraph

```yaml
candidate_graph:
  synonym_edges:
    - ["체험단", "리뷰단"]
  contains_edges:
    - ["협찬형", "체험단"]
  overlap_edges:
    - ["기자단", "원고료 포스팅"]
  merge_candidates:
    - ["cand-001", "cand-004"]
  split_candidates:
    - ["cand-009"]
  orphans:
    - "cand-015"
```

## DynamicTaxonomy

```yaml
dynamic_taxonomy:
  emergent_categories:
    - name: "캠페인형 수익화"
      members: ["cand-001", "cand-002"]
  subtypes:
    - name: "체험 리뷰형"
      parent: "캠페인형 수익화"
  local_only_models:
    - "cand-003"
  unclassified_candidates:
    - "cand-015"
  derived_views:
    research_map:
      categories: ["캠페인형", "제휴형", "서비스형"]
```

## CoverageLedger

```yaml
coverage_ledger:
  axis_hits:
    reward_axis: ["cash", "product"]
    locality_axis: ["kr", "global"]
  weak_axes:
    - "policy_axis"
  candidate_gaps:
    - "현금형 기자단 근거 부족"
  suppressed_candidates:
    - candidate_id: "cand-022"
      reason: "단발성 중복 표현"
  evidence_weak_candidates:
    - "cand-015"
  freshness_window: "180 days"
```

## SourceRecord

```yaml
source_record:
  source_id: "src-001"
  url: "URL"
  title: "제목"
  snippet: "요약"
  source_type: "official / academic / report / news / community / blog"
  candidate_ids: ["cand-001"]
  pass_tag: "discovery / evidence / gap_validation / deep_read"
  locality: "kr / global / local"
  policy_relevance: true
  credibility: 1
  relevance: 1
  freshness: "fresh / aging / stale / unknown"
  genealogy_group: "독립성 판단용 그룹"
```

## SynthesisResultV6

```yaml
synthesis_result_v6:
  output_mode: "standard_report / comparison_report / trend_monetization_report / decision_guide / opportunity_map / strategy_brief"
  one_line_conclusion: "한줄 결론"
  reframed_question: "질문 재정의"
  discovery_snapshot:
    - "발견된 핵심 표현 / 신호"
  candidate_map:
    - "발견된 후보 구조"
  normalized_model_structure:
    - "정규화된 모델"
  established_models:
    - "잘 알려진 모델"
  emergent_models:
    - "새로 드러난 모델"
  local_only_models:
    - "로컬 전용 모델"
  unresolved_candidates:
    - "근거 약하지만 반복 등장한 후보"
  implications:
    - "시사점"
  opportunity_models:
    - name: "새 모델 이름"
      why_now: "왜 유효한지"
      required_assets: "필요 자산"
      risks: "핵심 리스크"
      experiment: "1주 실험안"
  next_actions:
    - "즉시 이어서 할 일"
  follow_up_questions:
    - "다음 리서치에서 더 파볼 질문"
  sources:
    - "핵심 출처"
```
