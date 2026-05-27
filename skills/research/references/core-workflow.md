# Core Workflow


## Contents

- [1. 질문 재정의](#1-질문-재정의)
- [2. 짧은 인터뷰](#2-짧은-인터뷰)
- [3. Discovery Planning](#3-discovery-planning)
- [4. Open-World Discovery](#4-open-world-discovery)
- [5. Candidate Normalization](#5-candidate-normalization)
- [6. Dynamic Taxonomy](#6-dynamic-taxonomy)
- [7. Evidence Search](#7-evidence-search)
- [8. Analysis + Coverage Ledger](#8-analysis-coverage-ledger)
- [9. Targeted Gap Search](#9-targeted-gap-search)
- [10. Synthesis](#10-synthesis)
- [11. Opportunity Design](#11-opportunity-design)
- [12. Trend-Sensitive Discovery](#12-trend-sensitive-discovery)

이 문서는 `research` 스킬의 discovery-first 플레이북이다. 기본 경로는 `질문 재정의 -> discovery planning -> open-world discovery -> candidate normalization -> dynamic taxonomy -> evidence search -> analysis + coverage ledger -> synthesis -> opportunity design`이다.

## 1. 질문 재정의

아래 5개 항목으로 먼저 다시 쓴다.

- 조사 대상
- 범위
- 목적
- 성공 기준
- 제외 범위

질문이 넓을수록 검색부터 하지 말고 재정의부터 한다.

## 2. 짧은 인터뷰

질문은 아래 상황에서만 한다.

- 지역이나 플랫폼이 결과를 크게 바꿈
- 사용자의 자산이나 목표가 결론을 바꿈
- `최대한 많이`와 `현실적으로 가능한 것` 중 무엇이 목표인지 모름
- local-only 결과가 중요한지 확인이 필요함

답이 없어도 시작 가능한 경우에는 질문 없이 진행한다.

## 3. Discovery Planning

검색 전에 최소한 아래를 만든다.

- seed term sets
- discovery axes
- locale bias
- query families
- normalization hints
- gap budget

예: `블로그 수익화`

- language seeds: 체험단, 기자단, 쿠팡 파트너스, 원고료 포스팅, 협찬 포스팅
- reward axis: 현금, 제품, 쿠폰, 포인트, 수수료, 리드
- recruitment axis: 브랜드 직접, 대행사, 플랫폼 모집, 커뮤니티 모집
- action axis: 리뷰 작성, 포스팅, 공동구매 연결, 리드 유입

예: `현재 트렌드`

- signal seeds: 출시, 채택, 투자, 사용 패턴, 정책 변화
- trend axes: 기술 변화, 소비자 행동 변화, 플랫폼 변화, 유통/결제 변화, 정책/규제 변화

## 4. Open-World Discovery

이 단계의 목표는 카테고리가 아니라 후보를 찾는 것이다.

반드시 아래를 수집한다.

- 시장에서 실제 쓰는 표현
- 커뮤니티/업계 표현
- 보상 구조
- 모집 구조
- 실제 행위 단위
- 로컬 전용 표현

핵심 규칙:

- 처음에는 분류하지 않는다
- 애매하면 `raw_term` 그대로 남긴다
- 반복 등장하면 약한 후보라도 버리지 않는다

## 5. Candidate Normalization

이 단계에서 아래를 판단한다.

- 표현만 다른 동일 후보인가
- 하나처럼 보이지만 수익 흐름이 다른가
- 상위/하위 관계인가
- 아직 분류할 수 없는가

출력은 `CandidateGraph`와 `unclassified_candidates`다.

## 6. Dynamic Taxonomy

이 단계에서 taxonomy를 동적으로 만든다.

- `emergent_categories`
- `subtypes`
- `local_only_models`
- `unclassified_candidates`
- `derived research_map`

핵심은 미리 정해진 대분류에 끼워 넣는 것이 아니라, 발견된 후보를 보고 구조를 뒤늦게 만드는 것이다.

## 7. Evidence Search

정규화된 후보마다 최소 아래를 찾는다.

- 정의와 작동 방식
- 대표 사례
- 근거 데이터 또는 관찰
- 적용 조건
- 한계와 리스크
- 플랫폼/정책 제약

## 8. Analysis + Coverage Ledger

아래를 함께 본다.

- 어떤 axis에서 실제로 후보가 나왔는가
- 어떤 후보가 근거가 약한가
- 어떤 후보가 suppression 대상인가
- unresolved 상태인 후보가 있는가
- 최신성 검증이 더 필요한가

## 9. Targeted Gap Search

다음 경우에만 수행한다.

- evidence weak candidates 보강
- unresolved candidates 검증
- policy / locality / reward axis 중 비어 있는 축 보강
- 최신성 재검증

## 10. Synthesis

최종 결과는 아래를 중심으로 정리한다.

- 한줄 결론
- 질문 재정의
- discovery snapshot
- candidate map
- normalized model structure
- established / emergent / local / unresolved models
- 해석과 시사점
- 다음 액션과 후속 질문

`놓치기 쉬운 관점`은 `unresolved candidates`와 별도로 유지한다.

## 11. Opportunity Design

수익화/사업/전략/제품 주제에서는 조사 결과를 기반으로 신규 모델을 설계한다.

규칙:

- 발견된 후보 2개 이상을 조합해 새 모델을 만든다
- 사용자 자산이나 시장 특성을 반영한다
- 왜 유효한지 근거를 적는다
- 필요한 자산과 리스크를 같이 적는다
- 1주 안에 실험 가능한 형태로 줄인다

## 12. Trend-Sensitive Discovery

`현재`, `최신`, `요즘`, `트렌드` 요청이면 아래를 추가한다.

1. 최근 3-6개월 자료를 우선 수집
2. 유사 신호를 trend cluster로 묶기
3. 각 cluster에서 candidate를 뽑기
4. 한국과 글로벌 실행 차이를 분리하기
5. 아직 덜 일반화된 후보까지 남기기
