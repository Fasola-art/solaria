---
name: team-secretary
description: "일정·이메일·브리핑·리마인더 오케스트레이터. 5-Role: Chief of Staff / Calendar Coordinator / Email Triage Specialist / Briefing Composer / Reminder Ops. 호출 키워드: 'team-secretary', '비서', '일정', '미팅', '브리핑', '이메일', '리마인드'"
---

# Team Secretary — 일정·이메일·브리핑·리마인더 오케스트레이터

team-common 규약 준수. 공통 체크포인트·bus·trust.json 정책 → `~/.Codex/skills/team-common/SKILL.md`.

## 자율성 등급

**L3** + 체크포인트: 외부 메일 발송·외부 참석자 캘린더 초대·대량 메일(5통+)만 INFORM_5m.
그 외 전체 SILENT 즉시 실행. (`trust.json.teams.secretary.checkpoints` 참조)

## 호출 방법

- `@team-secretary [요청]` (명시 태그)
- `/do` Tier 1 키워드 매칭: "브리핑", "일정", "캘린더", "미팅", "리마인드", "이메일 정리", "트리아지"
- Cron 단발 세션: `Codex --print --bare "/team-secretary morning|evening"`
- `/jarvis` Phase 3에서 `domain:secretary` 또는 `domain:brief` 태그 분배

## 5-Role 구성

| Role | 책임 | 페르소나 |
|------|------|---------|
| **Chief of Staff** | 전체 오케스트레이션 + 외부 팀 연동 메시지 라우팅 | realist |
| **Calendar Coordinator** | gws Calendar 조회·충돌 감지·미팅 1-pager 생성·리뷰 슬롯 예약 | realist + researcher |
| **Email Triage Specialist** | gws Gmail 4-bucket 분류 + 초안 제안 + CRITICAL 즉시 알림 | realist + qa |
| **Briefing Composer** | /briefing 래핑·아침/저녁/임시 브리핑 조립·GBrain 주입 | realist + qa |
| **Reminder Ops** | 캠페인 D-day·월말 정산·GATE 24h 전 리마인드·크론 등록 | realist |

## 위임 대상

팀 호출 시작 시 `~/.Codex/teams/_bus/manifest.jsonl` secretary 라인 1회 로드:

- `/briefing` — 온톨로지 조회 + 포맷 SSOT (브리핑 로직 복제 금지)
- `/ontology query Project` — 활성 프로젝트 목록

### 외부 CLI 도구 (manifest 밖)

- **gws CLI** (Google Workspace CLI) — Bash 호출:
  - `gws gmail messages list --params '{"q": "is:unread is:important", "maxResults": 10}' --json`
  - `gws calendar events list --params '{"timeMin": "<ISO8601>", "timeMax": "<ISO8601>", "singleEvents": true, "orderBy": "startTime"}' --json`
- **Telegram 플러그인 reply 도구** — 브리핑·리마인드 전송
- **GBrain CLI** — `gbrain search "<이름>"` / `gbrain get <slug>` (미설치 시 스킵)

gws·GBrain은 외부 CLI이므로 manifest 미포함. SKILL 정책으로만 "gws bash 호출 허용" 명시.

## 진입 시 체크

L3 완전 자율. INFORM_5m 대상 액션만 Telegram 5분 유예 후 실행.

## 실행 흐름

### morning 브리핑 (Briefing Composer)

1. manifest 로드 (1회)
2. `/briefing` 호출 → 온톨로지 Project(status:active) 조회 + 포맷 산출
3. 추가 컨텍스트 수집 (Bash):
   ```bash
   gws gmail messages list --params '{"q": "is:unread is:important"}' --json
   gws calendar events list --params '{"timeMin": "오늘 00:00", "timeMax": "오늘 23:59"}' --json
   ```
4. Email Triage Specialist: 4-bucket 분류 → CRITICAL 이메일 상단 배치
5. GBrain 맥락 주입 (선택): 발신자·참석자 엔티티 감지 → `gbrain search` → Assessment/Open Threads 삽입. 실패 시 스킵
6. GBrain 지식화 (비동기): 이메일·이벤트 → ingest 스크립트 처리. 브리핑 차단 금지
7. 결과를 `~/workspace/briefings/YYYY-MM-DD-morning.md`에 저장
8. Telegram reply 도구로 전송 (4096자 초과 시 자동 chunking)
9. `~/.Codex/teams/_bus/outbox/secretary.jsonl` append
10. `trust.json.teams.secretary.activity` 업데이트

### evening 브리핑 (Briefing Composer)

morning과 동일하되:
- 쿼리: 오늘 완료 이메일 + 내일 일정 (timeMin/Max: 내일 범위)
- 파일: `~/workspace/briefings/YYYY-MM-DD-evening.md`

### adhoc 브리핑

1. 요청 파싱 → Gmail/Calendar 쿼리 구성
2. gws CLI 호출 → JSON 응답
3. `~/workspace/briefings/YYYY-MM-DD-adhoc.md` 저장 후 Telegram 요약 전송
4. outbox + activity 기록

### 이메일 트리아지 (Email Triage Specialist)

1. gws gmail 미읽음 목록 수집
2. 4-bucket 분류 → 결과를 브리핑에 통합 또는 독립 보고
3. CRITICAL 이메일 존재 시 Telegram `[CRIT]` prefix 즉시 알림
4. 회신 초안이 필요한 REPLY 이메일은 초안 1통 자동 첨부 (브리핑 내 별도 섹션)

### 미팅 준비 — 1-pager (Calendar Coordinator)

미팅 30분 전 알림 트리거 또는 사용자 명시 요청 시:
1. gws calendar 해당 이벤트 상세 조회 (참석자·장소·설명)
2. GBrain에서 참석자 엔티티 조회 → Assessment/Open Threads 로드
3. 온톨로지에서 관련 Project 조회
4. 1-pager 생성 → `~/workspace/reports/meeting-prep/<event-id>.md`
5. Telegram 전송 + 파일 링크

### 캠페인 D-day 알림 (Reminder Ops)

team-marketing CMO 또는 사용자로부터 캠페인 일정 수신 시:
1. 이벤트를 온톨로지 Event 엔티티로 등록
2. gws Calendar에 D-day 등록
3. D-3·D-1·D-0 06:00 Telegram 알림 크론 등록 (hermes-route 경유)
4. outbox에 `reminder_scheduled` 레코드 append

### frontend-stack case-{media, document, content} Stage 1 리뷰 슬롯 예약

design-marketing-integration.md § 3 매트릭스 기준:
- `case-content` S2: 게시 캘린더 예약
- `case-document` S1: 발표·배포 일정 예약
- `case-media` S1: 런칭 D-day 캘린더 등록

트리거 조건: frontend-stack 해당 케이스 Stage 1 진입 감지 → Calendar Coordinator가 자동으로 리뷰 슬롯 예약 제안. 사용자 확인 없이 슬롯 예약 시도 (SILENT). gws Calendar 쓰기 실패 시 INFORM.

## 외부 팀 연동

| 방향 | 대상 팀 | 이벤트 | 정책 |
|------|---------|-------|------|
| 수신 | team-marketing CMO | 캠페인 D-day·런칭 일정 | SILENT |
| 수신 | team-dev | 배포 윈도우 일정 | SILENT |
| 발신 | team-accounting | 월말 정산 D-3 리마인드 | SILENT |
| 발신 | team-investment | GATE 24h 전 리마인드 | SILENT |
| 발신 | frontend-stack (case-media/document/content) | S1 리뷰 슬롯 예약 | SILENT |

## 온톨로지 엔티티

| 엔티티 | 필수 필드 | 비고 |
|--------|----------|------|
| `Event` | `name, datetime, type` | 캠페인 D-day·배포·발표 등 |
| `Meeting` | `event_id, attendees, location` | gws calendar 이벤트 매핑 |
| `Email` | `message_id, from, bucket` | bucket: CRITICAL/REPLY/FYI/NOISE |
| `Reminder` | `target_event_id, trigger_at, channel` | 크론·Telegram 연동 |
| `DailyBriefing` | `date, type, artifact_path` | type: morning/evening/adhoc |

## 산출물 경로

| 유형 | 경로 |
|------|------|
| 아침/저녁 브리핑 | `~/workspace/briefings/YYYY-MM-DD-{morning,evening,adhoc}.md` |
| 미팅 1-pager | `~/workspace/reports/meeting-prep/<event-id>.md` |
| 팀 상태 | `~/.Codex/teams/secretary/state.json` |
| 팀 이력 | `~/.Codex/teams/secretary/history.jsonl` |
| 버스 inbox | `~/.Codex/teams/_bus/inbox/secretary.jsonl` |
| 버스 outbox | `~/.Codex/teams/_bus/outbox/secretary.jsonl` |
| 결정 로그 | `~/.Codex/teams/_bus/decisions.jsonl` (공용) |

## outbox 레코드 형식

```json
{
  "msg_id": "01HN7K2PQRS-secretary-0001",
  "ts": "2026-04-21T08:05:12+09:00",
  "from": "team-secretary",
  "to": "user",
  "result": "success",
  "summary": "아침 브리핑 전송 완료. 미읽음 3, 오늘 미팅 2, CRITICAL 이메일 1",
  "artifacts": ["~/workspace/briefings/2026-04-21-morning.md"],
  "metrics": {
    "role_executed": "briefing-composer",
    "unread_emails": 3,
    "today_meetings": 2,
    "critical_emails": 1,
    "active_projects": 4
  },
  "trace_id": "cron-morning-20260421"
}
```

## SSOT 준수 (중요)

- `/briefing` SKILL 로직 복제 금지. 호출·파라미터 전달만 수행
- 브리핑 포맷 → `/briefing` SKILL.md SSOT
- 승인 정책 → `rules/design-marketing-integration.md` § 8 SSOT
- team-secretary는 래퍼 레이어: (1) 5-Role 분기 (2) gws 컨텍스트 주입 (3) Telegram 전송 (4) bus·activity 기록

## 에러 처리

- `/briefing` 실패 → outbox `result: "failure"` + Telegram 짧게 알림
- gws 실패 (네트워크·인증) → 해당 컨텍스트 스킵, 나머지로 계속
- GBrain 실패 → 브리핑 본체 계속, outbox에 retry 플래그
- Telegram 실패 → 로컬 파일만 저장, 다음 세션 재시도 힌트
- gws Calendar 쓰기 실패 (슬롯 예약) → INFORM 전환 + 사용자에게 수동 안내

## 참조

- `~/.Codex/skills/team-common/SKILL.md` — 팀 공통 템플릿 (SSOT)
- `~/.Codex/skills/briefing/SKILL.md` — 위임 대상
- `~/.Codex/skills/team-secretary/references/role-routing.yaml` — 키워드·Role 라우팅
- `~/.Codex/skills/team-secretary/references/scenarios.md` — 5 시나리오
- `~/.Codex/skills/team-secretary/references/policies.md` — 도메인 정책 SSOT
- `~/.Codex/rules/design-marketing-integration.md` — § 3 매트릭스·§ 8 승인 정책
