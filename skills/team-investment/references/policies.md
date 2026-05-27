# team-investment 정책 (SSOT)


## Contents

- [1. 체크포인트 분류표](#1-체크포인트-분류표)
- [2. GATE_24h 전체 타임라인 (SSOT)](#2-gate_24h-전체-타임라인-ssot)
  - [CRITICAL prefix [CRIT] 규약](#critical-prefix-crit-규약)
- [3. INFORM_5m 프로토콜](#3-inform_5m-프로토콜)
- [4. 매매 후 취소 불가 원칙](#4-매매-후-취소-불가-원칙)
- [5. decisions.jsonl 감사 기록 (GATE 전용)](#5-decisionsjsonl-감사-기록-gate-전용)
- [6. Role 책임 분담 (SSOT)](#6-role-책임-분담-ssot)
- [7. 외부 팀 연동 규약](#7-외부-팀-연동-규약)
- [8. 산출물 저장 경로 (SSOT)](#8-산출물-저장-경로-ssot)
- [9. outbox 메시지 스키마 (team-common 확장)](#9-outbox-메시지-스키마-team-common-확장)
- [10. 페르소나 강제 규칙 요약](#10-페르소나-강제-규칙-요약)

team-common 규약 준수. outbox/decisions/manifest/trust SSOT는 team-common/SKILL.md 참조.

## 1. 체크포인트 분류표

| 액션 유형 | 체크포인트 | 이유 |
|---|---|---|
| `trade_order` | GATE_24h | 경제적 손실 불가역 |
| `rebalancing` | GATE_24h | 다수 종목 동시 영향 |
| `stop_loss` | GATE_24h | 손절 실행 불가역 |
| `funds_transfer` | GATE_24h | 자금 이동 불가역 |
| VaR 초과 경고 | INFORM_5m | 인지 필요, 즉시 실행 없음 |
| 드로다운 임계 도달 | INFORM_5m | 인지 필요 |
| 신규 종목 편입 추천 | INFORM_5m | 매매 아님, 추천만 |
| 시세 조회 | SILENT | 되돌릴 수 있음 |
| 포트폴리오 리포트 | SILENT | 읽기 전용 |
| 시그널 탐지 | SILENT | 매매 아님 |
| 딥리서치 | SILENT | 읽기 전용 |
| 일일 브리핑 (Cron) | SILENT | 정보 제공 |

## 2. GATE_24h 전체 타임라인 (SSOT)

```
T+0h    GATE 요청 발송 (Telegram [HIGH])
            포함 정보: ticker / direction / qty / price / risk_summary / trace_id
            응답 옵션: /approve {trace_id} | /reject {trace_id}

T+18h   리마인드 1차 [HIGH] — "남은 6시간"
            메시지: [HIGH] GATE_24h 리마인드 — 남은 6시간
            {ticker} {direction} {qty}주 @{price}
            /approve {trace_id} | /reject {trace_id}

T+12h   리마인드 2차 [HIGH] — "남은 12시간"
            메시지: [HIGH] GATE_24h 리마인드 — 남은 12시간
            {ticker} {direction} {qty}주 @{price}
            /approve {trace_id} | /reject {trace_id}

T+23h   리마인드 3차 [CRIT] — "남은 1시간" (CRITICAL prefix 필수)
            메시지: [CRIT] GATE_24h CRITICAL — 남은 1시간
            {ticker} {direction} {qty}주 @{price} 승인 기한 임박
            /approve {trace_id} | /reject {trace_id}

T+24h   무응답 → pending 상태 유지 (자동 거부 없음)
            사용자 명시 취소 시까지 대기
```

### CRITICAL prefix [CRIT] 규약

- 최후 1h 리마인드에만 사용 (T+23h)
- 긴급 리스크 경고 (VaR 대폭 초과, 마진콜 위험)에도 사용
- [HIGH]와 혼용 금지: [CRIT]는 [HIGH]보다 상위 우선순위
- Telegram 알림음 별도 설정 권장 (사용자 주의 환기)

## 3. INFORM_5m 프로토콜

```
T+0m    [INFO] 경고 또는 추천 발송
            "5분 내 /cancel {trace_id} 응답 없으면 자동 진행"
T+5m    무응답 → 리포트 생성 또는 다음 단계 자동 진행
            취소 수신 → outbox: {result: "abandoned"}, 중단
```

INFORM_5m 대상:
- VaR 임계 초과 → 리스크 리포트 자동 생성
- 드로다운 5%+ → 리스크 리포트 + 손절 검토 안내
- 신규 편입 추천 → Risk Analyst 평가 단계 자동 진행

## 4. 매매 후 취소 불가 원칙

- GATE 승인 후 브로커 MCP 호출 완료 = **취소 불가**
- 취소 가능 시점: `/approve` 수신 전까지만
- 체결 완료 후 정정 필요 시 → 신규 반대 매매 주문 (별도 GATE_24h)
- 이 원칙은 예외 없음. 사용자 요청으로도 체결 완료 주문 번복 불가

## 5. decisions.jsonl 감사 기록 (GATE 전용)

모든 GATE_24h 결정은 반드시 decisions.jsonl에 기록:

```json
{
  "decision_id": "01HN-investment-{ulid}",
  "ts": "2026-04-21T09:30:00+09:00",
  "trace_id": "{trace_id}",
  "team": "investment",
  "action": "trade_order|rebalancing|stop_loss|funds_transfer",
  "checkpoint_type": "GATE",
  "decision": "approved|rejected_by_user|abandoned|pending",
  "decided_by": "user",
  "decision_channel": "telegram",
  "payload_ref": "_bus/inbox/investment.jsonl#msg_id=...",
  "ticker": "{ticker}",
  "direction": "BUY|SELL",
  "quantity": 0,
  "price": 0,
  "reasoning": "Telegram /approve 응답 수신"
}
```

## 6. Role 책임 분담 (SSOT)

| 경계 | 소유 Role | 비고 |
|---|---|---|
| 포트폴리오 현황·배분·손익 | Portfolio Manager | portfolio.json SSOT |
| 시세 조회·일일 브리핑 | Market Scanner | Cron 08:05 자동 |
| 기술 지표·시그널 생성 | Signal Detector | /research finance 프리셋 |
| VaR·드로다운·집중 위험 평가 | Risk Analyst | GATE 전 강제 선행 |
| GATE_24h 실행·리마인드 | Trade Executor | Risk Analyst 선행 필수 |
| 종목·산업 딥리서치 | Research Analyst | /research 위임, 복제 금지 |

## 7. 외부 팀 연동 규약

| 연동 | 방향 | 데이터 | 방식 |
|---|---|---|---|
| team-business → investment | 수신 | 경쟁사·산업 시그널 | inbox 폴링 |
| investment → team-accounting | 송신 | 실현손익·배당·세금 자료 | outbox 기록 |
| investment → team-secretary | 송신 | 실적 발표·배당락·옵션 만기 일정 | outbox 기록 |

**비연동 (Out of Scope)**: team-marketing, frontend-stack
- team-investment는 투자·금융 도메인에 한정
- 마케팅 채널·UI 변경 요청은 해당 팀으로 직접 라우팅

## 8. 산출물 저장 경로 (SSOT)

| 유형 | 경로 |
|---|---|
| 월간 포트폴리오 | `~/workspace/investment/portfolio-{YYYY-MM}.xlsx` |
| 종목 리서치 리포트 | `~/workspace/reports/research-{ticker}-{YYYY-MM-DD}.md` |
| 리스크 경고 리포트 | `~/workspace/reports/risk-alert-{YYYY-MM-DD}-{trace_id}.md` |
| 일일 브리핑 | `~/workspace/briefings/investment-{YYYY-MM-DD}.md` |
| 포트폴리오 DB | `~/.claude/skills/team-investment/references/portfolio.json` |
| 팀 상태 | `~/.claude/teams/investment/state.json` |
| 이력 | `~/.claude/teams/investment/history.jsonl` |
| outbox | `~/.claude/teams/_bus/outbox/investment.jsonl` |
| 감사 기록 | `~/.claude/teams/_bus/decisions.jsonl` (공용, GATE 전용) |

## 9. outbox 메시지 스키마 (team-common 확장)

```json
{
  "msg_id": "uuid",
  "ts": "ISO8601",
  "from": "team-investment",
  "to": "<target_team_or_role>",
  "result": "success|partial|failed|rejected|abandoned|pending",
  "summary": "1-2줄 요약",
  "artifacts": ["경로1"],
  "metrics": {
    "role_executed": "portfolio-manager|market-scanner|signal-detector|risk-analyst|trade-executor|research-analyst",
    "scenario": "daily-scan|signal-gate|rebalancing|risk-alert|research|ad-hoc",
    "ticker": "선택적",
    "portfolio_delta_krw": 0
  },
  "trace_id": "uuid"
}
```

## 10. 페르소나 강제 규칙 요약

| 액션 | 강제 페르소나 | 이유 |
|---|---|---|
| trade_order / stop_loss / funds_transfer | risk_analyst + realist | 과신 차단, 최악 시나리오 명시 |
| rebalancing | cfo + risk_analyst | 자산 배분 전략 + 위험 평가 |
| 시그널·백테스트 | growth + critic | 과최적화 방지 |
| 딥리서치 | researcher + critic | 확증 편향 차단 |

페르소나는 CLAUDE.md 글로벌 규칙 준수. 최대 3개 동시 활성.
