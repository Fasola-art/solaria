# team-secretary 도메인 정책 (SSOT)


## Contents

- [1. 브리핑 시간대 정의](#1-브리핑-시간대-정의)
- [2. 이메일 4-bucket 분류 기준 (SSOT)](#2-이메일-4-bucket-분류-기준-ssot)
  - [CRITICAL (즉각 대응 필요)](#critical-즉각-대응-필요)
  - [REPLY (회신 필요)](#reply-회신-필요)
  - [FYI (읽기만)](#fyi-읽기만)
  - [NOISE (무시 가능)](#noise-무시-가능)
- [3. 일정 우선순위](#3-일정-우선순위)
- [4. 체크포인트 정책 (승인 분류)](#4-체크포인트-정책-승인-분류)
  - [SILENT (즉시 실행)](#silent-즉시-실행)
  - [INFORM_5m (5분 유예 후 자동 확정)](#inform_5m-5분-유예-후-자동-확정)
- [5. 브리핑 포맷 (SSOT — /briefing 스킬 호출 결과 기준)](#5-브리핑-포맷-ssot-briefing-스킬-호출-결과-기준)
- [요약](#요약)
- [[긴급] 이메일](#긴급-이메일)
- [오늘 일정](#오늘-일정)
  - [CRITICAL (2시간 이내)](#critical-2시간-이내)
  - [전체](#전체)
- [이메일 (회신 필요)](#이메일-회신-필요)
- [이메일 (읽기만)](#이메일-읽기만)
- [내일 일정](#내일-일정)
- [활성 프로젝트](#활성-프로젝트)
- [제안](#제안)
- [6. Telegram 전송 정책](#6-telegram-전송-정책)
- [7. 활성 프로젝트 조회 정책](#7-활성-프로젝트-조회-정책)
- [8. 1-pager 생성 정책 (Calendar Coordinator)](#8-1-pager-생성-정책-calendar-coordinator)
- [9. frontend-stack 케이스 연동 정책](#9-frontend-stack-케이스-연동-정책)
- [10. 활동 카운터 갱신 규칙](#10-활동-카운터-갱신-규칙)
- [11. 에러 처리 정책](#11-에러-처리-정책)
- [12. 산출물 경로 (SSOT)](#12-산출물-경로-ssot)
- [참조](#참조)

team-common 규약 준수. 공통 체크포인트·bus·trust.json 정책 → `~/.claude/skills/team-common/SKILL.md`.
승인 정책 매트릭스 SSOT → `~/.claude/rules/design-marketing-integration.md` § 8.

---

## 1. 브리핑 시간대 정의

| 유형 | 시간대 | 트리거 |
|------|--------|--------|
| morning | 06:00~11:59 | cron 또는 명시 파라미터 |
| evening | 18:00~23:59 | cron 또는 명시 파라미터 |
| adhoc | 시간대 무관 | 사용자 즉시 요청 |

## 2. 이메일 4-bucket 분류 기준 (SSOT)

### CRITICAL (즉각 대응 필요)
- `is:important` 필터 + 아래 키워드 1개 이상 동시 매칭
- 키워드: `긴급`, `urgent`, `ASAP`, `확인바람`, `검토`, `오늘까지`, `마감`, `결정 필요`, `deadline`
- 발신자 허용리스트(`references/allowlist.txt`) 매칭
- **액션**: Telegram `[CRIT]` prefix 즉시 선발송 (브리핑 조립 완료 전 발송 가능)

### REPLY (회신 필요)
- 질문문(`?`) 포함 또는 요청 표현(`~해주세요`, `~부탁드립니다`, `~확인 바랍니다`) 포함
- CRITICAL 기준 미달이어야 함
- **액션**: 상위 3건 회신 초안 자동 생성 후 브리핑에 첨부

### FYI (읽기만)
- 공지·정보 공유 목적. 응답 불필요 확인
- noreply 발신자, GitHub·Jira 알림, 정기 리포트
- **액션**: 건수 합산 요약만

### NOISE (무시 가능)
- 광고·스팸·대량 발송(Unsubscribe 링크 포함)
- 구독 취소 가능 뉴스레터
- **액션**: 건수 + "광고 M건 포함" 1줄 요약만

## 3. 일정 우선순위

| 우선순위 | 기준 | 표기 |
|---------|------|------|
| CRITICAL | 현재 시점 기준 2시간 이내 | 최상단 + `[CRIT]` |
| HIGH | 당일 나머지 일정 | 상단 섹션 |
| NORMAL | 내일 일정 | 하단 섹션 |
| CONFLICT | 시간 겹침 감지 | 별도 경고 섹션 |

충돌 감지: 동일 시간대 2개 이상 이벤트 → "일정 충돌 감지: [이벤트A] vs [이벤트B]" 경고.

## 4. 체크포인트 정책 (승인 분류)

### SILENT (즉시 실행)
- 브리핑 작성·저장
- 이메일 트리아지·분류·회신 초안 생성 (실제 발송 아님)
- 캘린더 조회·충돌 감지
- 1-pager 생성
- 리마인더 등록·크론 설정
- Telegram 수신 전용 알림 (reply 전송)
- team-dev 배포 윈도우 공유 (정보 전달만)
- team-accounting 월말 정산 D-3 리마인드 (정보 전달만)
- team-investment GATE 24h 전 리마인드 (정보 전달만)
- gws Calendar 슬롯 예약 (내부 캘린더)

### INFORM_5m (5분 유예 후 자동 확정)
- **외부 메일 실제 발송** (gws gmail send)
- **외부 참석자 캘린더 초대** (gws calendar invite — 외부 도메인 참석자 포함)
- **대량 메일 5통 이상** (내부·외부 합산)
- gws Calendar 쓰기 실패 후 INFORM 전환

INFORM_5m 절차:
1. Telegram `[INFO] "작업 시작 예정 — 5분 내 /cancel <trace_id> 가능"` 전송
2. 5분 대기 (Session A 내 신규 메시지 확인)
3. `/cancel <trace_id>` 수신 시 → outbox `abandoned` 기록, 실행 중단
4. 5분 경과 후 자동 실행

## 5. 브리핑 포맷 (SSOT — /briefing 스킬 호출 결과 기준)

```markdown
# 브리핑 (YYYY-MM-DD morning|evening|adhoc)

## 요약
- 미읽음 이메일 N건 (긴급 M건)
- 오늘/내일 미팅 N건
- 활성 프로젝트 N건

## [긴급] 이메일
- [발신자] 제목 — 요약 1줄
  → 회신 초안: ...

## 오늘 일정
### CRITICAL (2시간 이내)
- HH:MM 제목 @ 장소

### 전체
- HH:MM 제목

## 이메일 (회신 필요)
- [발신자] 제목 — 요약 1줄
  → 회신 초안 (상위 3건)

## 이메일 (읽기만)
- FYI N건 요약

## 내일 일정
- HH:MM 제목

## 활성 프로젝트
- 프로젝트명 (last_activity: ...)

## 제안
- (선택) 자동 생성 다음 행동 제안
```

**주의**: 이 포맷은 /briefing 스킬과 일관성 유지. /briefing 포맷 변경 시 이 파일도 동기화.

## 6. Telegram 전송 정책

| 유형 | 전송 내용 | 조건 |
|------|----------|------|
| morning/evening 브리핑 | 전체 본문 | 항상 (4096자 초과 시 chunking) |
| adhoc | 요약만 | 상세는 파일 링크 |
| CRITICAL 이메일 | `[CRIT]` 즉시 선발송 | 브리핑 조립 완료 전 가능 |
| INFORM_5m 유예 | `[INFO]` 알림 | 유예 시작 시 |
| 조용한 날 | "조용한 날입니다" 1줄 | 긴급 0건 + 미팅 0건 + 프로젝트 0건 |

prefix 규칙: `[CRIT]` > `[HIGH]` > `[INFO]` > prefix 없음 (일반)

## 7. 활성 프로젝트 조회 정책

- `/ontology query Project` → `status:active` 필터
- `last_activity` 기준 내림차순 정렬
- 최대 5개만 브리핑에 포함 (초과 시 "외 N개" 요약)

## 8. 1-pager 생성 정책 (Calendar Coordinator)

트리거:
- gws calendar 이벤트 startTime - 30분 = 현재 (cron 1분 단위 체크)
- 사용자 명시 요청 ("미팅 준비", "1-pager")

포함 정보:
- 이벤트 상세 (일시·장소·참석자·설명)
- 참석자 컨텍스트 (GBrain → Assessment/Open Threads, 실패 시 온톨로지)
- 관련 프로젝트 현황
- 논의 아젠다 (이벤트 설명 기반)
- 준비 체크리스트

저장: `~/workspace/reports/meeting-prep/<event-id>.md`

## 9. frontend-stack 케이스 연동 정책

design-marketing-integration.md § 3 기준:

| Case | Stage | Secretary 액션 | 정책 |
|------|-------|---------------|------|
| content | S2 | 게시 캘린더 슬롯 예약 | SILENT |
| document | S1 | 발표·배포 일정 등록 | SILENT |
| media | S1 | 런칭 D-day 캘린더 + 리마인더 3개 | SILENT |

연동 트리거: frontend-stack 해당 케이스 Stage 진입 감지 → Calendar Coordinator 자동 활성.
gws Calendar 쓰기 실패 → INFORM_5m 전환.

## 10. 활동 카운터 갱신 규칙

| 카운터 | 증분 조건 |
|--------|---------|
| `monthly_briefings_sent` | Telegram 전송 성공 시만 |
| `monthly_decisions` | outbox 기록 완료 시 (실패 포함) |
| `monthly_emails_triaged` | 4-bucket 분류 완료 시 |
| `monthly_meetings_prepped` | 1-pager 생성 완료 시 |
| `monthly_reminders_set` | Reminder 크론 등록 완료 시 |

## 11. 에러 처리 정책

| 에러 | 처리 |
|------|------|
| Gmail/Calendar 접근 실패 | 부분 성공: 접근 가능한 정보만 브리핑 |
| gws 완전 실패 (미설치·인증 만료) | Telegram "브리핑 실패: <이유>" + `/channel-guide` 안내 |
| GBrain 실패 | 브리핑 계속. outbox에 retry 플래그 |
| Telegram 실패 | 로컬 파일만 저장. 다음 세션 재시도 힌트 |
| 1-pager 참석자 조회 실패 | 이벤트 기본 정보만으로 1-pager 생성 |
| gws Calendar 쓰기 실패 | INFORM_5m 전환 + 수동 등록 안내 |
| /briefing 스킬 실패 | outbox `result: "failure"` + Telegram 짧게 알림 |

## 12. 산출물 경로 (SSOT)

```
~/workspace/
├── briefings/
│   ├── YYYY-MM-DD-morning.md
│   ├── YYYY-MM-DD-evening.md
│   └── YYYY-MM-DD-adhoc.md
└── reports/
    └── meeting-prep/
        └── <event-id>.md

~/.claude/
└── teams/
    └── secretary/
        ├── state.json
        └── history.jsonl

~/.claude/teams/_bus/
├── inbox/secretary.jsonl
├── outbox/secretary.jsonl
└── decisions.jsonl  (공용)
```

## 참조

- `~/.claude/skills/team-common/SKILL.md` — 공통 규약 SSOT
- `~/.claude/skills/briefing/SKILL.md` — 브리핑 포맷 SSOT
- `~/.claude/rules/design-marketing-integration.md` — § 3 매트릭스·§ 8 승인 정책
- `~/.claude/skills/team-secretary/SKILL.md` — 팀 진입점
- `~/.claude/skills/team-secretary/references/role-routing.yaml` — 키워드·Role 라우팅
- `~/.claude/skills/team-secretary/references/scenarios.md` — 5 시나리오
