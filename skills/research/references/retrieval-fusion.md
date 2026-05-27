# Retrieval Fusion — RRF 2단계 검색


## Contents

- [1. 왜 2단계인가](#1-왜-2단계인가)
- [2. RRF 알고리즘 (1단계)](#2-rrf-알고리즘-1단계)
  - [입력 — v6.0 멀티 출처](#입력-v60-멀티-출처)
  - [출력](#출력)
- [3. dedup (RRF 전후)](#3-dedup-rrf-전후)
- [4. 2단계 Rerank + source 가중치 결합](#4-2단계-rerank-source-가중치-결합)
- [5. 관련성 점수 필터](#5-관련성-점수-필터)
- [6. 비용](#6-비용)
- [7. 적용 흐름](#7-적용-흐름)

> **목적**: 여러 출처·여러 쿼리 변형의 검색 결과를 놓침 없이 병합(recall) → 상위만 정밀 재정렬(precision).
> **사용처**: Searcher의 Evidence Search(1단계 병합) → Analyzer의 Coverage Ledger(2단계 rerank).
> **차용**: Cormack et al. (2009) Reciprocal Rank Fusion. 산업 표준 — RRF는 multi-source recall을 65-78%→91%로 끌어올린다.

---

## 1. 왜 2단계인가

| 단계 | 도구 | 목적 |
|---|---|---|
| 1단계 — Fusion | RRF | 여러 출처를 넓게 병합. **놓침 최소화(recall)** |
| 2단계 — Rerank | LLM 정밀 평가 | 상위 후보만 정밀 재정렬. **정확도(precision)** |

1단계만으로는 의미적 정밀도가 부족하고, 2단계를 전체에 적용하면 비싸다.
RRF로 넓게 모은 뒤 상위 N개만 LLM이 재정렬하는 것이 표준 패턴.

---

## 2. RRF 알고리즘 (1단계)

각 출처에서 결과가 rank 순서로 들어온다. 같은 결과(URL/제목 일치)가 여러 출처에
등장하면 점수를 합산한다.

```
RRF_score(d) = Σ_source  1 / (k + rank_source(d))
```

- `d`: 검색 결과 1건 (URL + 제목 + snippet)
- `rank_source(d)`: 해당 출처에서 d의 순위 (1부터. 미등장이면 합산 제외)
- `k = 60`: Cormack 권장 상수. 낮은 rank의 영향 완화

### 입력 — v6.0 멀티 출처
research v6.0의 검색 출처:
- **WebSearch** — 일반 웹 검색 (쿼리 변형별)
- **무료 API** — arxiv·github·pubmed·law_go_kr·DART·coingecko 등 (`free-api-sources/`)
- **한국 도메인** — Naver Search API + site filter (`free-api-sources/phase1-korea.yaml`)
- **GitHub 검색** — `gh search` (코드·repo 주제)

여러 쿼리 변형 × 여러 출처의 결과를 모두 한 pool에 넣고 RRF를 적용한다.

### 출력
RRF score 내림차순 정렬된 통합 후보 풀. 각 항목에 `sources` 배열(어느 출처들에서
나왔는지)을 기록 — coverage ledger의 axis_hits 추적에 사용.

---

## 3. dedup (RRF 전후)

dedup은 리서치 에이전트 빌드에서 가장 흔히 누락되는 단계이자 1순위 실패 원인 —
같은 내용을 15개 출처가 다루면 보고서에 15번 중복된다.

- **URL dedup (RRF 전)**: scheme·trailing slash·`?utm_*` 파라미터 정규화 후 비교, 첫 등장만 유지.
- **content dedup (RRF 후)**: 상위 N(=20)개에 대해 본문/제목 유사도 비교. 동일 사실
  진술이면 `sources`를 합치고 1건만 유지(출처 다중 표기). 단순 phrasing 차이는 병합,
  추가 맥락·다른 관점이면 유지.
- **site diversity**: 같은 도메인에서 과다 노출 방지 — 상위 결과에 한 사이트 2건 초과 시 가중 감산.

---

## 4. 2단계 Rerank + source 가중치 결합

RRF 후보 풀 상위 N개를 Analyzer가 LLM으로 정밀 재정렬한다. 이때 v6.0
`searcher/config.yaml`의 `source_types` 신뢰도 가중치와 **단일 공식**으로 결합한다 —
두 랭킹을 따로 적용하면 혼선이 생기므로:

```
final_score(d) = RRF_score(d) × source_weight(d)
```

- `source_weight`: official 1.0 / academic 0.95 / authoritative_reports 0.90 /
  news 0.70 / community 0.55 / blogs 0.35 (v6.0 searcher config 값)
- LLM rerank는 이 점수를 출발점으로, 질문 관련성·최신성을 반영해 상위 후보 순서 조정.

---

## 5. 관련성 점수 필터

rerank 단계에서 각 후보를 질문 대비 0-10 관련성 점수로 평가:
- **5 미만**: 후보 풀에서 제외 (단, 제외 사유를 coverage ledger의 `suppressed_candidates`에 기록)
- **7 이상**: 고우선 — synthesis에서 우선 인용

---

## 6. 비용

- RRF·dedup은 순수 알고리즘 — 외부 API·LLM 호출 0.
- 2단계 rerank만 LLM 호출 — 상위 N(=20)개로 제한해 비용 통제.

---

## 7. 적용 흐름

```
쿼리 변형 × 출처(WebSearch·무료 API·한국 도메인·GitHub)
   → URL dedup → RRF 병합 → content dedup        [Searcher: Evidence Search]
   → 상위 N개 LLM rerank (RRF×source_weight) → 관련성 점수 필터   [Analyzer: Coverage Ledger]
   → 정제된 후보 풀 → Synthesis
```
