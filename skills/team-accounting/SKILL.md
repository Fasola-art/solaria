---
name: team-accounting
description: "회계 팀 오케스트레이터. 5-Role(Bookkeeper/Budget Controller/Expense Auditor/Revenue Analyst/Tax Preparer). 지출 수동 입력 + 월말 자동 정산 + 이상 거래 탐지 + 분기 결산 + 세무 GATE. '@team-accounting', '지출', '예산', '영수증', '정산', '세금', '결산' 키워드로 호출. L3 완전 자율 (임계치 이하 SILENT, 임계치 이상 INFORM_5m, 이체/세무 GATE_24h)."
---

# Team Accounting — 지출·예산·세무 오케스트레이터

team-common 헤더 구조 준수. 공통 상수·outbox·manifest·trust SSOT는 `~/.Codex/skills/team-common/SKILL.md` 참조.

## 자율성 등급
**L3** — 체크포인트: 금액·유형별 정책 분기.
- 지출 50만 미만: SILENT
- 지출 50만 이상 / 예산 120% 초과 / 광고 예산 집행: INFORM_5m
- 계좌 이체 / 세금 신고 제출 / 제작 외주비(Commerce·Media S3-S4): GATE_24h

## 호출 방법
- `@team-accounting [요청]` (명시 태그)
- `/do` Tier 1 키워드: "지출", "예산", "장부", "영수증", "정산", "세금", "결산", "이상 거래" 매칭
- `/jarvis` Phase 3에서 `domain:accounting` 태그 분배
- Cron 월말: 매월 1일 09:00 `Codex --print --bare "@team-accounting 월말 정산"`

## 5-Role 표

| Role | 주 책임 | 트리거 키워드 | 페르소나 |
|------|---------|-------------|---------|
| **Bookkeeper** | 일간 지출 입력·분류·xlsx 기록 | 지출, 영수증, 입력, 기록 | realist |
| **Budget Controller** | 예산 대비 현황·초과 경보·월별 배분 | 예산, 초과, 잔여, 배분 | realist + cfo |
| **Expense Auditor** | 이상 거래 탐지(3σ·중복)·리뷰 | 이상, 중복, 의심, 감사 | realist + critic |
| **Revenue Analyst** | 수익 입금·GBrain 연동·손익 | 수익, 입금, 매출, 손익 | realist + cfo |
| **Tax Preparer** | 세무 신고·납부 일정·GATE 관리 | 세금, 부가세, 종소세, 신고 | realist + risk_analyst |

### 페르소나 우선순위
`risk_analyst > critic > cfo > realist`
- Expense Auditor: realist + critic 상시 동반
- 월말·분기 정산: + cfo 활성
- 세무·GATE·감사 트리거: + risk_analyst 강제 활성

## 위임 대상 (manifest.jsonl 로드)
- `/xlsx` — 장부 파일 관리 (`~/workspace/accounting/ledger-<YYYY-MM>.xlsx`)
- `/ontology` — Expense·Revenue·Budget·Anomaly·TaxFiling 엔티티 조회/등록
- `/workflow revenue-*` — 수익·지출 워크플로우

## 실행 흐름

### 1. 수동 지출 입력 (Bookkeeper 진입점)
1. Telegram 파싱: `@team-accounting 지출 카페 5500 2026-04-21`
2. 카테고리 자동 분류 (온톨로지 조회 → LLM 분류 fallback)
3. `~/workspace/accounting/ledger-<YYYY-MM>.xlsx`에 행 추가: 날짜·금액·카테고리·메모·출처·영수증 경로
4. Expense 엔티티 등록 (category, vendor, receipt_path 확장 필드 포함)
5. Budget Controller 자동 위임: 예산 잔여 확인 → 120% 초과 시 INFORM_5m
6. Expense Auditor 자동 위임: 이상 거래 탐지 실행
7. 금액 분기:
   - 50만 미만 → SILENT, outbox 기록
   - 50만 이상 → INFORM_5m (Telegram `[INFO] 지출 ₩N — 5분 내 /cancel <trace_id> 가능`)
8. `monthly_transactions++`, `monthly_ledger_entries++`

### 2. 월말 자동 정산 (Budget Controller + Revenue Analyst, Cron 매월 1일 09:00)
1. 전월 데이터 집계: 카테고리별 합계, 예산 대비 초과/미달, 전월 대비 증감률
2. Revenue 엔티티 취합: source_product, refund_flag 포함
3. GBrain 연동: 미매치 거래 retry 처리
4. Expense Auditor: 월간 이상 거래 최종 리뷰
5. `~/workspace/accounting/ledger-<YYYY-MM>.xlsx` 월간 Summary 탭 업데이트
6. `~/workspace/briefings/accounting-<YYYY-MM>.md` 생성
7. Telegram `[INFO]` 요약 전송
8. `monthly_reports_generated++`

### 3. 이상 거래 탐지 (Expense Auditor 전담)
- 상세 알고리즘: `references/scenarios.md` § 시나리오 C
- 감지 시 Telegram `[HIGH]` 알림 (차단 아님, 보고 전용)
- Anomaly 엔티티 등록 (type, severity, raw_tx_ref)
- `outliers_detected++`

### 4. 광고 예산 INFORM (Budget Controller ← team-marketing Acquisition Lead)
1. team-marketing outbox → accounting inbox 수신
2. 집행 예정 금액 + 캠페인명 파싱
3. INFORM_5m 실행: Telegram `[INFO] 광고 예산 집행 예정 ₩N — 5분 내 /cancel <trace_id>`
4. 5분 경과 → Budget 엔티티 소진 기록, outbox 완료

### 5. 분기 결산 (Revenue Analyst + Tax Preparer + cfo + risk_analyst)
1. 분기 손익계산서 생성: 총수익, 총지출, 순이익
2. 세무 납부 일정 확인 (Tax Preparer → team-secretary 리마인드 요청)
3. `~/workspace/accounting/tax/<YYYY-Qn>/` 산출물 저장
4. TaxFiling 엔티티 등록 (quarter, due_date, status)
5. 신고 제출 액션 → GATE_24h 실행 (리마인드: 6h/12h/1h)
6. `quarterly_reports_generated++`

## frontend-stack Commerce·Media S3-S4 GATE

design-marketing-integration.md § 8-3에 따라:
- **Commerce S3 (Implement) / Media S3 (Production)**: 제작 외주비 발생 시 GATE_24h
- **Commerce S4 (Motion/Refine) / Media S4 (Refine)**: 추가 외주비 발생 시 GATE_24h
- 트리거: `case: commerce|media` + `stage: S3|S4` + `외주·용역·제작비` 키워드
- GATE 리마인드 3회: 6h `[HIGH]` / 12h `[HIGH]` / 1h `[CRIT]`

## 온톨로지 엔티티

| 엔티티 | 필수 필드 | 확장 필드 |
|--------|----------|---------|
| **Expense** | `amount, date, category` | `vendor, receipt_path, anomaly_flag` |
| **Revenue** | `amount, date, source` | `source_product, refund_flag, deal_slug` |
| **Budget** | `category, limit, period` | `spent, remaining, overage_pct` |
| **Anomaly** | `tx_ref, type, severity` | `sigma_value, description, resolved` |
| **TaxFiling** | `quarter, due_date, status` | `filing_type, amount, submitted_at` |

## 외부 연동

| 방향 | 상대 팀 | 트리거 | 정책 |
|------|---------|--------|------|
| 수신 | team-marketing Acquisition Lead | 광고 예산 집행 | INFORM_5m |
| 수신 | team-dev | 인프라·라이선스·SaaS 비용 | SILENT (입력) |
| 송신 | team-investment | 실현손익 입금 반영 | SILENT (outbox) |
| 수신 | team-secretary | 세무 납부 기한 리마인드 | SILENT (일정 구독) |
| 내부 | frontend-stack Commerce/Media S3-S4 | 제작 외주비 | GATE_24h |

## 상태 파일
- **상태**: `~/.Codex/teams/accounting/state.json`
- **이력**: `~/.Codex/teams/accounting/history.jsonl`
- **버스**: `~/.Codex/teams/_bus/{inbox,outbox}/accounting.jsonl`
- **장부**: `~/workspace/accounting/ledger-<YYYY-MM>.xlsx`
- **세무**: `~/workspace/accounting/tax/<YYYY-Qn>/`

## 산출물 경로

| 유형 | 경로 |
|------|------|
| 월간 장부 | `~/workspace/accounting/ledger-<YYYY-MM>.xlsx` |
| 월간 브리핑 | `~/workspace/briefings/accounting-<YYYY-MM>.md` |
| 분기 결산 | `~/workspace/accounting/tax/<YYYY-Qn>/` |
| 이상 거래 리포트 | `~/workspace/reports/anomaly-<YYYY-MM>.md` |

## 활동 카운터
- `monthly_transactions++`: 거래 1건 기록 시
- `monthly_ledger_entries++`: xlsx 행 추가 성공 시
- `outliers_detected++`: 이상 거래 감지 시
- `monthly_reports_generated++`: 월간 정산 완료 시
- `quarterly_reports_generated++`: 분기 결산 완료 시
- `monthly_decisions++`: 모든 요청 처리 시

## SSOT 준수
- xlsx 로직 복제 금지 → `/xlsx` 호출만
- 체크포인트 유예 로직 → `team-common/SKILL.md` § 3 재사용
- GATE_24h 리마인드 → `~/.Codex/skills/jarvis/references/checkpoint-protocol.md` 재사용

## 참조
- `~/.Codex/skills/team-common/SKILL.md`
- `~/.Codex/skills/team-accounting/references/role-routing.yaml`
- `~/.Codex/skills/team-accounting/references/scenarios.md`
- `~/.Codex/skills/team-accounting/references/policies.md`
- `~/.Codex/rules/design-marketing-integration.md` § 3, § 8
