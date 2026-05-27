# Research 주제별 프리셋 (22가지 유형)


## Contents

- [프리셋 개요](#프리셋-개요)
- [🏢 비즈니스 리서치 (Business)](#비즈니스-리서치-business)
  - [1. market_research (시장 조사)](#1-market_research-시장-조사)
  - [2. competitive_analysis (경쟁 분석)](#2-competitive_analysis-경쟁-분석)
  - [3. due_diligence (실사)](#3-due_diligence-실사)
  - [4. technology_research (기술 조사)](#4-technology_research-기술-조사)
  - [5. strategic_research (전략 리서치)](#5-strategic_research-전략-리서치)
  - [6. trend_analysis (트렌드 분석)](#6-trend_analysis-트렌드-분석)
  - [7. policy_analysis (정책 분석)](#7-policy_analysis-정책-분석)
  - [8. vendor_selection (벤더 선정)](#8-vendor_selection-벤더-선정)
- [🛒 제품/서비스 리서치 (Product & Service)](#제품서비스-리서치-product-service)
  - [9. purchase_decision (구매 결정)](#9-purchase_decision-구매-결정)
  - [10. product_review (제품 리뷰)](#10-product_review-제품-리뷰)
  - [11. service_comparison (서비스 비교)](#11-service_comparison-서비스-비교)
  - [12. user_research (사용자 리서치)](#12-user_research-사용자-리서치)
  - [13. price_analysis (가격 분석)](#13-price_analysis-가격-분석)
- [👤 개인/생활 리서치 (Personal & Life)](#개인생활-리서치-personal-life)
  - [14. health_research (건강 리서치)](#14-health_research-건강-리서치)
  - [15. travel_research (여행 리서치)](#15-travel_research-여행-리서치)
  - [16. education_research (교육 리서치)](#16-education_research-교육-리서치)
  - [17. career_research (커리어 리서치)](#17-career_research-커리어-리서치)
  - [18. finance_research (금융 리서치)](#18-finance_research-금융-리서치)
  - [19. real_estate (부동산)](#19-real_estate-부동산)
  - [20. legal_research (법률 리서치)](#20-legal_research-법률-리서치)
- [📚 학술 리서치 (Academic)](#학술-리서치-academic)
  - [21. literature_review (문헌 리뷰)](#21-literature_review-문헌-리뷰)
  - [22. research_survey (연구 동향)](#22-research_survey-연구-동향)
- [프리셋 자동 선택 로직](#프리셋-자동-선택-로직)
- [사용 예시](#사용-예시)

> **4대 분류**: 비즈니스(8) | 제품/서비스(5) | 개인/생활(7) | 학술(2)

---

## 프리셋 개요

| 분류 | 유형 | 키워드 | 깊이 | 형식 |
|------|------|--------|------|------|
| 🏢 비즈니스 | Market Research | `ds market` | deep | market_report |
| 🏢 비즈니스 | Competitive Analysis | `ds compare` | deep | quadrant |
| 🏢 비즈니스 | Due Diligence | `ds dd` | full | risk_report |
| 🏢 비즈니스 | Technology Research | `ds tech` | standard | report |
| 🏢 비즈니스 | Strategic Research | `ds strategy` | deep | hypothesis |
| 🏢 비즈니스 | Trend Analysis | `ds trend` | deep | hype_cycle |
| 🏢 비즈니스 | Policy Analysis | `ds policy` | deep | report |
| 🏢 비즈니스 | Vendor Selection | `ds vendor` | deep | quadrant |
| 🛒 제품/서비스 | Purchase Decision | `ds buy` | standard | buying_guide |
| 🛒 제품/서비스 | Product Review | `ds review` | standard | summary |
| 🛒 제품/서비스 | Service Comparison | `ds service` | standard | comparison |
| 🛒 제품/서비스 | User Research | `ds user` | deep | report |
| 🛒 제품/서비스 | Price Analysis | `ds price` | quick | comparison |
| 👤 개인/생활 | Health Research | `ds health` | standard | summary |
| 👤 개인/생활 | Travel Research | `ds travel` | standard | summary |
| 👤 개인/생활 | Education Research | `ds edu` | standard | summary |
| 👤 개인/생활 | Career Research | `ds career` | standard | summary |
| 👤 개인/생활 | Finance Research | `ds finance` | deep | report |
| 👤 개인/생활 | Real Estate | `ds realestate` | deep | report |
| 👤 개인/생활 | Legal Research | `ds legal` | deep | summary |
| 📚 학술 | Literature Review | `ds lit` | full | prisma |
| 📚 학술 | Research Survey | `ds academic` | deep | report |

---

## 🏢 비즈니스 리서치 (Business)

### 1. market_research (시장 조사)

```yaml
name: market_research
category: business
trigger_keyword: "ds market"

triggers:
  - "시장"
  - "동향"
  - "트렌드"
  - "규모"
  - "성장률"
  - "CAGR"
  - "TAM"
  - "SAM"
  - "SOM"

defaults:
  depth: deep
  format: market_report
  breadth: 8
  max_react_cycles: 4

methodology: "Gartner 정량분석"

focus_areas:
  - 시장 규모 (TAM/SAM/SOM)
  - 성장률 (CAGR)
  - 주요 플레이어 및 점유율
  - 시장 동인 및 저해 요인
  - 세그먼트 분석
  - 미래 전망

search_queries:
  - "[주제] market size [year]"
  - "[주제] market growth CAGR"
  - "[주제] industry trends [year]"
  - "[주제] market forecast"
  - "[주제] key players market share"
  - "[주제] TAM SAM SOM"

sources_priority:
  high:
    - Statista
    - Gartner
    - IDC
    - Grand View Research
    - 업계 리포트
  medium:
    - Bloomberg
    - Reuters
    - 증권사 리포트
  low:
    - 뉴스 기사
    - 블로그 분석

output_sections:
  - 시장 개요
  - 규모 및 성장률 (TAM/SAM/SOM)
  - 주요 플레이어
  - 트렌드 분석
  - 미래 전망
  - 기회 및 위협

metrics:
  - market_size_usd: "시장 규모 (USD)"
  - cagr_percent: "연평균 성장률 (%)"
  - top_players: "상위 플레이어 목록"
  - market_share: "시장 점유율"
```

---

### 2. competitive_analysis (경쟁 분석)

```yaml
name: competitive_analysis
category: business
trigger_keyword: "ds compare"

triggers:
  - "경쟁사"
  - "비교"
  - "vs"
  - "대"
  - "차이"
  - "장단점"
  - "포지셔닝"

defaults:
  depth: deep
  format: quadrant  # Magic Quadrant
  breadth: 6
  max_react_cycles: 4

methodology: "Gartner Magic Quadrant, SWOT"

focus_areas:
  - 제품/서비스 비교
  - 가격 전략
  - 시장 점유율
  - 차별화 포인트
  - 강점/약점
  - 실행 능력 vs 비전

search_queries:
  - "[A] vs [B] comparison"
  - "[A] vs [B] features"
  - "[A] pricing vs [B]"
  - "[A] review vs [B] review"
  - "[A] pros cons vs [B]"
  - "[A] [B] market position"
  - "Gartner [A] [B]"

sources_priority:
  high:
    - 공식 웹사이트
    - G2, Capterra (소프트웨어)
    - Gartner/Forrester 리포트
  medium:
    - 전문 리뷰 사이트
    - Reddit 비교 글
  low:
    - YouTube 비교 영상
    - 블로그 비교

output_sections:
  - Magic Quadrant 시각화
  - SWOT 분석
  - 상세 항목별 비교
  - 가격 비교
  - 장단점 정리
  - 상황별 추천

evaluation_axes:
  x_axis: "비전 완성도"
  y_axis: "실행 능력"
```

---

### 3. due_diligence (실사)

```yaml
name: due_diligence
category: business
trigger_keyword: "ds dd"

triggers:
  - "투자"
  - "M&A"
  - "실사"
  - "인수"
  - "펀딩"
  - "시리즈"
  - "밸류에이션"

defaults:
  depth: full
  format: risk_report
  breadth: 10
  max_react_cycles: 5

methodology: "BCG/Bain Due Diligence"

special_requirements:
  - "레드팀 검증 필수"
  - "반대 증거 명시적 검색"
  - "리스크 정량화"

focus_areas:
  - 재무 상태
  - 법적 리스크
  - 경영진 평가
  - 시장 포지션
  - 기술 자산
  - 고객/매출 집중도
  - 경쟁 환경
  - 규제 리스크

search_queries:
  - "[회사명] financial statements"
  - "[회사명] lawsuits legal issues"
  - "[회사명] founder CEO background"
  - "[회사명] customer reviews complaints"
  - "[회사명] competitors market"
  - "[회사명] funding valuation"
  - "[회사명] SEC filings"
  - "[회사명] glassdoor reviews"

sources_priority:
  high:
    - SEC Filings (EDGAR)
    - 회사 재무제표
    - 법원 기록
    - 특허 데이터베이스
  medium:
    - Crunchbase, PitchBook
    - LinkedIn
    - Glassdoor
  low:
    - 뉴스 기사
    - 소셜 미디어

output_sections:
  - 회사 개요
  - 재무 분석
  - 리스크 매트릭스 (확률×영향)
  - 경영진 평가
  - 시장 포지션
  - 레드 플래그
  - 기회 요인
  - 종합 평가

risk_matrix:
  probability: [낮음, 중간, 높음]
  impact: [낮음, 중간, 높음, 치명적]
```

---

### 4. technology_research (기술 조사)

```yaml
name: technology_research
category: business
trigger_keyword: "ds tech"

triggers:
  - "기술"
  - "아키텍처"
  - "스택"
  - "프레임워크"
  - "라이브러리"
  - "구현"

defaults:
  depth: standard
  format: report
  breadth: 5
  max_react_cycles: 2

methodology: "Gartner Hype Cycle"

focus_areas:
  - 기술 개요
  - 작동 원리
  - 장단점
  - 사용 사례
  - 성숙도 위치
  - 모범 사례

search_queries:
  - "[기술] how it works"
  - "[기술] architecture"
  - "[기술] best practices [year]"
  - "[기술] pros cons"
  - "[기술] use cases"
  - "github [기술] examples"
  - "Gartner hype cycle [기술]"

sources_priority:
  high:
    - 공식 문서
    - GitHub
    - Gartner Hype Cycle
  medium:
    - Stack Overflow
    - 기술 블로그 (Medium, Dev.to)
  low:
    - 개인 블로그
    - 튜토리얼

output_sections:
  - 기술 개요
  - Hype Cycle 위치
  - 작동 원리
  - 장단점
  - 사용 사례
  - 예제/코드
  - 대안 기술
```

---

### 5. strategic_research (전략 리서치)

```yaml
name: strategic_research
category: business
trigger_keyword: "ds strategy"

triggers:
  - "전략"
  - "의사결정"
  - "방향"
  - "신사업"
  - "진출"
  - "확장"

defaults:
  depth: deep
  format: hypothesis  # Hypothesis Tree
  breadth: 7
  max_react_cycles: 4

methodology: "McKinsey MECE, Hypothesis-driven"

focus_areas:
  - 가설 수립 및 검증
  - MECE 분해
  - 선택지 평가
  - 리스크 분석
  - 실행 로드맵

search_queries:
  - "[주제] strategy analysis"
  - "[주제] SWOT analysis"
  - "[주제] market entry strategy"
  - "[주제] competitive strategy"
  - "[주제] case study"
  - "McKinsey [주제]"
  - "BCG [주제]"

sources_priority:
  high:
    - McKinsey Insights
    - BCG Henderson Institute
    - Harvard Business Review
  medium:
    - 업계 리포트
    - 케이스 스터디
  low:
    - 뉴스 분석
    - 블로그

output_sections:
  - 상황 분석
  - MECE 분해
  - 가설 트리 (Hypothesis Tree)
  - 가설별 검증 결과
  - 전략 옵션
  - 추천 및 로드맵

hypothesis_format:
  structure: "트리형"
  validation_levels: [검증됨, 부분검증, 기각, 미검증]
```

---

### 6. trend_analysis (트렌드 분석)

```yaml
name: trend_analysis
category: business
trigger_keyword: "ds trend"

triggers:
  - "트렌드"
  - "미래"
  - "예측"
  - "전망"
  - "변화"
  - "신기술"

defaults:
  depth: deep
  format: hype_cycle
  breadth: 7
  max_react_cycles: 4

methodology: "Gartner Hype Cycle, 시나리오 플래닝"

focus_areas:
  - 현재 트렌드
  - 성숙도 단계
  - 시나리오 분석
  - 타임라인 예측
  - 영향 평가

search_queries:
  - "[주제] trends [year]"
  - "[주제] future predictions"
  - "Gartner hype cycle [주제]"
  - "[주제] emerging technologies"
  - "[주제] industry outlook"

sources_priority:
  high:
    - Gartner
    - Forrester
    - McKinsey Global Institute
  medium:
    - 업계 전문가 예측
    - 학술 연구
  low:
    - 뉴스 전망
    - 블로그 예측

output_sections:
  - 트렌드 개요
  - Hype Cycle 시각화
  - 성숙도별 분류
  - 시나리오 분석 (낙관/기본/비관)
  - 타임라인
  - 액션 아이템
```

---

### 7. policy_analysis (정책 분석)

```yaml
name: policy_analysis
category: business
trigger_keyword: "ds policy"

triggers:
  - "정책"
  - "규제"
  - "법안"
  - "규정"
  - "컴플라이언스"
  - "정부"

defaults:
  depth: deep
  format: report
  breadth: 6
  max_react_cycles: 4

methodology: "정책 프레임워크 분석"

focus_areas:
  - 현행 규제
  - 정책 동향
  - 영향 분석
  - 컴플라이언스 요건
  - 향후 전망

search_queries:
  - "[주제] regulation [year]"
  - "[주제] policy changes"
  - "[주제] compliance requirements"
  - "[주제] government regulation"
  - "[주제] legal framework"

sources_priority:
  high:
    - 정부 공식 문서
    - 법령 데이터베이스
    - 규제 기관 발표
  medium:
    - 법무법인 분석
    - 업계 협회
  low:
    - 뉴스 해설
    - 전문가 의견

output_sections:
  - 정책 개요
  - 현행 규제 요약
  - 최근 변화
  - 영향 분석
  - 컴플라이언스 체크리스트
  - 향후 전망
```

---

### 8. vendor_selection (벤더 선정)

```yaml
name: vendor_selection
category: business
trigger_keyword: "ds vendor"

triggers:
  - "공급업체"
  - "벤더"
  - "RFP"
  - "파트너"
  - "솔루션"
  - "도입"

defaults:
  depth: deep
  format: quadrant  # Vendor Scorecard
  breadth: 6
  max_react_cycles: 4

methodology: "Gartner Critical Capabilities"

focus_areas:
  - 기능 비교
  - 가격/TCO
  - 지원/서비스
  - 확장성
  - 통합 용이성
  - 레퍼런스

search_queries:
  - "[솔루션] vendors comparison"
  - "[솔루션] Gartner Magic Quadrant"
  - "[솔루션] pricing"
  - "[솔루션] reviews G2 Capterra"
  - "[솔루션] case studies"

sources_priority:
  high:
    - G2, Capterra
    - Gartner/Forrester
    - 공식 가격표
  medium:
    - 사용자 리뷰
    - 케이스 스터디
  low:
    - 블로그 리뷰
    - 포럼 토론

output_sections:
  - 벤더 개요
  - Magic Quadrant 포지션
  - 기능 비교 매트릭스
  - 가격/TCO 비교
  - 장단점 요약
  - 상황별 추천
  - 최종 스코어카드
```

---

## 🛒 제품/서비스 리서치 (Product & Service)

### 9. purchase_decision (구매 결정)

```yaml
name: purchase_decision
category: product_service
trigger_keyword: "ds buy"

triggers:
  - "살까"
  - "구매"
  - "추천"
  - "어떤 게 좋아"
  - "뭐 사야"
  - "사도 될까"

defaults:
  depth: standard
  format: buying_guide
  breadth: 5
  max_react_cycles: 2

methodology: "McKinsey Consumer Decision Journey"

special_requirements:
  - "Consumer Journey 5단계 적용"
  - "예산 고려"
  - "사용 목적 파악"

focus_areas:
  - 제품 카테고리 이해
  - 주요 고려 사항
  - 예산별 추천
  - 사용 목적별 추천
  - 구매 시 체크리스트

search_queries:
  - "[제품] buying guide [year]"
  - "[제품] best picks [year]"
  - "[제품] what to look for"
  - "[제품] budget recommendations"
  - "[제품] reviews comparison"

sources_priority:
  high:
    - 전문 리뷰 사이트 (Wirecutter, RTINGS)
    - YouTube 리뷰
  medium:
    - Amazon/쿠팡 리뷰
    - Reddit 추천글
  low:
    - 블로그 추천
    - 인플루언서 리뷰

output_sections:
  - 제품 카테고리 개요
  - 핵심 고려 사항
  - 예산별 TOP 추천
  - 상세 비교
  - 구매 체크리스트
  - 어디서 살지

consumer_journey_stages:
  - 인지 (Awareness)
  - 고려 (Consideration)
  - 평가 (Evaluation)
  - 구매 (Purchase)
  - 사용 후 (Post-purchase)
```

---

### 10. product_review (제품 리뷰)

```yaml
name: product_review
category: product_service
trigger_keyword: "ds review"

triggers:
  - "리뷰"
  - "평가"
  - "후기"
  - "사용기"
  - "어때"
  - "괜찮아"

defaults:
  depth: standard
  format: summary
  breadth: 5
  max_react_cycles: 2

focus_areas:
  - 제품 개요
  - 장단점
  - 사용자 평가 종합
  - 가격 대비 가치
  - 대안

search_queries:
  - "[제품] review [year]"
  - "[제품] pros cons"
  - "[제품] user reviews"
  - "[제품] worth it"
  - "[제품] alternatives"

sources_priority:
  high:
    - 전문 리뷰 사이트
    - YouTube 상세 리뷰
  medium:
    - Amazon/쿠팡 리뷰
    - Reddit 사용기
  low:
    - 블로그 후기
    - SNS 리뷰

output_sections:
  - 제품 개요
  - 장단점
  - 사용자 평가 요약 (평점, 주요 의견)
  - 가격 분석
  - 대안 제품
  - 추천 여부
```

---

### 11. service_comparison (서비스 비교)

```yaml
name: service_comparison
category: product_service
trigger_keyword: "ds service"

triggers:
  - "서비스"
  - "구독"
  - "플랜"
  - "요금제"
  - "멤버십"

defaults:
  depth: standard
  format: comparison
  breadth: 5
  max_react_cycles: 2

focus_areas:
  - 요금제 비교
  - 기능 비교
  - 제한 사항
  - 가성비 분석

search_queries:
  - "[서비스] pricing plans"
  - "[서비스] features comparison"
  - "[서비스] vs alternatives"
  - "[서비스] free vs paid"
  - "[서비스] worth it"

sources_priority:
  high:
    - 공식 가격 페이지
    - 비교 사이트
  medium:
    - 사용자 리뷰
    - Reddit 토론
  low:
    - 블로그 비교
    - 제휴 리뷰

output_sections:
  - 서비스 개요
  - 요금제 비교표
  - 기능 비교 매트릭스
  - 사용 사례별 추천
  - 숨겨진 비용
  - 최종 추천
```

---

### 12. user_research (사용자 리서치)

```yaml
name: user_research
category: product_service
trigger_keyword: "ds user"

triggers:
  - "사용자"
  - "고객"
  - "페르소나"
  - "니즈"
  - "UX"

defaults:
  depth: deep
  format: report
  breadth: 6
  max_react_cycles: 4

methodology: "페르소나, UX 리서치"

focus_areas:
  - 타겟 사용자 정의
  - 페르소나 도출
  - 사용자 니즈
  - 페인 포인트
  - 사용 패턴

search_queries:
  - "[제품/서비스] user research"
  - "[제품/서비스] customer needs"
  - "[제품/서비스] user pain points"
  - "[제품/서비스] user behavior"
  - "[제품/서비스] customer feedback"

sources_priority:
  high:
    - UX 리서치 리포트
    - 사용자 인터뷰 데이터
  medium:
    - 리뷰 사이트 분석
    - 포럼 분석
  low:
    - SNS 멘션
    - 블로그

output_sections:
  - 리서치 개요
  - 페르소나 정의
  - 사용자 니즈 맵
  - 페인 포인트
  - 인사이트
  - 제언
```

---

### 13. price_analysis (가격 분석)

```yaml
name: price_analysis
category: product_service
trigger_keyword: "ds price"

triggers:
  - "가격"
  - "비용"
  - "저렴"
  - "최저가"
  - "할인"
  - "세일"

defaults:
  depth: quick
  format: comparison
  breadth: 4
  max_react_cycles: 1

focus_areas:
  - 현재 가격
  - 가격 변동 추이
  - 최저가 채널
  - 할인 정보

search_queries:
  - "[제품] price"
  - "[제품] lowest price"
  - "[제품] price history"
  - "[제품] deals discounts"
  - "[제품] where to buy cheap"

sources_priority:
  high:
    - 가격 비교 사이트
    - 공식 판매처
  medium:
    - 쇼핑 플랫폼
    - 딜 사이트
  low:
    - 중고 거래
    - 직구 사이트

output_sections:
  - 현재 가격 비교
  - 최저가 채널
  - 할인/프로모션 정보
  - 가격 추이 (있는 경우)
  - 구매 추천
```

---

## 👤 개인/생활 리서치 (Personal & Life)

### 14. health_research (건강 리서치)

```yaml
name: health_research
category: personal
trigger_keyword: "ds health"

triggers:
  - "건강"
  - "증상"
  - "질병"
  - "치료"
  - "영양"
  - "비타민"
  - "운동"

defaults:
  depth: standard
  format: summary
  breadth: 5
  max_react_cycles: 2

special_requirements:
  - "의학적 면책 조항 필수"
  - "전문의 상담 권고"
  - "공신력 있는 소스만 인용"

disclaimer: |
  ⚠️ **면책 조항**: 이 정보는 일반적인 참고 목적으로만 제공됩니다.
  의학적 진단이나 치료를 대체할 수 없으며, 건강 관련 결정은
  반드시 의료 전문가와 상담하시기 바랍니다.

focus_areas:
  - 기본 정보
  - 원인/메커니즘
  - 증상/징후
  - 예방/관리
  - 전문가 상담 필요 시점

search_queries:
  - "[주제] NIH"
  - "[주제] Mayo Clinic"
  - "[주제] WebMD"
  - "[주제] medical research"
  - "[주제] clinical guidelines"

sources_priority:
  high:
    - NIH (National Institutes of Health)
    - Mayo Clinic
    - WHO
    - 대학 병원 자료
  medium:
    - WebMD, Healthline
    - 의학 저널 요약
  low:
    - 건강 블로그 (신뢰도 낮음)

output_sections:
  - 면책 조항
  - 개요
  - 주요 정보
  - 예방/관리 방법
  - 전문가 상담 권고 사항
  - 참고 자료
```

---

### 15. travel_research (여행 리서치)

```yaml
name: travel_research
category: personal
trigger_keyword: "ds travel"

triggers:
  - "여행"
  - "호텔"
  - "맛집"
  - "관광"
  - "휴가"
  - "숙소"
  - "항공"

defaults:
  depth: standard
  format: summary
  breadth: 5
  max_react_cycles: 2

focus_areas:
  - 목적지 개요
  - 추천 코스
  - 숙소 추천
  - 맛집/액티비티
  - 예산 가이드
  - 팁/주의사항

search_queries:
  - "[목적지] travel guide [year]"
  - "[목적지] best hotels"
  - "[목적지] restaurants recommendations"
  - "[목적지] things to do"
  - "[목적지] travel tips"
  - "[목적지] budget travel"

sources_priority:
  high:
    - TripAdvisor
    - Lonely Planet
    - Google Maps 리뷰
  medium:
    - 여행 블로그
    - YouTube 여행 영상
  low:
    - SNS 후기
    - 개인 블로그

output_sections:
  - 목적지 개요
  - 추천 일정
  - 숙소 추천 (가격대별)
  - 맛집/액티비티
  - 예산 가이드
  - 여행 팁
```

---

### 16. education_research (교육 리서치)

```yaml
name: education_research
category: personal
trigger_keyword: "ds edu"

triggers:
  - "강의"
  - "학습"
  - "자격증"
  - "코스"
  - "배우기"
  - "공부"
  - "교육"

defaults:
  depth: standard
  format: summary
  breadth: 5
  max_react_cycles: 2

focus_areas:
  - 학습 주제 개요
  - 추천 강의/코스
  - 학습 로드맵
  - 자격증 정보 (해당 시)
  - 무료/유료 자원

search_queries:
  - "[주제] best courses [year]"
  - "[주제] learning path"
  - "[주제] Udemy Coursera"
  - "[주제] certification"
  - "[주제] free resources"
  - "[주제] tutorial beginner"

sources_priority:
  high:
    - Coursera, Udemy, edX
    - 공식 문서/튜토리얼
  medium:
    - YouTube 강의
    - 학습 로드맵 블로그
  low:
    - 개인 추천글
    - 포럼 토론

output_sections:
  - 학습 주제 개요
  - 추천 학습 경로
  - 추천 강의 (무료/유료)
  - 자격증 정보
  - 학습 팁
  - 추가 자원
```

---

### 17. career_research (커리어 리서치)

```yaml
name: career_research
category: personal
trigger_keyword: "ds career"

triggers:
  - "이직"
  - "연봉"
  - "커리어"
  - "취업"
  - "직무"
  - "채용"
  - "경력"

defaults:
  depth: standard
  format: summary
  breadth: 5
  max_react_cycles: 2

focus_areas:
  - 직무/역할 개요
  - 필요 역량
  - 연봉 범위
  - 채용 동향
  - 성장 경로

search_queries:
  - "[직무] salary [year]"
  - "[직무] job requirements"
  - "[직무] career path"
  - "[직무] job market [year]"
  - "[직무] interview tips"
  - "Glassdoor [직무]"

sources_priority:
  high:
    - Glassdoor
    - LinkedIn
    - 사람인, 잡코리아
  medium:
    - 블라인드
    - 업계 리포트
  low:
    - 개인 경험담
    - 포럼 토론

output_sections:
  - 직무 개요
  - 필요 역량 및 자격
  - 연봉 범위
  - 채용 시장 동향
  - 커리어 성장 경로
  - 이직/취업 팁
```

---

### 18. finance_research (금융 리서치)

```yaml
name: finance_research
category: personal
trigger_keyword: "ds finance"

triggers:
  - "투자"
  - "주식"
  - "펀드"
  - "금리"
  - "저축"
  - "ETF"
  - "재테크"

defaults:
  depth: deep
  format: report
  breadth: 6
  max_react_cycles: 4

special_requirements:
  - "투자 면책 조항 필수"
  - "과거 성과 ≠ 미래 수익"

disclaimer: |
  ⚠️ **면책 조항**: 이 정보는 투자 조언이 아닙니다.
  모든 투자에는 위험이 수반되며, 과거 성과가 미래 수익을 보장하지 않습니다.
  투자 결정 전 금융 전문가와 상담하시기 바랍니다.

focus_areas:
  - 투자 상품 개요
  - 리스크 분석
  - 수익률 분석
  - 비용 구조
  - 시장 동향

search_queries:
  - "[주제] investment analysis"
  - "[주제] risk return"
  - "[주제] market outlook [year]"
  - "[주제] expert opinion"
  - "[주제] comparison"

sources_priority:
  high:
    - 증권사 리서치 리포트
    - 금융감독원
    - Bloomberg, Reuters
  medium:
    - Investopedia
    - 경제 뉴스
  low:
    - 투자 블로그
    - SNS 추천

output_sections:
  - 면책 조항
  - 상품/시장 개요
  - 리스크 분석
  - 수익률 비교
  - 비용 분석
  - 시장 전망
  - 고려 사항
```

---

### 19. real_estate (부동산)

```yaml
name: real_estate
category: personal
trigger_keyword: "ds realestate"

triggers:
  - "부동산"
  - "아파트"
  - "매매"
  - "전세"
  - "월세"
  - "집"
  - "청약"

defaults:
  depth: deep
  format: report
  breadth: 6
  max_react_cycles: 4

focus_areas:
  - 시세 분석
  - 입지 분석
  - 개발 호재
  - 규제/정책
  - 투자 가치

search_queries:
  - "[지역] 부동산 시세"
  - "[지역] 아파트 전망"
  - "[지역] 개발 호재"
  - "[지역] 청약"
  - "부동산 정책 [year]"

sources_priority:
  high:
    - 네이버 부동산
    - KB부동산
    - 국토교통부
  medium:
    - 부동산 뉴스
    - 업계 분석
  low:
    - 커뮤니티 후기
    - 개인 블로그

output_sections:
  - 지역/물건 개요
  - 시세 분석
  - 입지 분석
  - 개발 호재/리스크
  - 규제/정책 영향
  - 투자 판단
```

---

### 20. legal_research (법률 리서치)

```yaml
name: legal_research
category: personal
trigger_keyword: "ds legal"

triggers:
  - "법률"
  - "소송"
  - "계약"
  - "권리"
  - "분쟁"
  - "법적"

defaults:
  depth: deep
  format: summary
  breadth: 5
  max_react_cycles: 4

special_requirements:
  - "법률 면책 조항 필수"
  - "전문 변호사 상담 권고"

disclaimer: |
  ⚠️ **면책 조항**: 이 정보는 법률 자문이 아닙니다.
  법적 결정은 반드시 자격을 갖춘 변호사와 상담하시기 바랍니다.

focus_areas:
  - 관련 법령
  - 판례
  - 권리/의무
  - 절차
  - 주의사항

search_queries:
  - "[주제] 법률"
  - "[주제] 판례"
  - "[주제] 법적 절차"
  - "[주제] 권리"
  - "대한법률구조공단 [주제]"

sources_priority:
  high:
    - 법제처 (국가법령정보센터)
    - 대법원 판례
    - 법률구조공단
  medium:
    - 법무법인 가이드
    - 법률 칼럼
  low:
    - 법률 Q&A 사이트
    - 커뮤니티

output_sections:
  - 면책 조항
  - 법률 개요
  - 관련 법령
  - 권리/의무
  - 절차 안내
  - 전문가 상담 권고
```

---

## 📚 학술 리서치 (Academic)

### 21. literature_review (문헌 리뷰)

```yaml
name: literature_review
category: academic
trigger_keyword: "ds lit"

triggers:
  - "논문"
  - "문헌"
  - "체계적 리뷰"
  - "systematic review"
  - "meta-analysis"

defaults:
  depth: full
  format: prisma  # PRISMA Flow
  breadth: 10
  max_react_cycles: 5

methodology: "PRISMA (Preferred Reporting Items for Systematic Reviews)"

special_requirements:
  - "PRISMA 플로우 필수"
  - "포함/배제 기준 명시"
  - "검색 전략 문서화"

focus_areas:
  - 연구 질문 정의
  - 검색 전략
  - 포함/배제 기준
  - 품질 평가
  - 증거 합성

search_queries:
  - "arxiv [주제]"
  - "[주제] systematic review"
  - "[주제] meta-analysis"
  - "scholar [주제]"
  - "PubMed [주제]"

sources_priority:
  high:
    - arXiv
    - Google Scholar
    - PubMed
    - IEEE Xplore
    - ACM Digital Library
  medium:
    - Semantic Scholar
    - ResearchGate
  low:
    - 프리프린트 (비피어리뷰)

output_sections:
  - 연구 질문
  - PRISMA 플로우 다이어그램
  - 검색 전략
  - 포함/배제 기준
  - 선정 논문 목록
  - 주요 발견
  - 연구 갭
  - 결론

prisma_flow:
  stages:
    - 식별 (Identification): "검색 결과 수"
    - 스크리닝 (Screening): "제목/초록 검토"
    - 적격성 (Eligibility): "전문 검토"
    - 포함 (Included): "최종 선정"
```

---

### 22. research_survey (연구 동향)

```yaml
name: research_survey
category: academic
trigger_keyword: "ds academic"

triggers:
  - "연구"
  - "학술"
  - "최신 연구"
  - "학계"
  - "연구 동향"

defaults:
  depth: deep
  format: report
  breadth: 7
  max_react_cycles: 4

methodology: "인용 분석, 연구 동향 분석"

focus_areas:
  - 연구 분야 개요
  - 주요 연구 그룹
  - 핵심 논문
  - 연구 트렌드
  - 미해결 문제

search_queries:
  - "arxiv [주제]"
  - "[주제] research paper [year]"
  - "[주제] state of the art"
  - "[주제] survey paper"
  - "scholar [주제]"

sources_priority:
  high:
    - arXiv
    - Google Scholar
    - IEEE, ACM
    - Nature, Science
  medium:
    - 학회 proceedings
    - 기술 리포트
  low:
    - 프리프린트
    - 블로그 요약

output_sections:
  - 연구 배경
  - 주요 연구 그룹/기관
  - 핵심 논문 요약 (Top 5-10)
  - 연구 트렌드
  - 미해결 문제
  - 향후 방향
```

---

## 프리셋 자동 선택 로직

```yaml
auto_select:
  priority:
    1: "명시적 키워드 (ds market, ds compare 등)"
    2: "트리거 키워드 매칭"
    3: "질문 형태 분석"
    4: "기본값 (general_inquiry)"

  rules:
    # 명시적 키워드
    - if: "ds market"
      then: market_research
    - if: "ds compare"
      then: competitive_analysis
    - if: "ds dd"
      then: due_diligence
    - if: "ds tech"
      then: technology_research
    - if: "ds strategy"
      then: strategic_research
    - if: "ds trend"
      then: trend_analysis
    - if: "ds policy"
      then: policy_analysis
    - if: "ds vendor"
      then: vendor_selection
    - if: "ds buy"
      then: purchase_decision
    - if: "ds review"
      then: product_review
    - if: "ds service"
      then: service_comparison
    - if: "ds user"
      then: user_research
    - if: "ds price"
      then: price_analysis
    - if: "ds health"
      then: health_research
    - if: "ds travel"
      then: travel_research
    - if: "ds edu"
      then: education_research
    - if: "ds career"
      then: career_research
    - if: "ds finance"
      then: finance_research
    - if: "ds realestate"
      then: real_estate
    - if: "ds legal"
      then: legal_research
    - if: "ds lit"
      then: literature_review
    - if: "ds academic"
      then: research_survey

    # 트리거 키워드 매칭
    - if: "vs 또는 비교 포함"
      then: competitive_analysis
    - if: "시장 AND (규모 OR 동향)"
      then: market_research
    - if: "투자 AND (회사 OR 스타트업)"
      then: due_diligence

    # 면책 조항 필요 분류
    disclaimer_required:
      - health_research
      - finance_research
      - legal_research

  override:
    - "사용자가 명시적으로 깊이/형식 지정 시 프리셋 기본값 무시"
```

---

## 사용 예시

| 사용자 입력 | 감지 프리셋 | 설정 |
|-------------|-------------|------|
| `ds market AI 에이전트` | market_research | deep, market_report |
| `ds compare Notion vs Obsidian` | competitive_analysis | deep, quadrant |
| `ds dd 토스 투자 검토` | due_diligence | full, risk_report |
| `ds buy 맥북 M4 프로` | purchase_decision | standard, buying_guide |
| `ds health 비타민D 효과` | health_research | standard, summary |
| `ds lit 강화학습 최신 연구` | literature_review | full, prisma |
