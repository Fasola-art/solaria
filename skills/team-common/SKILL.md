---
name: team-common
description: "6팀 공통 템플릿 및 헬퍼. 실제 호출 대상은 아니며 team-dev/secretary/accounting/investment/marketing/business가 이 문서를 참조하여 구조를 맞춘다. 공통 상수, 체크포인트 정책, outbox/decisions 기록 형식, manifest 조회 규칙 정의."
---

# Team Common — 공통 템플릿 (참조 전용)

**이 스킬은 직접 호출 대상이 아닙니다.** `team-*` 6개 스킬이 SKILL.md 구조·체크포인트 정책·bus 기록 형식을 일관되게 맞추기 위해 참조하는 SSOT입니다.

## 1. 팀 스킬 SKILL.md 표준 헤더

```markdown
---
name: team-<name>
description: "<한 줄 설명 — 호출 키워드 포함>"
---

# Team <Name>

## 자율성 등급
**L3** + 체크포인트: <해당 팀의 체크포인트 목록 또는 "없음">
(trust.json.teams.<name>.checkpoints 참조)

## 호출 방법
- `@team-<name> [요청]` (명시 태그)
- /do Tier 1 키워드 매칭 (섹션 참조)
- /jarvis Phase 3에서 `domain:<name>` 태그 태스크 위임

## 위임 대상
(~/.Codex/teams/_bus/manifest.jsonl 에서 팀별 skills 배열 로드)

## 실행 흐름
1. manifest 로드 (1회, 캐싱)
2. 체크포인트 평가 (trust.json.teams.<name>.checkpoints)
3. 위임 대상에 실제 작업 지시
4. 결과 수집 → outbox 기록
5. trust.json.teams.<name>.activity 카운터 증분
6. (필요 시) Telegram 알림

## 상태 파일
- 상태: ~/.Codex/teams/<name>/state.json
- 이력: ~/.Codex/teams/<name>/history.jsonl
- 버스: ~/.Codex/teams/_bus/{inbox,outbox}/<name>.jsonl
- 결정 로그: ~/.Codex/teams/_bus/decisions.jsonl (공용)

## 참조
- team-common/SKILL.md — 공통 템플릿 (이 문서)
- team-common/references/ — 세부 정책
```

## 2. manifest 조회 규칙

- **팀 호출 시작 시 1회만** `~/.Codex/teams/_bus/manifest.jsonl` 로드 (R28 완화)
- 실행 중 재로드 금지
- manifest에 없는 스킬 호출 금지 (allowlist 방식)
- manifest 수정은 Stage A에서만 (런타임 수정 금지)

구현 의사코드:
```
skills = []
for line in read_jsonl("~/.Codex/teams/_bus/manifest.jsonl"):
    if line["team"] == "<name>":
        skills = line["skills"]
        break
```

## 3. 체크포인트 정책 (섹션 11.2 반영)

### INFORM 5분 유예 (team-dev 구현/배포)
1. Telegram `reply` 도구로 "작업 시작 예정 — 5분 내 `/cancel <trace_id>` 응답 가능" 전송
2. 현재 Session A 내에서 5분 동안 새 메시지 대기
3. 5분 내 `/cancel <trace_id>` 수신 시 → outbox에 `abandoned` 기록, 실행 중단
4. 5분 경과 후에만 worker 호출 (취소 안전성 확보)
5. worker 시작 후에는 취소 불가

### GATE 24h 승인 (team-investment 매매)
1. Telegram으로 주문 상세 + `/approve <trace_id>` 또는 `/reject <trace_id>` 전송
2. 6h / 12h / 1h 전 리마인드 알림 (R26 완화)
   - 최후 1h는 CRITICAL prefix `[CRIT]`
3. `/approve` 수신 → 브로커 MCP 호출 → 주문 실행
4. `/reject` 수신 → outbox에 `rejected_by_user` 기록
5. 24h 무응답 → `pending` 상태 유지 (자동 거부 아님)

### SILENT (기본)
- 체크포인트 없는 작업은 즉시 실행
- 완료 시 outbox 기록 + trust.json.activity 증분
- Telegram 알림은 INFORM 레벨로 전송 가능 (일반 알림)

## 4. _bus 파일 스키마

### inbox/<team>.jsonl (요청 큐)
```json
{
  "msg_id": "01HN7K2PQRS-dev-0001",
  "ts": "2026-04-11T08:00:00+09:00",
  "from": "do",
  "to": "team-dev",
  "intent": "review_pr",
  "payload": { "repo": "...", "pr_number": 142 },
  "priority": "normal",
  "trace_id": "jarvis-phase3-task-7",
  "status": "pending"
}
```

### outbox/<team>.jsonl (완료 리포트)
```json
{
  "msg_id": "01HN7K2PQRS-dev-0001",
  "ts": "2026-04-11T08:14:32+09:00",
  "from": "team-dev",
  "to": "do",
  "result": "success",
  "summary": "PR #142 리뷰 완료. 보안 1건, 성능 2건 지적",
  "artifacts": ["~/workspace/reports/pr-142-review.md"],
  "metrics": { "files_reviewed": 12, "issues_found": 3 },
  "trace_id": "jarvis-phase3-task-7"
}
```

### decisions.jsonl (감사 타임라인, Paperclip P1)
```json
{
  "decision_id": "01HN7K2PQRS-decision-0001",
  "ts": "2026-04-11T08:14:32+09:00",
  "trace_id": "jarvis-phase3-task-7",
  "team": "investment",
  "action": "trade_order",
  "checkpoint_type": "GATE",
  "decision": "approved",
  "decided_by": "user",
  "decision_channel": "telegram",
  "payload_ref": "_bus/inbox/investment.jsonl#msg_id=...",
  "reasoning": "Telegram /approve 응답",
  "metadata": { "reviewer_health_score": null, "grace_period_used_seconds": 0 }
}
```

## 5. trust.json.activity 업데이트 규칙

팀 실행 완료 시 원자적 업데이트:

```
read trust.json
increment trust.teams.<name>.activity.monthly_decisions
increment 팀별 지표 (예: team-dev.activity.monthly_prs_reviewed)
update trust.teams.<name>.activity.last_activity = now()
write trust.json (flock 권장)
```

R19 완화: `flock(1)` 사용하여 동시 쓰기 경쟁 방지.

## 6. Telegram 전송 규칙

- 모든 전송은 Session A의 Telegram 플러그인 `reply` 도구 사용
- prefix 규칙:
  - `[CRIT]` — GATE 최후 1시간 또는 긴급 알림
  - `[HIGH]` — 승인 대기 상태
  - `[INFO]` — 일상 알림 (INFORM)
  - prefix 없음 — SILENT 알림 (일반 완료 보고)
- 텍스트 길이 제한: 4096자 (Telegram 제한, 자동 chunking)

## 7. 팀 디렉토리 구조 (미래 생성)

Stage B/C에서 각 팀 생성 시:

```
~/.Codex/skills/team-<name>/
  SKILL.md              # 해당 팀의 진입점 (이 템플릿 구조 따름)
  references/
    policies.md         # 도메인 정책 SSOT
    templates/          # 보고 포맷

~/.Codex/teams/<name>/
  state.json            # 팀별 현재 상태 (진행 태스크, 최근 결정)
  history.jsonl         # 팀 내부 이력
```

## 8. 참조 문서

- `~/workspace/reports/jarvis-merge-plan.md` (전체 플랜 SSOT)
  - 섹션 11.2: 자율성 등급 매핑
  - 섹션 11.7: 팀별 상세 설계
  - 섹션 13: 운영 세부사항
  - 섹션 21: Paperclip 병합 패턴
  - 섹션 23: Phase 0 결과 + 아키텍처 재설계
- `references/context-multi-agent-patterns.md`: 멀티 에이전트 토폴로지, context isolation, supervisor/swarm/hierarchical coordination, handoff protocol 설계가 필요할 때 로드.
