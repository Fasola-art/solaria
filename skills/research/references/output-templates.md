# Output Templates


## Contents

- [1. Discovery-First Report](#1-discovery-first-report)
- [한줄 결론](#한줄-결론)
- [질문 재정의](#질문-재정의)
- [Discovery Snapshot](#discovery-snapshot)
- [발견된 후보 맵](#발견된-후보-맵)
- [정규화된 모델 구조](#정규화된-모델-구조)
- [근거가 확인된 사례](#근거가-확인된-사례)
- [해석과 시사점](#해석과-시사점)
- [놓치기 쉬운 관점](#놓치기-쉬운-관점)
- [다음 액션](#다음-액션)
- [후속 질문](#후속-질문)
- [출처](#출처)
- [2. Trend -> Candidate -> Monetization Report](#2-trend---candidate---monetization-report)
- [한줄 결론](#한줄-결론)
- [트렌드 신호 스냅샷](#트렌드-신호-스냅샷)
- [발견된 후보](#발견된-후보)
- [정규화된 모델 구조](#정규화된-모델-구조)
- [한국 vs 글로벌 차이](#한국-vs-글로벌-차이)
- [unresolved candidates](#unresolved-candidates)
- [새로 설계한 수익화 방식](#새로-설계한-수익화-방식)
  - [모델 1](#모델-1)
- [먼저 실험할 3가지](#먼저-실험할-3가지)
- [출처](#출처)
- [3. Opportunity Card](#3-opportunity-card)
  - [[모델 이름]](#모델-이름)
- [4. Comparison Add-on](#4-comparison-add-on)
- [5. 깊이 검증](#5-깊이-검증)

기본 출력은 발견 과정과 정규화 과정을 빠르게 파악할 수 있어야 한다. 아래 템플릿을 기본으로 사용한다.

## 1. Discovery-First Report

```markdown
## 한줄 결론

## 질문 재정의
- 조사 대상:
- 범위:
- 목적:
- 성공 기준:

## Discovery Snapshot
- 이번 조사에서 먼저 발견된 표현:
- 로컬/비표준 표현:
- 최신성 창:

## 발견된 후보 맵
| raw term | 정규화 레이블 | 보상 방식 | 모집 구조 | locality | 상태 |
|---|---|---|---|---|---|

## 정규화된 모델 구조
- established models:
- emergent models:
- local-only models:
- unresolved candidates:

## 근거가 확인된 사례
| 모델 | 예시 | 왜 중요한가 | 제약 |
|---|---|---|---|

## 해석과 시사점
- ...

## 놓치기 쉬운 관점
- 반례:
- 숨은 변수:
- 아직 검증 안 된 가정:
- suppression reason이 필요한 후보:

## 다음 액션
- ...

## 후속 질문
- ...

## 출처
- ...
```

## 2. Trend -> Candidate -> Monetization Report

```markdown
## 한줄 결론

## 트렌드 신호 스냅샷
| 트렌드 | 신호 | 최신성 | 강도 |
|---|---|---|---|

## 발견된 후보
| 트렌드 | 후보 | 왜 돈이 되는가 | locality |
|---|---|---|---|

## 정규화된 모델 구조
| 모델 | 누가 돈을 버는가 | 과금 구조 | 진입 조건 |
|---|---|---|---|

## 한국 vs 글로벌 차이
| 항목 | 한국 | 글로벌 |
|---|---|---|

## unresolved candidates
- ...

## 새로 설계한 수익화 방식
### 모델 1
- 구조:
- 근거:
- 필요한 자산:
- 리스크:
- 1주 실험안:

## 먼저 실험할 3가지
1. ...
2. ...
3. ...

## 출처
- ...
```

## 3. Opportunity Card

신규 모델은 아래 카드 형식으로 제시한다.

```markdown
### [모델 이름]
- 유형: established / emergent / local-only / hybrid
- 작동 방식:
- 조사 기반 근거:
- 적합한 사용자/시장:
- 필요한 자산:
- 장점:
- 리스크:
- 1주 MVP 실험:
```

## 4. Comparison Add-on

비교 조사에서는 아래를 추가한다.

- 평가축
- 항목별 차이
- 상황별 추천
- 자주 놓치는 비교 기준
- unresolved comparison questions

## 5. 깊이 검증

기본 보고서를 제출하기 전에 확인한다.

- discovery snapshot이 있는가
- raw term과 normalized model이 분리되어 있는가
- local/emergent/unresolved가 필요한 경우 노출되는가
- `놓치기 쉬운 관점`이 실질적인가
- 필요 시 신규 기회 설계가 포함됐는가
- 최신 주제면 시점이 명시됐는가
