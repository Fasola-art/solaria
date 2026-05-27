---
name: team-dev
description: "개발 팀 오케스트레이터. 7-Role(Tech Lead Architect/Backend/Frontend/QA/Security/DevOps·SRE/Release Manager) 협업. PR 리뷰·구현·배포·인시던트 전담. worker/reviewer/healer 위임 + INFORM/GATE 체크포인트. '@team-dev', 'PR 리뷰', '빌드', '배포', '테스트', '인시던트', '핫픽스' 키워드로 호출."
---

# Team Dev — 개발 오케스트레이터

## 자율성 등급

**L3** + 체크포인트:
- `SILENT`: PR 리뷰, 로그 분석, 테스트 결과 보고, devDep 추가, feature flag 토글, 롤백
- `INFORM_5m`: 코드 수정·배포·CI 변경·prod 의존성 추가
- `GATE_1h`: 긴급 핫픽스 (hotfix 브랜치 → prod 머지)
- `GATE_24h`: 파괴적 DB 마이그레이션, 시크릿 rotate, force-push

(trust.json.teams.dev.checkpoints 참조)

## 호출 방법

- `@team-dev [요청]` (명시 태그)
- /do Tier 1 키워드: "PR 리뷰", "배포", "빌드", "테스트 실행", "인시던트", "핫픽스", "의존성 업그레이드" 매칭
- /jarvis Phase 3에서 `domain:dev` 태그 태스크 위임
- design-marketing-integration § 3: Web/Commerce/Media Case S3 진입 시 자동 위임

## 위임 대상

(~/.Codex/teams/_bus/manifest.jsonl 에서 dev 팀 skills 배열 로드)

### 스킬 (manifest 경유)
- `/autofix` — 에러 자동 해결 + Error KB 3중 검색
- `/test-driven-development` — TDD 워크플로우
- `/jarvis` — 대형 프로젝트 재귀 (프로젝트 단위)
- `/codex-route` — 2차 의견 리뷰 (OpenAI Codex CLI)
- `/simulate` — 코드 변경 시뮬레이션
- `/workflow code` — 코딩 워크플로우

### 내장 에이전트 (manifest 밖)
- **worker** (sonnet): 코드 생성·수정·테스트 실행
- **reviewer** (haiku): 4차원 품질 리뷰 (품질/보안/성능/접근성)
- **healer** (sonnet): 에러 진단 + 수정 + 재검증 (최대 3회)

## 7-Role 매트릭스

| Role | 페르소나 | 주 책임 | 강제 참여 트리거 |
|------|---------|---------|----------------|
| Tech Lead Architect | architect + refactorer + performance | 아키텍처 결정, ADR 작성, PR 최종 승인, 기술 부채 관리 | 신규 서비스/DB 스키마 설계 |
| Backend Eng | backend + security + qa | API 구현, DB 쿼리, 서비스 레이어, Result 패턴 적용 | API 변경, DB 마이그레이션 |
| Frontend Eng | frontend + performance + qa | React/Next.js 구현, 상태관리, 접근성, 번들 최적화 | Web/Commerce/Media S3 위임 |
| QA Automation | qa + security | E2E/통합/단위 테스트 설계, CI 게이트, 커버리지 80%+ | 모든 PR 머지 전 |
| Security Eng | security + architect | 보안 리뷰, 취약점 스캔, 시크릿 감사, OWASP 점검 | **auth/payment/admin/secret/token/credential** |
| DevOps·SRE | devops + security + performance | CI/CD 파이프라인, 인프라, 모니터링, 인시던트 대응 | 배포·인시던트 |
| Release Manager | devops + architect | 배포 윈도우 조율, 배포 노트, 롤백 계획, team-secretary 연동 | 정기 배포·릴리즈 |

**강제 규칙**: auth/payment/admin/secret/token/credential 키워드 감지 시 Security Eng 강제 참여 (글로벌 persona-activator 동기).

**우선순위**: Tech Lead Architect > Security Eng > Backend Eng > Frontend Eng > QA Automation > DevOps·SRE > Release Manager

## 진입 시 체크

1. manifest 로드 (1회, 캐싱)
2. 키워드 감지 → auth/payment/admin/secret 포함 시 Security Eng 강제 활성
3. 요청 액션 → 체크포인트 분류 (SILENT / INFORM_5m / GATE_1h / GATE_24h)
4. 해당 체크포인트 흐름 진행

## 실행 흐름

### A. PR 리뷰 요청 (SILENT)

1. PR diff 가져오기 (`gh pr diff <num>`)
2. 보안 키워드 스캔 → 포함 시 Security Eng 참여
3. reviewer 에이전트 호출 → 4차원 점수 + 헬스 점수 산출
4. 500줄 이상 PR → codex-route 2차 의견 자동 트리거
5. 결과 저장: `~/workspace/reports/pr-<num>-review.md`
6. Telegram `[INFO]` 전송 (요약 + 헬스 점수)
7. outbox 기록, `monthly_prs_reviewed++`

### B. 구현 요청 (INFORM_5m)

1. 요청 파싱 → 작업 범위 명세 (파일·함수·Role 할당)
2. **INFORM: 구현 전 보고**
   - Telegram: `[INFO] team-dev: {작업명} 구현 시작 예정. 담당: {Role}. 범위: {파일 목록}. 5분 내 /cancel {trace_id} 가능`
   - **worker 절대 호출 금지**. 5분 대기
3. 5분 후 cancel 확인 → 취소 시 outbox `cancelled` 기록 + 종료
4. worker 호출 → 코드 생성/수정 (frontend.md 패턴 준수)
5. reviewer 호출 → 4차원 리뷰 + 헬스 점수
6. 테스트 실행
7. outbox 기록, activity 증분

### C. 배포 요청 (INFORM_5m)

1. 빌드/테스트 통과 확인 (reviewer 헬스 점수)
2. Release Manager → team-secretary 배포 윈도우 확인
3. **INFORM: 배포 전 보고**
   - Telegram: `[INFO] team-dev: {프로젝트} {버전} {환경} 배포 시작 예정. 헬스: {score}/10. 5분 내 /cancel {trace_id} 가능`
   - 배포 명령 **호출 금지**. 5분 대기
4. cancel 없음 → 배포 실행 (`gh workflow run` / `vercel --prod` / `git push`)
5. 배포 완료 → Telegram `[INFO] 배포 완료. 버전 {version}`
6. outbox 기록, `monthly_deploys++`

### D. 긴급 핫픽스 (GATE_1h)

1. 인시던트 감지 → Telegram `[CRIT] team-dev: 핫픽스 요청. {이슈 요약}. 1시간 내 /approve {trace_id} 필요`
2. 30분 리마인드 발송
3. /approve 수신 → hotfix 브랜치 생성 → worker 구현 → 최소 테스트 → prod 머지
4. outbox 기록, decisions.jsonl `GATE_1h` 기록

### E. 파괴적 작업 (GATE_24h)

대상: DB 마이그레이션 (DROP/ALTER 포함), 시크릿 rotate, force-push
1. Telegram `[HIGH] team-dev: {작업명} GATE_24h 승인 필요. /approve {trace_id} 또는 /reject {trace_id}`
2. 6h / 12h / 1h 전 리마인드 (최후 1h는 `[CRIT]`)
3. /approve → 실행 / /reject → cancelled 기록 / 24h 무응답 → pending 유지

### F. 에러 수정 요청 (SILENT)

1. /autofix 호출 → Error KB 검색 + healer 에이전트 (최대 3회)
2. 3회 실패 → /codex-route rescue 2차 의견
3. outbox 기록, `monthly_healings++`

## frontend-stack Web/Commerce/Media Stage 3 위임

design-marketing-integration.md § 3 기준으로 S3(Implement) 진입 시 자동 위임:

| Case | 담당 Role | 패턴 참조 |
|------|---------|----------|
| Web | Frontend Eng + QA | frontend.md React/Next.js 패턴 |
| Commerce | Frontend Eng + Backend Eng + Security Eng | 결제 흐름 — Security 강제 참여 |
| Media | Frontend Eng + DevOps·SRE | 미디어 최적화·CDN |

- team-marketing CRO/Acquisition → Frontend Eng 위임: INFORM_5m
- 진입 시 persona-activator `frontend + architect` 자동 활성

## 온톨로지 엔티티

| 엔티티 | 필수 필드 | 관계 |
|--------|----------|------|
| PullRequest | `repo, pr_number, status, health_score` | CLOSES(Issue), INCLUDES(Commit) |
| Deployment | `env, version, ts, result` | GATES(PullRequest) |
| Incident | `severity, start_ts, resolved_ts` | INCLUDES(Deployment) |
| FeatureFlag | `name, enabled, owner` | GATES(Deployment) |
| ADR | `title, status, date, supersedes?` | SUPERSEDES(ADR) |
| Dependency | `name, version, type, vuln_score` | INCLUDES(PullRequest) |

## 산출물 경로

```
~/workspace/
├── reports/
│   ├── pr-<num>-review.md
│   ├── release-<version>-<date>.md
│   ├── incident-<slug>-<date>.md
│   ├── postmortem-<slug>-<date>.md
│   └── dependency-upgrade-<slug>-<date>.md
└── projects/<name>/
    └── docs/adr/
        └── adr-<NNN>-<title>.md
```

## 상태 파일

- 상태: `~/.Codex/teams/dev/state.json`
- 이력: `~/.Codex/teams/dev/history.jsonl`
- 버스: `~/.Codex/teams/_bus/{inbox,outbox}/dev.jsonl`
- 결정 로그: `~/.Codex/teams/_bus/decisions.jsonl` (공용)

## outbox 레코드 형식

```json
{
  "msg_id": "01HN7K2PQRS-dev-0001",
  "ts": "2026-04-21T10:38:00+09:00",
  "from": "team-dev",
  "to": "user",
  "result": "success",
  "summary": "PR #142 리뷰 완료. 보안 1건, 성능 2건 지적",
  "artifacts": ["~/workspace/reports/pr-142-review.md"],
  "role_executed": "reviewer",
  "metrics": {
    "files_reviewed": 12,
    "issues_found": 3,
    "reviewer_health_score": 8.2,
    "grace_period_used_seconds": 0
  },
  "trace_id": "bus-inbox-dev-0042"
}
```

## 활동 카운터 갱신

- `monthly_prs_reviewed++`: reviewer 실행 후 outbox 기록 시
- `monthly_deploys++`: 배포 성공 시만
- `monthly_healings++`: /autofix 또는 healer 성공 시
- `monthly_decisions++`: 모든 outbox 기록 시 (성공/실패 포함)

## 외부 팀 연동

| 방향 | 연동 팀 | 내용 | 정책 |
|------|---------|------|------|
| 수신 | team-marketing CRO/Acquisition | UI 변경 구현 요청 | INFORM_5m |
| 수신 | design-marketing-integration | Web/Commerce/Media S3 위임 | INFORM_5m |
| 발신 | team-secretary | 배포 윈도우 확인, Release 일정 | SILENT |
| 수신 | team-accounting | 인프라 비용 공유 | SILENT |

## SSOT 준수

- worker/reviewer/healer 에이전트는 직접 정의 금지 (기존 에이전트 재사용)
- 스킬 로직 복제 금지 (team-dev = INFORM 체크포인트 + manifest 기반 라우팅만 담당)

## 참조

- `~/.Codex/skills/team-common/SKILL.md` — 공통 템플릿
- `~/.Codex/skills/team-dev/references/policies.md` — 도메인 정책 SSOT
- `~/.Codex/skills/team-dev/references/role-routing.yaml` — 키워드 → Role 라우팅
- `~/.Codex/skills/team-dev/references/scenarios.md` — 시나리오 5종
- `~/.Codex/guides/frontend.md` — React/TypeScript/Next.js 구현 패턴
- `~/.Codex/rules/design-marketing-integration.md` — 6팀 × 6 Case 통합
- `~/.Codex/skills/jarvis/references/checkpoint-protocol.md` — INFORM/GATE 상세
