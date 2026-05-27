# 상태 파일 스키마 (L3 하이브리드 v2)


## Contents

- [1. trust.json (v2 하이브리드)](#1-trustjson-v2-하이브리드)
  - [폐기된 v1 필드](#폐기된-v1-필드)
- [2. plan.json (프로젝트별, 기존 유지)](#2-planjson-프로젝트별-기존-유지)
- [3. progress.json (기존 유지 + team_id 추가)](#3-progressjson-기존-유지-team_id-추가)
- [4. _bus 파일 3종 (Paperclip P1/P3)](#4-_bus-파일-3종-paperclip-p1p3)
  - [_bus/inbox/<team>.jsonl (요청 큐)](#_businboxteamjsonl-요청-큐)
  - [_bus/outbox/<team>.jsonl (완료 리포트)](#_busoutboxteamjsonl-완료-리포트)
  - [_bus/decisions.jsonl (감사 타임라인, 공용)](#_busdecisionsjsonl-감사-타임라인-공용)
  - [_bus/manifest.jsonl (팀별 스킬 카탈로그)](#_busmanifestjsonl-팀별-스킬-카탈로그)
- [5. 디렉토리 구조 (v2)](#5-디렉토리-구조-v2)
- [6. 참조](#6-참조)

> 2026-04-11 v2 개편. trust.json 구조 전면 재설계. 팀 구조 + bus 파일 3종 추가.

## 1. trust.json (v2 하이브리드)

`~/.claude/jarvis/trust.json`:

```json
{
  "mode": "L3_hybrid",
  "version": 2,
  "skills": {
    "code_write": {
      "successes": 3,
      "failures": 0,
      "score": 0.3,
      "last_used": "2026-04-08",
      "history": [1, 1, 1]
    }
  },
  "teams": {
    "dev": {
      "autonomy": "L3",
      "score": 1.0,
      "successes": 0,
      "failures": 0,
      "checkpoints": {
        "implementation_start": { "type": "INFORM", "grace_seconds": 300 },
        "deploy_start":         { "type": "INFORM", "grace_seconds": 300 }
      },
      "activity": {
        "monthly_decisions": 0,
        "monthly_prs_reviewed": 0,
        "monthly_deploys": 0,
        "monthly_healings": 0,
        "last_activity": null
      }
    },
    "secretary": {
      "autonomy": "L3", "score": 1.0, "successes": 0, "failures": 0,
      "checkpoints": {},
      "activity": {
        "monthly_decisions": 0,
        "monthly_briefings_sent": 0,
        "monthly_schedule_conflicts_resolved": 0,
        "last_activity": null
      }
    },
    "accounting": {
      "autonomy": "L3", "score": 1.0, "successes": 0, "failures": 0,
      "checkpoints": {},
      "activity": {
        "monthly_decisions": 0,
        "monthly_transactions": 0,
        "monthly_ledger_entries": 0,
        "outliers_detected": 0,
        "last_activity": null
      }
    },
    "investment": {
      "autonomy": "L3", "score": 1.0, "successes": 0, "failures": 0,
      "checkpoints": {
        "trade_order":    { "type": "GATE", "timeout_seconds": 86400 },
        "rebalancing":    { "type": "GATE", "timeout_seconds": 86400 },
        "stop_loss":      { "type": "GATE", "timeout_seconds": 86400 },
        "funds_transfer": { "type": "GATE", "timeout_seconds": 86400 }
      },
      "activity": {
        "monthly_decisions": 0,
        "monthly_trade_signals": 0,
        "monthly_trades_executed": 0,
        "monthly_approvals": 0,
        "monthly_rejections": 0,
        "portfolio_delta_krw": 0,
        "last_activity": null
      }
    },
    "marketing": {
      "autonomy": "L3", "score": 1.0, "successes": 0, "failures": 0,
      "checkpoints": {},
      "activity": {
        "monthly_decisions": 0,
        "monthly_content_published": 0,
        "monthly_campaigns_completed": 0,
        "last_activity": null
      }
    },
    "business": {
      "autonomy": "L3", "score": 1.0, "successes": 0, "failures": 0,
      "checkpoints": {},
      "activity": {
        "monthly_decisions": 0,
        "monthly_competitor_updates": 0,
        "monthly_reports_generated": 0,
        "last_activity": null
      }
    }
  },
  "global": {
    "total_tasks": 3,
    "last_reset_date": "2026-04-08"
  }
}
```

### 폐기된 v1 필드
- `global.daily_auto_approved`, `global.daily_limit`, `global.daily_reset_date` → 자율성 제한 불필요
- 개별 팀에 `risk_multiplier`, `hard_limits`, `read_only` 등 → checkpoints 맵으로 통일

## 2. plan.json (프로젝트별, 기존 유지)

`~/.claude/jarvis/projects/[project-id]/plan.json`:

```json
{
  "id": "jarvis_[project-name]_[YYYYMMDD]",
  "goal": "프로젝트 목표 (원문)",
  "scale": "small|medium|large",
  "created_at": "ISO8601",
  "phases": [
    {
      "id": "phase_1",
      "name": "Phase 이름",
      "status": "pending|in_progress|completed|failed",
      "tasks": [
        {
          "id": "task_1_1",
          "name": "태스크 이름",
          "type": "research|code|test|deploy|content|financial",
          "domain": "dev|secretary|accounting|investment|marketing|business|null",
          "deps": [],
          "delegate_to": "team-dev|worker|reviewer|/research|...",
          "status": "pending|in_progress|completed|failed|skipped",
          "result": null
        }
      ]
    }
  ]
}
```

v2 추가: `tasks[].domain` — Phase 3에서 팀 분배 시 사용.

## 3. progress.json (기존 유지 + team_id 추가)

```json
{
  "project_id": "jarvis_[name]_[date]",
  "started_at": "ISO8601",
  "current_phase": "phase_2",
  "current_task": "task_2_3",
  "completed_tasks": 12,
  "failed_tasks": 1,
  "total_tasks": 20,
  "checkpoints": [
    {
      "type": "INFORM|GATE",
      "team": "dev",
      "action": "deploy_start",
      "phase": "phase_3",
      "timestamp": "ISO8601",
      "decision": "executed|cancelled|approved|rejected|pending",
      "trace_id": "..."
    }
  ],
  "last_updated": "ISO8601"
}
```

v1 차이: `total_tokens_used` 제거 (CLI 환경에서 의미 없음), `team` + `action` + `trace_id` 필드 추가.

## 4. _bus 파일 3종 (Paperclip P1/P3)

### _bus/inbox/<team>.jsonl (요청 큐)
```json
{
  "msg_id": "01HN7K2PQRS-dev-0001",
  "ts": "2026-04-11T08:00:00+09:00",
  "from": "do|jarvis|user",
  "to": "team-dev",
  "intent": "review_pr|deploy|brief_morning|...",
  "payload": { "...": "..." },
  "priority": "urgent|high|normal|low",
  "trace_id": "jarvis-phase3-task-7",
  "status": "pending"
}
```

### _bus/outbox/<team>.jsonl (완료 리포트)
```json
{
  "msg_id": "01HN7K2PQRS-dev-0001",
  "ts": "2026-04-11T08:14:32+09:00",
  "from": "team-dev",
  "to": "do",
  "result": "success|failure|cancelled",
  "summary": "PR #142 리뷰 완료...",
  "artifacts": ["~/workspace/reports/pr-142-review.md"],
  "metrics": { "files_reviewed": 12 },
  "trace_id": "jarvis-phase3-task-7"
}
```

### _bus/decisions.jsonl (감사 타임라인, 공용)
```json
{
  "decision_id": "01HN7K2PQRS-decision-0001",
  "ts": "2026-04-11T08:14:32+09:00",
  "trace_id": "jarvis-phase3-task-7",
  "team": "investment",
  "action": "trade_order",
  "checkpoint_type": "GATE",
  "decision": "approved|rejected|pending|executed|cancelled",
  "decided_by": "user|system",
  "decision_channel": "telegram|cli|auto",
  "payload_ref": "_bus/inbox/investment.jsonl#msg_id=...",
  "reasoning": "...",
  "metadata": { "...": "..." }
}
```

### _bus/manifest.jsonl (팀별 스킬 카탈로그)
```json
{"team": "dev", "skills": ["autofix", "test-driven-development", "jarvis", "codex-route", "simulate", "workflow"]}
```

## 5. 디렉토리 구조 (v2)

```
~/.claude/jarvis/
├── trust.json                    # v2 하이브리드 (L3 + teams + checkpoints + activity)
├── cron.log                       # Cron 실행 로그
├── channel-session.log            # Session A 로그
├── channel-session.stdout.log
├── channel-session.stderr.log
├── bus-watcher.log
└── projects/
    └── [project-id]/
        ├── plan.json             # 태스크 트리 (domain 태그 추가)
        ├── progress.json         # 진행 상태 (team_id 필드 추가)
        ├── decisions.md          # 프로젝트별 체크포인트 이력 (v1 유지)
        └── phases/
            └── phase_N/

~/.claude/teams/
├── _bus/
│   ├── inbox/<team>.jsonl        # 6팀 요청 큐
│   ├── outbox/<team>.jsonl       # 6팀 완료 리포트
│   ├── decisions.jsonl           # 전 팀 공용 감사 로그
│   ├── manifest.jsonl            # 팀별 호출 가능 스킬 카탈로그
│   └── archive/YYYY-MM/          # 월간 로테이션 (bus-rotate.sh)
└── <name>/                       # 팀별 (Stage B/C에서 생성)
    ├── state.json
    └── history.jsonl

~/.claude/scripts/
├── cron-runner.sh                # Cron 단발 실행 래퍼
├── bus-rotate.sh                 # 월간 로테이션
└── jarvis-channel-session.sh     # Session A 진입점

~/.claude/launchd/
├── com.mane23.jarvis.channel-session.plist   # Session A (상주)
├── com.mane23.jarvis.bus-watcher.plist       # inbox 변경 감지
└── INSTALL.md                    # 사용자 수동 배치 가이드
```

## 6. 참조

- `trust-risk-engine.md` — Score/Activity 계산 상세
- `checkpoint-protocol.md` — INFORM/GATE 동작 상세
- `task-decomposition.md` — domain 태그 부여 규칙
- `~/.claude/skills/team-common/SKILL.md` — 팀 공통 템플릿
