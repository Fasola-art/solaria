---
name: jarvis
description: "자율 프로젝트 완성 오케스트레이터. 대규모 프로젝트(SaaS MVP, 앱, 시스템)를 체크포인트 기반 자율 완성. /jarvis [프로젝트 설명]으로 호출. /jarvis status, /jarvis continue, /jarvis abort, /jarvis trust. '프로젝트 만들어', 'MVP 개발', '자율 개발', 'jarvis' 키워드로도 호출."
---

# Jarvis — 자율 프로젝트 완성 오케스트레이터

기존 스킬(/research, /autofix, /workflow, /prd-create, /simulate)과 에이전트(worker, reviewer, healer)를 오케스트레이션하여 프로젝트를 자율 완성한다.

## 호출 모드

- `/jarvis [프로젝트 설명]` — 새 프로젝트 시작
- `/jarvis status` — 현재 프로젝트 진행 대시보드
- `/jarvis continue` — 마지막 체크포인트에서 재개
- `/jarvis abort` — 긴급 정지 + git stash 롤백
- `/jarvis trust` — 현재 신뢰도 점수 표시

## 6-Phase 프로세스

### Phase 0: INTAKE
$ARGUMENTS에서 프로젝트 목표 파싱 → 규모 분류:
- **Small** (≤5 태스크): /workflow로 위임 (Jarvis 불필요)
- **Medium** (5-15 태스크): Jarvis lite (Phase 1,2를 합치고 체크포인트 축소)
- **Large** (15+ 태스크): Full pipeline

프로젝트 디렉토리 생성:
```
~/.Codex/jarvis/projects/[project-id]/
├── plan.json        # 분해된 태스크 트리 + 의존성
├── progress.json    # 태스크 상태, 타임스탬프, 결과
├── decisions.md     # 체크포인트 결정 이력
└── phases/          # Phase별 산출물
```

### Phase 1: RESEARCH & DISCOVERY [GATE]
- /research deep [프로젝트 도메인]
- 온톨로지에서 관련 패턴/프로젝트 조회
- discovery-report.md 생성
- **→ AskUserQuestion: 리서치 결과 확인 + 진행 승인**

### Phase 2: DESIGN & PLANNING [GATE]
- TaskDecomposer: 목표 → phases → tasks (MAX_DEPTH=3)
- 의존성 그래프 구축 (ADAPTIVE 정렬)
- 태스크별 리스크 평가
- plan.json 생성
- 프로젝트 templates/ 적용 (PROJECT.md, ROADMAP.md, STATE.md)
- **→ AskUserQuestion: 전체 계획 확인 + 스코프 수정 가능 + 진행 승인**

### Phase 3: IMPLEMENTATION [L3 하이브리드 자율성]
각 Phase의 각 태스크에 대해:

**1. 태스크 태그 확인 (domain:*)**
TaskDecomposer가 부여한 `domain:<name>` 태그로 팀 분배 결정:

| 태그 | 위임 대상 팀 |
|---|---|
| `domain:dev` | team-dev (INFORM 2단계 체크포인트) |
| `domain:ops`, `domain:schedule`, `domain:brief` | team-secretary |
| `domain:finance` (지출) | team-accounting |
| `domain:finance` (조회/매매) | team-investment (GATE 매매 승인) |
| `domain:content`, `domain:sns` | team-marketing (legacy alias → `domain:marketing:copy`) |
| `domain:marketing:strategy` | team-marketing → CMO Strategist (포지셔닝/런칭/가격) |
| `domain:marketing:insight` | team-marketing → Insight Analyst (VOC/경쟁/콘텐츠 갭) |
| `domain:marketing:copy` | team-marketing → Copy & Content Chief (카피/편집/콘텐츠/SNS/이메일) |
| `domain:marketing:cro` | team-marketing → CRO Engineer (전환/온보딩/A/B) |
| `domain:marketing:acquisition` | team-marketing → Acquisition Lead (SEO/Paid/Analytics) |
| `domain:marketing:growth` | team-marketing → Growth & GTM Ops (리텐션/추천/세일즈) |
| `domain:market`, `domain:competitor` | team-business |
| 미태깅 | 기존 worker/reviewer 직접 위임 (아래 표) |

**2. 팀 위임 시 흐름**:
- `~/.Codex/teams/_bus/inbox/<team>.jsonl`에 요청 레코드 append
- launchd WatchPaths가 변경 감지 → Session A가 해당 팀 스킬 호출
- 팀 스킬이 manifest.jsonl 조회 → 위임 대상 결정 → 실행
- 결과는 `_bus/outbox/<team>.jsonl` 기록

**3. 미태깅 태스크 위임 (기존 경로, 변경 없음)**:

| 태스크 유형 | 위임 대상 | 모델 |
|------------|----------|------|
| 리서치 | /research | main |
| 코드 생성 | worker 에이전트 | sonnet |
| 코드 리뷰 | reviewer 에이전트 (4차원 품질) | haiku |
| 에러 수정 | /autofix → healer 에이전트 | sonnet |
| 콘텐츠 | worker 에이전트 | sonnet |
| 테스트 | worker 에이전트 (bash) | sonnet |
| 배포 | team-dev 경유 (INFORM 5분 유예) | sonnet |

**4. L3 하이브리드 자율성** (사용자 확정):
- 일상 업무: SILENT 즉시 실행
- team-dev 구현/배포: INFORM 5분 유예 (Session A에서 `/cancel` 대기)
- team-investment 매매: GATE 24h 명시 승인 필수
- 나머지: trust.json.teams.<name>.checkpoints 참조

5. 결과를 progress.json + `_bus/decisions.jsonl`에 기록
6. 실패 시 → healer (최대 3회) → circuit breaker
7. **Phase 완료 → INFORM (Telegram 알림, 중단하지 않으면 계속)**

### Phase 4: VERIFICATION [INFORM]
- reviewer 에이전트 → 전체 프로젝트 리뷰 (4차원)
- 테스트 실행 (해당 시)
- 품질 루브릭 체크
- **→ 결과 보고, 이슈 없으면 계속**

### Phase 5: DELIVERY [GATE]
- 프로젝트 요약 생성
- Git 커밋/PR (해당 시)
- 배포 → **반드시 사용자 승인**
- /learn → 프로젝트 패턴 캡처
- 온톨로지 프로젝트 엔티티 등록
- **→ AskUserQuestion: 최종 배포 승인**

## Trust & Activity 엔진 (L3 하이브리드, v2)

### 신뢰도 (Trust, 관찰용)
`~/.Codex/jarvis/trust.json` v2 스키마. 팀별 `score`는 **통계 관찰용**, 실행 차단에 사용하지 않음.

```json
{
  "mode": "L3_hybrid",
  "version": 2,
  "teams": {
    "dev": {
      "autonomy": "L3",
      "score": 1.0,
      "checkpoints": {
        "implementation_start": { "type": "INFORM", "grace_seconds": 300 },
        "deploy_start": { "type": "INFORM", "grace_seconds": 300 }
      },
      "activity": { "monthly_prs_reviewed": 0, "monthly_deploys": 0, ... }
    },
    "investment": {
      "autonomy": "L3",
      "score": 1.0,
      "checkpoints": {
        "trade_order": { "type": "GATE", "timeout_seconds": 86400 }
      },
      "activity": { "portfolio_delta_krw": 0, ... }
    }
  }
}
```

### 체크포인트 해석 (team-common 참조)
- **SILENT** (기본): 즉시 실행
- **INFORM grace_seconds**: Telegram으로 사전 보고 → N초 유예 → `/cancel` 미수신 시 실행
- **GATE timeout_seconds**: Telegram으로 승인 요청 → `/approve` 필수. 타임아웃 시 pending 보류 (자동 거부 아님)

### Activity 통계 (Budget 대체, Paperclip P2)
토큰/비용 추적은 폐기 (Max/Pro 구독 + CLI 환경). 대신:
- `team-dev.monthly_prs_reviewed`, `monthly_deploys`, `monthly_healings`
- `team-investment.monthly_trades_executed`, `portfolio_delta_krw`
- 각 팀 실행 완료 시 outbox append → state.json → trust.json.teams.<name>.activity 증분
- 월말 team-accounting이 집계해서 Telegram 리포트

### 삭제된 개념 (v1 → v2)
- 3중 게이트 (trust ≥ 0.85 AND risk ≤ 0.5 AND pattern ≥ 3)
- Risk 승수 (financial 1.5x 등)
- daily_auto_approved 카운터, daily_limit
- HITL 7개 불확실성 신호

이유: L3 하이브리드 정책이 "기본 자율 + 특정 액션만 체크포인트"로 단순화. 과거 복잡한 gate 로직 불필요.

## 체크포인트 유형 (L3 하이브리드)

| 유형 | 동작 | 사용 시점 |
|------|------|----------|
| **SILENT** | 즉시 자율 실행 | 기본. 일상 업무, 조회, 브리핑, 학습 |
| **INFORM** | Telegram 사전 보고 → grace_seconds 유예 → 실행 | team-dev 구현/배포 (5분 유예) |
| **GATE** | Telegram 명시 승인 필수 | team-investment 매매/리밸런싱 (24h) |

체크포인트는 `trust.json.teams.<name>.checkpoints` 맵에 팀/액션별로 지정. 기본값은 SILENT.

## 안전장치 (L3 하이브리드로 대폭 축소)

1. **긴급 정지**: `/jarvis abort` → git stash + 프로젝트 ABORTED (세션 내)
2. **Circuit breaker**: 동일 Phase 3연속 실패 → HALT + Telegram 알림
3. **Session A 상주**: launchd가 채널 세션을 KeepAlive로 유지 (비정상 종료 시 재시작)
4. **최소 보안 가드**: `settings.json` deny 2건 (`rm -rf /`, `rm -rf ~`) + Anthropic 모델 safety layer
5. **bus 로테이션**: 매월 1일 `bus-rotate.sh`가 `_bus/*.jsonl`을 `archive/YYYY-MM/`으로 이동 (디스크 고갈 방지)

### 삭제된 안전장치 (v1 → v2, L3 결정)
- 일일 자동 승인 한도 50회
- 금융/삭제/배포 GATE 강제
- 비용 가드 (Phase당 100K, 프로젝트당 500K 토큰)
- 체크포인트 24h 타임아웃 자동 pause → 대신 팀별 `checkpoints.timeout_seconds`로 개별 설정

## 예시

### Small (→ /workflow 위임)
```
/jarvis "블로그 글 하나 써줘: AI 에이전트 트렌드"
→ Scale: small → /workflow content blog "AI 에이전트 트렌드"
```

### Medium
```
/jarvis "GitHub README 자동 생성기 CLI 도구"
→ Phase 1: /research quick "README generator CLI" [GATE]
→ Phase 2: Plan (scaffold, core, tests) [GATE]
→ Phase 3: worker × 3 tasks [AUTONOMOUS]
→ Phase 4: reviewer [INFORM]
→ Phase 5: git commit [GATE for push]
```

### Large
```
/jarvis "AI 기반 일정 관리 SaaS MVP"
→ Phase 1: /research deep "AI scheduling SaaS market" [GATE]
→ Phase 2: Full decomposition (4 sub-phases, 20+ tasks) [GATE]
→ Phase 3: Implementation (INFORM per sub-phase)
→ Phase 4: Full verification + integration test [INFORM]
→ Phase 5: Deployment prep [GATE]
```

## 상세 참조
- references/trust-risk-engine.md — Trust 공식, Risk 매트릭스, Auto-Approval 로직
- references/task-decomposition.md — 7개 분해 패턴, MAX_DEPTH, 프로젝트 템플릿
- references/checkpoint-protocol.md — GATE/INFORM/SILENT 정의, HITL 신호
- references/state-schema.md — plan.json, progress.json, trust.json 스키마
