# team-accounting 정책 (금액 임계치 + 체크포인트 + Role 책임 + 연동 규약)


## Contents

- [1. 체크포인트 정책 (SSOT)](#1-체크포인트-정책-ssot)
  - [정책 enum](#정책-enum)
  - [금액 임계치](#금액-임계치)
  - [GATE_24h 리마인드 일정](#gate_24h-리마인드-일정)
  - [INFORM_5m 유예 흐름](#inform_5m-유예-흐름)
- [2. Role 책임 분담 (SSOT)](#2-role-책임-분담-ssot)
- [3. 온톨로지 엔티티 책임](#3-온톨로지-엔티티-책임)
- [4. 외부 팀 연동 정책](#4-외부-팀-연동-정책)
  - [team-marketing 광고 예산 수신 상세](#team-marketing-광고-예산-수신-상세)
  - [team-dev 인프라 비용 수신 상세](#team-dev-인프라-비용-수신-상세)
- [5. 산출물 저장 경로 (SSOT)](#5-산출물-저장-경로-ssot)
- [6. outbox 메시지 스키마 (team-common 확장)](#6-outbox-메시지-스키마-team-common-확장)
- [7. 사용자 노출 원칙](#7-사용자-노출-원칙)
- [8. 범위 제약](#8-범위-제약)

team-common 규약 준수. outbox/decisions/manifest/trust SSOT는 team-common/SKILL.md 참조.
충돌 시 우선순위: design-marketing-integration.md > 이 파일 > 각 Role 기본값.

## 1. 체크포인트 정책 (SSOT)

GATE_24h 리마인드 로직은 `~/.claude/skills/jarvis/references/checkpoint-protocol.md` 재사용.

### 정책 enum

| 코드 | 의미 | 유예·타임아웃 | 채널 |
|------|------|-------------|------|
| `SILENT` | 알림 없이 즉시 기록·실행 | — | outbox.jsonl |
| `INFORM_5m` | 5분 유예 후 자동 확정 | 5분 | Telegram + outbox |
| `GATE_24h` | 24시간 내 /approve 필수 | 6h / 12h / 1h 리마인드 | Telegram |

### 금액 임계치

| 조건 | 정책 | 비고 |
|------|------|------|
| 지출 50만 미만 | SILENT | 즉시 기록, 확인 불필요 |
| 지출 50만 이상 | INFORM_5m | 고액 지출 경보 |
| 예산 120% 초과 | INFORM_5m | Budget.overage_pct >= 1.2 |
| 광고 예산 집행 | INFORM_5m | team-marketing 수신 포함 |
| 계좌 이체 | GATE_24h | 금액 무관 |
| 세금 신고 제출 | GATE_24h | TaxFiling 엔티티 status 전환 |
| 제작 외주비 Commerce/Media S3-S4 | GATE_24h | design-marketing-integration § 8-3 |

### GATE_24h 리마인드 일정

```
기준: 승인 요청 발송 시점으로부터 또는 due_date 기준
  T+0       → [HIGH] 초기 승인 요청 전송
  T+6h      → [HIGH] 리마인드 1회차
  T+12h     → [HIGH] 리마인드 2회차
  T+23h     → [CRIT] 최후 리마인드 (due_date 기준 1h 전)
  T+24h     → pending 유지 (자동 실행 없음) + [CRIT] 1회 추가 알림

세금 신고처럼 외부 기한이 있는 경우:
  due_date - 6h  → [HIGH]
  due_date - 12h → [HIGH]  (※ T+6h/12h 기준이 아닌 due_date 역산)
  due_date - 1h  → [CRIT]
```

### INFORM_5m 유예 흐름

```
1. Telegram "[INFO] [액션 설명] ₩N — 5분 내 /cancel <trace_id> 응답 가능"
2. 5분 대기 (hermes-route 타이머)
3. /cancel 수신 → outbox: { result: "cancelled" } + Telegram 취소 확인
4. 5분 경과 → 자동 확정, xlsx·온톨로지 기록
5. 확정 후 outbox: { result: "success" }
```

## 2. Role 책임 분담 (SSOT)

| 경계 | 소유 Role | 비고 |
|------|---------|------|
| 일간 지출 입력·분류·xlsx 기록 | Bookkeeper | 기본 진입점 |
| 예산 대비 현황·초과 경보·배분 | Budget Controller | INFORM_5m 트리거 주체 |
| 이상 거래 탐지(3σ·중복)·감사 | Expense Auditor | critic 상시 동반, 차단 없음 |
| 수익 입금·GBrain 연동·손익 | Revenue Analyst | refund_flag·source_product 관리 |
| 세무 신고·납부 일정·GATE_24h | Tax Preparer | risk_analyst 강제 활성 |

**중복 금지**:
- Budget Controller가 이상 탐지 실행 금지 (Expense Auditor 전담)
- Bookkeeper가 세무 계산 실행 금지 (Tax Preparer 전담)
- 금액 임계치 판단은 Budget Controller 단독 (Bookkeeper는 전달만)

## 3. 온톨로지 엔티티 책임

| 엔티티 | 생성 Role | 수정 허용 Role |
|--------|---------|-------------|
| Expense | Bookkeeper | Expense Auditor (anomaly_flag) |
| Revenue | Revenue Analyst | Bookkeeper (입금 입력) |
| Budget | Budget Controller | Tax Preparer (세목 배분) |
| Anomaly | Expense Auditor | Expense Auditor (resolved 전환) |
| TaxFiling | Tax Preparer | Tax Preparer (status 전환) |

## 4. 외부 팀 연동 정책

| 방향 | 상대 팀 | 정책 | 메시지 형식 |
|------|---------|------|-----------|
| 수신 | team-marketing Acquisition Lead | INFORM_5m | inbox.jsonl intent: ad_budget_request |
| 수신 | team-dev | SILENT | inbox.jsonl intent: infra_cost_report |
| 송신 | team-investment | SILENT | outbox.jsonl intent: realized_profit_update |
| 수신 | team-secretary | SILENT | 세무 기한 리마인드 구독 |
| 내부 | frontend-stack Commerce/Media S3-S4 | GATE_24h | design-marketing-integration § 8-3 |

### team-marketing 광고 예산 수신 상세
- accounting inbox에서 `intent: "ad_budget_request"` 감지
- Budget Controller가 자동 처리
- 집행 확정 후 team-marketing outbox에 `intent: "ad_budget_confirmed"` 반환

### team-dev 인프라 비용 수신 상세
- `intent: "infra_cost_report"` 수신 → SILENT 즉시 Expense 엔티티 등록
- 카테고리: "인프라비" 또는 "라이선스비" 자동 분류

## 5. 산출물 저장 경로 (SSOT)

| 유형 | 경로 |
|------|------|
| 월간 장부 | `~/workspace/accounting/ledger-<YYYY-MM>.xlsx` |
| 월간 브리핑 | `~/workspace/briefings/accounting-<YYYY-MM>.md` |
| 분기 손익계산서 | `~/workspace/accounting/tax/<YYYY-Qn>/income-statement.md` |
| 분기 지출 분류표 | `~/workspace/accounting/tax/<YYYY-Qn>/expense-summary.xlsx` |
| 세무 신고 초안 | `~/workspace/accounting/tax/<YYYY-Qn>/tax-filing-draft.md` |
| 이상 거래 리포트 | `~/workspace/reports/anomaly-<YYYY-MM>.md` |
| 영수증 원본 | `~/workspace/accounting/receipts/<YYYY-MM>/<date>-<vendor>.pdf` |

## 6. outbox 메시지 스키마 (team-common 확장)

```json
{
  "msg_id": "uuid",
  "ts": "ISO8601+09:00",
  "from": "team-accounting",
  "to": "<target_team_or_role>",
  "result": "success|partial|failed|cancelled|rejected_by_user",
  "summary": "1-2줄 요약",
  "artifacts": ["경로1"],
  "metrics": {
    "role_executed": "bookkeeper|budget-controller|expense-auditor|revenue-analyst|tax-preparer",
    "scenario": "daily-entry|monthly-close|anomaly-detect|ad-budget-inform|quarterly-close",
    "amount": 0,
    "checkpoint_type": "SILENT|INFORM_5m|GATE_24h"
  },
  "trace_id": "uuid"
}
```

## 7. 사용자 노출 원칙

1. **전문 용어 간소화**: "3σ 이상치" → "비정상 지출 감지". "MoM" → "지난달 대비". "TaxFiling" → "세무 신고 항목"
2. **결과 구조**: "기록 N건 → 잔여 예산 ₩N → 이상 없음 / 이상 N건 [상세]"
3. **승인 포인트**: 50만+·세금 신고·계좌 이체만 명시적 승인. 그 외 L3 자율
4. **외부 팀 전달**: team-marketing·team-dev 위임 후 "다음 단계"에서만 안내
5. **선택지**: 이상 거래 감지 시 /resolve 또는 /dismiss 명시 제공

## 8. 범위 제약

- **국내 오픈뱅킹 MCP 부재** → 자동 거래 내역 수집 불가. 수동 입력 기본.
- **세무 계산**: 간이 추정치만 제공 (법적 효력 없음). 실제 신고는 세무사 확인 권고.
- **환율**: 외화 거래는 기록 시점 매매기준율 적용, 별도 환율 엔티티 미지원.
- **미래**: 오픈뱅킹 MCP 도입 시 Bookkeeper 자동화 단계적 전환.
