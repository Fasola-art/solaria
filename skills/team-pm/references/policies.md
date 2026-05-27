# Team PM 승인 정책

SSOT: `rules/pm-skills-integration.md` §8

## 기본: SILENT (L3 자율)

문서 작성·분석·PRD·OKR·스프린트·회고·이력서·NDA·Privacy 등은 기록만 하고 자동 실행.

## INFORM_5m (5분 유예 후 자동 확정)

| 액션 | 공유 대상 |
|---|---|
| OKR 분기 확정 | team-secretary (리마인드 등록) |
| Release 배포 연계 | team-dev (Release Manager) |
| 대량 문서 발송 (10+) | 사용자 (Telegram) |

## GATE_24h (24시간 내 승인 필수)

| 액션 | 공유 대상 | 리마인드 |
|---|---|---|
| Pricing 권고 | team-accounting | 6h/12h/1h |
| 외주 계약서 발송 | team-secretary | 6h/12h/1h |
| 외주비 집행 (50만원+) | team-accounting | 6h/12h/1h |

## 즉시 차단

- 시크릿 노출 (SQL 출력에 password/API_KEY/DATABASE_URL 포함)
- 민감 엔티티(Battlecard/Assumption/OKR/Beachhead) 외부 공유 시도
- `hooks/secret-scanner.sh` PostToolUse에서 자동 감지

## 유예 타이머 로직
재사용: `~/.claude/skills/jarvis/references/checkpoint-protocol.md`

## 외부 팀 통지 포맷
```jsonl
~/.claude/teams/_bus/outbox/pm.jsonl
{"ts":"...","role":"<role>","action":"<action>","policy":"INFORM_5m|GATE_24h","target_team":"...","originating_team":"pm"}
```
