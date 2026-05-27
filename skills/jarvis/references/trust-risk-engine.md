# Trust & Activity 엔진 (L3 하이브리드 v2)


## Contents

- [1. 기본 정책](#1-기본-정책)
- [2. Trust Score (관찰용, 차단 아님)](#2-trust-score-관찰용-차단-아님)
- [3. 체크포인트 (팀별 설정)](#3-체크포인트-팀별-설정)
  - [체크포인트 타입](#체크포인트-타입)
  - [INFORM 구현 규칙 (team-common 참조)](#inform-구현-규칙-team-common-참조)
  - [GATE 구현 규칙 (team-common 참조)](#gate-구현-규칙-team-common-참조)
- [4. Activity 통계 (Budget 대체, Paperclip P2)](#4-activity-통계-budget-대체-paperclip-p2)
  - [공통 필드](#공통-필드)
  - [팀별 확장 지표](#팀별-확장-지표)
  - [수집 방식 (모두 CLI 전용 호환)](#수집-방식-모두-cli-전용-호환)
- [5. 폐기된 개념 (v1 → v2)](#5-폐기된-개념-v1-v2)
- [6. 파일 위치](#6-파일-위치)
- [7. 참조](#7-참조)

> 2026-04-11 L3 하이브리드 개편. 기존 3중 게이트, Risk 승수, 일일 한도, HITL 7 신호는 **폐기**. 팀별 체크포인트 + 관찰용 Activity 통계로 대체.

## 1. 기본 정책

**L3 하이브리드**: 기본은 완전 자율(SILENT), 특정 팀/액션만 선별적 체크포인트.

```
일상 업무    → SILENT (즉시 실행)
team-dev     → INFORM 5분 유예 (구현 시작, 배포 시작)
team-investment → GATE 24h (매매/리밸런싱/손절/이체)
```

## 2. Trust Score (관찰용, 차단 아님)

trust.json v2의 `teams.<name>.score`는 **실행 차단에 사용하지 않음**. 통계·시각화 목적만.

초기값: 1.0 (모든 팀 신뢰 최대)

Score는 결과 이력 반영을 위해 누적 갱신:
- 성공 시 `successes++` (score는 1.0 유지)
- 실패 시 `failures++` (score 소폭 하락)
- 하락 공식: `score = max(0.5, 1.0 - failures × 0.05)` (최소 0.5 하한, 완전 실추 방지)

## 3. 체크포인트 (팀별 설정)

`trust.json.teams.<name>.checkpoints`에 팀 단위로 선언:

```json
"dev": {
  "checkpoints": {
    "implementation_start": { "type": "INFORM", "grace_seconds": 300 },
    "deploy_start": { "type": "INFORM", "grace_seconds": 300 }
  }
},
"investment": {
  "checkpoints": {
    "trade_order":    { "type": "GATE", "timeout_seconds": 86400 },
    "rebalancing":    { "type": "GATE", "timeout_seconds": 86400 },
    "stop_loss":      { "type": "GATE", "timeout_seconds": 86400 },
    "funds_transfer": { "type": "GATE", "timeout_seconds": 86400 }
  }
}
```

### 체크포인트 타입

| Type | 동작 | 사용자 개입 |
|---|---|---|
| `SILENT` | 즉시 실행 (기본값, checkpoints에 미선언) | 없음 |
| `INFORM` | Telegram 사전 보고 → `grace_seconds` 유예 → `/cancel <trace_id>` 미수신 시 실행 | 선택적 취소 |
| `GATE` | Telegram 승인 요청 → `/approve` 또는 `/reject` 명시 응답 필수 → timeout 시 pending 보류 | 필수 승인 |

### INFORM 구현 규칙 (team-common 참조)
1. Telegram `reply` 도구로 "작업 시작 예정 — 5분 내 `/cancel <trace_id>` 응답 가능" 전송
2. 팀 스킬은 **5분 동안 worker 에이전트를 절대 호출하지 않음** (R24 완화)
3. 5분 경과 직전 `_bus/outbox/<team>.jsonl` 폴링 및 Session A가 수신한 cancel 메시지 확인
4. 취소 없으면 worker 호출 (이 시점부터 취소 불가)

### GATE 구현 규칙 (team-common 참조)
1. Telegram으로 주문 상세 + `/approve <trace_id>` 또는 `/reject <trace_id>` 전송
2. 리마인드 알림: 만료 6h / 12h / 1h 전
3. 최후 1h는 CRITICAL prefix `[CRIT]`
4. `/approve` 수신 시 실행, `/reject` 수신 시 `rejected_by_user` 기록
5. timeout 무응답 시 `pending` 상태 유지 (자동 거부 아님, 사용자 재확인 대기)

## 4. Activity 통계 (Budget 대체, Paperclip P2)

L3 + Claude Max/Pro 구독 환경에서 토큰/USD 추적은 무의미. 대신 **실제 활동량**을 기록.

### 공통 필드
- `monthly_decisions`: 팀이 처리한 의사결정 건수
- `last_activity`: 마지막 활동 ISO8601

### 팀별 확장 지표
- **team-dev**: `monthly_prs_reviewed`, `monthly_deploys`, `monthly_healings`
- **team-secretary**: `monthly_briefings_sent`, `monthly_schedule_conflicts_resolved`
- **team-accounting**: `monthly_transactions`, `monthly_ledger_entries`, `outliers_detected`
- **team-investment**: `monthly_trade_signals`, `monthly_trades_executed`, `monthly_approvals`, `monthly_rejections`, `portfolio_delta_krw`
- **team-marketing**: `monthly_content_published`, `monthly_campaigns_completed`
- **team-business**: `monthly_competitor_updates`, `monthly_reports_generated`

### 수집 방식 (모두 CLI 전용 호환)
- 팀 실행 완료 시 outbox append → state.json → trust.json.teams.<name>.activity 증분
- 월 1일 team-accounting이 집계 → Telegram 리포트 전송
- 파일 기반, 실시간, Claude API 불필요

## 5. 폐기된 개념 (v1 → v2)

| 폐기 항목 | 폐기 이유 |
|---|---|
| 3중 게이트 (trust≥0.85 AND risk≤0.5 AND pattern≥3) | L3 단일 자율성으로 게이트 불필요 |
| Risk 테이블 + 승수 (financial 1.5x 등) | 팀별 checkpoints로 개별 지정이 더 명확 |
| `daily_auto_approved` 카운터, `daily_limit` | 자율 실행 제한 불필요 |
| HITL 7개 불확실성 신호 | 사용자가 명시적 L3 선택, 불확실성 게이트 제거 |
| 금융/삭제/배포 자동 GATE 강제 | 팀별 checkpoints로 선별 (investment=GATE, dev=INFORM, 나머지=SILENT) |
| Phase당 100K / 프로젝트당 500K 토큰 비용 가드 | Max/Pro 구독 + 월정액 환경에서 무의미 |

## 6. 파일 위치

- `~/.claude/jarvis/trust.json` — 단일 SSOT
- `~/.claude/teams/_bus/decisions.jsonl` — 결정 감사 로그 (Paperclip P1)
- `~/.claude/teams/<name>/state.json` — 팀 내부 상태

## 7. 참조

- `state-schema.md` — trust.json v2 전체 스키마
- `checkpoint-protocol.md` — INFORM/GATE 구체 동작
- `~/.claude/skills/team-common/SKILL.md` — 팀 공통 템플릿
- `~/workspace/reports/jarvis-merge-plan.md` 섹션 11.2 / 21.3 / 23 — 설계 배경
