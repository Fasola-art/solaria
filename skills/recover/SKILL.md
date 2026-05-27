---
name: recover
description: 세션 스냅샷 복원 스킬. /recover (최근), /recover --list, /recover --id [ID]. 중단된 작업 재개에 사용.
---

# Recover 스킬

session-snapshot.js 훅이 생성한 스냅샷을 사용해 작업 상태를 복원한다.

## 트리거
- /recover (기본): 가장 최근 스냅샷 요약 + 복원 제안
- /recover --list: 전체 스냅샷 목록 (시간순)
- /recover --id [ID]: 특정 스냅샷 복원

## 스냅샷 위치
~/.Codex/sessions/snapshots/ (FIFO 10개 보관)

## /recover 기본 동작

1. ls ~/.Codex/sessions/snapshots/*.json | tail -1 으로 최근 파일 확인
2. 없으면 "스냅샷 없음" 반환
3. JSON 로드 후 요약 표시:
   ```
   [최근 스냅샷: snap_20260413_143022]
   시간: 2026-04-13 14:30
   작업: {currentTask or "(unknown)"} [{currentTaskSource: todo|plan_file}]
   수정된 파일: N개 (세션 전체 누적)
   - file1
   - file2
   진행 상태:
   - 완료: N개
   - 진행 중: N개
   - 대기: N개
   ```
   - currentTaskSource가 'plan_file'이면 "(플랜 파일 기반 유추)" 표기 추가
   - currentTaskSource가 'todo'이면 "(TodoWrite 기반)" 표기 추가
4. 사용자에게 확인: "이 작업을 이어서 진행할까요?"
5. 승인 시:
   - todoState 있으면 TodoWrite로 재주입
   - modifiedFiles 있으면 각 파일을 Read로 컨텍스트 로드
   - workingDirectory로 cd 권장 표시
   - 복원 완료 메시지

## /recover --list

전체 스냅샷 목록 테이블:

| # | ID | 시간 | 트리거 | 파일 수 |
|---|-----|------|--------|---------|
| 1 | snap_20260413_143022 | 04-13 14:30 | file_modified | 2 |
| 2 | snap_20260413_120015 | 04-13 12:00 | git_commit | 5 |

## /recover --id [ID]

특정 스냅샷 파일을 찾아 /recover 기본 동작과 동일하게 복원.
ID가 존재하지 않으면 --list 제안.

## 복원 프로세스 상세

1. 스냅샷 JSON 로드
2. todoState 유효하면 TodoWrite 도구로 재주입 (완료/진행/대기 각각)
3. modifiedFiles 배열 순회하며 Read 도구로 컨텍스트 로드
4. workingDirectory 확인 후 사용자에게 cd 권장
5. gitStatus 있으면 현재 브랜치와 비교하여 불일치 시 경고
6. "복원 완료. 다음 단계를 진행합니다." 출력

## Vibe 키워드 연동
- "계속/cont" -> /recover 자동 호출
- "되돌려/undo" -> /recover --list 자동 호출

참조: ~/.Codex/guides/vibe-workflow.md

## External References

- Read `references/matt-handoff.md` when the user asks for a handoff document for another agent or session.
- Read `references/context-compression.md` when compressing long-running work into durable summaries that preserve intent, files, decisions, risks, and next actions.
