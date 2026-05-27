---
name: briefing
description: "데일리 브리핑. 연결된 MCP/채널에서 정보 수집 + 온톨로지 활성 프로젝트 참조. /briefing으로 호출. '브리핑', '오늘 뭐 있어', '상황 정리' 키워드로도 호출. 미연결 소스는 자동 건너뜀."
---

# 데일리 브리핑 스킬

## 실행 흐름

1. **온톨로지 조회**: ~/.Codex/memory/ontology/graph.jsonl에서 Project(status:active) 조회 → 활성 프로젝트 목록

2. **소스 수집** (가능한 소스만, 병렬 sub-agent haiku):
   - Gmail MCP → 미읽음 중요 메일 요약
   - Google Calendar MCP → 오늘 일정
   - GitHub MCP → 내 PR, 리뷰 요청, 이슈 알림
   - Telegram → 미읽음 멘션/DM
   - 미연결 소스 → 건너뜀 + "/channel-guide로 설정 가능" 안내

3. **브리핑 생성** (아래 형식):

```markdown
# 브리핑 (YYYY-MM-DD)

## 활성 프로젝트
(온톨로지 기반 목록)

## 오늘 할 일 (우선순위)
1. ...
2. ...

## 확인 필요 (메시지/PR/이슈)
- ...

## 일정
- ...

## 마케팅 팀 활동 (지난 7일 / 월간)
(team-marketing state.json.roles.* 카운터 집계 — 비어있으면 섹션 생략)
- CMO Strategist: strategies_drafted=N, positions_updated=N
- Insight Analyst: voc_reports=N, competitor_intel=N
- Copy & Content Chief: copies_written=N, content_published=N, copy_edits=N
- CRO Engineer: cro_audits=N, ab_tests_set=N
- Acquisition Lead: seo_audits=N, ad_campaigns=N, analytics_events=N
- Growth & GTM Ops: retention_ops=N, referrals_shipped=N

## 제안
- ...
```

4. **저장**: ~/workspace/briefings/YYYY-MM-DD.md
5. **텔레그램 전송** (Channels 연결 시)

## 초기 상태 (MCP 없음)

```
# 브리핑 (YYYY-MM-DD)
## 활성 프로젝트: 없음
→ /ontology add Project [이름]으로 등록하세요
## 연결된 소스: 없음
→ /channel-guide로 Gmail, Calendar, GitHub, Telegram을 설정하면 브리핑이 풍부해집니다.
```

## /schedule 연동
매일 아침 자동 실행하려면:
```
/schedule "매일 아침 9시 /briefing 실행" --frequency daily
```
