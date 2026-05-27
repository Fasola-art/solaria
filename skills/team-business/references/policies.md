# team-business 정책 (SSOT)


## Contents

- [1. 체크포인트 정책](#1-체크포인트-정책)
  - [SILENT (기본 — 알림 없이 실행)](#silent-기본-알림-없이-실행)
  - [INFORM_5m (5분 유예 후 자동 확정 — Telegram 알림)](#inform_5m-5분-유예-후-자동-확정-telegram-알림)
- [2. 출처 검증 규칙 (가드레일 #1)](#2-출처-검증-규칙-가드레일-1)
- [3. risk_analyst 강제 참여 (가드레일 #2)](#3-risk_analyst-강제-참여-가드레일-2)
- [4. 온톨로지 엔티티 관리 규칙](#4-온톨로지-엔티티-관리-규칙)
- [5. 외부 연동 규약](#5-외부-연동-규약)
  - [team-marketing Insight Analyst](#team-marketing-insight-analyst)
  - [team-investment](#team-investment)
  - [frontend-stack Commerce·Brand Stage 1](#frontend-stack-commercebrand-stage-1)
  - [/prd-create](#prd-create)
- [6. Role 책임 분담 (SSOT)](#6-role-책임-분담-ssot)
- [7. 산출물 경로 (SSOT)](#7-산출물-경로-ssot)
- [8. outbox 메시지 스키마 (team-common 확장)](#8-outbox-메시지-스키마-team-common-확장)
- [9. 가드레일 매트릭스](#9-가드레일-매트릭스)

team-common 규약 준수. outbox/decisions/manifest/trust SSOT는 team-common/SKILL.md 참조.
승인 정책 enum 및 팀 × 액션 매트릭스 최종값: rules/design-marketing-integration.md § 8.

---

## 1. 체크포인트 정책

### SILENT (기본 — 알림 없이 실행)
| 액션 | 근거 |
|------|------|
| 경쟁사 리서치·모니터링 | 읽기 전용, 되돌릴 수 있음 |
| 시장 분석 리포트 생성 | 내부 문서, 외부 영향 없음 |
| 트렌드 스캔 리포트 생성 | 내부 문서, 외부 영향 없음 |
| 온톨로지 엔티티 갱신 | 내부 데이터베이스 업데이트 |
| team-marketing Insight 엔티티 전달 | 정보 전달, 액션 없음 |
| frontend-stack S1 벤치마크 데이터 공급 | 읽기 전용 데이터 공급 |
| Opportunity 스코링 (임계값 미달) | 내부 계산, 외부 영향 없음 |

### INFORM_5m (5분 유예 후 자동 확정 — Telegram 알림)
| 액션 | 근거 |
|------|------|
| 신시장 진입 권고 발행 | 사업 방향 결정에 영향 |
| /prd-create 위임 (Opportunity 임계 초과) | 새 프로젝트 생성 트리거 |
| team-investment 시장 시그널 전달 | 투자 결정에 영향 가능 |
| Threat severity: critical 보고 | 긴급 대응 요구 |

**INFORM_5m 절차**:
1. Telegram `[INFO]` "작업 시작 예정 — 5분 내 `/cancel <trace_id>` 응답 가능" 전송
2. 5분 대기
3. `/cancel` 수신 시 → outbox `abandoned` 기록, 실행 중단
4. 5분 경과 → 자동 실행

---

## 2. 출처 검증 규칙 (가드레일 #1)

**규칙**: 모든 결론은 독립 출처 3개 이상 필수.

```
검증 기준:
  - 독립 출처: 동일 회사/운영 미디어는 1개로 산정
  - 허용 소스: G2·Capterra·TrustRadius(리뷰), Reddit·HN(커뮤니티),
               공식 발표·채용 공고(1차), 업계 리포트(Gartner·CB Insights 등),
               언론 보도, arXiv/학술 논문
  - 우선 소스: 1차 출처 > 업계 리포트 > 언론 > 커뮤니티
```

**미달 시 처리**:
1. researcher 역할 재검증 강제 (추가 검색 1회)
2. 재검증 후에도 3개 미달 → 불확실성 명시 후 "추가 검증 필요" 표시
3. critical 결론은 3개 미달 시 보고 차단 (불확실 상태 유지)

---

## 3. risk_analyst 강제 참여 (가드레일 #2)

**트리거 키워드**:
```yaml
force_risk_analyst_with:
  - 법적
  - 규제
  - compliance
  - 신시장
  - lawsuit
  - GDPR
  - 진입 장벽
  - 규제 리스크
  - 법적 이슈
```

**강제 시 동작**:
1. Strategy Lead + risk_analyst 페르소나 강제 활성화
2. 결론에 리스크 섹션 필수 포함
3. 법적·규제 항목은 "전문가 검토 권장" 문구 자동 추가

---

## 4. 온톨로지 엔티티 관리 규칙

| 엔티티 | 생성 조건 | 갱신 주기 | 삭제 조건 |
|--------|----------|----------|----------|
| Competitor | 신규 경쟁사 발견 시 | 주 1회 (모니터링 시) | 사업 철수 확인 후 `status: inactive` |
| MarketSegment | 신시장 분석 시 | 분석 시마다 | 미사용 6개월 이상 |
| Trend | 트렌드 스캔 시 | 월 1회 | stage: plateau + 관련성 3 미만 |
| Opportunity | Opportunity 스코링 시 | 스코링 시마다 | status: closed (PRD 생성 또는 기각) |
| Threat | 위협 감지 시 | 대응 진행 중 갱신 | response: resolved |

**Competitor tier 정의**:
- `tier1`: 직접 경쟁, 동일 ICP, 주요 feature 겹침 70%+
- `tier2`: 간접 경쟁, 일부 ICP 겹침, feature 겹침 30-70%
- `tier3`: 잠재 경쟁, 관련 시장, 미래 진입 가능성

**Opportunity threshold**:
- 기본값: 70/100
- 초과 시: INFORM_5m + /prd-create 위임 준비
- 프로젝트별 threshold는 MarketSegment 엔티티에 커스텀 설정 가능

---

## 5. 외부 연동 규약

### team-marketing Insight Analyst
- **방향**: team-business outbox → team-marketing inbox
- **내용**: Competitor 엔티티 갱신 알림 (delta_log 포함)
- **정책**: SILENT
- **스키마**:
  ```json
  {
    "to": "team-marketing",
    "intent": "competitor_update",
    "payload": {
      "entity_type": "Competitor",
      "entity_id": "<id>",
      "delta": { "field": "pricing_model", "old": "X", "new": "Y" }
    }
  }
  ```

### team-investment
- **방향**: team-business outbox → team-investment inbox
- **내용**: 시장 시그널·기회 점수·위협 심각도
- **정책**: INFORM_5m
- **조건**: Opportunity.score >= 80 또는 Threat.severity = critical

### frontend-stack Commerce·Brand Stage 1
- **방향**: team-business outbox → frontend-stack case-*.md S1 컨텍스트
- **내용**: 경쟁사 기능·가격 벤치마크 매트릭스
- **정책**: SILENT
- **시점**: Competitive Scout 시나리오 완료 후 자동

### /prd-create
- **방향**: 직접 위임
- **조건**: Opportunity.score >= Opportunity.threshold
- **정책**: INFORM_5m (사용자 확인 후 실행)

---

## 6. Role 책임 분담 (SSOT)

| 경계 | 소유 Role | 비고 |
|------|----------|------|
| 주간 경쟁사 모니터링 + delta 감지 | Market Intelligence Analyst | 크론 트리거 전담 |
| 벤치마크 비교 매트릭스 | Competitive Scout | frontend-stack 데이터 공급 전담 |
| 트렌드 스캔·분류·velocity 측정 | Trend Researcher | 월 1회 정기 + 요청 시 |
| Opportunity 스코링 + JTBD | Opportunity Scanner | /prd-create 위임 결정권 |
| 신시장 진입·위협 대응·종합 전략 | Strategy Lead | risk_analyst 렌즈 필수 |

---

## 7. 산출물 경로 (SSOT)

| 유형 | 경로 |
|------|------|
| 경쟁사 모니터링 | `~/workspace/reports/competitor-weekly-<YYYY-WW>.md` |
| 경쟁사 벤치마크 | `~/workspace/reports/competitor-benchmark-<slug>-<YYYY-MM-DD>.md` |
| 시장 분석 | `~/workspace/reports/market-<topic>-<YYYY-MM-DD>.md` |
| 트렌드 스캔 | `~/workspace/reports/trend-<domain>-<YYYY-MM>.md` |
| 기회 평가 | `~/workspace/reports/opportunity-<slug>-<YYYY-MM-DD>.md` |
| 위협 대응 | `~/workspace/reports/threat-<slug>-<YYYY-MM-DD>.md` |
| 팀 상태 | `~/.claude/teams/business/state.json` |
| outbox | `~/.claude/teams/_bus/outbox/business.jsonl` |

---

## 8. outbox 메시지 스키마 (team-common 확장)

```json
{
  "msg_id": "uuid",
  "ts": "ISO8601",
  "from": "team-business",
  "to": "<target_team_or_skill>",
  "result": "success|partial|failed",
  "summary": "1-2줄 요약",
  "artifacts": ["경로1"],
  "metrics": {
    "role_executed": "market-intelligence-analyst|competitive-scout|trend-researcher|opportunity-scanner|strategy-lead",
    "scenario": "weekly-monitor|market-entry|benchmark|trend-scan|threat-response|ad-hoc",
    "sources_count": 0,
    "entities_updated": 0
  },
  "trace_id": "uuid"
}
```

---

## 9. 가드레일 매트릭스

| 트리거 | 가드레일 | 동작 |
|--------|---------|------|
| 출처 < 3개 | 출처 검증 | researcher 재검증 강제 → 미달 시 불확실 표시 |
| 법적·규제·GDPR·신시장·lawsuit 키워드 | risk_analyst 강제 | Strategy Lead + risk_analyst 페르소나 강제 활성 |
| Opportunity.score >= threshold | PRD 위임 | INFORM_5m → /prd-create |
| Threat.severity = critical | 즉시 보고 | INFORM_5m + Telegram [INFO] 즉시 전송 |
| 경쟁사 delta_log: legal/lawsuit | 법적 가드레일 | Strategy Lead + risk_analyst 자동 개입 |
| 동일 파일 병렬 수정 시도 | 오케스트레이션 | 병렬 실행 차단, 순차 처리로 전환 |
