# Research 평가 프레임워크


## Contents

- [평가 프레임워크 개요](#평가-프레임워크-개요)
- [1. 소스 2축 평가 (Gartner 스타일)](#1-소스-2축-평가-gartner-스타일)
  - [1.1 평가 축 정의](#11-평가-축-정의)
  - [1.2 2축 매트릭스](#12-2축-매트릭스)
  - [1.3 사분면별 액션](#13-사분면별-액션)
  - [1.4 소스 신뢰도 상세 기준](#14-소스-신뢰도-상세-기준)
- [2. 결론 성숙도 (BCG 스타일)](#2-결론-성숙도-bcg-스타일)
  - [2.1 4단계 성숙도 정의](#21-4단계-성숙도-정의)
  - [2.2 성숙도 계산 공식](#22-성숙도-계산-공식)
  - [2.3 성숙도 표시 예시](#23-성숙도-표시-예시)
  - [결론 성숙도](#결론-성숙도)
- [3. 가설 검증 (McKinsey MECE)](#3-가설-검증-mckinsey-mece)
  - [3.1 가설 검증 상태](#31-가설-검증-상태)
  - [3.2 MECE 검증 체크리스트](#32-mece-검증-체크리스트)
- [4. 목적별 평가 기준](#4-목적별-평가-기준)
  - [4.1 비즈니스 리서치 평가](#41-비즈니스-리서치-평가)
  - [4.2 제품/서비스 리서치 평가](#42-제품서비스-리서치-평가)
  - [4.3 개인/생활 리서치 평가](#43-개인생활-리서치-평가)
  - [4.4 학술 리서치 평가](#44-학술-리서치-평가)
- [5. 평가 워크플로우](#5-평가-워크플로우)
  - [5.1 소스 평가 프로세스](#51-소스-평가-프로세스)
  - [5.2 결론 성숙도 판정 프로세스](#52-결론-성숙도-판정-프로세스)
- [6. 평가 결과 표시](#6-평가-결과-표시)
  - [6.1 소스 평가 결과 예시](#61-소스-평가-결과-예시)
  - [소스 평가 결과](#소스-평가-결과)
  - [6.2 성숙도 결과 예시](#62-성숙도-결과-예시)
  - [결론 성숙도 평가](#결론-성숙도-평가)
- [7. 도메인별 신뢰도 사전](#7-도메인별-신뢰도-사전)
  - [7.1 주요 도메인 신뢰도](#71-주요-도메인-신뢰도)
- [8. 평가 체크리스트](#8-평가-체크리스트)

> **핵심 방법론**: Gartner 2축 평가 + BCG 성숙도 + MECE 검증

---

## 평가 프레임워크 개요

| 평가 유형 | 방법론 | 적용 대상 | 출력 |
|----------|--------|----------|------|
| **소스 평가** | Gartner 2축 (신뢰도 × 관련성) | 모든 소스 | 사분면 분류 |
| **결론 성숙도** | BCG BFF | 최종 결론 | 4단계 확신도 |
| **가설 검증** | McKinsey MECE | 전략/의사결정 | 검증 상태 |
| **목적별 평가** | 리서치 유형별 | 프리셋별 | 커스텀 메트릭 |

---

## 1. 소스 2축 평가 (Gartner 스타일)

### 1.1 평가 축 정의

```yaml
source_evaluation:
  x_axis: "관련성 (Relevance)"
    definition: "해당 소스가 질문에 얼마나 직접적으로 답변하는가"
    levels:
      5_high: "질문에 직접적이고 완전한 답변"
      4_medium_high: "질문의 핵심 부분에 답변"
      3_medium: "관련 배경 정보 제공"
      2_medium_low: "간접적으로 관련"
      1_low: "매우 간접적 또는 거의 무관"

  y_axis: "신뢰도 (Credibility)"
    definition: "해당 소스의 정보가 얼마나 신뢰할 수 있는가"
    levels:
      5_authoritative: "공식/학술 (peer-reviewed, 정부/기관)"
      4_reliable: "신뢰 매체/전문가 (Reuters, 업계 전문가)"
      3_moderate: "일반 뉴스/블로그 (검증된 매체)"
      2_questionable: "개인 의견/오래된 자료 (2년+)"
      1_unreliable: "출처 불명/검증 불가"
```

### 1.2 2축 매트릭스

```
              ▲ 신뢰도 (높음)
              │
    5 ┌───────┼───────┐
      │ 배경  │ 핵심  │
      │ 참고  │ 인용  │  ← TOP-RIGHT: 핵심 인용 (신뢰도 높고 관련성 높음)
    4 ├───────┼───────┤
      │       │       │
      │       │       │
    3 ├───────┼───────┤
      │ 제외  │ 교차  │
      │ 또는  │ 검증  │  ← BOTTOM-RIGHT: 교차검증 필요
    2 │ 주의  │ 필요  │
      │       │       │
    1 └───────┴───────┘
      1   2   3   4   5 ▶ 관련성 (높음)
```

### 1.3 사분면별 액션

| 사분면 | 위치 | 특징 | 액션 |
|--------|------|------|------|
| **핵심 인용** | 우상단 (신뢰도↑ 관련성↑) | 가장 가치 있는 소스 | 우선 인용, 주요 근거로 사용 |
| **배경 참고** | 좌상단 (신뢰도↑ 관련성↓) | 신뢰할 수 있지만 간접적 | 배경 설명, 컨텍스트 제공용 |
| **교차검증 필요** | 우하단 (신뢰도↓ 관련성↑) | 관련성 높지만 검증 필요 | 다른 소스로 교차검증 후 사용 |
| **제외 또는 주의** | 좌하단 (신뢰도↓ 관련성↓) | 가치 낮음 | 제외하거나 주의 표기 |

### 1.4 소스 신뢰도 상세 기준

```yaml
credibility_criteria:
  5_authoritative:
    examples:
      - "정부/기관 공식 발표 (통계청, WHO, FDA)"
      - "학술 논문 (peer-reviewed journals)"
      - "공식 문서 (법령, 규정, 표준)"
      - "1차 데이터 (설문, 실험, 인터뷰)"
    indicators:
      - "출처가 명확하고 검증 가능"
      - "전문가 검토 프로세스 존재"
      - "데이터 수집 방법론 명시"

  4_reliable:
    examples:
      - "주요 뉴스 매체 (Reuters, AP, NYT, BBC)"
      - "업계 전문가 분석 (Gartner, Forrester)"
      - "기업 공식 발표 (IR 자료, 보도자료)"
      - "인정된 기술 블로그 (Official blogs)"
    indicators:
      - "저자/기관 신원 확인 가능"
      - "팩트체크 프로세스 존재"
      - "과거 정확도 기록 양호"

  3_moderate:
    examples:
      - "일반 뉴스 매체"
      - "업계 분석 블로그 (Medium 인기글)"
      - "커뮤니티 합의 (Reddit 인기글, 다수 의견)"
      - "위키피디아 (검증된 항목)"
    indicators:
      - "출처 일부 확인 가능"
      - "다수 의견과 일치"
      - "최신성 유지 (2년 이내)"

  2_questionable:
    examples:
      - "개인 블로그 (팔로워 적음)"
      - "오래된 자료 (2년 이상)"
      - "소수 의견 (검증 안 됨)"
      - "마케팅 자료 (편향 가능)"
    indicators:
      - "출처 검증 어려움"
      - "업데이트 안 됨"
      - "이해관계 충돌 가능"

  1_unreliable:
    examples:
      - "출처 불명"
      - "익명 게시글"
      - "명백한 오류 포함"
      - "편향성 확인됨"
    indicators:
      - "검증 불가"
      - "다른 소스와 상충"
      - "논리적 오류"
```

---

## 2. 결론 성숙도 (BCG 스타일)

### 2.1 4단계 성숙도 정의

```yaml
conclusion_maturity:
  definitive:
    label: "✅ 확정적 (Definitive)"
    confidence: "90-100%"
    criteria:
      - "신뢰도 4+ 소스 3개 이상"
      - "반박 증거 없음"
      - "독립 소스 간 일치"
    action: "즉시 실행 가능"
    display: "🟢🟢🟢🟢🟢"

  high:
    label: "🟢 높음 (High)"
    confidence: "70-89%"
    criteria:
      - "신뢰도 4+ 소스 2개 이상"
      - "경미한 반박 또는 조건부"
      - "대부분 소스 일치"
    action: "조건부 실행, 모니터링 필요"
    display: "🟢🟢🟢🟢⚪"

  emerging:
    label: "🟡 발전 중 (Emerging)"
    confidence: "40-69%"
    criteria:
      - "신뢰도 3+ 소스 1개 이상"
      - "일부 불확실 또는 상충"
      - "추가 검토 권장"
    action: "추가 조사 후 결정"
    display: "🟢🟢🟢⚪⚪"

  low:
    label: "🔴 낮음 (Low)"
    confidence: "0-39%"
    criteria:
      - "소스 부족"
      - "신뢰도 낮은 소스만 존재"
      - "소스 간 상충"
    action: "추가 조사 필수"
    display: "🟢⚪⚪⚪⚪"
```

### 2.2 성숙도 계산 공식

```yaml
maturity_calculation:
  inputs:
    - source_count: "핵심 인용 사분면 소스 수"
    - avg_credibility: "평균 신뢰도 점수"
    - contradiction_count: "반박 증거 수"
    - cross_verification: "교차검증 통과율"

  formula: |
    기본 점수 = (source_count × avg_credibility × 10) / max_possible
    감점 = contradiction_count × 10
    보너스 = cross_verification × 20
    최종 점수 = min(100, max(0, 기본 점수 - 감점 + 보너스))

  thresholds:
    definitive: "≥ 90"
    high: "70-89"
    emerging: "40-69"
    low: "< 40"
```

### 2.3 성숙도 표시 예시

```markdown
### 결론 성숙도

| 결론 | 성숙도 | 근거 |
|------|--------|------|
| AI 에이전트 시장은 2025년 급성장 예상 | ✅ **확정적** | 신뢰도 5 소스 4개, 반박 0 |
| 클로드가 GPT보다 코딩에 강함 | 🟢 **높음** | 신뢰도 4 소스 3개, 일부 조건부 |
| 오픈소스가 상용 솔루션을 대체함 | 🟡 **발전 중** | 신뢰도 3 소스 2개, 의견 분분 |
| 새로운 프레임워크 X가 대세가 됨 | 🔴 **낮음** | 신뢰도 2 소스 1개, 검증 불가 |
```

---

## 3. 가설 검증 (McKinsey MECE)

### 3.1 가설 검증 상태

```yaml
hypothesis_validation:
  verified:
    label: "✅ 검증됨"
    criteria:
      - "신뢰도 4+ 소스 3개 이상 지지"
      - "반박 증거 없음"
      - "논리적 일관성 확인"
    confidence: "높음"

  partially_verified:
    label: "⚠️ 부분 검증"
    criteria:
      - "지지 증거 존재"
      - "일부 반박 또는 조건부"
      - "특정 상황에서만 유효"
    confidence: "중간"

  rejected:
    label: "❌ 기각"
    criteria:
      - "반박 증거가 지지 증거보다 강함"
      - "신뢰도 높은 소스에서 반박"
      - "논리적 오류 발견"
    confidence: "-"

  unverified:
    label: "❓ 미검증"
    criteria:
      - "충분한 증거 부족"
      - "관련 소스 없음"
      - "검증 불가"
    confidence: "-"
    action: "추가 조사 필요"
```

### 3.2 MECE 검증 체크리스트

```yaml
mece_validation:
  mutually_exclusive:
    check: "각 하위 분류가 겹치지 않는가?"
    examples:
      good: "시장 = 북미 + 유럽 + 아시아 + 기타"
      bad: "시장 = 선진국 + 미국 + 아시아 (미국이 선진국과 중복)"

  collectively_exhaustive:
    check: "모든 가능성이 포함되었는가?"
    examples:
      good: "결제 방식 = 카드 + 현금 + 디지털 + 기타"
      bad: "결제 방식 = 카드 + 현금 (디지털 누락)"

  validation_questions:
    - "각 가설이 독립적인가?"
    - "모든 가능성을 커버하는가?"
    - "동일 계층에서 상호 배타적인가?"
    - "누락된 중요 영역이 있는가?"
```

---

## 4. 목적별 평가 기준

### 4.1 비즈니스 리서치 평가

```yaml
business_evaluation:
  market_research:
    key_metrics:
      - market_size: "시장 규모 (TAM/SAM/SOM)"
      - growth_rate: "성장률 (CAGR)"
      - player_count: "주요 플레이어 수"
      - data_freshness: "데이터 최신성"
    quality_threshold:
      excellent: "TAM+SAM+SOM 모두 확보, CAGR 2개+ 소스"
      good: "TAM 또는 SAM 확보, CAGR 1개 소스"
      acceptable: "시장 규모 추정치만 확보"
      insufficient: "정량 데이터 없음"

  competitive_analysis:
    key_metrics:
      - comparison_dimensions: "비교 차원 수"
      - data_sources: "직접 소스 vs 2차 소스"
      - pricing_accuracy: "가격 정보 정확도"
      - swot_completeness: "SWOT 완성도"
    quality_threshold:
      excellent: "공식 소스 + 5개+ 차원 비교 + SWOT 완성"
      good: "3개+ 차원 비교 + SWOT 부분 완성"
      acceptable: "2개 차원 비교"
      insufficient: "비교 불가"

  due_diligence:
    key_metrics:
      - financial_data: "재무 데이터 확보"
      - risk_identification: "리스크 식별 수"
      - red_team_check: "레드팀 검증 여부"
      - source_diversity: "소스 다양성"
    quality_threshold:
      excellent: "재무 + 법적 + 기술 리스크 모두 식별, 레드팀 검증"
      good: "2개 영역 리스크 식별"
      acceptable: "1개 영역 리스크 식별"
      insufficient: "리스크 미식별"
    special_requirements:
      - "반드시 반대 증거 검색"
      - "리스크 매트릭스 (확률 × 영향) 필수"
```

### 4.2 제품/서비스 리서치 평가

```yaml
product_service_evaluation:
  purchase_decision:
    key_metrics:
      - option_count: "추천 옵션 수"
      - price_accuracy: "가격 정확도"
      - review_sources: "리뷰 소스 다양성"
      - journey_coverage: "Consumer Journey 커버리지"
    quality_threshold:
      excellent: "3개+ 옵션 + 정확한 가격 + 5개+ 리뷰 소스"
      good: "2개+ 옵션 + 대략적 가격"
      acceptable: "1개 옵션 + 가격 범위"
      insufficient: "추천 불가"

  product_review:
    key_metrics:
      - pros_cons_count: "장단점 수"
      - review_aggregation: "리뷰 종합 여부"
      - alternative_count: "대안 제품 수"
    quality_threshold:
      excellent: "5개+ 장단점 + 100개+ 리뷰 종합 + 3개+ 대안"
      good: "3개+ 장단점 + 리뷰 종합"
      acceptable: "장단점 나열"
      insufficient: "리뷰 없음"
```

### 4.3 개인/생활 리서치 평가

```yaml
personal_evaluation:
  health_research:
    key_metrics:
      - authoritative_sources: "권위 있는 소스 수 (NIH, WHO 등)"
      - disclaimer_present: "면책 조항 포함 여부"
      - professional_recommendation: "전문가 상담 권고 여부"
    quality_threshold:
      excellent: "신뢰도 5 소스 2개+ + 면책 조항 + 전문가 권고"
      good: "신뢰도 4+ 소스 + 면책 조항"
      acceptable: "면책 조항 포함"
      insufficient: "면책 조항 없음 (위험)"
    mandatory:
      - "면책 조항 필수"
      - "전문가 상담 권고 필수"
      - "자가 진단/치료 금지 명시"

  finance_research:
    key_metrics:
      - risk_disclosure: "리스크 고지 여부"
      - data_sources: "공식 데이터 소스"
      - disclaimer_present: "투자 면책 조항"
    quality_threshold:
      excellent: "공식 데이터 + 리스크 분석 + 면책 조항"
      good: "리스크 언급 + 면책 조항"
      acceptable: "면책 조항 포함"
      insufficient: "면책 조항 없음 (위험)"
    mandatory:
      - "투자 면책 조항 필수"
      - "과거 수익 ≠ 미래 수익 명시"

  legal_research:
    key_metrics:
      - official_sources: "공식 법령 소스"
      - disclaimer_present: "법률 면책 조항"
      - professional_recommendation: "변호사 상담 권고"
    mandatory:
      - "법률 면책 조항 필수"
      - "전문 변호사 상담 권고 필수"
```

### 4.4 학술 리서치 평가

```yaml
academic_evaluation:
  literature_review:
    key_metrics:
      - prisma_compliance: "PRISMA 준수 여부"
      - search_transparency: "검색 전략 문서화"
      - inclusion_criteria: "포함/배제 기준 명시"
      - study_count: "포함 연구 수"
    quality_threshold:
      excellent: "PRISMA 완전 준수 + 10개+ 연구 + 품질 평가"
      good: "PRISMA 부분 준수 + 5개+ 연구"
      acceptable: "검색 전략 문서화 + 3개+ 연구"
      insufficient: "체계적 검색 없음"
    mandatory:
      - "PRISMA 플로우 다이어그램 필수"
      - "검색 전략 문서화 필수"
      - "포함/배제 기준 명시 필수"

  research_survey:
    key_metrics:
      - source_quality: "피어리뷰 논문 비율"
      - recency: "최신 연구 비율 (2년 이내)"
      - citation_analysis: "인용 분석 여부"
    quality_threshold:
      excellent: "피어리뷰 80%+ + 최신 50%+ + 인용 분석"
      good: "피어리뷰 60%+ + 최신 30%+"
      acceptable: "피어리뷰 40%+"
      insufficient: "피어리뷰 없음"
```

---

## 5. 평가 워크플로우

### 5.1 소스 평가 프로세스

```
┌─────────────────────────────────────────────────────┐
│ 1. 소스 수집                                          │
│    - 검색 결과 수집                                   │
│    - 중복 제거                                        │
└─────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────┐
│ 2. 신뢰도 평가 (Y축)                                   │
│    - 출처 유형 확인                                   │
│    - 저자/기관 신원 확인                              │
│    - 최신성 확인                                      │
│    → 1-5점 부여                                      │
└─────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────┐
│ 3. 관련성 평가 (X축)                                   │
│    - 질문과의 직접성 평가                             │
│    - 핵심 정보 포함 여부                              │
│    → 1-5점 부여                                      │
└─────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────┐
│ 4. 사분면 분류                                        │
│    - 핵심 인용 (우상단)                               │
│    - 배경 참고 (좌상단)                               │
│    - 교차검증 필요 (우하단)                           │
│    - 제외/주의 (좌하단)                               │
└─────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────┐
│ 5. 교차검증 (deep 이상)                               │
│    - 핵심 사실 추출                                   │
│    - 독립 소스에서 확인                               │
│    - 불일치 시 추가 검색                              │
└─────────────────────────────────────────────────────┘
```

### 5.2 결론 성숙도 판정 프로세스

```
┌─────────────────────────────────────────────────────┐
│ 1. 핵심 인용 소스 집계                                │
│    - 신뢰도 4+ 소스 수                               │
│    - 평균 신뢰도                                     │
└─────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────┐
│ 2. 반박 증거 확인                                     │
│    - 반대 의견 검색 (full 깊이)                      │
│    - 반박 소스 신뢰도 평가                           │
└─────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────┐
│ 3. 성숙도 점수 계산                                   │
│    - 기본 점수 계산                                   │
│    - 감점/보너스 적용                                 │
└─────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────┐
│ 4. 성숙도 레벨 판정                                   │
│    - ≥90: 확정적                                     │
│    - 70-89: 높음                                     │
│    - 40-69: 발전 중                                  │
│    - <40: 낮음                                       │
└─────────────────────────────────────────────────────┘
```

---

## 6. 평가 결과 표시

### 6.1 소스 평가 결과 예시

```markdown
### 소스 평가 결과

#### 핵심 인용 (High Credibility + High Relevance)
| # | 소스 | 신뢰도 | 관련성 | 사용 |
|---|------|--------|--------|------|
| 1 | Gartner 2024 Report | ⭐⭐⭐⭐⭐ (5) | ★★★★★ (5) | 주요 근거 |
| 2 | McKinsey Analysis | ⭐⭐⭐⭐⭐ (5) | ★★★★☆ (4) | 주요 근거 |
| 3 | Official Documentation | ⭐⭐⭐⭐⭐ (5) | ★★★★☆ (4) | 기술 상세 |

#### 배경 참고 (High Credibility + Lower Relevance)
| # | 소스 | 신뢰도 | 관련성 | 사용 |
|---|------|--------|--------|------|
| 4 | Academic Paper | ⭐⭐⭐⭐⭐ (5) | ★★☆☆☆ (2) | 배경 설명 |

#### 교차검증 필요 (Lower Credibility + High Relevance)
| # | 소스 | 신뢰도 | 관련성 | 조치 |
|---|------|--------|--------|------|
| 5 | Tech Blog | ⭐⭐⭐☆☆ (3) | ★★★★★ (5) | 검증 후 사용 |

#### 제외 (Low Both)
| # | 소스 | 신뢰도 | 관련성 | 이유 |
|---|------|--------|--------|------|
| 6 | Anonymous Post | ⭐☆☆☆☆ (1) | ★★☆☆☆ (2) | 신뢰도 부족 |
```

### 6.2 성숙도 결과 예시

```markdown
### 결론 성숙도 평가

| 결론 | 지지 소스 | 반박 소스 | 성숙도 | 액션 |
|------|----------|----------|--------|------|
| 결론 1 | 5개 (신뢰도 4.6) | 0개 | ✅ **확정적** (95%) | 즉시 실행 |
| 결론 2 | 3개 (신뢰도 4.0) | 1개 (신뢰도 2) | 🟢 **높음** (78%) | 조건부 실행 |
| 결론 3 | 2개 (신뢰도 3.5) | 2개 (신뢰도 3) | 🟡 **발전 중** (52%) | 추가 조사 |
| 결론 4 | 1개 (신뢰도 2) | 0개 | 🔴 **낮음** (25%) | 추가 조사 필수 |
```

---

## 7. 도메인별 신뢰도 사전

> 상세: `domain-authority.md`

### 7.1 주요 도메인 신뢰도

```yaml
domain_authority:
  tier_1_authoritative:  # 신뢰도 5
    government:
      - "*.gov"
      - "*.go.kr"
      - "who.int"
      - "fda.gov"
    academic:
      - "arxiv.org"
      - "pubmed.ncbi.nlm.nih.gov"
      - "ieee.org"
      - "acm.org"
      - "*.edu"

  tier_2_reliable:  # 신뢰도 4
    news:
      - "reuters.com"
      - "apnews.com"
      - "bbc.com"
      - "nytimes.com"
    research:
      - "gartner.com"
      - "mckinsey.com"
      - "hbr.org"
      - "forrester.com"
    tech_official:
      - "*.official docs"
      - "github.com (official repos)"

  tier_3_moderate:  # 신뢰도 3
    general_news:
      - "techcrunch.com"
      - "theverge.com"
      - "zdnet.com"
    community:
      - "stackoverflow.com"
      - "reddit.com (high-karma posts)"
    encyclopedia:
      - "wikipedia.org"

  tier_4_questionable:  # 신뢰도 2
    blogs:
      - "medium.com (unverified)"
      - "dev.to"
    old_content:
      - "content > 2 years old"

  tier_5_unreliable:  # 신뢰도 1
    - "anonymous sources"
    - "known misinformation sites"
    - "unverifiable claims"
```

---

## 8. 평가 체크리스트

### 8.1 리서치 완료 전 체크리스트

```yaml
pre_completion_checklist:
  source_evaluation:
    - [ ] "핵심 인용 소스 3개 이상 확보"
    - [ ] "평균 신뢰도 3.5 이상"
    - [ ] "교차검증 필요 소스 모두 검증"

  conclusion_maturity:
    - [ ] "모든 주요 결론에 성숙도 라벨 부여"
    - [ ] "낮음 결론에 추가 조사 필요 명시"

  special_requirements:
    health: [ ] "면책 조항 포함"
    finance: [ ] "투자 면책 조항 포함"
    legal: [ ] "법률 면책 조항 포함"
    due_diligence: [ ] "레드팀 검증 완료"
    literature_review: [ ] "PRISMA 플로우 포함"

  depth_specific:
    deep:
      - [ ] "교차검증 완료"
      - [ ] "자기성찰 (standard) 완료"
    full:
      - [ ] "반대 증거 검색 완료"
      - [ ] "자기성찰 (full) 완료"
      - [ ] "불확실성 명시"
```
