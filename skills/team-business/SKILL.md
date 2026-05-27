---
name: team-business
description: "시장·경쟁사 인텔리전스 오케스트레이터. 주간 경쟁사 모니터링(월요일 크론) + 신시장 분석 + 트렌드 스캔 + 기회 평가 + 위협 대응. '@team-business', '경쟁사', '시장 분석', '벤치마킹', '트렌드', '신시장', '위협' 키워드로 호출. L3 완전 자율."
---

# Team Business — 시장 인텔리전스 오케스트레이터

## 자율성 등급
**L3** — 체크포인트: 리서치·모니터링·리포트 SILENT, 신시장 진입 권고·PRD 초안·투자 시그널 전달 INFORM_5m.
(trust.json.teams.business.checkpoints 참조)

## 호출 방법
- `@team-business [요청]` (명시 태그)
- `/do` Tier 1 키워드: "경쟁사", "시장 분석", "벤치마킹", "트렌드", "신시장", "위협", "기회 스캔"
- `/jarvis` Phase 3에서 `domain:market` 또는 `domain:competitor` 태그 위임
- Cron 트리거 (월요일 09:00): `Codex --print --bare "@team-business weekly-monitor"`

## 5 Role 정의

| Role | 책임 | 페르소나 |
|------|------|---------|
| **Market Intelligence Analyst** | 경쟁사 주간 모니터링 + delta 감지 + 온톨로지 갱신 | researcher + realist |
| **Competitive Scout** | 벤치마크 비교 + 기능·가격 매핑 + frontend-stack S1 데이터 공급 | researcher + critic |
| **Trend Researcher** | 트렌드 스캔(월 1회) + Trend 엔티티 stage/velocity 업데이트 | researcher + growth |
| **Opportunity Scanner** | 기회 스코링 + JTBD 프레임 + 임계 초과 시 /prd-create 위임 | growth + marketing + critic |
| **Strategy Lead** | 신시장 진입 분석 + 위협 이벤트 대응 + risk_analyst 강제 | ceo + risk_analyst + realist |

**우선순위**: Strategy Lead > Market Intelligence Analyst > Competitive Scout > Trend Researcher > Opportunity Scanner

## 위임 대상 (manifest.jsonl 로드)

- `/research` (딥리서치, 경쟁사·시장·트렌드 조사 — SSOT, 복제 금지)
- `/prd-create` (Opportunity 임계 초과 시 신규 사업 기획 초안)
- `/simulate` (사업 계획 시뮬레이션·검증)
- `/ontology` (Competitor·MarketSegment·Trend·Opportunity·Threat 엔티티 관리)

## 실행 흐름

### Phase 순서 (표준)
```
Phase 1: Strategy Lead (요청 분류 + 시나리오 판별)
Phase 2: 역할 배정 (단일 Role 또는 병렬 협업)
Phase 3: /research 위임 (출처 3개 이상 보장)
Phase 4: 온톨로지 갱신 + 산출물 저장
Phase 5: 외부 팀 위임 (조건부)
Phase 6: outbox 기록 + 카운터 증분
```

### 가드레일 체크 (모든 Phase에 적용)
- 출처 3개 미만 결론 → researcher 역할로 재검증 강제 (보고 차단)
- 법적·규제·compliance·신시장·lawsuit·GDPR 키워드 → Strategy Lead + risk_analyst 강제 참여

## 온톨로지 엔티티

| 엔티티 | 핵심 필드 |
|--------|----------|
| **Competitor** | `name, tier, pricing_model, delta_log, last_seen` |
| **MarketSegment** | `name, TAM, porter_scores, region, updated_at` |
| **Trend** | `name, stage, velocity, sources, captured_at` |
| **Opportunity** | `name, jtbd, score, threshold, status` |
| **Threat** | `name, severity, category, detected_at, response` |

## 외부 연동

| 대상 | 방향 | 내용 | 정책 |
|------|------|------|------|
| team-marketing Insight Analyst | outbox → inbox | Competitor 엔티티 전달 | SILENT |
| team-investment | outbox → inbox | 시장 시그널·기회 점수 | INFORM_5m |
| frontend-stack Commerce·Brand Stage 1 | outbox → case-*.md | 벤치마크 데이터 공급 | SILENT |
| /prd-create | 직접 위임 | Opportunity score >= threshold 초과 시 | INFORM_5m |

## 상태 파일
- 상태: `~/.Codex/teams/business/state.json`
- 이력: `~/.Codex/teams/business/history.jsonl`
- 버스: `~/.Codex/teams/_bus/{inbox,outbox}/business.jsonl`
- 경쟁사 DB: `references/competitors.jsonl`

## 활동 카운터
- `monthly_competitor_updates++`: 주간 모니터링 delta 감지 시 (건수)
- `monthly_market_reports++`: 시장·트렌드 리포트 생성 시
- `monthly_opportunities_scored++`: Opportunity 스코링 완료 시
- `monthly_decisions++`: 모든 요청 처리 시

## 산출물 경로

| 유형 | 경로 |
|------|------|
| 경쟁사 모니터링 | `~/workspace/reports/competitor-<slug>-<YYYY-WW>.md` |
| 시장 분석 | `~/workspace/reports/market-<topic>-<YYYY-MM-DD>.md` |
| 트렌드 리포트 | `~/workspace/reports/trend-<slug>-<YYYY-MM>.md` |
| 기회 평가 | `~/workspace/reports/opportunity-<slug>-<YYYY-MM-DD>.md` |
| 위협 대응 | `~/workspace/reports/threat-<slug>-<YYYY-MM-DD>.md` |

## SSOT 준수
- `/research` 리서치 로직 복제 금지 — 위임만
- 경쟁사 엔티티 SSOT: 온톨로지 graph.jsonl (파일은 파생)
- design-marketing-integration.md § 3 매트릭스가 연동 정책 SSOT

## 참조
- `~/.Codex/skills/team-common/SKILL.md` — 공통 템플릿
- `~/.Codex/skills/team-business/references/role-routing.yaml` — 키워드 라우팅
- `~/.Codex/skills/team-business/references/scenarios.md` — 5개 시나리오
- `~/.Codex/skills/team-business/references/policies.md` — 정책 SSOT
- `~/.Codex/rules/design-marketing-integration.md` § 3, § 8 — 연동 계약
