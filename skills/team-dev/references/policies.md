# team-dev 도메인 정책 (SSOT)


## Contents

- [SILENT (즉시 실행, 알림 없음)](#silent-즉시-실행-알림-없음)
- [INFORM_5m (5분 유예 후 자동 확정)](#inform_5m-5분-유예-후-자동-확정)
- [GATE_1h (1시간 내 승인 필수 — 핫픽스)](#gate_1h-1시간-내-승인-필수-핫픽스)
- [GATE_24h (24시간 내 승인 필수 — 파괴적 작업)](#gate_24h-24시간-내-승인-필수-파괴적-작업)
- [보안 강제 참여 정책](#보안-강제-참여-정책)
- [PR 리뷰 정책](#pr-리뷰-정책)
- [배포 환경 구분](#배포-환경-구분)
- [git push 정책](#git-push-정책)
- [worker 호출 규칙](#worker-호출-규칙)
- [배포 롤백 규칙](#배포-롤백-규칙)
- [design-marketing-integration 연동 정책](#design-marketing-integration-연동-정책)
- [Telegram 메시지 포맷](#telegram-메시지-포맷)
- [활동 카운터 갱신](#활동-카운터-갱신)
- [참조](#참조)

design-marketing-integration.md § 8 매트릭스 team-dev 행 + design 연동 항목 포함.
본 파일이 SSOT. SKILL.md는 이 문서를 참조만 한다.

---

## SILENT (즉시 실행, 알림 없음)

대상 액션:
- PR 리뷰 (조회·보고)
- 로그 분석 / 에러 로그 수집
- 테스트 결과 보고
- devDep 추가·업그레이드
- feature flag 토글 (기능 켜기/끄기)
- 롤백 (배포 실패 시 자동 복구)
- 인시던트 초기 조사 (코드 수정 없는 로그/지표 분석)
- 의존성 취약점 분석 (실행 없는 리포트)
- ADR 초안 작성
- Postmortem 작성

완료 처리:
- outbox 기록 + trust.json.activity 증분
- Telegram 일반 알림 (prefix 없음) 선택적 전송

---

## INFORM_5m (5분 유예 후 자동 확정)

대상 액션:
- 코드 수정 (버그픽스, 기능 구현, 리팩토링)
- prod / staging / preview 환경 배포
- CI/CD 파이프라인 변경
- prod 의존성(prodDep) 추가·업그레이드
- team-marketing CRO/Acquisition → Frontend Eng UI 변경 구현
- design-marketing-integration Web/Commerce/Media S3 랜딩 구현 착수
- 인프라 스케일 아웃·재시작

타임라인:
1. Telegram [INFO] "작업 시작 예정. 5분 내 `/cancel {trace_id}` 가능" 전송
2. 5분 동안 worker 절대 호출 금지 (Agent tool 취소 불가 제약)
3. 5분 경과 직전 cancel 확인
4. cancel 없음 → worker 호출 → 실행
5. 완료 → Telegram [INFO] 결과 + outbox 기록

완료 처리:
- outbox `result: success|cancelled`
- decisions.jsonl `checkpoint_type: INFORM_5m`
- trust.json.activity 증분

---

## GATE_1h (1시간 내 승인 필수 — 핫픽스)

대상 액션:
- 긴급 핫픽스 hotfix 브랜치 → prod 머지
  (장애 대응 목적 한정. 일반 기능 구현은 INFORM_5m)

타임라인:
1. Telegram [HIGH] "GATE_1h 승인 필요. `/approve {trace_id}` 또는 `/reject {trace_id}`"
2. 30분 리마인드 Telegram [HIGH] 발송
3. 1h 직전 Telegram [CRIT] 최후 알림
4. /approve 수신 → 핫픽스 실행 (INFORM_5m 배포 절차 추가 적용)
5. /reject 수신 → `rejected_by_user` 기록
6. 1h 무응답 → `pending` 유지 (자동 거부 아님)

완료 처리:
- decisions.jsonl `checkpoint_type: GATE_1h, decision: approved|rejected|pending`
- 핫픽스 성공 시 Incident.resolved_ts 기록

---

## GATE_24h (24시간 내 승인 필수 — 파괴적 작업)

대상 액션:
- 파괴적 DB 마이그레이션 (DROP TABLE, DROP COLUMN, ALTER TYPE, 데이터 삭제 포함)
- 시크릿 rotate (API 키, OAuth Secret, DB 패스워드 변경)
- force-push (git push --force, --force-with-lease 포함)
  - 예외: `git push --force-with-lease`는 GATE_24h 적용. `git push --force`는 team-dev 내부 차단.

타임라인:
1. Telegram [HIGH] "GATE_24h 승인 필요. {작업 상세} `/approve {trace_id}` 또는 `/reject {trace_id}`"
2. 6h 리마인드 [HIGH]
3. 12h 리마인드 [HIGH]
4. 23h 리마인드 [CRIT] "최후 1시간 남음"
5. /approve → 실행 / /reject → cancelled / 24h 무응답 → pending

완료 처리:
- decisions.jsonl `checkpoint_type: GATE_24h`
- DB 마이그레이션 성공 시 온톨로지 Dependency 엔티티 갱신

---

## 보안 강제 참여 정책

트리거 키워드: `auth`, `payment`, `admin`, `secret`, `token`, `credential`

- 키워드 포함 시 Security Eng 무조건 참여 (주 Role 수에 포함)
- 글로벌 persona-activator security 강제 동기
- Security Eng 리뷰 없이 auth/payment 코드 worker 호출 금지

---

## PR 리뷰 정책

- 기본: reviewer 4차원 리뷰 (품질 / 보안 / 성능 / 접근성)
- 500줄 이상 PR: /codex-route 2차 의견 자동 트리거
- 보안 키워드 포함 PR (auth, .env, token): Security Eng 별도 섹션 경고
- 헬스 점수 0~10 (관찰용, 차단 조건 아님):
  - 10점: 전체 통과 (git clean + test + build + lint + type)
  - 8~9점: 경고 1-2건 (lint 경미, 미커밋 소수)
  - 5~7점: 주의 (테스트 실패, 타입 에러)
  - 0~4점: 문제 다수 (빌드 실패, 대량 미커밋)

---

## 배포 환경 구분

| 환경 | 정책 | Telegram prefix |
|------|------|----------------|
| preview (PR 브랜치) | INFORM_5m | [INFO] |
| staging | INFORM_5m | [INFO] |
| production | INFORM_5m + [CRIT] 헤더 실패 시 | [INFO] / 실패 시 [CRIT] |

prod 배포 전 추가 조건:
- 빌드/테스트 통과 (reviewer 헬스 점수 명시)
- Release Manager → team-secretary 배포 윈도우 확인
- FeatureFlag 목록 확인

---

## git push 정책

| 명령 | 정책 | 근거 |
|------|------|------|
| `git push origin main` | INFORM_5m | 배포 흐름 일부 |
| `git push --force` | 차단 (team-dev 내부 차단) | 히스토리 파괴 위험 |
| `git push --force-with-lease` | GATE_24h | 다소 안전하나 파괴적 |
| `git push origin feature/*` | SILENT | 브랜치 push |

---

## worker 호출 규칙

- INFORM/GATE 유예 기간 동안 worker 절대 호출 금지
- 유예 종료 시점에만 cancel 확인 후 worker 호출
- worker 실행 중 별도 취소 불가 (Agent tool 제약)
- healer 최대 3회 재시도 → 3회 실패 시 circuit breaker → `healing_failed` + 수동 개입 요청

---

## 배포 롤백 규칙

1. 배포 실패 감지 시 즉시 자동 롤백 시도 (git revert, vercel rollback)
2. 롤백 성공 → Telegram [INFO] "롤백 완료"
3. 롤백 실패 → Telegram [CRIT] "PROD 배포 실패 + 롤백 실패. 수동 개입 필요"
4. 상태: `emergency_manual_required`
5. 롤백 중 worker 호출 2회 허용 (revert 커밋 + push)

---

## design-marketing-integration 연동 정책

design-marketing-integration.md § 8 팀-dev 행 전체 포함 + design 특화 항목:

| 트리거 | 정책 | 근거 |
|--------|------|------|
| team-marketing CRO → UI 변경 구현 요청 | INFORM_5m | 코드 수정 |
| Web/Commerce/Media S3 착수 | INFORM_5m | 구현 시작 |
| 랜딩 페이지 prod 배포 | INFORM_5m | 가역성 확보 |
| `quality_gates.brand` 실패 (금지 어휘) | 즉시 차단 (PostToolUse) | Brand Consistency Gate |
| `quality_gates.license` 실패 | 즉시 차단 | 라이선스 위반 |

---

## Telegram 메시지 포맷

| 상황 | prefix | 예시 |
|------|--------|------|
| INFORM 시작 | [INFO] | `[INFO] team-dev: {액션} 시작 예정. 5분 내 /cancel {trace_id} 가능` |
| GATE 승인 요청 | [HIGH] | `[HIGH] team-dev: GATE_{Xh} 승인 필요. /approve {id}` |
| 최후 알림 | [CRIT] | `[CRIT] team-dev: 최후 1시간. /approve 또는 /reject {id}` |
| 실행 중 | [INFO] | `[INFO] team-dev: 배포 진행 중... (80%)` |
| 완료 | [INFO] | `[INFO] team-dev: {액션} 완료. {결과 요약}` |
| 에러 | [HIGH] | `[HIGH] team-dev: {액션} 실패 — {에러 요약}` |
| prod 장애 | [CRIT] | `[CRIT] team-dev: PROD 배포 실패. 롤백 {성공|실패}` |
| 인시던트 | [CRIT] | `[CRIT] team-dev: 인시던트 감지. severity: {level}` |

---

## 활동 카운터 갱신

- `monthly_prs_reviewed++`: reviewer 실행 후 outbox 기록 시
- `monthly_deploys++`: 배포 성공 시만 (실패 카운트 제외)
- `monthly_healings++`: /autofix 또는 healer 성공 시
- `monthly_decisions++`: 모든 outbox 기록 시 (성공/실패 포함)
- `roles.<role>.monthly_*`: 각 Role별 세부 카운터 (scenarios.md 상태 업데이트 섹션 참조)

---

## 참조

- 상위 SSOT: `~/.claude/rules/design-marketing-integration.md` § 8 승인 정책 매트릭스
- 공통: `~/.claude/skills/team-common/SKILL.md`
- 체크포인트: `~/.claude/skills/jarvis/references/checkpoint-protocol.md`
- 보안: `~/.claude/rules/security.md`
- 라우팅: `~/.claude/skills/team-dev/references/role-routing.yaml`
- 시나리오: `~/.claude/skills/team-dev/references/scenarios.md`
