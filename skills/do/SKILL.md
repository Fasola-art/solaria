---
name: do
description: "4-Tier 자동 라우팅. 사용자 요청을 분석하여 적절한 워크플로우/스킬/에이전트로 자동 연결. /do [요청]으로 호출. /do continue로 진행 중 캠페인 재개."
---

# 4-Tier 라우팅 스킬

$ARGUMENTS를 분석하여 가장 적합한 실행 경로를 선택한다.

## 라우팅 순서

### Tier 1: 패턴 매칭 (즉시, 토큰 0)
정규식으로 키워드 매칭:

**팀 라우팅 (최우선, @team-* 태그 또는 도메인 키워드)**:
- "@team-dev|PR 리뷰|배포|빌드|테스트 실행" → team-dev
- "@team-secretary|일정|캘린더|미팅|리마인드" → team-secretary
- "@team-accounting|지출|예산|장부|영수증|정산" → team-accounting
- "@team-investment|시세|포트폴리오|매매|종목|주식" → team-investment
- "@team-marketing|콘텐츠 게시|캠페인|SNS|인스타|유튜브|카피|헤드라인|랜딩|CRO|전환율|A/B|온보딩|팝업|페이월|SEO|스키마|유료 광고|구글 광고|메타 광고|애드|analytics|GA|UTM|VOC|JTBD|페르소나|경쟁사|포지셔닝|ICP|이탈률|해지|리텐션|레퍼럴|커뮤니티|리드 매그넷|피치덱|RevOps|런칭|가격 전략|마케팅|브랜드 보이스|이메일 시퀀스|콜드 이메일|광고 소재" → team-marketing (내부 6-Role 라우팅: CMO/Insight/Copy/CRO/Acquisition/Growth)
- "@team-business|경쟁사|시장 분석|벤치마킹|트렌드" → team-business
- "@team-pm|PRD 섹션|8섹션 PRD|OKR|스프린트|리트로|회고|유저 스토리|잡 스토리|릴리즈 노트|프리모템|pre-mortem|이해관계자 맵|가설|assumption|OST|opportunity tree|기회 트리|인터뷰|실험 설계|BMC|Lean Canvas|린 캔버스|9섹션|Pricing|가격 전략|사업성 검토|포지셔닝|SWOT|PESTLE|Porter|Ansoff|페르소나|CJM|고객 여정|TAM|SAM|SOM|시장 크기|sentiment|감성 분석|SQL|cohort|코호트|A/B 분석|A/B 결과|유의성|효과크기|GTM|Go-to-Market|Beachhead|비치헤드|ICP|Growth Loop|성장 루프|Battlecard|배틀카드|PLG|SLG|이력서|resume|NDA|비밀유지|개인정보처리방침|privacy policy|문법|교정|grammar" → team-pm (내부 7-Role: Strategist/Discovery/Execution/Research/Analytics/GTM/Toolkit)

**일반 스킬 라우팅**:
- "브리핑|오늘 뭐" → /workflow briefing
- "강의|lecture" → /workflow content lecture $ARGUMENTS
- "블로그|blog" → /workflow content blog $ARGUMENTS
- "코딩|코드|개발|만들어" → /workflow code $ARGUMENTS
- "리서치|조사|분석" → /workflow research $ARGUMENTS
- "수익|기회|스카우트" → /workflow revenue-scout
- "에러|수정|fix" → /autofix
- "온톨로지|그래프|관계" → /ontology $ARGUMENTS
- "채널|텔레그램|설정" → /channel-guide
- "continue|이어서|재개" → 캠페인 재개 (아래 참조)
- "프로젝트 만들어|MVP|자율 개발|jarvis" → /jarvis $ARGUMENTS
- "PRD|기획서|사업성" → /prd-create $ARGUMENTS
- "시뮬레이션|검증|simulate" → /simulate $ARGUMENTS
- "빠르게|qk|바로" + 코딩 요청 → /workflow code --vibe $ARGUMENTS

**라우팅 규칙**:
- 팀 태그 `@team-*`은 **무조건 우선** (명시적 지정)
- 도메인 키워드는 점수 기반 매칭: 2개 이상 매칭 시 팀 라우팅
- 팀과 일반 스킬 키워드가 둘 다 매칭되면 **팀 우선** (팀이 상위 오케스트레이터)
- 예: "블로그 배포" → team-marketing (marketing이 블로그보다 구체적)

### 전문 도메인 트리거 (Tier 1 확장)
| 트리거 | 키워드 | 우선순위 | 라우팅 |
|--------|--------|---------|--------|
| security | 보안, 취약점, CVE, vulnerability | Critical(자동) | reviewer (보안 차원 집중) |
| build_error | 빌드 에러, build fail, 컴파일 에러 | Critical(자동) | /autofix |
| test_failure | 테스트 실패, test fail, 테스트 깨짐 | Critical(자동) | /autofix |
| refactor | 리팩토링, refactor, 구조 개선 | High(추천) | worker + reviewer 검증 |
| architecture | 아키텍처, 설계, architecture | High(추천) | 메인 스레드 (설계는 LLM 직접) |
| database | DB, 데이터베이스, migration, 스키마 | Medium(추천) | worker |
| code_review | 코드 리뷰, review, PR 검토 | Low(추천) | reviewer (품질 게이트) |

Critical = 즉시 실행, High/Medium/Low = "추천: [에이전트/스킬]로 처리할까요?" 확인 후 실행

### Tier 2: 세션 상태 확인 (토큰 0)
~/workspace/workflows/state/에서 in_progress 상태의 워크플로우 확인:
- 있으면 → "진행 중인 [워크플로우명]이 있습니다. 이어서 할까요?" 확인

### Tier 3: 키워드 매칭 (토큰 0)
스킬 description과 매칭:
- 등록된 모든 스킬의 description에서 키워드 검색
- 가장 관련성 높은 스킬 선택

### Tier 4: LLM 분류 (~500 토큰)
Tier 1~3에서 매칭 실패 시:
- 요청의 복잡도 분석
- 단순 → worker(haiku) 위임
- 중간 → worker(sonnet) 위임
- 복잡 → 메인 스레드에서 직접 처리

## 캠페인 재개 (/do continue)

1. ~/workspace/campaigns/ 스캔
2. 가장 최근 campaign.json 읽기
3. 현재 단계 + 결정 이력 복원
4. 이어서 작업

## 캠페인 생성 (장기 작업 시)

예상 기간이 1세션 이상인 작업은 자동으로 캠페인 생성:
```
~/workspace/campaigns/[캠페인명]/
├── campaign.json     # 목표, 현재 단계, 결정 이력
├── decisions.md      # 주요 의사결정 기록
└── progress.md       # 진행 상황 요약
```
