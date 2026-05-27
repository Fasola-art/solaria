# 체크포인트 프로토콜 (L3 하이브리드 v2)


## Contents

- [1. 3종 체크포인트](#1-3종-체크포인트)
  - [SILENT (기본)](#silent-기본)
  - [INFORM](#inform)
  - [GATE](#gate)
- [2. 팀별 체크포인트 선언](#2-팀별-체크포인트-선언)
- [3. INFORM 5분 유예 안전 규칙](#3-inform-5분-유예-안전-규칙)
- [4. GATE 24h 리마인드 스케줄](#4-gate-24h-리마인드-스케줄)
- [5. 결정 기록 형식 (decisions.jsonl, Paperclip P1)](#5-결정-기록-형식-decisionsjsonl-paperclip-p1)
- [6. 폐기된 개념 (v1 → v2)](#6-폐기된-개념-v1-v2)
- [7. 참조](#7-참조)

> 2026-04-11 L3 하이브리드 개편. HITL 7 신호는 **폐기**. 팀별 명시적 체크포인트 설정으로 대체.

## 1. 3종 체크포인트

### SILENT (기본)
- **동작**: 알림 없이 즉시 실행
- **사용**: 일상 업무 전반 (조회, 브리핑, 콘텐츠 초안, 검색 등)
- **기록**: outbox 완료 레코드 + trust.activity 증분만

### INFORM
- **동작**: Telegram 사전 보고 → `grace_seconds` 유예 대기 → 미취소 시 실행
- **사용**: team-dev 구현 시작 / 배포 시작 (grace_seconds=300, 5분)
- **취소 경로**: Telegram `/cancel <trace_id>` → Session A가 수신 → 팀 스킬이 실행 스킵
- **기록**: decisions.jsonl에 `type=INFORM, decision=executed|cancelled` 기록

### GATE
- **동작**: Telegram 승인 요청 → 명시 응답 대기 (timeout_seconds)
- **사용**: team-investment 매매/리밸런싱/손절/이체 (timeout=86400, 24h)
- **응답 경로**: Telegram `/approve <trace_id>` 또는 `/reject <trace_id>`
- **리마인드**: 만료 6h / 12h / 1h 전 자동 리마인드. 최후 1h는 CRITICAL prefix `[CRIT]`
- **타임아웃**: `pending` 상태 유지 (자동 거부 아님). 사용자 재확인 또는 수동 정리 대기
- **기록**: decisions.jsonl에 `type=GATE, decision=approved|rejected|pending` 기록

## 2. 팀별 체크포인트 선언

`~/.claude/jarvis/trust.json` v2의 `teams.<name>.checkpoints` 맵 사용.

```json
"dev": {
  "checkpoints": {
    "implementation_start": { "type": "INFORM", "grace_seconds": 300 },
    "deploy_start":         { "type": "INFORM", "grace_seconds": 300 }
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

액션 이름이 checkpoints 맵에 없으면 **기본 SILENT**.

## 3. INFORM 5분 유예 안전 규칙

R24 완화(worker 중간 종료 불가 회피):
1. 팀 스킬이 Telegram INFORM 전송
2. `sleep grace_seconds` 대기 (또는 Session A 내부 타이머)
3. 대기 기간 동안 **worker 에이전트 호출 절대 금지**
4. 대기 종료 직전 Session A가 수신한 cancel 메시지 확인
5. 취소 없으면 worker 호출 (이 시점부터 취소 불가, 되돌릴 수 없음)

**반드시 지킬 것**: worker를 먼저 호출하고 취소 메시지로 중단시키려 하지 말 것. Claude Code Agent tool에는 외부 종료 API가 없다.

## 4. GATE 24h 리마인드 스케줄

team-investment 같은 긴 타임아웃 GATE는 다음 리마인드를 설정:

| 경과 시간 | 알림 | 내용 |
|---|---|---|
| 0h | 초기 GATE 요청 | 전체 상세 정보 |
| 18h (6h 전) | 리마인드 1 | 간략 요약 |
| 12h 전 | 리마인드 2 | 간략 요약 |
| 1h 전 | 리마인드 3 `[CRIT]` | CRITICAL 우선순위 |
| 24h | timeout | 상태 `pending`으로 전환, 사용자 재확인 대기 |

리마인드 스케줄은 팀 스킬 내부에서 `launchd` at jobs 또는 Session A 지속 타이머로 구현 가능.

## 5. 결정 기록 형식 (decisions.jsonl, Paperclip P1)

모든 INFORM/GATE 결정은 `~/.claude/teams/_bus/decisions.jsonl`에 append:

```json
{
  "decision_id": "01HN7K2PQRS-decision-0001",
  "ts": "2026-04-11T08:14:32+09:00",
  "trace_id": "jarvis-phase3-task-7",
  "team": "investment",
  "action": "trade_order",
  "checkpoint_type": "GATE",
  "decision": "approved",
  "decided_by": "user",
  "decision_channel": "telegram",
  "payload_ref": "_bus/inbox/investment.jsonl#msg_id=...",
  "reasoning": "사용자 명시 승인 (Telegram /approve 응답)",
  "metadata": {
    "reviewer_health_score": null,
    "grace_period_used_seconds": 0,
    "reminders_sent": [18000, 12000, 1000]
  }
}
```

## 6. 폐기된 개념 (v1 → v2)

- **HITL 불확실성 7개 신호**: 사용자가 L3 선택으로 불확실성 게이트 제거
- **체크포인트 24h 일괄 타임아웃**: 팀별 `timeout_seconds`로 개별 설정
- **자동 pause + /jarvis continue 재개**: GATE pending 상태로 대체

## 7. 참조

- `trust-risk-engine.md` — L3 하이브리드 엔진 개요
- `state-schema.md` — trust.json v2 + decisions.jsonl 스키마
- `~/.claude/skills/team-common/SKILL.md` — 공통 구현 가이드
