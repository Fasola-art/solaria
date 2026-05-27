---
name: team-investment
description: "투자 팀 오케스트레이터. 시세 스캔 + 포트폴리오 관리 + 시그널 탐지 + GATE_24h 매매 승인. Yahoo Finance/Alpha Vantage/Alpaca MCP 경유. '@team-investment', '시세', '포트폴리오', '매매', '종목', '주식', '리밸런싱', '시그널', '손절' 키워드로 호출."
---

# Team Investment — 포트폴리오·매매·리스크 오케스트레이터

team-common/SKILL.md 구조 준수. 체크포인트·bus·trust SSOT는 team-common/SKILL.md 참조.

## 자율성 등급

**L3** + 체크포인트:
- **SILENT**: 시세 조회, 포트폴리오 리포트, 시그널 탐지, 리서치, 브리핑
- **INFORM_5m**: VaR 초과, 드로다운 임계 도달, 신규 종목 편입 추천
- **GATE_24h**: `trade_order`, `rebalancing`, `stop_loss`, `funds_transfer` — Telegram `/approve` 명시 필수

(trust.json.teams.investment.checkpoints 참조)

## 호출 방법

- `@team-investment [요청]` (명시 태그)
- `/do` Tier 1 키워드 매칭: "시세", "포트폴리오", "매매", "종목", "주식", "리밸런싱", "시그널", "손절"
- `/jarvis` Phase 3에서 `domain:finance` 태그 태스크 위임
- Cron 일일 자동 (08:05 KST): Market Scanner → 포트폴리오 일일 브리핑

## 6 Role 구성

| Role | 책임 | 페르소나 |
|---|---|---|
| Portfolio Manager | 포트폴리오 전체 현황·손익·배분 관리 | cfo + risk_analyst |
| Market Scanner | 시세 스캔, 일일 브리핑 생성 | growth (데이터 수집) |
| Signal Detector | 기술 지표 기반 매매 시그널 탐지 | growth + critic |
| Risk Analyst | VaR·드로다운·집중 위험 평가 | risk_analyst + realist |
| Trade Executor | GATE_24h 매매 실행 (승인 후) | risk_analyst + realist |
| Research Analyst | 종목·산업 딥리서치 | researcher + critic |

### 페르소나 강제 규칙

- `trade_order / stop_loss / funds_transfer` → **risk_analyst + realist 강제** (과신 차단)
- `rebalancing` → **cfo + risk_analyst 강제** (자산 배분 관점)
- 시그널·백테스트 → growth + critic (과최적화 경계 검증)
- 리서치 → researcher + critic (편향 차단)

## 위임 대상 (manifest.jsonl 로드)

- `/research` (종목·산업·경쟁사 딥리서치, finance 프리셋)
- `/ontology` (Portfolio/Position/Trade/Signal/RiskEvent 엔티티 조회·등록)
- `worker` (xlsx 생성, 시세 파싱)

### 외부 MCP 서버

| MCP | 용도 | 상태 |
|---|---|---|
| Yahoo Finance MCP | 시세 조회, 기본 재무 데이터 | 우선 사용 |
| Alpha Vantage MCP | 기술 지표 (RSI, MACD, MA) | 보조 |
| Alpaca MCP | 해외 주식 실거래 주문 | Phase V 검토 |
| TradingView MCP | 차트·지표 시각화 | 선택적 |

MCP 미설치 시: WebFetch + Yahoo Finance 페이지 fallback. 매매는 수동 안내 전송.

## 온톨로지 엔티티

| 엔티티 | 주요 속성 | 관계 |
|---|---|---|
| Portfolio | total_value, cash_ratio, updated_at | has → Position |
| Position | ticker, quantity, avg_cost, current_price | affects → RiskEvent |
| Trade | ticker, direction, quantity, price, status, trace_id | executes_on → Position |
| Signal | ticker, type, confidence, generated_at | triggers → Trade |
| RiskEvent | type, severity, threshold, triggered_at | affects → Portfolio |

## 진입 시 체크

1. `trust.json.teams.investment.checkpoints` 로드
2. 요청 액션 분류: GATE_24h / INFORM_5m / SILENT
3. GATE_24h → 6 Role 중 Risk Analyst 선행 평가 후 Trade Executor 진행
4. SILENT → Market Scanner 또는 Research Analyst 즉시 실행

## 실행 흐름

### A. 시세 조회 (SILENT)

```
Market Scanner
  종목 심볼 파싱 → Yahoo Finance MCP 호출
  없으면 WebFetch fallback
  결과: Telegram 전송 + outbox 기록
  monthly_scan_reports++
```

### B. 포트폴리오 일일 브리핑 (SILENT, Cron 08:05)

```
Market Scanner → Portfolio Manager 순서
  1. references/portfolio.json 보유 종목 로드
  2. 각 종목 시세 조회 + 전일 대비 변동률
  3. 포트폴리오 총 평가액·손익·섹터 배분 계산
  4. Risk Analyst: VaR·드로다운 체크
     → 임계 초과 시 INFORM_5m 알림 발송
  5. ~/workspace/briefings/investment-YYYY-MM-DD.md 저장
  6. Telegram 요약 전송
  7. portfolio_delta_krw 업데이트, monthly_scan_reports++
```

### C. 시그널 탐지 (SILENT → INFORM_5m → GATE_24h)

```
Signal Detector
  1. 기술 지표 계산 (RSI/MACD/MA cross) — Alpha Vantage MCP
  2. 시그널 조건 평가 → Signal 엔티티 생성
  3. 신규 편입 추천 시 → INFORM_5m 알림
  4. 매매 시그널 생성 시 → D 흐름 전환 (GATE_24h)
  monthly_trade_signals++
```

### D. 매매 주문 (GATE_24h)

```
Risk Analyst 선행 (강제)
  포지션 위험·집중도·VaR 영향 평가
  반대 의견 있으면 Telegram에 경고 포함

Trade Executor
  1. 주문 파라미터 구성: {ticker, direction, quantity, price, trace_id}
  2. Telegram GATE 요청:
     [HIGH] team-investment GATE_24h
     종목: {ticker} | 방향: {BUY/SELL} | 수량: {qty}주 | 가격: {price}
     리스크 평가: {Risk Analyst 한줄 요약}
     승인: /approve {trace_id}  거부: /reject {trace_id}
     (타임아웃 24시간 후 pending 유지)
  3. 리마인드 스케줄:
     18h 경과 → [HIGH] 남은 6시간 — {ticker} {direction} {qty}주
     12h 경과 → [HIGH] 남은 12시간 — {ticker} {direction} {qty}주
     23h 경과 → [CRIT] 남은 1시간 — {ticker} {direction} {qty}주 CRITICAL
  4. /approve 수신 → Alpaca MCP 호출
     MCP 미설치 → [HIGH] 수동 주문 안내 전송
  5. /reject 수신 → rejected_by_user, monthly_rejections++
  6. 24h 무응답 → pending 유지 (자동 거부 아님)
  7. 체결 성공 → Position 업데이트, Trade 엔티티 등록
     monthly_trades_executed++, monthly_approvals++
```

### E. 리밸런싱 (GATE_24h)

```
Portfolio Manager + Risk Analyst 협업 (cfo + risk_analyst 강제)
  1. 현재 배분 vs 목표 배분 비교
  2. 조정 필요 종목·금액 목록 생성
  3. GATE_24h 요청 (D 흐름과 동일, 종목별 복수 trace_id)
  4. 승인 후 순차 실행 (동시 실행 금지)
  monthly_rebalances++
```

### F. 종목 딥리서치 (SILENT)

```
Research Analyst (researcher + critic 강제)
  1. /research finance 프리셋 → 재무·산업·경쟁사 분석
  2. team-business outbox에서 경쟁사·산업 시그널 수신 확인
  3. ~/workspace/reports/research-{ticker}-{YYYY-MM-DD}.md 저장
  4. 결과 요약 Telegram 전송
  monthly_research_reports++
```

### G. 리스크 임계 경고 (INFORM_5m)

```
Risk Analyst (자동 트리거)
  VaR 초과 / 드로다운 5% 이상 / 단일 종목 30%+ 집중
  → [INFO] INFORM_5m 알림 + 5분 대기
  → 취소(/cancel {trace_id}) 없으면 경고 리포트 저장
  monthly_risk_alerts++
```

## 외부 팀 연동

| 연동 방향 | 내용 | 방식 |
|---|---|---|
| team-business → investment | 경쟁사·산업 시그널 수신 | inbox 폴링 |
| investment → team-accounting | 실현손익·배당·세금 자료 전달 | outbox 기록 |
| investment → team-secretary | 실적 발표·배당락·옵션 만기 리마인드 | outbox 기록 |

**비연동 (Out of Scope)**: team-marketing, frontend-stack — 직접 연동 없음.

## 산출물 저장 경로

| 유형 | 경로 |
|---|---|
| 월간 포트폴리오 | `~/workspace/investment/portfolio-{YYYY-MM}.xlsx` |
| 종목 리서치 | `~/workspace/reports/research-{ticker}-{YYYY-MM-DD}.md` |
| 일일 브리핑 | `~/workspace/briefings/investment-{YYYY-MM-DD}.md` |
| 포트폴리오 DB | `~/.Codex/skills/team-investment/references/portfolio.json` |
| 팀 상태 | `~/.Codex/teams/investment/state.json` |
| 이력 | `~/.Codex/teams/investment/history.jsonl` |
| 버스 | `~/.Codex/teams/_bus/{inbox,outbox}/investment.jsonl` |

## 활동 카운터

- `monthly_scan_reports++`: 시세 스캔·브리핑 완료 시
- `monthly_trade_signals++`: 시그널 탐지 시
- `monthly_trades_executed++`: 주문 체결 성공 시
- `monthly_approvals++`: `/approve` 수신 시
- `monthly_rejections++`: `/reject` 수신 시
- `monthly_rebalances++`: 리밸런싱 완료 시
- `monthly_research_reports++`: 딥리서치 완료 시
- `monthly_risk_alerts++`: 리스크 임계 경고 발송 시
- `portfolio_delta_krw`: 포트폴리오 일일 손익 (전일 대비)
- `monthly_decisions++`: 모든 요청 처리 시

## 범위 제약

- 브로커 MCP 미설치: 조회·리포트·시그널 + 수동 실행 안내
- 브로커 MCP 설치 후: 자동 매매 (모든 매매는 GATE_24h 필수)
- 국내 오픈뱅킹 MCP 부재: 이체는 수동 처리

## SSOT 준수

- `/research` 리서치 로직 복제 금지 — finance 프리셋으로 위임
- team-investment 고유 책임: 시그널 생성, GATE_24h 워크플로우, 포트폴리오 상태 관리

## 참조

- `~/.Codex/skills/team-common/SKILL.md` — 공통 체크포인트·bus·trust 규약
- `~/.Codex/skills/team-investment/references/role-routing.yaml` — Role 라우팅
- `~/.Codex/skills/team-investment/references/scenarios.md` — 5 시나리오 상세
- `~/.Codex/skills/team-investment/references/policies.md` — GATE_24h 정책 SSOT
- `~/.Codex/skills/team-investment/references/portfolio.json` — 보유 종목 DB
