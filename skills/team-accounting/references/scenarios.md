# team-accounting 실행 시나리오 5종


## Contents

- [시나리오 A: 일간 지출 입력](#시나리오-a-일간-지출-입력)
- [시나리오 B: 월말 자동 정산 (Cron 매월 1일 09:00)](#시나리오-b-월말-자동-정산-cron-매월-1일-0900)
- [시나리오 C: 이상 거래 탐지 (Expense Auditor)](#시나리오-c-이상-거래-탐지-expense-auditor)
  - [3σ 알고리즘](#3σ-알고리즘)
  - [중복 탐지 룰](#중복-탐지-룰)
  - [감지 후 처리](#감지-후-처리)
- [시나리오 D: 광고 예산 INFORM (team-marketing → team-accounting)](#시나리오-d-광고-예산-inform-team-marketing-team-accounting)
- [시나리오 E: 분기 결산](#시나리오-e-분기-결산)
- [공통 실행 규칙](#공통-실행-규칙)

수동 입력·크론·탐지·INFORM·분기 결산 전 과정 포함.

**공통 원칙**:
- 모든 거래는 온톨로지 엔티티로 등록 (Expense/Revenue/Budget/Anomaly/TaxFiling)
- xlsx 직접 조작 금지 → `/xlsx` 스킬 위임
- 사용자 노출 결과: "항목 N건 기록 → 잔여 예산 N → 이상 없음/이상 N건"
- 외부 팀 위임 시 outbox 기록 + 사용자에겐 "다음 단계" 안내만

---

## 시나리오 A: 일간 지출 입력

**트리거**: Telegram `@team-accounting 지출 [내용] [금액] [날짜]` 또는 자연어 "오늘 카페 5500원 썼어"

```
Bookkeeper 진입
  Telegram 메시지 파싱:
    - 금액: 숫자 추출 (원/만원 정규화)
    - 날짜: 명시 없으면 오늘 날짜 (KST)
    - 카테고리: 온톨로지 Expense.category 조회 → 없으면 LLM 분류
    - 벤더: 상호명 추출 (없으면 blank)

  /xlsx 호출: ledger-<YYYY-MM>.xlsx에 행 추가
    컬럼: 날짜 | 금액 | 카테고리 | 벤더 | 메모 | 영수증경로 | 이상플래그

  Expense 엔티티 등록:
    { amount, date, category, vendor, receipt_path: null, anomaly_flag: false }

  Budget Controller 자동 위임:
    잔여 예산 조회 → 120% 초과 여부 체크

  Expense Auditor 자동 위임:
    이상 거래 탐지 실행 (3σ + 중복)

  금액 분기:
    < 500,000원 → SILENT + outbox 기록
               → Telegram "[INFO] 지출 기록: [카테고리] ₩[금액] | 잔여 예산 ₩[remaining]"
    >= 500,000원 → INFORM_5m
               → Telegram "[INFO] 고액 지출 예정 ₩[금액] — 5분 내 /cancel <trace_id> 가능"
               → 5분 경과 후 xlsx 기록 확정

  activity.monthly_transactions++
  activity.monthly_ledger_entries++
```

---

## 시나리오 B: 월말 자동 정산 (Cron 매월 1일 09:00)

**트리거**: `claude --print --bare "@team-accounting 월말 정산"` (hermes-route 크론 등록)

```
Budget Controller + Revenue Analyst 병렬 실행

  [Budget Controller]
    전월 Expense 엔티티 전체 집계:
      - 카테고리별 합계
      - 예산 대비 초과/미달 (Budget.overage_pct 계산)
      - 전월 대비 증감률 (MoM)

  [Revenue Analyst]
    전월 Revenue 엔티티 집계:
      - source_product별 매출 합계
      - refund_flag=true 건 환불 차감
      - 순이익 = 총수익 - 총지출

    GBrain 미매치 거래 retry:
      outbox retry_flag=true 건 → gbrain search 재시도
      매치 성공 → timeline_entry 추가
      매치 실패 → unmatched_log 기록

  [Expense Auditor]
    월간 Anomaly 엔티티 리뷰:
      - resolved=false 건 목록 정리
      - severity=HIGH 미해결 건 [HIGH] 알림

  /xlsx 호출: Summary 탭 업데이트

  ~/workspace/briefings/accounting-<YYYY-MM>.md 생성:
    섹션: 총지출 | 총수익 | 순이익 | 카테고리 TOP5 | 이상 거래 | 다음 달 예산 권고

  Telegram "[INFO] [YYYY-MM] 정산 완료. 순이익 ₩N. 상세: briefings/accounting-<YYYY-MM>.md"

  activity.monthly_reports_generated++
```

---

## 시나리오 C: 이상 거래 탐지 (Expense Auditor)

**트리거**: 지출 입력 시 자동 실행 OR `@team-accounting 이상 거래 확인`

### 3σ 알고리즘
```
조건: 해당 카테고리에 최소 30일치 데이터 존재

1. 카테고리별 최근 30일 금액 시계열 수집
2. μ (평균) = sum(amounts) / n
3. σ (표준편차) = sqrt(sum((x - μ)^2) / n)
4. 임계치 = μ + 3σ
5. 신규 거래 금액 > 임계치 → 의심 (σ 미달 시 정상)

출력:
  severity = "LOW"  (2σ~3σ)
  severity = "HIGH" (3σ 초과)
  Anomaly 엔티티: { tx_ref, type: "sigma_outlier", sigma_value, severity }
```

### 중복 탐지 룰
```
다음 조건 AND 매칭 시 중복 의심:
  - 동일 금액 (±0원 일치)
  - 동일 벤더명 (정규화: 공백·특수문자 제거 후 비교)
  - 24시간 이내 2건 이상
  → Anomaly: { type: "duplicate", severity: "HIGH" }

추가 룰:
  - 동일 가맹점 24시간 내 3건 이상 → type: "frequency_spike"
  - 금액이 100만 단위 정수 (1000000, 2000000) + 수동 입력 → type: "round_number_check"
    (입력 오류 가능성, severity: "LOW")
```

### 감지 후 처리
```
severity=LOW:
  Telegram "[ ] 이상 거래 감지: [내용] — 확인 필요"
  Anomaly.resolved = false (자동 해결 안 함)

severity=HIGH:
  Telegram "[HIGH] 이상 거래 감지: [내용] ₩[금액] — /resolve <anomaly_id> 또는 /dismiss <anomaly_id>"
  outbox 기록 (to: user, intent: anomaly_review)

activity.outliers_detected++
```

---

## 시나리오 D: 광고 예산 INFORM (team-marketing → team-accounting)

**트리거**: team-marketing Acquisition Lead → accounting inbox 메시지 수신

```
Budget Controller 진입

  inbox 수신 파싱:
    { from: "team-marketing", intent: "ad_budget_request",
      amount: N, campaign: "...", period: "YYYY-MM-DD ~ YYYY-MM-DD" }

  Budget.remaining 조회:
    잔여 > 요청액 → 집행 가능
    잔여 < 요청액 → 경고 포함 INFORM

  INFORM_5m 실행:
    Telegram "[INFO] 광고 예산 집행 예정: [campaign] ₩[amount]
             기간: [period] | 잔여 예산 ₩[remaining]
             5분 내 /cancel <trace_id> 로 취소 가능"

  5분 경과:
    Budget 엔티티 소진 기록 (spent += amount, remaining -= amount)
    Expense 엔티티 등록: { category: "광고비", vendor: campaign, amount }
    /xlsx 기록
    outbox: { to: "team-marketing", result: "success", summary: "광고 예산 ₩N 집행 확정" }

  /cancel 수신 시:
    outbox: { result: "cancelled", reason: "user_cancel" }
    Telegram "광고 예산 집행 취소됨"

  activity.monthly_decisions++
```

---

## 시나리오 E: 분기 결산

**트리거**: `@team-accounting 분기 결산` OR Tax Preparer 자동 체크 (납부 기한 D-30)

```
Tax Preparer + Revenue Analyst + cfo + risk_analyst 활성

  [Revenue Analyst]
    분기 손익계산서 생성:
      - 총수익: Revenue 엔티티 분기 합산
      - 총지출: Expense 엔티티 분기 합산
      - 순이익 = 총수익 - 총지출
      - 세목별 분류: 부가세 대상 / 비대상

  [Tax Preparer]
    납부 세액 계산:
      - 부가세: 과세 매출 × 10% - 매입세액 (간이 계산)
      - 신고 유형: 일반/간이/면세 판별
    
    납부 기한 확인:
      → team-secretary outbox: "세무 납부 기한 리마인드 등록 요청"
        { due_date, tax_type, amount_estimate }

    TaxFiling 엔티티 등록:
      { quarter, due_date, status: "pending", filing_type, amount }

  산출물 저장:
    ~/workspace/accounting/tax/<YYYY-Qn>/
      ├── income-statement.md   # 손익계산서
      ├── expense-summary.xlsx  # 지출 분류표
      └── tax-filing-draft.md   # 신고 초안

  신고 제출 액션 → GATE_24h:
    Telegram "[HIGH] 세금 신고 제출 승인 필요: [세목] ₩[amount] | 기한 [due_date]
             /approve <trace_id> 또는 /reject <trace_id>"
    리마인드:
      6h 전  → "[HIGH] 세금 신고 GATE — 6시간 후 기한"
      12h 전 → "[HIGH] 세금 신고 GATE — 12시간 후 기한" (단계 조정: due_date 기준)
      1h 전  → "[CRIT] 세금 신고 GATE — 1시간 후 기한. 즉시 승인 필요"

  /approve 수신:
    TaxFiling.status = "submitted"
    outbox 성공 기록
    Telegram "세금 신고 완료"

  /reject 수신:
    TaxFiling.status = "rejected_by_user"
    outbox 거부 기록

  24h 무응답:
    TaxFiling.status = "pending" 유지 (자동 제출 없음)
    Telegram "[CRIT] 세금 신고 24h 무응답. 수동 처리 필요"

  activity.quarterly_reports_generated++
```

---

## 공통 실행 규칙

1. **30일 데이터 미만**: 3σ 알고리즘 비활성 → 중복 탐지 룰만 적용
2. **GBrain 미연결**: Revenue 연동 스킵, ledger 정상 저장, outbox retry_flag=true
3. **영수증 파일**: receipt_path는 `~/workspace/accounting/receipts/<YYYY-MM>/<date>-<vendor>.pdf` 표준 경로
4. **GATE 24h 무응답**: 자동 실행 없음, pending 유지 + CRIT 알림 1회
5. **상태 갱신**: 각 Role 완료 시 state.json.roles.<role>.monthly_* 카운터 증분 + outbox role_executed 기록
