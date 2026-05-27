# team-marketing 실행 시나리오 5종


## Contents

- [시나리오 A: 런칭 (`"제품 만들었는데 어떻게 알려야 돼?"`)](#시나리오-a-런칭-제품-만들었는데-어떻게-알려야-돼)
- [시나리오 B: 전환율 저하 (`"사이트 들어와도 안 사"`)](#시나리오-b-전환율-저하-사이트-들어와도-안-사)
- [시나리오 C: SEO 하락 (`"구글 검색에 안 나와"`)](#시나리오-c-seo-하락-구글-검색에-안-나와)
- [시나리오 D: 리텐션 (`"가입하고 금방 나가"`)](#시나리오-d-리텐션-가입하고-금방-나가)
- [시나리오 E: 주간 콘텐츠 (`"이번 주 SNS 뭐 올려?"`)](#시나리오-e-주간-콘텐츠-이번-주-sns-뭐-올려)
- [공통 실행 규칙](#공통-실행-규칙)

비전문가 자연어 요청 → 자동 진단 → 6-Role 협업 → 일반어 결과.

**공통 원칙**:
- PMC 부재 시 최소 3-4개 질문으로만 부트스트랩 (나머지는 웹 fetch + 온톨로지 + 리서치)
- 전문 용어는 내부에서만 사용, 사용자에게는 일반어 번역
- 결과 구조: "원인 N가지 → 해결안 → 다음 단계 + 승인 필요 포인트"
- 외부 팀 위임 필요 시 자동 전달 후 "다음 단계"에서 안내

---

## 시나리오 A: 런칭 (`"제품 만들었는데 어떻게 알려야 돼?"`)

**매핑**: `/workflow marketing-launch` 또는 자동 시나리오 분기

```
훅 체인
  keyword-detector: "제품/알려야/웹사이트" → [TEAM-MARKETING:cmo]
  persona-activator: marketing + growth + risk_analyst 3종 활성
  plan-mode-detector: PROJECT_PLANNING + domain:marketing:strategy

Phase 1: CMO Strategist
  PMC 온톨로지 조회 → 없음 → 최소 3개 질문
    ("한 줄 소개 / 주 타겟 / 경쟁사 vs 우리")
  자동 보완: 웹사이트 fetch → 기능·가격·스크린샷 추출 → Product 엔티티 등록
  12섹션 PMC 초안 생성 → /marketing-context-sync 파일 파생

Phase 2: Insight Analyst (병렬 가능)
  /research marketing-voc-sources preset → Reddit/HN/G2 스크레이핑
  competitor-alternatives 4 쿼리 패턴 → 경쟁 매트릭스
  3-5개 페르소나 자동 생성 (data points 5-10+)

Phase 3: Copy & Content Chief
  marketing-skills:copywriting → 랜딩 카피 3안
  content-creator → 블로그 론칭 포스트 (한/영)
  marketing-skills:email-sequence → 웰컴 5통
  marketing-skills:copy-editing → Seven Sweeps 검수

Phase 4: CRO Engineer (병렬)
  marketing-skills:page-cro → 5초 테스트 + CTA 배치
  marketing-skills:signup-flow-cro → GitHub OAuth 1-click 권고
  marketing-skills:ab-test-setup → 헤드라인 A/B 2안

Phase 5: Acquisition Lead
  marketing-skills:seo-audit → 타이틀·스키마·sitemap 체크
  marketing-skills:schema-markup → SoftwareApplication+Product JSON-LD
  marketing-skills:analytics-tracking → 8개 이벤트 정의
  marketing-skills:paid-ads → Google/Meta 키워드 + 카피 6개

Phase 6: Growth & GTM Ops
  marketing-skills:lead-magnets → "흔한 버그 패턴 10선 PDF"
  marketing-skills:referral-program → "친구 초대 시 1개월 무료"

사용자 노출 결과 (일반어):
  [사이트 개선 3가지]
    - 첫 화면 헤드라인 모호 → 제안 카피 3안
    - 가입 8필드 → 3필드 권장
    - 검색엔진 인식 부족 → 기술 마크업 5개
  [론칭 콘텐츠]
    - 블로그 2편 / 이메일 5통 / 광고 6개
  [다음 단계 체크리스트]
    □ 헤드라인 교체 (5분)
    □ GitHub 로그인 붙이기 → team-dev 위임 가능
    □ 웰컴 이메일 발송 설정 (Resend/Postmark 어느 거 쓸지?)
    □ 첫 주 광고 30만원 운영 (team-accounting 승인)
  [측정 세팅 완료] 8개 이벤트 → 1주 후 자동 리포트

상태 업데이트:
  campaign_state: draft → approved
  roles.cmo-strategist.monthly_strategies_drafted++
  roles.insight-analyst.monthly_voc_reports++
  roles.copy-content-chief.monthly_content_published += 7
  roles.cro-engineer.monthly_cro_audits++
  roles.acquisition-lead.monthly_seo_audits++
  roles.growth-gtm-ops.monthly_referrals_shipped++
```

---

## 시나리오 B: 전환율 저하 (`"사이트 들어와도 안 사"`)

**매핑**: `/workflow marketing-cro-audit`

```
훅: [TEAM-MARKETING:cro]

CRO Engineer 진입 → page-cro 7축 분석
  ✗ 가치 제안 추상 / CTA 배치 / 가격 미노출 / 폼 8필드 등 진단

Insight Analyst 자동 위임
  이탈 사유 VOC → 유사 제품 리뷰 마이닝
  "가격 없으면 문의 귀찮아서 이탈" 패턴 12건

Copy & Content Chief
  copywriting → 헤드라인 A/B/C 3안 (이득/비교/통계 중심)
  CTA 카피 5안 + FAQ 반박 처리 초안
  copy-editing Seven Sweeps 검수

CRO 통합
  ab-test-setup → 3주 A/B 설계
  analytics-tracking → scroll_depth + cta_view + cta_click + form_abandon

사용자 노출:
  [원인 3가지]
    1. "혁신" 같은 추상 단어 3회 — 헤드라인 A/B/C 준비
    2. 가격 비공개 → 이탈. 요금 페이지 + FAQ 3개 준비
    3. 가입 8필드 → 3필드 단축안
  [적용 방법] A/B/C 고르면 3주 테스트 자동 세팅. 나머지 즉시 적용 가능
```

---

## 시나리오 C: SEO 하락 (`"구글 검색에 안 나와"`)

**매핑**: `/workflow marketing-seo-recovery`

```
훅: [TEAM-MARKETING:acquisition]

Acquisition Lead → seo-audit 5영역
  ✗ Core Web Vitals LCP 4.2초 (기준 2.5)
  ✗ 타이틀 태그 2페이지 누락, H1 3페이지 중복
  ✗ 블로그 3개월 정체
  ✗ 백링크 5개 (경쟁 평균 200+)

Insight Analyst 위임
  content-strategy → 경쟁사 블로그 TOP 20 분석
  4-stage buyer journey 분류 → awareness/consideration/implementation 부재
  
Copy & Content Chief
  content-creator 블로그 6편 초안 + copy-editing

Acquisition 추가
  schema-markup → Article+HowTo+FAQPage 자동
  ai-seo → 명확한 정의 섹션 + Q&A 포맷 (LLM 인용 최적화)
  programmatic-seo → "X vs Y" 비교 페이지 템플릿 5개

사용자 노출:
  [원인 3가지]
    1. 사이트 속도 느림 — team-dev 기술 작업 위임 가능
    2. 콘텐츠 업데이트 멈춤 → 블로그 6편 + 주 2편 자동 발행 제안
    3. 비교 페이지 부재 → 템플릿 5개
  [바로 적용] schema 5개 + 블로그 6편 승인 시 게시 예약
  [결정 필요] /workflow revenue-content 자동 발행 활성화?
```

---

## 시나리오 D: 리텐션 (`"가입하고 금방 나가"`)

**매핑**: `/workflow marketing-retention`

```
훅: [TEAM-MARKETING:growth]

Growth Ops → churn-prevention 진단
  analytics 이벤트 부재 → Acquisition 즉시 위임
  4개 이탈 지표 추가: activation/day_3/day_7/day_14_active

Insight 위임
  customer-research → "가입 후 뭐 해야 할지 모르겠다" 8건

CRO Engineer 병렬
  onboarding-cro → 설정 3스텝이 가치 경험 전 → 순서 재배치 권고

Copy & Content Chief
  email-sequence Re-engagement 3통 (Day 3/7/14)
    Day 3: "첫 리뷰 돌려봤어요?" 1-click
    Day 7: "이런 버그 탐지해드렸어요" 실제 예시
    Day 14: "아직 못 쓰고 계신가요?" 인터뷰 요청
  copy-editing 검수

Growth 통합
  referral-program → 활성 사용자 락인 "친구 초대 시 Pro 무료"

사용자 노출:
  [원인 2가지]
    1. 첫 가치 못 느낌 (설정 강요 → 경험 순서 바꾸기)
    2. 3일 후 연락 0 → 재참여 이메일 3통 준비
  [승인] 이메일 시퀀스 켤까요?
  [측정 세팅] 4개 이탈 지표 추적 시작. 2주 후 자동 리포트
```

---

## 시나리오 E: 주간 콘텐츠 (`"이번 주 SNS 뭐 올려?"`)

**매핑**: `/workflow marketing-weekly-content` (주 1회 자동)

```
훅: [TEAM-MARKETING:copy]

Copy & Content Chief
  온톨로지 최근 블로그 2편 확인 (7일 내)
  PMC Content Pillars 3개 확인

Insight Analyst (경량)
  /research 트렌드 HN TOP + Twitter 개발자 트렌드

Copy 실행
  content-creator → 블로그 2편 리퍼포징 (SNS 클립 4개)
  social-content 플랫폼별 최적화:
    LinkedIn 3건 (carousel 1 + 단문 2)
    Twitter 5건 (스레드 1 + 단문 4)
    Instagram 2건 (이미지 1 + 릴스 1)
  copy-editing 검수

Acquisition 자동
  UTM 삽입 (utm_source per 플랫폼)

사용자 노출:
  [이번 주 10개 준비]
    블로그 기반: LinkedIn 캐러셀 (수), Twitter 스레드 (화)
    트렌드 반응: Instagram 릴스 "MCP 표준 30초" (금)
  [전체 10건 캘린더 첨부] 승인 시 예약 게시
  [SNS MCP 미연결] 수동 게시 링크 Telegram 발송
```

---

## 공통 실행 규칙

1. **PMC 부트스트랩**: 없으면 3-4개 질문. 있으면 건너뜀.
2. **DAG 순서**: 상위 Role(CMO→Insight)이 하위 Role(Copy→CRO→Acquisition→Growth)에 컨텍스트 제공.
3. **copy-editing Seven Sweeps**: 모든 카피 산출물의 자동 검수 레이어.
4. **analytics-tracking**: 모든 시나리오 완료 시 측정 이벤트 자동 제안.
5. **외부 팀 위임**: team-dev(코드), team-accounting(예산), team-secretary(일정) 자동 전달 → 사용자에겐 "다음 단계"에서만 안내.
6. **L3 자율**: 게시·발송 등 되돌릴 수 있는 작업은 SILENT 즉시 실행. 예산 집행·코드 배포는 INFORM.
7. **상태 갱신**: 각 Role 완료 시 state.json.roles.<role>.monthly_* 카운터 증분 + outbox에 role_executed 기록.
