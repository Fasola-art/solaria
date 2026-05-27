# team-business 실행 시나리오 5종


## Contents

- [시나리오 A: 주간 경쟁사 모니터링 (Cron 트리거)](#시나리오-a-주간-경쟁사-모니터링-cron-트리거)
- [시나리오 B: 신시장 진입 분석 (`"동남아 시장 진입 어떻게 봐?"`)](#시나리오-b-신시장-진입-분석-동남아-시장-진입-어떻게-봐)
- [시나리오 C: 제품 벤치마크 (`"우리 제품 경쟁사 대비 어디 부족해?"`)](#시나리오-c-제품-벤치마크-우리-제품-경쟁사-대비-어디-부족해)
- [시나리오 D: 트렌드 스캔 (월 1회 자동 또는 요청)](#시나리오-d-트렌드-스캔-월-1회-자동-또는-요청)
- [시나리오 E: 위협 이벤트 대응 (`"경쟁사 A가 우리 핵심 기능 복사해서 무료로 풀었어"`)](#시나리오-e-위협-이벤트-대응-경쟁사-a가-우리-핵심-기능-복사해서-무료로-풀었어)
- [공통 실행 규칙](#공통-실행-규칙)

자연어 요청 → 자동 진단 → 5 Role 협업 → 인사이트 리포트 산출.

**공통 원칙**:
- 출처 3개 미만 결론 시 researcher 역할로 재검증 강제 (보고 차단)
- 법적·규제·신시장·compliance 키워드 → Strategy Lead + risk_analyst 강제 참여
- 결과 구조: "핵심 발견 N가지 → 전략적 시사점 → 권고 액션 + 승인 필요 포인트"
- 외부 팀 위임 필요 시 자동 전달 후 결과에서 안내

---

## 시나리오 A: 주간 경쟁사 모니터링 (Cron 트리거)

**트리거**: 매주 월요일 09:00 — `claude --print --bare "@team-business weekly-monitor"`
**주 Role**: Market Intelligence Analyst

```
훅 체인
  cron-trigger: "weekly-monitor" → [TEAM-BUSINESS:market-intelligence-analyst]
  persona-activator: researcher + realist 활성화

Phase 1: 대상 로드
  references/competitors.jsonl에서 모니터링 대상 경쟁사 목록 로드
  온톨로지 Competitor 엔티티 last_seen 확인 (7일 초과 → 우선 처리)

Phase 2: 병렬 리서치 (경쟁사 N개 동시)
  각 경쟁사에 대해 /research quick "[경쟁사명] 최근 1주 업데이트"
    - 신규 기능·제품 발표
    - 가격 변경 (pricing_model delta)
    - 채용 공고 (전략 방향 추론)
    - 언론 보도·블로그·SNS 동향
  출처 3개 이상 확보 필수 (미달 시 재검색)

Phase 3: Delta 감지 및 분류
  전주 Competitor.delta_log 비교
  변경 분류: feature / pricing / personnel / partnership / funding / legal
  중요도 스코링: critical / high / medium / low

Phase 4: 온톨로지 갱신
  /ontology update: Competitor.last_seen, delta_log 추가
  중요도 critical/high → Threat 엔티티 자동 생성

Phase 5: 산출물 저장
  ~/workspace/reports/competitor-weekly-<YYYY-WW>.md 저장
  포맷: 경쟁사별 요약 카드 + delta 하이라이트 + 중요도 순 정렬

Phase 6: 외부 연동
  team-marketing Insight Analyst outbox 전달: Competitor 엔티티 갱신 알림
  frontend-stack S1 활성 케이스 있으면 벤치마크 데이터 공급
  Threat 신규 생성 시 → 시나리오 E(위협 대응) 자동 트리거 고려

Phase 7: 기록
  outbox: business.jsonl role_executed: market-intelligence-analyst
  monthly_competitor_updates += delta 감지 건수
  monthly_decisions++
  Telegram [INFO]: "경쟁사 N건 업데이트 감지. 리포트: <경로>"

사용자 노출 결과:
  [이번 주 경쟁사 동향 요약]
    - 경쟁사 A: 가격 15% 인하 (pricing delta — 중요도: high)
    - 경쟁사 B: 신기능 X 발표 (feature delta — 중요도: medium)
  [전략적 시사점] 가격 경쟁 압력 + 기능 격차 주의
  [권고] 대응 필요 시 → "@team-business 위협 대응: 경쟁사 A 가격 인하"
```

---

## 시나리오 B: 신시장 진입 분석 (`"동남아 시장 진입 어떻게 봐?"`)

**주 Role**: Strategy Lead (risk_analyst 강제 포함)

```
훅 체인
  keyword-detector: "신시장/진입" → [TEAM-BUSINESS:strategy-lead]
  persona-activator: ceo + risk_analyst + realist 3종 활성화
  force_risk_analyst: true (신시장 키워드)

Phase 1: Strategy Lead — 시장 정의
  대상 시장·지역·세그먼트 명확화
  포터 5력 프레임 설정 (진입 장벽/공급자/구매자/대체재/경쟁 강도)
  MarketSegment 엔티티 생성 (TAM/porter_scores 초기화)

Phase 2: Market Intelligence Analyst — 시장 조사 (병렬)
  /research deep "[시장] TAM/SAM/SOM 규모"
  /research deep "[시장] 규제·법적 요건·compliance"
  /research deep "[시장] 현지 경쟁사 TOP 5"
  출처 3개 이상 필수 (미달 시 재검색 강제)

Phase 3: Competitive Scout — 경쟁 매핑
  현지 + 글로벌 경쟁사 포지셔닝 맵
  가격·기능·채널 비교 매트릭스
  차별화 기회 포인트 도출

Phase 4: Opportunity Scanner — 기회 스코링
  JTBD 프레임: 고객 과제 + 현재 해결 방식 + 미충족 수요
  Opportunity 엔티티 생성 (jtbd/score/threshold)
  score >= threshold → /prd-create 위임 준비 (INFORM_5m)

Phase 5: Strategy Lead — 종합 판단 (risk_analyst 관점)
  진입 가능성 평가: 기회 점수 × 리스크 점수
  규제 리스크 명시 (법적·compliance 항목)
  권고 3가지: 진입 / 관망 / 파트너십 진입

Phase 6: 산출물 저장
  ~/workspace/reports/market-<region>-entry-<YYYY-MM-DD>.md

Phase 7: 외부 연동 (조건부)
  Opportunity score >= threshold → /prd-create 위임 (INFORM_5m)
  투자 시그널 있으면 → team-investment outbox 전달 (INFORM_5m)

사용자 노출 결과:
  [시장 현황] TAM X억 / 현지 경쟁 3개사 / 진입 장벽 중간
  [기회 점수] 72/100 — 임계값(70) 초과 → PRD 초안 생성 가능
  [리스크] 규제 A 필수, 현지화 비용 예상 X억
  [권고] 파트너십 진입 추천 (이유: 규제 리스크 분산 + 빠른 진출)
    대안 단점: 직접 진입은 빠르지만 규제 준수 비용 2배
  [승인 필요] PRD 초안 작성할까요? (5분 이내 취소 가능)
```

---

## 시나리오 C: 제품 벤치마크 (`"우리 제품 경쟁사 대비 어디 부족해?"`)

**주 Role**: Competitive Scout

```
훅 체인
  keyword-detector: "벤치마킹/비교" → [TEAM-BUSINESS:competitive-scout]
  persona-activator: researcher + critic 활성화

Phase 1: 비교 대상 확정
  온톨로지 Competitor 엔티티 로드 (tier 1 우선)
  비교 축 설정: 기능 / 가격 / UX / 성능 / 지원 / 통합 / 생태계

Phase 2: Competitive Scout — 데이터 수집
  /research medium "[경쟁사] 기능 목록·가격·사용자 리뷰" (G2/Capterra/Reddit)
  각 경쟁사별 출처 3개 이상
  기능 매트릭스 구성 (있음/없음/부분)

Phase 3: Market Intelligence Analyst — 검증
  수집 데이터 교차 검증
  delta_log와 최신 정보 일치 여부 확인

Phase 4: 비교 분석 산출
  기능 격차 매트릭스 (우리 약점 / 강점 / 기회)
  포지셔닝 갭 도식화
  frontend-stack S1 데이터 패키지 준비 (Commerce·Brand 케이스 시)

Phase 5: 산출물 + 연동
  ~/workspace/reports/competitor-benchmark-<slug>-<YYYY-MM-DD>.md
  frontend-stack 활성 케이스 → Stage 1 벤치마크 데이터 자동 공급 (SILENT)
  team-marketing Insight Analyst → Competitor 엔티티 갱신 알림

Phase 6: 기록
  monthly_competitor_updates++
  monthly_decisions++

사용자 노출 결과:
  [우리 강점] A기능, B통합 (경쟁사 대부분 미보유)
  [격차 3가지]
    1. 모바일 앱 미지원 (경쟁사 4개사 지원)
    2. API 문서 부족 (G2 리뷰 12건 언급)
    3. 가격 투명성 (비교 페이지 없음)
  [권고] 모바일 로드맵 우선순위 검토 → team-dev 위임 가능
```

---

## 시나리오 D: 트렌드 스캔 (월 1회 자동 또는 요청)

**주 Role**: Trend Researcher
**기본 스케줄**: 월 1회 (크론 또는 수동 트리거)

```
훅 체인
  keyword-detector: "트렌드/emerging" → [TEAM-BUSINESS:trend-researcher]
  persona-activator: researcher + growth 활성화

Phase 1: 스캔 범위 설정
  도메인 확인: 기술 트렌드 / 시장 트렌드 / 소비자 행동 / 규제 흐름
  온톨로지 기존 Trend 엔티티 로드 (stage/velocity 현황 파악)

Phase 2: Trend Researcher — 데이터 수집 (병렬)
  /research medium "기술 트렌드 [도메인] [YYYY-MM]"
    소스: HN TOP / arXiv / CB Insights / Gartner Hype Cycle / 업계 리포트
  /research medium "소비자 행동 변화 [도메인]"
  /research medium "규제·법적 흐름 [도메인]"
  각 소스 출처 3개 이상

Phase 3: 트렌드 분류 및 스코링
  Gartner 단계: innovation-trigger / peak / trough / slope / plateau
  velocity: fast(6개월내) / medium(1-2년) / slow(3년+)
  우리 사업 관련성 스코어 (1-10)

Phase 4: 온톨로지 갱신
  /ontology update: Trend 엔티티 stage/velocity/sources 갱신
  신규 트렌드 → Opportunity Scanner 자동 연계 (score 계산)

Phase 5: 산출물
  ~/workspace/reports/trend-<domain>-<YYYY-MM>.md
  포맷: 트렌드 카드 (이름/단계/속도/우리 관련성/액션)

Phase 6: 기록
  monthly_market_reports++
  monthly_decisions++
  Telegram [INFO]: "월간 트렌드 스캔 완료. N개 트렌드 감지"

사용자 노출 결과:
  [이달 주요 트렌드 N개]
    1. AI 에이전트 통합 (단계: slope, 속도: fast) — 관련성: 9/10
    2. 규제 X 시행 예정 (단계: trough, 속도: medium) — 관련성: 7/10
  [기회로 전환 가능] AI 에이전트 → Opportunity Scanner 연계됨
  [주의 트렌드] 규제 X → Strategy Lead 검토 권고
```

---

## 시나리오 E: 위협 이벤트 대응 (`"경쟁사 A가 우리 핵심 기능 복사해서 무료로 풀었어"`)

**주 Role**: Strategy Lead (risk_analyst 강제)

```
훅 체인
  keyword-detector: "위협/위협 대응/경쟁사 공격" → [TEAM-BUSINESS:strategy-lead]
  persona-activator: ceo + risk_analyst + realist 강제 활성화
  force_risk_analyst: true

Phase 1: 위협 분류 및 긴급도 판단
  Threat 엔티티 생성 (severity: critical/high/medium, category: pricing/feature/legal/partnership)
  즉각 대응 필요 여부 판단 (critical → 즉시, high → 24h, medium → 주간)

Phase 2: 시장 영향 분석 (병렬)
  Market Intelligence Analyst
    /research quick "[경쟁사] [이벤트] 최신 정보" — 출처 3개
    사용자 반응 수집 (SNS·커뮤니티·리뷰)
  Competitive Scout
    기능·가격 delta 매핑
    우리 현재 포지션 재평가

Phase 3: Strategy Lead — 대응 옵션 도출
  risk_analyst 렌즈: 법적·규제 검토 필요 여부
  realist 렌즈: 실행 가능한 대응 vs 과잉 대응 구분
  대응 옵션 3가지 (즉각·중기·장기)

Phase 4: 권고 및 외부 위임
  team-marketing Insight Analyst → 포지셔닝 메시지 수정 요청 (SILENT)
  PRD 수정 필요 시 → /prd-create 위임 (INFORM_5m)
  투자 시그널 변화 → team-investment outbox (INFORM_5m)

Phase 5: 산출물
  ~/workspace/reports/threat-<slug>-<YYYY-MM-DD>.md
  Threat 엔티티 온톨로지 갱신 (response 필드 업데이트)

Phase 6: 기록
  monthly_decisions++
  Telegram [INFO]: "위협 이벤트 대응 완료. 심각도: <level>"

사용자 노출 결과:
  [위협 요약] 경쟁사 A — 핵심 기능 무료화. 심각도: high
  [시장 반응] 커뮤니티 X에서 우리 대안 문의 12건 (기회)
  [대응 옵션 3가지]
    즉각: 차별화 카피 업데이트 → team-marketing 위임 가능
    중기: 프리미엄 기능 강화 로드맵 → team-dev 협의
    장기: 파트너십 생태계 구축
  [추천] 즉각 대응 먼저. 이유: 커뮤니티 문의 전환 기회
    대안 단점: 장기 대응만 하면 단기 사용자 이탈 위험

```

---

## 공통 실행 규칙

1. **출처 검증**: 모든 결론은 출처 3개 이상. 미달 시 researcher 역할 재검증 (보고 차단).
2. **risk_analyst 강제**: 법적·규제·compliance·신시장·lawsuit·GDPR 키워드 포함 시 Strategy Lead + risk_analyst 자동 참여.
3. **병렬 가능 조건**: Phase 간 데이터 의존성 없을 때 Role 병렬 실행. 동일 파일 동시 수정 금지.
4. **온톨로지 우선**: 기존 Competitor/Trend/MarketSegment 엔티티 먼저 조회 후 /research 위임.
5. **SILENT 기본**: 리서치·모니터링·리포트는 알림 없이 실행. INFORM_5m 대상만 예외.
6. **외부 팀 전달**: team-marketing·team-investment·frontend-stack 자동 위임 후 결과에서 안내.
7. **상태 갱신**: Role 완료 시 state.json 카운터 증분 + outbox에 role_executed 기록.
