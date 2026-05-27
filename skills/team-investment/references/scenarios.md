# team-investment 실행 시나리오 5종


## Contents

- [시나리오 A: 일간 시세 스캔 (Cron 08:05 자동)](#시나리오-a-일간-시세-스캔-cron-0805-자동)
- [시나리오 B: 시그널 → GATE_24h 매매 전 과정](#시나리오-b-시그널-gate_24h-매매-전-과정)
- [시나리오 C: 월간 리밸런싱](#시나리오-c-월간-리밸런싱)
- [시나리오 D: 리스크 임계 경고](#시나리오-d-리스크-임계-경고)
- [시나리오 E: 종목 딥리서치](#시나리오-e-종목-딥리서치)
- [공통 실행 규칙](#공통-실행-규칙)

**공통 원칙**:
- 모든 매매 액션은 GATE_24h 필수 (risk_analyst 선행 강제)
- 시세·리서치·브리핑은 SILENT 즉시 실행
- VaR 초과·드로다운·신규 편입 추천은 INFORM_5m
- 외부 팀 위임 후 결과는 Telegram 또는 브리핑 파일로만 안내
- decisions.jsonl에 모든 GATE 결정 감사 기록 필수

---

## 시나리오 A: 일간 시세 스캔 (Cron 08:05 자동)

**트리거**: Cron 08:05 KST 자동 실행

```
Market Scanner 진입
  1. references/portfolio.json 보유 종목 로드
  2. Yahoo Finance MCP → 종목별 현재가·전일 대비·거래량 조회
     MCP 미설치 시: WebFetch fallback (Yahoo Finance 페이지)
  3. 코스피·나스닥·S&P500 지수 조회

Risk Analyst 자동 체크
  4. 포트폴리오 총 평가액·일간 손익 계산
  5. 드로다운 임계 체크:
     - 5% 이상 → INFORM_5m 경고 발송
     - VaR 일일 한도 초과 → INFORM_5m 경고 발송
     - 단일 종목 30%+ 집중 → INFORM_5m 경고 발송
  6. 임계 미달 시 → SILENT 계속

Portfolio Manager
  7. ~/workspace/briefings/investment-YYYY-MM-DD.md 저장
     포맷: 지수 요약 / 보유 종목별 변동 / 총 손익 / 리스크 메모
  8. portfolio_delta_krw 업데이트
  9. Telegram 브리핑 전송 (prefix 없음, SILENT)
     예시:
       team-investment 08:05 브리핑
       지수: 코스피 2,847 (+0.3%) | 나스닥 19,210 (+0.8%)
       포트폴리오: +₩320,000 (+1.2%)
       상위: 삼성전자 +2.1% | 하위: TSMC -0.8%
       리스크: 정상 범위
  10. monthly_scan_reports++, monthly_decisions++
```

---

## 시나리오 B: 시그널 → GATE_24h 매매 전 과정

**트리거**: Signal Detector 자동 감지 또는 사용자 "@team-investment 매수 신호 확인"

```
Signal Detector (growth + critic 강제)
  1. Alpha Vantage MCP → RSI·MACD·MA20/60/120 계산
  2. 시그널 조건 평가:
     예: RSI < 30 AND MACD 골든크로스 AND 거래량 평균 2배
  3. Signal 엔티티 생성:
     {ticker, type: "BUY", confidence: 0.78, generated_at}
  4. critic 페르소나 검증:
     "과최적화 여부 — 백테스트 기간 편향 없는가?"
     "최근 3개월 동일 시그널 승률은?"
  monthly_trade_signals++

신규 편입 추천 시 → INFORM_5m
  [INFO] team-investment: {ticker} 신규 편입 신호 감지
  매수 근거: RSI 28 / MACD 골든크로스 / 거래량 230%
  /cancel {trace_id} 로 5분 내 취소 가능
  5분 무응답 → Risk Analyst 평가 단계로 자동 진행

Risk Analyst 선행 평가 (강제, risk_analyst + realist)
  5. 현재 포트폴리오 집중도 체크
  6. VaR 영향 시뮬레이션 (매수 시 포트폴리오 VaR 변화)
  7. 반대 의견 생성 (realist):
     "이 시점 매수 시 최악 시나리오: -15% 손실 가능"
  8. 위험 요약 한 줄 생성 (GATE 메시지 포함용)

Trade Executor (risk_analyst + realist 강제)
  9. Telegram GATE_24h 요청 전송:

     [HIGH] team-investment GATE_24h 매수 주문 승인 요청
     ────────────────────────────
     종목: {ticker} ({종목명})
     방향: BUY (매수)
     수량: {qty}주
     가격: {price}원 (시장가 / 지정가)
     예상 금액: ₩{total}
     시그널 근거: RSI {rsi} / MACD 골든크로스 / 거래량 {vol}%
     리스크: {Risk Analyst 한줄 요약}
     trace_id: {trace_id}
     ────────────────────────────
     승인: /approve {trace_id}
     거부: /reject {trace_id}
     (24시간 후 응답 없으면 pending 유지)

  리마인드 스케줄 (자동):
    18h 경과 →
      [HIGH] GATE_24h 리마인드 — 남은 6시간
      {ticker} BUY {qty}주 @{price} | /approve {trace_id} | /reject {trace_id}
    12h 경과 →
      [HIGH] GATE_24h 리마인드 — 남은 12시간
      {ticker} BUY {qty}주 @{price} | /approve {trace_id} | /reject {trace_id}
    23h 경과 →
      [CRIT] GATE_24h CRITICAL — 남은 1시간
      {ticker} BUY {qty}주 @{price} 승인 기한 임박
      /approve {trace_id} | /reject {trace_id}

  /approve {trace_id} 수신 시:
    10. decisions.jsonl 기록:
        {decision_id, ts, trace_id, team: "investment", action: "trade_order",
         checkpoint_type: "GATE", decision: "approved", decided_by: "user",
         decision_channel: "telegram"}
    11. Alpaca MCP → 주문 실행
        MCP 미설치 →
          [HIGH] 브로커 MCP 미설치. 수동 주문 필요:
          {ticker} {qty}주 {direction} @{price} — 브로커 앱에서 직접 실행 후 확인 바랍니다.
    12. Position 엔티티 업데이트 (온톨로지)
    13. outbox 기록: {result: "success", ticker, qty, price}
    14. monthly_trades_executed++, monthly_approvals++

  /reject {trace_id} 수신 시:
    10. decisions.jsonl 기록: {decision: "rejected_by_user"}
    11. outbox 기록: {result: "rejected", ticker}
    12. monthly_rejections++

  24h 무응답:
    → outbox 기록: {result: "pending", ticker}
    → 상태 pending 유지. 자동 거부 없음. 사용자 명시 취소 필요.

  취소 완료 시 outbox:
    {result: "abandoned", decided_by: "user", ts: 취소_시각}
```

---

## 시나리오 C: 월간 리밸런싱

**트리거**: 사용자 "@team-investment 리밸런싱" 또는 Portfolio Manager 드로다운 감지

```
Portfolio Manager + Risk Analyst 협업 (cfo + risk_analyst 강제)
  1. 현재 배분 조회 (portfolio.json)
  2. 목표 배분 비교:
     예: 주식 70% / 채권 20% / 현금 10% (목표)
         현재: 주식 82% / 채권 13% / 현금 5%
  3. 조정 필요 종목·금액 목록 생성
  4. Risk Analyst 영향 평가:
     "리밸런싱 후 VaR 변화: {before} → {after}"
     "세금 효과: 실현손익 {amount}원 예상"
  5. team-accounting outbox 전송 (세금·손익 계산 요청)

GATE_24h 요청 (종목별 복수 trace_id):
  [HIGH] team-investment GATE_24h 리밸런싱 승인 요청
  ────────────────────────────
  조정 목록:
    SELL: {ticker_A} {qty}주 (비중 12% → 8%)
    BUY: {ticker_B} {qty}주 (비중 5% → 10%)
  예상 실현손익: +₩{amount} (세금 약 ₩{tax})
  리밸런싱 후 VaR: {var_after}
  trace_id: {trace_id_rebalance}
  ────────────────────────────
  승인: /approve {trace_id_rebalance}
  거부: /reject {trace_id_rebalance}

  승인 후: 종목별 순차 매매 (동시 실행 금지)
  완료 후: portfolio.json 업데이트, monthly_rebalances++
  team-accounting outbox: 실현손익·세금 자료 전달
```

---

## 시나리오 D: 리스크 임계 경고

**트리거**: Market Scanner 또는 Risk Analyst 자동 감지

```
Risk Analyst 자동 평가
  트리거 조건 (INFORM_5m):
    - 포트폴리오 드로다운 5% 이상 (고점 대비)
    - 일일 VaR 한도 초과 (설정값 초과)
    - 단일 종목 집중도 30%+ (편중 위험)
    - 무위험 수익률 기준 샤프 지수 급락

  1. [INFO] INFORM_5m 경고 전송:
     [INFO] team-investment 리스크 경고
     유형: {드로다운/VaR초과/집중위험}
     현황: {수치 및 임계값}
     권장: {손절 고려 / 비중 축소 / 헤지 검토}
     /cancel {trace_id} 로 5분 내 취소 가능

  2. 5분 무응답 → 리스크 리포트 자동 생성:
     ~/workspace/reports/risk-alert-{YYYY-MM-DD}-{trace_id}.md
     포함: 원인 분석, 시나리오별 손실 추정, 권장 액션 3가지

  3. VaR 임계 초과 + 사용자 손절 요청 시 → 시나리오 B (GATE_24h) 전환

  monthly_risk_alerts++
```

---

## 시나리오 E: 종목 딥리서치

**트리거**: 사용자 "@team-investment 삼성전자 분석해" 또는 투자 검토 요청

```
Research Analyst (researcher + critic 강제)
  1. /research finance 프리셋 호출:
     - 재무제표 (매출·영업이익·부채비율·ROE 3년)
     - PER·PBR·EV/EBITDA 밸류에이션
     - 경쟁사 비교 (산업 내 포지션)
     - 최근 실적 발표·가이던스

  2. team-business inbox 확인:
     경쟁사·산업 시그널 수신 여부 체크

  3. Signal Detector 협업 (선택):
     기술적 관점 추가 (과매도/과매수 여부)

  4. critic 페르소나 반론:
     "강세 근거의 반대 시나리오는?"
     "리서치 편향 체크: 확증 편향 항목 있는가?"

  5. 리서치 리포트 생성:
     ~/workspace/reports/research-{ticker}-{YYYY-MM-DD}.md
     포함 섹션:
       - 기업 개요 및 사업 모델
       - 재무 지표 3년 추이
       - 밸류에이션 비교
       - 경쟁사 포지션
       - 리스크 요인 3가지
       - 투자 아이디어 (근거 + 반론)
       - 추천 액션 (매수/관망/회피)

  6. Telegram 요약 전송 (SILENT):
     team-investment 리서치 완료: {ticker}
     요약: {2-3줄 핵심}
     리포트: ~/workspace/reports/research-{ticker}-{date}.md

  monthly_research_reports++
```

---

## 공통 실행 규칙

1. **GATE_24h 필수 액션**: trade_order, rebalancing, stop_loss, funds_transfer — 예외 없음
2. **risk_analyst 선행 강제**: 모든 GATE_24h 액션 전 Risk Analyst 평가 먼저
3. **리마인드 타임라인**: 6h 전 [HIGH] → 12h 전 [HIGH] → 1h 전 [CRIT] — policies.md SSOT
4. **decisions.jsonl**: 모든 GATE 결정 (approve/reject/abandon/pending) 감사 기록 필수
5. **취소 불가**: 체결 완료된 매매는 되돌릴 수 없음. GATE 승인 전 신중히.
6. **외부 팀 위임**: team-accounting(손익·세금), team-secretary(일정 알림), team-business(산업 시그널) 자동 outbox. 사용자에겐 결과 요약만.
7. **상태 갱신**: Role 완료 시 state.json.roles.<role>.monthly_* 카운터 증분 + outbox role_executed 기록
