
## Contents

- [실행 프로세스](#실행-프로세스)
  - [Phase 1: 아이디어 수신 + 구체화 + 💡 AI 아이디어](#phase-1-아이디어-수신-구체화-ai-아이디어)
  - [Phase 2: 사업성 검토 [★ Go/No-Go 결정]](#phase-2-사업성-검토-gono-go-결정)
  - [Phase 3: 기술/디자인 리서치](#phase-3-기술디자인-리서치)
  - [Phase 4: PRD 문서 생성](#phase-4-prd-문서-생성)
  - [Phase 5: 확인 + 다음 단계](#phase-5-확인-다음-단계)
- [모드 선택](#모드-선택)
  - [모드별 차이](#모드별-차이)
- [PRD 템플릿](#prd-템플릿)
  - [기본 섹션 (1-10)](#기본-섹션-1-10)
  - [엔터프라이즈 섹션 (11-19)](#엔터프라이즈-섹션-11-19)
- [사용 예시](#사용-예시)
  - [기본 사용](#기본-사용)
  - [모드 지정](#모드-지정)
  - [키워드 자동 감지](#키워드-자동-감지)
- [키워드 트리거](#키워드-트리거)
- [다음 단계 연결](#다음-단계-연결)
- [참조](#참조)
- [통합 참조 (v2 추가)](#통합-참조-v2-추가)
- [워크플로우 (v2)](#워크플로우-v2)

---
name: prd-create
description: 아이디어/컨셉을 PRD 문서로 변환하는 스킬. 사업성 검토 → 기술 리서치 → PRD 생성. `/prd-create` 명령으로 호출. PRD 작성, 기획서 생성, 서비스 기획이 필요할 때 사용.
---

# PRD Create Skill

아이디어를 사업성 검토와 기술 리서치를 거쳐 PRD 문서로 변환하는 시스템.

## 실행 프로세스

### Phase 1: 아이디어 수신 + 구체화 + 💡 AI 아이디어

```yaml
questions:
  # 🔴 필수 질문 (반드시 확인)
  essential:
    - "무엇을 만들고 싶으세요? (한 문장)"
    - "핵심 기능 3가지는?"
    - "누가 사용하나요? (타겟 사용자)"
    - "왜 필요한가요? (해결하려는 문제)"

  # 🟡 선택 질문 (사용자가 원하면)
  optional:
    - "참고할 서비스가 있나요?"
    - "기술적 제약이 있나요?"
    - "예산/일정 제약은?"

# 💡 AI 아이디어 제안 (질문과 함께 제공)
ai_ideas:
  principle: "질문할 때마다 관련 AI 아이디어 함께 제안"

  format: |
    💡 **AI 제안**: [아이디어 한 줄 요약]

    제가 분석해보니, [분석 내용].

    **옵션 A**: [제안 1]
      - 장점: ...
      - 단점: ...

    **옵션 B**: [제안 2]
      - 장점: ...
      - 단점: ...

    **추천**: [옵션] → [이유]

  # 질문별 AI 아이디어 예시
  examples:
    # Q1: 핵심 기능 질문 시
    after_feature_question: |
      💡 말씀하신 기능 외에 이런 것도 고려해보세요:

      **추가 기능 아이디어**:
      - 🎮 **게이미피케이션**: 연속 운동 뱃지, 친구 챌린지
      - 🤖 **AI 코치**: GPT 기반 운동 상담, 동기부여 메시지
      - 👥 **소셜 기능**: 운동 인증샷, 커뮤니티

      MVP에 어디까지 포함할까요?
      **추천**: 핵심 3개 + AI 코치 (차별화 강화)

    # Q2: 타겟 사용자 질문 시
    after_target_question: |
      💡 타겟을 더 구체화하면 차별화에 유리해요:

      **옵션 A**: 홈트 초보자 (20-30대 직장인)
        - 시장: 크지만 경쟁 치열 (레드오션)
        - 차별화: AI 자세 교정으로 부상 방지

      **옵션 B**: 시니어 (50-60대)
        - 시장: 작지만 블루오션
        - 차별화: 쉬운 UI, 관절 보호 운동

      **옵션 C**: 재활 환자
        - 시장: 니치, B2B 가능
        - 차별화: 의료진 연동

      **추천**: 옵션 A → 시장 크고 AI 자세 교정이 핵심 차별화

    # Q3: 문제/기존 솔루션 질문 시
    after_problem_question: |
      💡 경쟁사 대비 차별화 포인트 제안:

      **현재 시장 약점 분석**:
      | 경쟁사 | 약점 | 우리의 기회 |
      |--------|------|-------------|
      | Fitbod | 헬스장 장비 필요 | 맨몸운동 특화 |
      | Apple Fitness+ | Watch 필수 | 디바이스 프리 |
      | Peloton | 고가 | 저렴한 구독료 |

      **핵심 포지셔닝 제안**:
      "장비 없이, 어디서나, AI가 실시간 자세 교정"

      이 방향 어떠세요?

    # Q4: 제약사항 질문 시
    after_constraints_question: |
      💡 수익 모델 옵션:

      **옵션 A**: 프리미엄 구독 ($9.99/월)
        - 장점: 예측 가능한 수익, 업계 표준
        - 단점: 전환율 2-5%

      **옵션 B**: 기능별 인앱 구매
        - 장점: 진입 장벽 낮음
        - 단점: 수익 변동성

      **옵션 C**: 하이브리드 (구독 + PT 연결 수수료)
        - 장점: 다중 수익원
        - 단점: 복잡도 증가

      **추천**: 옵션 A → 피트니스 앱 67%가 구독, Trial-to-Paid 40% 가능

flow:
  1. 필수 질문 + 💡 AI 아이디어 제안
  2. 답변 + 아이디어 채택 여부 확인
  3. 채택된 아이디어 반영
  4. Phase 2로 진행
```

### Phase 2: 사업성 검토 [★ Go/No-Go 결정]

```yaml
parallel_research:
  # 거시 환경 분석 (2개)
  - Task(pestle_analysis): "PESTLE 6개 요소 분석 (Political/Economic/Social/Technological/Legal/Environmental)"
  - Task(porter_5forces): "Porter's 5 Forces 산업 구조 분석 (경쟁 강도/신규 진입/대체재/공급자/구매자)"

  # 시장 분석 (2개)
  - Task(market): "시장 규모 + 성장성 분석 (TAM/SAM/SOM 계산 근거 필수)"
  - Task(market_segmentation): "시장 세분화 (Geographic/Demographic/Psychographic) + Target 선정"

  # 경쟁 분석 (3개)
  - Task(competitor): "경쟁사 SWOT 분석 + 차별화 가능성"
  - Task(competitive_positioning): "경쟁 포지셔닝 매트릭스 (2x2) + 블루오션 영역 식별"
  - Task(feature_comparison): "상세 기능 비교표 + 가격 전략 비교"

  # 고객 분석 (3개)
  - Task(persona_jtbd): "Persona (Primary/Secondary) + Jobs-to-be-Done 통합 분석"
  - Task(customer_journey): "5단계 Customer Journey (인지→고려→전환→유지→추천) + Pain Points/Gains"
  - Task(customer_research): "사용자 인터뷰/설문 설계 + Willingness to Pay 분석"

  # 비즈니스 모델 분석 (2개)
  - Task(business_model): "Business Model Canvas 9개 요소 분석"
  - Task(revenue): "수익 모델 + Unit Economics (CAC/LTV/Payback) + 3-5년 재무 예측"

tools:
  pestle_analysis:
    - WebSearch: "[산업] PESTLE analysis [year]"
    - WebSearch: "[산업] regulatory trends [year]"
    - 분석: 각 요소별 High/Medium/Low Impact 평가

  porter_5forces:
    - WebSearch: "[산업] Porter's Five Forces [year]"
    - WebSearch: "[산업] entry barriers analysis"
    - 분석: 각 요소별 경쟁 강도 평가 (1-5점)

  market:
    - WebSearch: "[키워드] market size [year]"
    - WebSearch: "[키워드] TAM SAM SOM calculation"
    - WebSearch: "[키워드] market growth CAGR [year]"
    - WebFetch: "Statista, Grand View Research, Gartner 데이터"
    - 계산: Top-Down + Bottom-Up 방법론 병행

  market_segmentation:
    - WebSearch: "[산업] customer segmentation"
    - WebSearch: "[산업] target market analysis"
    - 분석: RFM, Demographic, Psychographic 세분화

  competitor:
    - WebSearch: "[키워드] competitors [year]"
    - WebFetch: "경쟁사 웹사이트, 제품 페이지, 가격표"
    - WebSearch: "[경쟁사명] SWOT analysis"
    - 분석: SWOT 매트릭스 생성

  competitive_positioning:
    - 분석: 2x2 매트릭스 (가격 vs 기능, 품질 vs 편의성 등)
    - WebSearch: "[산업] competitive positioning [year]"

  feature_comparison:
    - WebFetch: "경쟁사 Feature List, Pricing Page"
    - 분석: Feature Comparison Matrix (10-15개 핵심 기능)

  persona_jtbd:
    - WebSearch: "[타겟] persona template"
    - WebSearch: "[타겟] jobs to be done"
    - 분석: Persona Canvas (Demographics/Goals/Pain Points/Gains)

  customer_journey:
    - WebSearch: "[산업] customer journey map"
    - 분석: 5단계별 Touchpoint, Emotion, Pain Points, Opportunities

  customer_research:
    - 분석: 인터뷰 질문 10개 설계 (Problem/Solution Fit)
    - 분석: 설문 설계 (Van Westendorp PSM - 가격 민감도)

  business_model:
    - WebSearch: "[산업] business model canvas"
    - 분석: 9개 요소 (Customer Segments/Value Propositions/Channels/Customer Relationships/Revenue Streams/Key Resources/Key Activities/Key Partnerships/Cost Structure)

  revenue:
    - WebSearch: "[산업] unit economics benchmarks"
    - WebSearch: "[산업] CAC LTV ratio"
    - 계산: CAC (Customer Acquisition Cost)
    - 계산: LTV (Lifetime Value)
    - 계산: LTV:CAC Ratio (목표 3:1)
    - 계산: Payback Period (목표 < 12개월)
    - 예측: Year 1-5 Revenue/Cost/Profit

output:
  pestle_analysis:
    - Political: 정책/규제 변화 영향도
    - Economic: 경제 지표 (GDP, 실업률, 소비 트렌드)
    - Social: 사회/문화적 트렌드
    - Technological: 기술 혁신 동향
    - Legal: 법률/규제 요구사항
    - Environmental: 환경/지속가능성 이슈

  porter_5forces:
    - 산업 내 경쟁 강도 (1-5점)
    - 신규 진입자 위협 (1-5점)
    - 대체재 위협 (1-5점)
    - 공급자 교섭력 (1-5점)
    - 구매자 교섭력 (1-5점)
    - 종합 평가: 산업 매력도 (High/Medium/Low)

  market:
    - TAM (Total Addressable Market) + 계산 근거
    - SAM (Serviceable Available Market) + 계산 근거
    - SOM (Serviceable Obtainable Market) + 계산 근거
    - 시장 성장률 (CAGR 5년)
    - 데이터 출처 (Statista, Gartner 등)

  market_segmentation:
    - Geographic Segmentation (지역별)
    - Demographic Segmentation (연령/성별/소득)
    - Psychographic Segmentation (라이프스타일/가치관)
    - Target 시장 선정 근거

  competitor:
    - 주요 경쟁사 SWOT 분석 (3-5개)
    - 우리의 차별화 포인트
    - 진입 장벽 분석

  competitive_positioning:
    - 2x2 포지셔닝 매트릭스
    - 블루오션 영역 식별
    - 포지셔닝 전략 권장

  feature_comparison:
    - Feature Comparison Matrix (경쟁사 vs 우리)
    - 가격 전략 비교
    - Unique Selling Points (USP)

  persona_jtbd:
    - Primary Persona (Demographics/Goals/Pain Points)
    - Secondary Persona
    - Jobs-to-be-Done (Functional/Emotional/Social)

  customer_journey:
    - Stage 1 인지: Touchpoint/Emotion/Pain Points
    - Stage 2 고려: Touchpoint/Emotion/Pain Points
    - Stage 3 전환: Touchpoint/Emotion/Pain Points
    - Stage 4 유지: Touchpoint/Emotion/Pain Points
    - Stage 5 추천: Touchpoint/Emotion/Pain Points

  customer_research:
    - 인터뷰 질문 설계 (Problem/Solution Fit)
    - 설문 설계 (가격 민감도, NPS)
    - Willingness to Pay 분석

  business_model:
    - Business Model Canvas (9개 요소 상세)
    - Revenue Streams 우선순위

  revenue:
    - 가능한 수익 모델 (Subscription/Transaction/Ad 등)
    - 가격 전략 (Freemium/Tiered/Enterprise)
    - Unit Economics:
      - CAC (Customer Acquisition Cost)
      - LTV (Lifetime Value)
      - LTV:CAC Ratio
      - Payback Period
    - 재무 예측 (Year 1-5):
      - Revenue
      - Cost
      - Gross Profit
      - Net Profit
    - 손익분기점 예측

go_nogo_criteria:
  # 정량적 기준 (스코어링)
  scoring:
    market_size:      # TAM > $1B = 3점, $100M-$1B = 2점, < $100M = 1점
    market_growth:    # CAGR > 15% = 3점, 10-15% = 2점, < 10% = 1점
    competition:      # 블루오션 = 3점, 틈새 가능 = 2점, 레드오션 = 1점
    differentiation:  # 강력 = 3점, 보통 = 2점, 약함 = 1점
    revenue_model:    # 검증됨 = 3점, 가능 = 2점, 불명확 = 1점

  judgment:
    go: "총점 >= 12점 (평균 2.4점 이상)"
    pivot: "총점 8-11점 (평균 1.6-2.2점)"
    nogo: "총점 < 8점 (평균 1.6점 미만)"

  # Pivot 처리 흐름
  pivot_flow:
    1. "현재 점수 + 약점 분석 제시"
    2. "방향 수정 제안 (2-3개 옵션)"
    3. "사용자 선택"
    4. "선택된 방향으로 Phase 2 재실행"
    max_pivot_attempts: 2

  # No-Go 종료 흐름
  nogo_flow:
    1. "판정 근거 상세 설명"
    2. "실패 요인 분석"
    3. "대안 아이디어 제안 (선택)"
    4. "세션 종료"
```

### Phase 3: 기술/디자인 리서치

> **조건**: Phase 2에서 🟢 Go 판정 시에만 진행

```yaml
parallel_research:
  - Task(tech_stack): "기술 스택 추천"
  - Task(github): "GitHub 기반 기술 리서치"
  - Task(api_docs): "API/라이브러리 공식 문서"
  - Task(design): "디자인 레퍼런스"
  - Task(feasibility): "기술적 실현 가능성"
  - Task(test_strategy): "테스트 전략 수립 (Unit/Integration/E2E/Performance/Security)"
  - Task(api_design): "API 설계 (Contract-First, OpenAPI 3.0) [Enterprise 전용]"

tools:
  github:
    - WebSearch: "github [키워드] stars:>100"
    - WebFetch: "README, 아키텍처 문서"
  api_docs:
    - WebSearch: "[라이브러리] official documentation"
    - WebFetch: "공식 문서 분석"
  design:
    - WebSearch: "dribbble [키워드] ui design"
    - WebSearch: "figma community [키워드]"
  test_strategy:
    - WebSearch: "[산업] test automation best practices"
    - WebSearch: "unit testing integration testing e2e testing strategy"
    - 분석: 테스트 피라미드 적용 (Unit 80% > Integration 15% > E2E 5%)
    - 도구 선정: Jest, Playwright, k6, OWASP ZAP
  api_design:
    - WebSearch: "[산업] API design best practices RESTful"
    - WebSearch: "OpenAPI 3.0 specification"
    - WebSearch: "API versioning strategy"
    - 분석: RESTful 원칙, 네이밍 규칙, 에러 처리, Rate Limiting
    - 도구: OpenAPI Generator, Prism (Mock Server)

output:
  tech_stack:
    - 추천 기술 스택
    - 각 기술 선택 이유
  github:
    - 추천 라이브러리 목록
    - 참고할 구현체 링크
    - 아키텍처 패턴 제안
    - 라이선스 검토
  api_docs:
    - API 사용법 요약
    - 주요 기능 목록
    - 제약사항/한계
  design:
    - UI 레퍼런스 링크
    - 디자인 패턴 제안
    - UX 플로우 아이디어
  feasibility:
    - 구현 복잡도 평가
    - 예상 개발 기간
  test_strategy:
    - 테스트 유형별 전략 (Unit/Integration/E2E/Performance/Security)
    - 커버리지 목표 (80% 이상)
    - 도구 및 프레임워크 선정
    - CI/CD 통합 방안
    - 우선순위 (P0/P1/P2)
  api_design:
    - RESTful API 설계 원칙
    - 핵심 엔드포인트 정의 (인증, CRUD)
    - 요청/응답 형식 (JSON Schema)
    - HTTP 상태 코드 및 에러 처리
    - Pagination 전략 (Cursor vs Offset)
    - Rate Limiting 정책
    - OpenAPI 3.0 스펙 생성 방법
```

### Phase 4: PRD 문서 생성

```yaml
parallel_generation:
  - Task(overview): "개요, 배경, 목적"
  - Task(features): "핵심 기능, 우선순위"
  - Task(technical): "기술 스택, 아키텍처"
  - Task(scope): "범위, 제약사항"

# 데이터 통합 규칙
data_integration:
  # Phase 2 → PRD 섹션 매핑
  phase2_to_prd:
    market_research: "섹션 3.시장 분석"
    competitor_analysis: "섹션 3.경쟁 분석"
    revenue_model: "섹션 3.수익 모델"

  # Phase 3 → PRD 섹션 매핑
  phase3_to_prd:
    tech_stack: "섹션 10.기술 스택"
    github: "섹션 8.기술 리서치"
    design: "섹션 9.디자인 레퍼런스"
    feasibility: "섹션 7.제약사항"
    test_strategy: "섹션 5.4.테스트 전략"
    api_design: "섹션 26.API 설계 (Enterprise 전용)"

  # 통합 프로세스
  integration_steps:
    1. "각 에이전트 결과 수집"
    2. "섹션별 매핑 적용"
    3. "중복 내용 제거"
    4. "용어/형식 통일"
    5. "최종 문서 생성"
```

### Phase 5: 확인 + 다음 단계

```yaml
options:
  - "✅ 바로 개발 시작" → Project Planning 진입
  - "📝 PRD 수정 요청" → 수정 반영
  - "💾 PRD만 저장" → 종료

if_develop:
  action: "Project Planning 케이스로 자동 전환"
  input: "생성된 PRD 문서"
```

## 모드 선택

| 모드 | 설명 | 병렬 에이전트 | 섹션 |
|------|------|---------------|------|
| `quick` | 빠른 PRD | 없음 | 1-10 |
| `standard` | 표준 PRD | PRD 생성만 (4개) | 1-10 |
| `thorough` | 심층 PRD | 전체 (사업성+기술+PRD) | 1-10 |
| `enterprise` | 대기업 PRD | 전체 + PESTLE/Porter's 5 Forces/고객 분석 | 1-25 |

### 모드별 차이

```yaml
quick:
  agents: 0
  sections: 1-10
  parallel: false
  description: "간단한 아이디어 검증용, 5-10분 소요"

standard:
  agents: 4 (PRD 생성)
  sections: 1-10
  parallel: PRD 생성만
  description: "기본 PRD, 병렬 처리로 10-15분 소요"

thorough:
  agents: 14 (사업성 3 + 기술 7 + PRD 4)
  sections: 1-10
  parallel: 전체
  description: "심층 PRD, 사업성+기술 검토, 20-30분 소요"

enterprise:
  agents: 27 (사업성 12 + 기술 7 + PRD 4 + 엔터프라이즈 4)
  sections: 1-26
  parallel: 전체
  description: "대기업 수준 PRD, 전문 방법론 적용, 30-40분 소요"

  # Phase 2 사업성 검토 (12개 agents)
  market_research_agents:
    - Task(pestle_analysis): "PESTLE 6개 요소 분석"
    - Task(porter_5forces): "Porter's 5 Forces 산업 구조 분석"
    - Task(market): "시장 규모 TAM/SAM/SOM (계산 근거)"
    - Task(market_segmentation): "시장 세분화 + Target 선정"

  competitor_agents:
    - Task(competitor): "경쟁사 SWOT 분석"
    - Task(competitive_positioning): "경쟁 포지셔닝 매트릭스"
    - Task(feature_comparison): "상세 기능/가격 비교"

  customer_agents:
    - Task(persona_jtbd): "Persona + Jobs-to-be-Done"
    - Task(customer_journey): "Customer Journey Map"
    - Task(customer_research): "사용자 인터뷰/설문 설계"

  business_model_agents:
    - Task(business_model): "Business Model Canvas"
    - Task(revenue): "수익 모델 + Unit Economics"

  # Phase 3 기술 리서치 (7개 agents)
  tech_agents:
    - Task(tech_stack): "기술 스택 추천"
    - Task(github): "GitHub 기반 기술 리서치"
    - Task(api_docs): "API/라이브러리 공식 문서"
    - Task(design): "디자인 레퍼런스"
    - Task(feasibility): "기술적 실현 가능성"
    - Task(test_strategy): "테스트 전략 수립"
    - Task(api_design): "API 설계 (Contract-First)"

  # Phase 4 PRD 생성 (4개 agents)
  prd_agents:
    - Task(overview): "개요, 배경, 목적"
    - Task(features): "핵심 기능, 우선순위"
    - Task(technical): "기술 스택, 아키텍처"
    - Task(scope): "범위, 제약사항"

  # 엔터프라이즈 추가 분석 (4개 agents)
  extra_agents:
    - Task(legal_review): "법률/규제 검토 (GDPR, 개인정보보호법)"
    - Task(cost_analysis): "TCO/ROI 3-5년 분석"
    - Task(risk_matrix): "리스크 매트릭스 (확률×영향도)"
    - Task(stakeholder): "이해관계자 분석 (내부/외부)"

  # 추가 섹션 (20-26)
  additional_sections:
    - "20. PESTLE 분석 상세"
    - "21. Porter's 5 Forces 상세"
    - "22. 시장 세분화 전략"
    - "23. Persona + JTBD 상세"
    - "24. Customer Journey Map"
    - "25. 경쟁 포지셔닝 매트릭스"
    - "26. API 설계 (Contract-First)"

  # 데이터 품질 기준
  quality_standards:
    data_sources:
      - "모든 시장 수치: 출처 필수 (Statista, Gartner, IDC 등)"
      - "TAM/SAM/SOM: Top-Down + Bottom-Up 계산 근거"
      - "경쟁사 정보: 공식 웹사이트, 보도자료, 리뷰"

    analysis_depth:
      - "PESTLE: 각 요소별 2-3개 핵심 인사이트"
      - "Porter's 5 Forces: 각 요소별 1-5점 평가 + 근거"
      - "Persona: Demographics/Goals/Pain Points/Gains 필수"
      - "Customer Journey: 5단계 각각 Touchpoint/Emotion/Pain Points"

    financial_rigor:
      - "Unit Economics: CAC, LTV, LTV:CAC Ratio, Payback Period"
      - "Revenue Projections: Year 1-5 상세 (Revenue/Cost/Profit)"
      - "손익분기점: 필요 사용자 수 + 예상 시점"
```

## PRD 템플릿

→ 상세 템플릿: [references/template.md](references/template.md)

### 기본 섹션 (1-10)

| # | 섹션 | 내용 |
|---|------|------|
| 1 | 개요 | 한 줄 요약, 목적, 타겟 사용자 |
| 2 | 배경 | 해결하려는 문제, 기존 솔루션 한계, 기대 효과 |
| 3 | 사업성 검토 결과 | 시장/경쟁/수익 분석, Go/No-Go 판정 |
| 4 | 핵심 기능 | 우선순위별 기능 목록 |
| 5 | 비기능 요구사항 | 성능/보안/확장성 |
| 6 | 범위 | In Scope / Out of Scope |
| 7 | 제약사항 | 기술/일정/예산 |
| 8 | 기술 리서치 | 추천 라이브러리, 참고 프로젝트 |
| 9 | 디자인 레퍼런스 | UI/UX 참고 |
| 10 | 기술 스택 | 추천 스택, 선택 이유, 예상 비용 |

### 엔터프라이즈 섹션 (11-19)

| # | 섹션 | 내용 |
|---|------|------|
| 11 | 법률/규제 검토 | GDPR, 개인정보보호법, 라이선스 |
| 12 | 비용 분석 | TCO, ROI, 손익분기점 |
| 13 | 리스크 매트릭스 | 확률/영향도/완화 전략 |
| 14 | 이해관계자 분석 | 내부/외부 이해관계자 |
| 15 | KPI/성공 지표 | 목표값, 측정 방법, 주기 |
| 16 | 운영 계획 | SLA, 지원 체계 |
| 17 | 보안/컴플라이언스 | 보안 요구사항, 감사 대응 |
| 18 | 접근성/국제화 | WCAG, 다국어 지원 |
| 19 | 타임라인/로드맵 | 마일스톤, 의존성 |

## 사용 예시

### 기본 사용
```
사용자: /prd-create 운동 루틴 추천 앱

Codex:
1. 구체화 질문 (Phase 1)
2. 사업성 검토 → Go/No-Go (Phase 2)
3. 기술 리서치 (Phase 3)
4. PRD 생성 (Phase 4)
5. 다음 단계 제안 (Phase 5)
```

### 모드 지정
```
사용자: /prd-create enterprise 기업용 CRM 시스템

Codex:
- 엔터프라이즈 모드 적용
- 전체 19개 섹션 포함
- 법률/비용/리스크 분석 추가
```

### 키워드 자동 감지
```
사용자: 새로운 음식 배달 앱 PRD 만들어줘

Codex:
- "PRD 만들어줘" 키워드 감지
- PRD Creation 케이스 자동 진입
```

## 키워드 트리거

```yaml
triggers:
  - "PRD 만들어줘"
  - "PRD 작성"
  - "기획서 작성"
  - "기획서 만들어줘"
  - "요구사항 문서"
  - "프로젝트 기획"
  - "서비스 기획"
```

## 다음 단계 연결

PRD 완성 후 사용자가 개발을 원할 경우:

```yaml
connection:
  from: "PRD Creation Case"
  to: "Project Planning Case"
  trigger: "바로 개발할까요?" → "OK"
  action: 생성된 PRD를 Project Planning에 전달
```

## 참조

- Plan Mode: `~/.Codex/docs/PLAN-MODE.md`
- Project Planning: `~/.Codex/docs/PROJECT-PLANNING.md`
- PRD 템플릿: `~/.Codex/skills/prd-create/references/template.md`

## 통합 참조 (v2 추가)

- 인터뷰 설정: ~/.Codex/config/interview-settings.yaml (5W2H 기반)
- 인터뷰 상태 저장: ~/.Codex/sessions/interview/
- 템플릿: ~/.Codex/templates/PRD.md
- Red/Blue 분석: ~/.Codex/skills/simulate/references/red-blue-analysis.md
- 프로젝트 기획 가이드: ~/.Codex/guides/project-planning.md

## 워크플로우 (v2)

1. plan-mode-detector가 PROJECT_PLANNING 감지
2. interview-settings.yaml 로드 -> 5W2H 순서로 질문
3. coverage 90% 또는 stop_signal 시 종료
4. 템플릿 PRD.md 로드 -> 변수 치환
5. Red/Blue 분석 실행 (simulate 스킬 references 참조)
6. final_score 70+ 시 PRD 확정
7. ~/workspace/projects/{name}/.planning/PRD.md로 저장
