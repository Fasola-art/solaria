# team-secretary 실행 시나리오 5종


## Contents

- [시나리오 A: 아침 브리핑 (`"브리핑해줘"` / `"오늘 어때"` / cron morning)](#시나리오-a-아침-브리핑-브리핑해줘-오늘-어때-cron-morning)
- [시나리오 B: 저녁 정리 (`"오늘 마무리"` / cron evening)](#시나리오-b-저녁-정리-오늘-마무리-cron-evening)
- [시나리오 C: 미팅 30분 전 알림 + 참석자 1-pager](#시나리오-c-미팅-30분-전-알림-참석자-1-pager)
- [시나리오 D: 이메일 트리아지 4-bucket (`"이메일 정리해줘"`)](#시나리오-d-이메일-트리아지-4-bucket-이메일-정리해줘)
- [시나리오 E: 캠페인 D-day 알림 (`"런칭 D-day 관리해줘"`)](#시나리오-e-캠페인-d-day-알림-런칭-d-day-관리해줘)
- [공통 실행 규칙](#공통-실행-규칙)

자연어 요청 → 5-Role 자동 분기 → 실행 → 결과 보고.

**공통 원칙**:
- gws 실패 시 접근 가능한 정보만으로 계속 진행 (부분 성공 허용)
- CRITICAL 이메일 및 2시간 이내 일정은 항상 최상단 노출
- 사용자에게 Role 이름 노출 안 함. 결과만 통합 제시
- INFORM_5m 대상 외 전체 SILENT 자율 실행

---

## 시나리오 A: 아침 브리핑 (`"브리핑해줘"` / `"오늘 어때"` / cron morning)

**매핑**: Briefing Composer 주 Role + Email Triage Specialist 내포

```
트리거
  키워드: "브리핑", "아침", "morning", "오늘 어때"
  또는 cron: claude --print --bare "/team-secretary morning"

Phase 1: 데이터 수집 (병렬)
  gws gmail 미읽음 중요 메일 최대 10건
  gws calendar 오늘 00:00~23:59 일정
  /briefing → 온톨로지 Project(status:active) 조회

Phase 2: Email Triage Specialist
  4-bucket 분류:
    CRITICAL: 긴급·마감·오늘까지·is:important 동시 매칭
    REPLY: 질문·요청·승인 필요
    FYI: 공지·정보 공유
    NOISE: 광고·자동발송
  CRITICAL 존재 시 → Telegram [CRIT] prefix 즉시 선발송

Phase 3: GBrain 맥락 주입 (선택)
  발신자·참석자 엔티티 감지 → gbrain search → Assessment/Open Threads 삽입
  실패·미설치 시 스킵 (브리핑 차단 금지)

Phase 4: 브리핑 조립 (Briefing Composer)
  /briefing 포맷 준수 (SSOT)
  섹션 순서: 요약 → CRITICAL 이메일 → 2시간 내 일정 → 오늘 전체 일정 → REPLY 이메일 → FYI → 활성 프로젝트 → 제안
  저장: ~/workspace/briefings/YYYY-MM-DD-morning.md

Phase 5: 전송 + 기록
  Telegram reply 전송 (4096자 초과 시 chunking)
  GBrain 지식화 비동기 처리 (브리핑 차단 금지)
  outbox append + trust.json 업데이트

사용자 노출 예시:
  [2026-04-21 아침 브리핑]
  - 미읽음 이메일 5건 (긴급 1건: ABC 대표로부터 계약 관련)
  - 오늘 미팅 2건 (10:00 팀 스탠드업, 14:00 외부 미팅)
  - 활성 프로젝트 3개
  ---
  [긴급] ABC 대표 — "계약서 오늘 오전까지 검토 부탁" → 회신 초안 첨부
  [10:00] 팀 스탠드업 @ Meet (30분)
  [14:00] 외부 미팅 — 홍길동 외 2명
```

---

## 시나리오 B: 저녁 정리 (`"오늘 마무리"` / cron evening)

**매핑**: Briefing Composer 주 Role

```
트리거
  키워드: "저녁", "evening", "오늘 마무리", "내일 미리보기"
  또는 cron: claude --print --bare "/team-secretary evening"

Phase 1: 데이터 수집 (병렬)
  gws gmail 오늘 처리 이메일 + 잔여 미읽음
  gws calendar 내일 00:00~23:59 일정

Phase 2: 오늘 완료 정리
  처리된 CRITICAL/REPLY → 해결 여부 확인
  미처리 REPLY → 내일 CRITICAL로 상향 예고

Phase 3: 내일 미리보기
  내일 2시간 이내 일정 (HIGH)
  내일 전체 일정 (NORMAL)
  내일 예정 D-day 리마인더 확인

Phase 4: 저녁 브리핑 조립
  저장: ~/workspace/briefings/YYYY-MM-DD-evening.md
  Telegram 전송 + outbox 기록

사용자 노출 예시:
  [2026-04-21 저녁 정리]
  - 오늘 처리: 이메일 4/5건 완료 (미처리 1건 → 내일 오전 팔로우업 필요)
  - 내일 일정 3건 (09:00 기상 알람, 10:30 투자 검토, 15:00 팀 리뷰)
  - [참고] ABC 계약 건 내일 오전까지 회신 필요
```

---

## 시나리오 C: 미팅 30분 전 알림 + 참석자 1-pager

**매핑**: Calendar Coordinator 주 Role

```
트리거
  gws calendar 이벤트 startTime - 30분 = 현재 (cron 1분 단위 체크)
  또는 사용자: "다음 미팅 준비해줘", "미팅 브리핑", "<이름> 미팅 자료"

Phase 1: 이벤트 상세 조회
  gws calendar 해당 이벤트: 참석자 목록·장소·설명·첨부파일

Phase 2: 참석자 조회 (researcher 페르소나)
  각 참석자 → GBrain search → Assessment / Open Threads / 최근 소통 이력
  GBrain 미설치 시 온톨로지에서 관련 Project/Person 엔티티 조회

Phase 3: 관련 프로젝트 조회
  온톨로지 Project(관련 키워드 매칭) → 최근 상태·마일스톤

Phase 4: 1-pager 생성
  저장: ~/workspace/reports/meeting-prep/<event-id>.md
  포맷:
    ## 미팅 개요
    - 일시·장소·참석자
    ## 참석자 컨텍스트
    - [이름] 최근 상호작용·관심사·미결 이슈
    ## 관련 프로젝트 현황
    ## 논의 예정 아젠다 (이벤트 설명 기반)
    ## 준비 체크리스트

Phase 5: Telegram 전송
  "[30분 후] 미팅 준비 완료 — 1-pager: <링크>"
  outbox append

사용자 노출:
  [14:00 외부 미팅 — 30분 전]
  참석자: 홍길동 (ABC, 대표) — 지난주 계약 건 논의 중, Open: 조건 3항 미합의
  관련 프로젝트: ABC 협업 (status: negotiation)
  아젠다: 계약 조건 최종 확인 → 준비 자료: 계약서 v3, 비교표
  → ~/workspace/reports/meeting-prep/abc-20260421-1400.md
```

---

## 시나리오 D: 이메일 트리아지 4-bucket (`"이메일 정리해줘"`)

**매핑**: Email Triage Specialist 주 Role

```
트리거
  키워드: "이메일 정리", "메일 확인", "트리아지", "받은 편지함"
  또는 Briefing Composer 내포 실행

Phase 1: 미읽음 수집
  gws gmail messages list --params '{"q": "is:unread", "maxResults": 30}' --json

Phase 2: 4-bucket 분류 기준

  CRITICAL (즉각 대응):
    - is:important + 아래 키워드 중 1개 이상
    - 키워드: 긴급, urgent, ASAP, 확인바람, 검토, 오늘까지, 마감, 결정 필요
    - 발신자 허용리스트 매칭
    - Telegram [CRIT] 즉시 알림

  REPLY (회신 필요):
    - 질문문(?)·요청("~해주세요", "~부탁드립니다") 포함
    - CRITICAL 기준 미달
    - 상위 3건 회신 초안 자동 생성

  FYI (읽기만):
    - 공지·뉴스레터·자동 알림·수신 확인
    - 응답 불필요 확인 (발신자 noreply·newsletter 패턴)

  NOISE (무시 가능):
    - 광고·스팸·구독 취소 가능 뉴스레터
    - Unsubscribe 링크 포함 대량 발송

Phase 3: 결과 보고
  보고 구조:
    CRITICAL N건: [발신자] 제목 — 1줄 요약 + 회신 초안
    REPLY N건: [발신자] 제목 — 1줄 요약 + 회신 초안 (상위 3건)
    FYI N건: 합산 요약
    NOISE N건: "광고 M건 포함" 요약

Phase 4: 기록
  Email 엔티티 온톨로지 등록 (CRITICAL·REPLY만)
  outbox append

사용자 노출 예시:
  [이메일 정리 — 미읽음 12건]
  [긴급] ABC 대표 — "계약서 오늘 오전까지 검토" → 회신 초안 준비됨
  [회신 필요] 김철수 — "디자인 검토 의견 주시면" (3건 중 1건)
  [읽기만] 팀 공지 2건, GitHub 알림 3건
  [무시] 광고 4건
```

---

## 시나리오 E: 캠페인 D-day 알림 (`"런칭 D-day 관리해줘"`)

**매핑**: Reminder Ops 주 Role + Chief of Staff (외부 팀 연동)

```
트리거
  team-marketing CMO outbox에 campaign_dday 필드 포함 메시지 수신
  또는 사용자: "캠페인 D-day", "런칭 날짜 알림", "배포 일정 리마인드"

Phase 1: 이벤트 등록 (Chief of Staff)
  team-marketing CMO outbox 또는 사용자 입력에서 D-day 날짜·캠페인명 파싱
  온톨로지 Event 엔티티 등록:
    { name, datetime, type: "campaign_dday", campaign_id, owner: "team-marketing" }
  gws calendar에 D-day 이벤트 생성

Phase 2: 리마인드 스케줄 등록 (Reminder Ops)
  hermes-route 경유 크론 등록:
    D-3 06:00: "[D-3] 캠페인명 런칭 3일 전 — 준비 체크리스트 확인"
    D-1 06:00: "[D-1] 캠페인명 내일 런칭 — 최종 점검"
    D-0 06:00: "[D-day] 캠페인명 오늘 런칭!"
  Telegram prefix 규칙: D-3 [INFO] / D-1 [HIGH] / D-0 [CRIT]

Phase 3: 관련 팀 알림 (Chief of Staff)
  team-dev 배포 윈도우 공유 (SILENT)
  team-accounting 광고 예산 집행 예고 (INFORM_5m 해당 시)

Phase 4: 기록
  Reminder 엔티티 온톨로지 등록
  outbox에 reminder_scheduled 레코드 append

Phase 5: 실제 D-day 당일
  06:00 Telegram [CRIT] "오늘 런칭!" 알림
  런칭 완료 후 Event 엔티티 status: completed 업데이트

사용자 노출 예시:
  [D-day 등록 완료: 신규 서비스 런칭]
  - 런칭일: 2026-05-01
  - 알림 예정: 4/28 D-3, 4/30 D-1, 5/1 D-0 (Telegram)
  - 캘린더 등록 완료
  - team-dev 배포 윈도우 공유 완료
```

---

## 공통 실행 규칙

1. **gws 실패 허용**: 접근 가능한 정보만으로 부분 브리핑 계속. 완전 실패 시 Telegram 에러 알림 + `/channel-guide` 안내.
2. **CRITICAL 우선**: CRITICAL 이메일·2시간 이내 일정은 항상 최상단, 즉시 [CRIT] 알림.
3. **/briefing SSOT**: Briefing Composer는 /briefing 스킬 래핑만. 포맷 복제 금지.
4. **4-bucket 일관성**: 트리아지는 모든 시나리오에서 동일 기준 적용.
5. **1-pager 자동화**: 미팅 30분 전 트리거 또는 명시 요청 시 GBrain + 온톨로지 자동 조합.
6. **D-day 체인**: 캠페인 일정 수신 즉시 D-3·D-1·D-0 크론 3개 자동 등록.
7. **상태 갱신**: 각 Role 완료 시 state.json.roles.<role>.monthly_* 카운터 증분 + outbox role_executed 기록.
8. **외부 팀 자동 전달**: team-dev·accounting·investment 연동은 SILENT 자동 실행. 사용자에겐 결과 요약에서만 안내.
