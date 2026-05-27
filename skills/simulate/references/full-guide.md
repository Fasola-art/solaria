
## Contents

- [Quick Start](#quick-start)
- [1. 4-Dimension Framework](#1-4-dimension-framework)
  - [Reference 선택 로딩 규칙](#reference-선택-로딩-규칙)
- [2. 적응형 레벨](#2-적응형-레벨)
  - [자동 결정 기준](#자동-결정-기준)
  - [레벨 구조](#레벨-구조)
  - [레벨 결정 규칙](#레벨-결정-규칙)
- [3. Simulate-Develop Loop](#3-simulate-develop-loop)
  - [Auto-Develop 규칙](#auto-develop-규칙)
  - [Level별 라운드](#level별-라운드)
- [4. 컨텍스트 자동 감지](#4-컨텍스트-자동-감지)
- [5. 출력 형식](#5-출력-형식)
  - [Level 1 출력](#level-1-출력)
  - [Level 2 출력](#level-2-출력)
  - [Level 3 출력](#level-3-출력)
- [6. Simulation Modes](#6-simulation-modes)
  - [기본 모드: check (Default)](#기본-모드-check-default)
  - [비교 모드: compare](#비교-모드-compare)
  - [관점 모드: perspective](#관점-모드-perspective)
  - [스트레스 모드: stress](#스트레스-모드-stress)
  - [모드 요약](#모드-요약)
- [7. 병렬 실행 규칙](#7-병렬-실행-규칙)
  - [서브에이전트 프롬프트 템플릿](#서브에이전트-프롬프트-템플릿)
- [8. Target Resolution (시뮬레이션 대상)](#8-target-resolution-시뮬레이션-대상)
- [9. Blue/Red와의 관계](#9-bluered와의-관계)
- [10. Related Skills](#10-related-skills)
- [11. 설정](#11-설정)
- [12. 디자인 어댑터 (frontend-stack 6 Case 사전 검증)](#12-디자인-어댑터-frontend-stack-6-case-사전-검증)
  - [트리거](#트리거)
  - [4-Dimension 매핑](#4-dimension-매핑)

---
name: simulate
description: >
  Simulate-Develop 통합 스킬. 플랜/전략/아이디어를 4-Dimension 프레임워크로
  시뮬레이션하고, 빈틈 발견 시 자동 보강 후 재검증.
  플랜 모드, 직접 호출, 어떤 컨텍스트에서든 사용 가능.
version: "1.0.0"
trigger: "/simulate"
aliases: ["/sim", "/시뮬"]
---

# Simulate - Adaptive Plan Simulation

## Quick Start

- `/simulate` : 현재 플랜/전략을 4-Dim 체크 (기본)
- `/simulate deep` : 강제 Level 3 (Deep) 시뮬레이션
- `/simulate quick` : 강제 Level 1 (Quick) 시뮬레이션
- `/simulate compare` : A안 vs B안 병렬 비교
- `/simulate perspective` : 다중 관점(CEO/개발자/사용자) 병렬 평가
- `/simulate stress` : 극한 조건 강건성 테스트
- `/simulate --context=marketing` : 컨텍스트 지정
- `/simulate skip` 또는 `--no-sim` : 시뮬레이션 스킵

---

## 1. 4-Dimension Framework

모든 컨텍스트에 공통 적용되는 4가지 축:

| Dim | 이름 | 질문 |
|-----|------|------|
| [F] Feasibility | 실현성 | 실현 가능한가? (자원, 시간, 역량) |
| [D] Dependencies | 전제조건 | 뭐가 갖춰져야 하는가? |
| [R] Risk | 리스크 | 뭐가 잘못될 수 있는가? (확률 x 영향) |
| [I] Impact | 결과예측 | 결과가 어떨 것인가? (Best/Expected/Worst) |

컨텍스트별 구체적 체크 항목: `references/context-lens.md` 참조

### Reference 선택 로딩 규칙

모든 reference를 한 번에 로드하지 않는다. 모드별로 필요한 것만 로드:

| Mode | 로드 대상 |
|------|-----------|
| check | `context-lens.md`에서 감지된 컨텍스트 1개 섹션만 |
| compare | `context-lens.md` (감지 컨텍스트 섹션) + `config.yaml` (모드 설정) |
| perspective | `perspectives.md`만 (context-lens 불필요) |
| stress | `config.yaml`의 stress_factors만 |

---

## 2. 적응형 레벨

### 자동 결정 기준

- 플랜의 복잡도 (단계 수, 범위)
- 컨텍스트 (개발/마케팅/비즈니스/...)
- 요청의 모호함 정도

### 레벨 구조

| Level | 이름 | Dimension | 자동보강 | 추가 분석 |
|-------|------|-----------|---------|-----------|
| 0 | Skip | - | - | - |
| 1 | Quick | F, D | X (목록만) | - |
| 2 | Standard | F, D, R, I | O (1라운드) | 3-Scenario |
| 3 | Deep | F, D, R, I | O (2라운드) | Pre-Mortem, 핵심가정, 롤백 |

### 레벨 결정 규칙

단계 카운팅 기준: 플랜 내 번호가 매겨진 항목(Phase, Step, 단계) 또는 체크리스트 항목 수를 기준으로 한다. 중첩된 하위 항목은 카운트하지 않는다.

```yaml
base_level:
  단순한 계획 (3단계 이하): 0-1
  보통 계획 (4-7단계): 2
  복잡한 계획 (8단계+): 3

context_minimum:
  rebuilding/migration: 최소 Level 3
  project_planning: 최소 Level 2
  나머지: 제한 없음

boosters:
  반복되는 문제: +1
  매우 모호한 요청: +1

override:
  "/simulate deep": 강제 Level 3
  "/simulate quick": 강제 Level 1
```

---

## 3. Simulate-Develop Loop

핵심: 시뮬레이션이 빈틈 발견 -> 자동 보강 -> 재검증

```
대상(플랜/전략/아이디어)
        |
   Sim Round 1 (4-Dimension 체크)
        |
   빈틈 있는가?
   |           |
   No          Yes (Level 2+만)
   |           |
   |      Auto-Develop
   |      (FAIL -> 단계 추가/재설계)
   |      (WARN -> 대안/대응 추가)
   |           |
   |      Sim Round 2 (보강 부분만 재검증)
   |           |
   최종 결과 + 개선 내역 제시
        |
   사용자 확인 (AskUserQuestion)
   |     |      |       |
  진행  상세   수정    스킵
```

### Auto-Develop 규칙

| 판정 | 자동 보강 액션 |
|------|---------------|
| [FAIL] Feasibility | 해당 단계를 현실적으로 재설계 (규모 축소, 기술 대안, 단계 분할) |
| [FAIL] Dependencies | 누락된 전제조건을 "사전 준비 단계(Phase 0)"로 플랜 앞에 추가 |
| [FAIL] Risk | 해당 리스크의 회피 전략 수립 + 플랜에 리스크 대응 단계 삽입 |
| [WARN] Feasibility | 대안/우회 방안을 주석으로 추가 (실행 시 선택 가능) |
| [WARN] Dependencies | 병렬 준비 가능한 항목은 기존 단계와 병렬로 배치 |
| [WARN] Risk | 리스크 대응 방안(contingency plan)을 해당 단계에 추가 |
| [WARN] Impact | Worst 시나리오 대비 손절/피봇 기준선 추가 |
| [OK] 전부 | 보강 없음, 바로 최종 |

### Level별 라운드

- Level 1: 1라운드 (체크만, 보강 안 함)
- Level 2: 1~2라운드 (빈틈 시 보강 -> 재검증)
- Level 3: 1~2라운드 + Pre-Mortem/핵심가정/롤백

---

## 4. 컨텍스트 자동 감지

플랜/전략의 내용을 분석하여 13개 컨텍스트 중 자동 매칭:

```
development | marketing | business | creator | ecommerce |
education | event | freelance | agency | consulting |
community | operations | product
```

감지 불가 시 사용자에게 질문, 또는 `--context=xxx`로 직접 지정.

구체적 체크 항목: `references/context-lens.md`에서 로드.

---

## 5. 출력 형식

모든 레벨에서 출력 첫 줄에 **1줄 요약**을 포함한다:
`[SIM SUMMARY] {VERDICT} - {핵심 이슈 또는 "이슈 없음"}`

### Level 1 출력

```
[SIM SUMMARY] 조건부 진행 - 소재 준비 필요
[SIM] Level 1: QUICK | Context: {CONTEXT}

[F] Feasibility
  [OK/WARN/FAIL] 항목별 판정 + 이유 1줄

[D] Dependencies
  [OK/WARN/FAIL] 항목별 판정 + 이유 1줄

[VERDICT] 진행 / 조건부 진행 / 재설계
[ACTION] 필요한 조치 요약
```

### Level 2 출력

```
[SIM] Level 2: STANDARD | Context: {CONTEXT}
Rounds: {라운드 수} (초안 -> 보강 -> 재검증)

[IMPROVED] 시뮬레이션으로 개선된 항목:
  + 추가/변경된 내용 목록

[F] Feasibility: OK/WARN/FAIL (통과/전체)
[D] Dependencies: OK/WARN/FAIL (통과/전체)
[R] Risk: LOW/MEDIUM/HIGH
  1. 리스크명 (확률: 고/중/저, 영향: 고/중/저)
     -> 대응 방안
[I] Impact
  Best: 최선 시나리오
  Expected: 예상 시나리오
  Worst: 최악 시나리오

[VERDICT] 진행 / 조건부 진행 / 재설계
```

### Level 3 출력

```
[SIM] Level 3: DEEP | Context: {CONTEXT}
Rounds: {라운드 수} (초안 -> 보강 -> 재검증)

[IMPROVED]
  + 추가/변경된 내용 목록

[F] Feasibility: OK/WARN/FAIL (보강 후)
[D] Dependencies: OK/WARN/FAIL (보강 후)
[R] Risk: LOW/MEDIUM/MEDIUM-HIGH/HIGH
  1. 리스크명 (확률, 영향)
     -> 대응 방안
[I] Impact
  Best: 최선 시나리오
  Expected: 예상 시나리오
  Worst: 최악 시나리오

[PM] Pre-Mortem
  1. "실패 시나리오 서술"
     -> 예방 조치

[ASSUMPTIONS]
  1. 핵심 가정
     -> 검증 방법

[ROLLBACK]
  Phase N 실패 -> 대안/피봇 전략

[VERDICT] 진행 / 조건부 진행 / 재설계
[ACTION]
  1. 우선 조치 사항
  2. ...
```

---

## 6. Simulation Modes

### 기본 모드: check (Default)

기존 4-Dimension 체크 + Auto-Develop. 단일 플랜 검증.

```
/simulate            -> check 모드 (기본)
/simulate check      -> 명시적 check 모드
```

check 모드는 서브에이전트 없이 메인 에이전트가 직접 수행.
Level 2+ Auto-Develop 시 보강 내용도 메인이 직접 처리.

### 비교 모드: compare

2~3개 안을 병렬 시뮬 후 비교 분석.

```
/simulate compare    -> A안 vs B안 (또는 플랜에서 여러 안 감지)
```

실행 구조:

```
/simulate compare
      |
  +---+---+
  Task(A) Task(B)        <- 병렬 서브에이전트
  4-Dim   4-Dim
  +---+---+
      |
  비교 매트릭스 생성
  |  A안  |  B안  |
  |-------|-------|
  | [F] OK | [F] WARN |
  | [R] LOW | [R] HIGH |
  | ...    | ...      |
  -> 추천: A안 (이유: ...)
```

compare fallback:
- 플랜에 명시적 A안/B안이 있는 경우: 자동으로 각 안 분리 -> 병렬 시뮬
- 단일 플랜만 있는 경우: AskUserQuestion으로 비교 대안 요청

복수 안 감지 키워드: "안 1"/"안 2", "Option A"/"Option B", "대안:", "A안/B안", "vs", "또는", "방법 1"/"방법 2". 이 키워드가 있으면 자동 분리 시도.

### 관점 모드: perspective

다중 이해관계자 관점에서 동일 플랜을 병렬 평가.

```
/simulate perspective              -> 자동 관점 선택
/simulate perspective ceo,dev,user -> 관점 지정
```

미리 정의된 관점:

| 관점 | 초점 | 평가 기준 |
|------|------|-----------|
| CEO/대표 | ROI, 시장성, 성장 | 수익, 경쟁우위, 확장성 |
| 개발자/실행자 | 기술 난이도, 유지보수 | 구현 가능성, 코드 품질, 기술부채 |
| 사용자/고객 | UX, 가치, 편의성 | 사용성, 가치 체감, 전환 의향 |
| 재무/투자자 | 비용, 수익성, 위험 | 손익분기, 현금흐름, 투자 회수 |
| 마케터 | 소구점, 채널, 메시지 | 차별화, 타겟 적합성, 바이럴성 |
| 운영자 | 프로세스, 확장, 유지 | 운영 비용, 자동화, 장애 대응 |

관점별 상세 기준: `references/perspectives.md` 참조

실행 구조:

```
/simulate perspective
      |
  +---+---+
 Task  Task  Task        <- 병렬 서브에이전트
 CEO   Dev   User
  +---+---+
      |
  관점별 평가 종합
  | 관점 | 판정 | 핵심 의견 |
  |------|------|-----------|
  | CEO  | OK   | ROI 매력적 |
  | Dev  | WARN | 기술 난이도 높음 |
  | User | OK   | UX 직관적 |
  -> 종합: 조건부 진행 (기술 난이도 완화 필요)
```

컨텍스트별 기본 관점은 `config.yaml`의 `perspective_auto_select` 참조.

### 스트레스 모드: stress

극한 조건에서 플랜의 강건성(robustness) 테스트.

```
/simulate stress             -> 자동 스트레스 요인 선택
/simulate stress budget=50%  -> 예산 50%로 제한
```

스트레스 요인:

| 요인 | 설명 |
|------|------|
| 시간 50% | 일정이 절반으로 줄었을 때 |
| 예산 50% | 예산이 절반으로 줄었을 때 |
| 인력 -30% | 핵심 인력이 빠졌을 때 |
| 경쟁 가속 | 경쟁사가 먼저 출시했을 때 |
| 수요 부진 | 예상 수요의 30%만 실현됐을 때 |

실행 구조:

```
/simulate stress
      |
  +---+---+
 Task  Task  Task          <- 병렬 서브에이전트
 시간50 예산50 수요30%
  +---+---+
      |
  스트레스 내성 보고서
  | 요인 | 생존? | 핵심 조치 |
  |------|-------|-----------|
  | 시간50% | X | MVP 축소 필요 |
  | 예산50% | O | 채널 1개로 집중 |
  | 수요30% | O | 손익분기점 조정 |
  -> 취약점: 일정 압박에 가장 취약
  -> 강점: 예산/수요 변동에는 강건
```

컨텍스트별 기본 스트레스 요인은 `config.yaml`의 `stress_auto_select` 참조.

### 모드 요약

| Mode | 명령어 | 병렬 에이전트 | 출력 |
|------|--------|-------------|------|
| check | `/simulate` | 1 (메인 직접) | 4-Dim 체크 + 보강 |
| compare | `/simulate compare` | 2~3 (안별) | 비교 매트릭스 + 추천 |
| perspective | `/simulate perspective` | 3~4 (관점별) | 관점별 평가 + 종합 |
| stress | `/simulate stress` | 3~5 (요인별) | 내성 보고서 + 취약점 |

---

## 7. 병렬 실행 규칙

```yaml
parallel_execution:
  tool: Task                          # 서브에이전트 도구
  subagent_type: general-purpose      # 범용 에이전트
  max_concurrent: 5                   # 최대 동시 실행
  each_agent_receives:
    - 원본 플랜/전략 전문
    - 해당 모드의 시뮬레이션 관점/조건
    - 출력 형식 템플릿
  aggregation: main agent             # 메인 에이전트가 결과 종합
```

### 서브에이전트 프롬프트 템플릿

#### compare 모드

```
당신은 플랜 시뮬레이터입니다. 아래 플랜을 4-Dimension 프레임워크로 평가하세요.

[플랜 내용]
{plan_content}

[컨텍스트]
{context_name} - 아래 체크 항목을 사용하세요:
{context_lens_items}

[평가 지침]
각 Dimension에 대해:
- [OK]: 문제 없음 (이유 1줄)
- [WARN]: 주의 필요 (이유 + 대안)
- [FAIL]: 심각한 문제 (이유 + 보강 제안)

[출력 형식]
[F] Feasibility: [OK/WARN/FAIL] - 요약
  항목별 상세...
[D] Dependencies: [OK/WARN/FAIL] - 요약
  항목별 상세...
[R] Risk: [OK/WARN/FAIL] - 요약 (확률 x 영향)
  항목별 상세...
[I] Impact: Best / Expected / Worst
  항목별 상세...
[VERDICT]: 진행 / 조건부 진행 / 재설계
```

#### perspective 모드

```
당신은 {perspective_label}의 관점에서 아래 플랜을 평가합니다.

[플랜 내용]
{plan_content}

[당신의 관점]
- 역할: {perspective_label}
- 초점: {perspective_focus}
- 평가 기준: perspectives.md에서 로드한 기준

[평가 지침]
1. 당신의 관점에서 가장 중요한 3가지 포인트를 평가
2. 각 포인트에 [OK/WARN/FAIL] 판정
3. 최종 한 줄 의견

[출력 형식]
[{perspective_key}] {perspective_label} 평가

1. {기준1}: [OK/WARN/FAIL] - 이유
2. {기준2}: [OK/WARN/FAIL] - 이유
3. {기준3}: [OK/WARN/FAIL] - 이유

[VERDICT]: [OK/WARN/FAIL]
[OPINION]: 핵심 의견 1-2줄
```

#### stress 모드

```
당신은 스트레스 테스터입니다. 아래 플랜이 극한 조건에서 생존 가능한지 평가하세요.

[플랜 내용]
{plan_content}

[스트레스 조건]
{stress_factor_label}: {stress_factor_condition}

[평가 지침]
1. 이 조건에서 플랜의 각 단계가 실행 가능한지 체크
2. 붕괴 지점(breaking point) 식별
3. 생존 전략 제안

[출력 형식]
[STRESS] {stress_factor_label}

생존 여부: O/X
붕괴 지점: {어느 단계에서 실패하는가}
핵심 조치: {생존하려면 무엇을 바꿔야 하는가}
상세:
  - 단계 1: [OK/FAIL] - 이유
  - 단계 2: [OK/FAIL] - 이유
  ...
```

---

## 8. Target Resolution (시뮬레이션 대상)

시뮬레이션은 "대상"이 있어야 동작. 대상을 찾는 규칙:

```yaml
target_resolution:
  # 1순위: plan-mode에서 자동 호출 시
  plan_mode:
    - 현재 플랜 파일 경로: .Codex/plans/*.md (가장 최근 수정)
    - 플랜 파일 전체 내용을 시뮬레이션 대상으로 사용

  # 2순위: /simulate 직접 호출 시
  direct_call:
    - 직전 대화에서 제시된 플랜/전략/아이디어가 있으면 그것을 대상으로
    - 없으면 AskUserQuestion으로 대상 요청:
      "시뮬레이션할 대상을 알려주세요."
      options: ["현재 플랜 파일", "직접 입력", "파일 경로 지정"]

  # 3순위: 인자로 파일 경로 전달
  file_path:
    - /simulate path/to/plan.md -> 해당 파일을 대상으로
```

---

## 9. Blue/Red와의 관계

| | Blue/Red | Simulate |
|--|---------|----------|
| 시점 | 플랜 작성 중 | 플랜 완성 후 (독립 호출도 가능) |
| 질문 | 강점/약점은? | 실행하면 어떻게 되는가? |
| 범위 | 전략적 판단 | 전술적 실행 검증 |
| 액션 | 분석만 | 분석 + 자동 보강 |

Simulate는 Blue/Red 결과를 참조할 수 있지만 의존하지 않음.
독립 호출 시에도 자체적으로 4-Dimension 분석 수행.

---

## 10. Related Skills

| Skill | 관계 |
|-------|------|
| `red-blue-verification` | 전략적 분석. Simulate는 전술적 보완 |
| `plan-mode` | 자동 연동. 인터뷰 -> 플랜 -> /simulate |
| `research` | 시뮬레이션 중 시장/기술 데이터 필요 시 활용 |
| `ideation` | 아이디어 발상 후 /simulate compare로 비교 |

---

## 11. 설정

상세 설정은 `config.yaml` 참조:
- 레벨 구조, 모드별 병렬 에이전트 수
- perspective 자동 선택 (컨텍스트별 기본 관점 3개)
- stress 자동 선택 (컨텍스트별 기본 스트레스 요인 3개)
- 스킵 키워드, 판정 옵션, 출력 스타일

---

## 12. 디자인 어댑터 (frontend-stack 6 Case 사전 검증)

**SSOT**: `~/.Codex/rules/design-marketing-integration.md` § 10

### 트리거
- frontend-stack S1(Direction) 완료 시 자동 호출
- 명시 호출: `/simulate design [case]`

### 4-Dimension 매핑
| Dimension | 디자인 검증 항목 |
|-----------|-----------------|
| **Reality** | 아키타입 채택 근거의 시장 레퍼런스 존재 여부, 경쟁사 DNA 충돌 |
| **Ripple** | PMC 변경 → Copy/CRO/Motion/Brand Gate로의 전파 범위 |
| **Robustness** | WCAG 2.2 AA 대비 / BrandVoice 일관성 / 라이선스 커버리지 |
| **Adaptability** | Dark 모드·반응형·다국어·prefers-reduced-motion 호환성 |

### 차단 조건 (FAIL)
- Reality: 아키타입 레퍼런스 0개 또는 경쟁사와 90% 유사
- Ripple: Copy/CRO 영향 평가 미실시
- Robustness: 토큰 색상 대비 AA 미달 1개 이상 OR 금지 어휘 검출
- Adaptability: prefers-reduced-motion 폴백 미정의

### 위임
- content-quality-ops — Robustness 축 실질 검증
- marketing-context-sync — PMC 최신성 확인
- worker(haiku) — 레퍼런스 수집 / 토큰 대비 계산
