# team-dev 실행 시나리오 5종


## Contents

- [시나리오 1: PR 리뷰 → 머지](#시나리오-1-pr-리뷰-머지)
- [시나리오 2: 긴급 핫픽스](#시나리오-2-긴급-핫픽스)
- [시나리오 3: 정기 배포](#시나리오-3-정기-배포)
- [시나리오 4: 의존성 업그레이드](#시나리오-4-의존성-업그레이드)
- [시나리오 5: 인시던트 대응](#시나리오-5-인시던트-대응)
- [공통 실행 규칙](#공통-실행-규칙)

자연어 요청 → 자동 Role 할당 → 7-Role 협업 → 코드/리포트 산출.

**공통 원칙**:
- 체크포인트 흐름은 role-routing.yaml.checkpoint_map 참조
- auth/payment/admin/secret/token/credential → Security Eng 강제 참여
- 모든 시나리오 완료 시 outbox 기록 + trust.json.activity 증분
- 외부 팀 위임 필요 시 자동 전달 후 사용자에게 안내

---

## 시나리오 1: PR 리뷰 → 머지

**트리거**: "PR 리뷰해줘", "PR #142 봐줘", "@team-dev PR 리뷰"

**체크포인트**: SILENT

```
훅 체인
  keyword-detector: "PR 리뷰" → [TEAM-DEV:pr_review]
  persona-activator: architect + qa 활성 (보안 키워드 포함 시 security 추가)
  role-routing: tech-lead-architect 주 Role, qa-automation 협업

Phase 1: Tech Lead Architect
  gh pr diff <num> 가져오기
  보안 키워드 스캔 → auth/payment 포함 시 Security Eng 참여 활성
  PR 규모 확인 → 500줄 이상 시 /codex-route 2차 의견 트리거

Phase 2: reviewer 에이전트 (haiku) — 4차원 리뷰
  품질:   코드 스타일 / 함수 50줄 제한 / 중복 패턴 / const 원칙
  보안:   SQL 파라미터화 / 입력 sanitize / 시크릿 하드코딩 / CORS 설정
  성능:   N+1 쿼리 / Promise.all 병렬화 / 번들 영향 / 불필요 렌더링
  접근성: alt 속성 / aria-label / 키보드 네비게이션 / 대비율

Phase 3 (선택): Security Eng — 보안 전용 섹션
  OWASP Top 10 대조
  인증/인가 로직 별도 검토
  의존성 취약점 (CVE) 확인

Phase 4: QA Automation
  테스트 커버리지 확인 (목표 80%+)
  E2E 회귀 범위 영향 점검

산출물:
  ~/workspace/reports/pr-<num>-review.md
    - 헬스 점수 /10 (git clean / test / build / lint / type)
    - 4차원 점수 + 항목별 지적사항
    - 머지 추천 여부

상태 업데이트:
  Telegram [INFO] 리뷰 요약 전송
  outbox: result=success, role_executed=reviewer
  monthly_prs_reviewed++
```

**사용자 노출 결과**:
- [헬스 점수 8.2/10] 빌드 통과, lint 경고 2건, 타입 에러 없음
- [보안] auth 미들웨어 누락 1건 → 수정 권고
- [성능] useEffect 남용 1건, N+1 쿼리 패턴 1건
- [머지 권장]: 보안 수정 후 머지 가능

---

## 시나리오 2: 긴급 핫픽스

**트리거**: "핫픽스 해야 해", "지금 prod 장애야", "긴급 패치", "배포 실패"

**체크포인트**: GATE_1h

```
훅 체인
  keyword-detector: "핫픽스/장애/긴급" → [TEAM-DEV:hotfix]
  persona-activator: security + devops + architect 3종 활성
  role-routing: devops-sre 주 Role, tech-lead-architect + security-eng 협업

Phase 1: DevOps·SRE — 인시던트 선언
  온톨로지 Incident 엔티티 생성 (severity, start_ts)
  현재 상태 파악 → 롤백 가능 여부 확인
  팀 통보 (Telegram [CRIT])

Phase 2: GATE_1h 승인 요청
  Telegram [HIGH]: "핫픽스 GATE_1h 승인 필요.
    이슈: {요약}
    제안 수정: {범위}
    /approve {trace_id} 또는 /reject {trace_id}"
  30분 리마인드 발송

Phase 3 (승인 후): Tech Lead Architect + Backend/Frontend Eng
  hotfix/<issue> 브랜치 생성
  worker: 최소 범위 수정 (100줄 이내 권장)
  reviewer: 보안 + 품질 빠른 리뷰
  최소 단위 테스트 확인

Phase 4: Security Eng (항상 참여)
  패치 코드 보안 점검
  취약점 악용 흔적 확인

Phase 5: DevOps·SRE — prod 머지 + 배포
  INFORM_5m 추가 체크 (배포 단계)
  vercel --prod 또는 git push → prod
  모니터링 5분 대기

Phase 6: Release Manager
  릴리즈 노트: ~/workspace/reports/release-<hotfix-ver>-<date>.md
  team-secretary에 배포 완료 통보
  온톨로지 Deployment 엔티티 + Incident.resolved_ts 기록

산출물:
  ~/workspace/reports/incident-<slug>-<date>.md
  ~/workspace/reports/postmortem-<slug>-<date>.md (24h 이내)
  ~/workspace/reports/release-<hotfix-ver>-<date>.md

상태 업데이트:
  Telegram [INFO] 핫픽스 완료 전송
  decisions.jsonl: GATE_1h + approved + decided_by=user
  monthly_deploys++, monthly_decisions++
```

**사용자 노출 결과**:
- [인시던트 선언] severity: HIGH, 시작: 14:23 KST
- [GATE_1h 승인 후 완료] hotfix/payment-null-ref → prod 배포 14:51 KST
- [모니터링] 에러율 0.0%로 복귀 확인
- [다음 단계] 24h 이내 postmortem 작성 예정

---

## 시나리오 3: 정기 배포

**트리거**: "이번 주 배포해줘", "v2.3.0 릴리즈", "배포 일정", "staging 올려줘"

**체크포인트**: INFORM_5m

```
훅 체인
  keyword-detector: "배포/릴리즈" → [TEAM-DEV:deploy]
  persona-activator: devops + architect 활성
  role-routing: release-manager 주 Role, devops-sre 협업

Phase 1: Release Manager — 배포 준비
  team-secretary에서 배포 윈도우 확인
  온톨로지 PullRequest 엔티티 조회 → 미머지 PR 확인
  FeatureFlag 활성 목록 확인 (배포 포함 여부)
  CHANGELOG 자동 생성 (git log --oneline)

Phase 2: QA Automation — 배포 전 게이트
  CI/CD 파이프라인 상태 확인
  전체 테스트 스위트 통과 여부
  스테이징 smoke test 실행

Phase 3: INFORM_5m (배포 전 보고)
  Telegram [INFO]: "{프로젝트} {버전} prod 배포 예정.
    헬스 점수: {score}/10
    포함 PR: {목록}
    5분 내 /cancel {trace_id} 가능"
  5분 대기

Phase 4: DevOps·SRE — 배포 실행
  cancel 없음 확인 → 배포 명령 실행
  진행 상황 Telegram [INFO] 중간 보고
  배포 완료 확인 → 모니터링 체크

Phase 5: Release Manager — 릴리즈 마무리
  배포 노트 저장: ~/workspace/reports/release-<version>-<date>.md
  온톨로지 Deployment 엔티티 기록
  team-secretary 배포 완료 통보
  다음 배포 윈도우 예약

산출물:
  ~/workspace/reports/release-<version>-<date>.md
    - 포함 변경사항 (PR 목록)
    - 배포 환경별 결과
    - 롤백 방법 명시

상태 업데이트:
  Telegram [INFO] 배포 완료
  monthly_deploys++
  roles.release-manager.monthly_releases++
```

**사용자 노출 결과**:
- [배포 완료] v2.3.0 → prod 15:02 KST
- [포함 내용] PR #140 (로그인 개선), #141 (대시보드 성능), #143 (버그픽스)
- [헬스 점수] 9.5/10 (전체 테스트 통과, lint clean)
- [릴리즈 노트] ~/workspace/reports/release-2.3.0-2026-04-21.md

---

## 시나리오 4: 의존성 업그레이드

**트리거**: "패키지 업데이트 해줘", "npm 의존성 정리", "취약점 있는 패키지", "라이브러리 버전 올려"

**체크포인트**: SILENT (devDep) / INFORM_5m (prodDep)

```
훅 체인
  keyword-detector: "의존성/패키지/npm/취약점" → [TEAM-DEV:dependency]
  persona-activator: security + devops 활성
  role-routing: security-eng 주 Role (CVE 포함 시), devops-sre 협업

Phase 1: Security Eng — 취약점 분석
  npm audit / pnpm audit 실행
  CVE 심각도 분류 (critical > high > medium > low)
  라이선스 확인 (GPL 경고)
  온톨로지 Dependency 엔티티 조회 (기존 취약점 이력)

Phase 2: Tech Lead Architect — 업그레이드 전략
  major 버전 변경 → Breaking change 체크
  ADR 초안 작성 (중요 의존성 변경 시)
  /simulate로 호환성 사전 시뮬레이션

Phase 3: 업그레이드 실행
  devDep 추가/업그레이드 → SILENT (즉시 실행)
  prodDep 추가/업그레이드 → INFORM_5m
    Telegram [INFO]: "prodDep {패키지명} {버전} 업그레이드 예정. 5분 내 /cancel 가능"

Phase 4: QA Automation — 회귀 테스트
  전체 테스트 스위트 실행
  Breaking change 영향 영역 집중 테스트
  E2E 주요 경로 검증

Phase 5: Release Manager
  의존성 업그레이드 리포트 저장
  온톨로지 Dependency 엔티티 업데이트
  다음 정기 배포에 포함 여부 결정

산출물:
  ~/workspace/reports/dependency-upgrade-<slug>-<date>.md
    - 업그레이드된 패키지 목록 + 버전 변경
    - CVE 해소 목록
    - Breaking change 대응 내역
    - 라이선스 변경 사항

상태 업데이트:
  SILENT이면 즉시 outbox 기록
  INFORM_5m이면 5분 유예 후 기록
  roles.security-eng.monthly_vuln_fixed++ (CVE 해소 시)
```

**사용자 노출 결과**:
- [critical 1건] lodash 4.17.19 → 4.17.21 (Prototype Pollution) 즉시 수정 완료
- [prodDep 3건] next.js 14.1 → 14.2, react 18.2 → 18.3, prisma 5.10 → 5.12 (INFORM_5m 승인 후 완료)
- [회귀 테스트] 전체 통과 (142/142)
- [리포트] ~/workspace/reports/dependency-upgrade-2026-04-21.md

---

## 시나리오 5: 인시던트 대응

**트리거**: "서버 다운", "에러율 급증", "DB 응답 없음", "prod 이상 있어", "모니터링 알럿"

**체크포인트**: GATE_1h (핫픽스 필요 시) / SILENT (조사·보고)

```
훅 체인
  keyword-detector: "인시던트/장애/다운/에러율" → [TEAM-DEV:incident]
  persona-activator: devops + security + architect 3종 활성
  role-routing: devops-sre 주 Role, 전 Role 대기 상태

Phase 1: DevOps·SRE — 즉각 대응 (SILENT)
  온톨로지 Incident 엔티티 생성
    { severity: critical|high|medium|low, start_ts: now(), status: active }
  Telegram [CRIT]: "인시던트 감지. 심각도: {severity}. 조사 시작"
  로그 수집: 에러 스택, 응답 시간, DB 쿼리 레이턴시
  모니터링 대시보드 확인 (Grafana/Prometheus)

Phase 2: 원인 분석 (병렬)
  Backend Eng: DB 쿼리 + API 에러 로그 분석
  DevOps·SRE: 인프라 지표 (CPU/메모리/네트워크/디스크)
  Security Eng: 이상 트래픽 / 침해 징후 확인

Phase 3: 분기 결정
  분기 A (코드 버그) → 시나리오 2 핫픽스 흐름 진입 (GATE_1h)
  분기 B (인프라 이슈) → DevOps·SRE 즉시 대응 (INFORM_5m)
    - 스케일 아웃 / 재시작 / 롤백 선택
  분기 C (외부 의존성) → 모니터링 + 우회 방안 수립

Phase 4: 복구 실행
  DevOps·SRE: 복구 액션 실행
  QA Automation: 서비스 정상화 smoke test
  모니터링 5분 연속 정상 확인 → 인시던트 종료 선언

Phase 5: 인시던트 종료 처리
  온톨로지 Incident.resolved_ts + resolution 기록
  Telegram [INFO]: "인시던트 종료. 총 다운타임: {분}분"
  ~/workspace/reports/incident-<slug>-<date>.md 저장
  24h 이내 postmortem 예약

Phase 6: Postmortem (24h 이내)
  Tech Lead Architect 주도
  타임라인 재구성 → 근본 원인 분석 (5 Whys)
  재발 방지 액션 아이템 → 온톨로지 ADR 후보 등록
  ~/workspace/reports/postmortem-<slug>-<date>.md 저장

산출물:
  ~/workspace/reports/incident-<slug>-<date>.md
    - 타임라인 / 영향 범위 / 복구 과정
  ~/workspace/reports/postmortem-<slug>-<date>.md
    - 근본 원인 / 재발 방지 / 액션 아이템

상태 업데이트:
  Telegram [INFO] 최종 요약 전송
  decisions.jsonl 복구 결정 기록
  roles.devops-sre.monthly_incidents_resolved++
```

**사용자 노출 결과**:
- [인시던트 종료] 다운타임 7분 (14:23 ~ 14:30 KST)
- [근본 원인] DB 커넥션 풀 고갈 (N+1 쿼리 + 급격한 트래픽 증가)
- [즉시 조치] 커넥션 풀 크기 20 → 50 확장 + 문제 쿼리 캐싱
- [재발 방지] ADR-007 작성 예정, PR #145 (쿼리 배치화) 우선순위 상향
- [Postmortem] 내일 15:00까지 작성 예정

---

## 공통 실행 규칙

1. **Security Eng 강제 참여**: auth/payment/admin/secret/token/credential 키워드 감지 시 무조건 참여 (주 Role 수에 포함, 최대 3개).
2. **헬스 점수**: 관찰용 (0-10). 낮아도 차단 없음. 사용자가 /cancel 판단 자료로만 활용.
3. **500줄 PR**: /codex-route 2차 의견 자동 트리거.
4. **worker 안전 규칙**: INFORM/GATE 유예 기간 동안 worker 절대 호출 금지.
5. **롤백 자동 시도**: 배포 실패 감지 시 즉시 git revert / vercel rollback 시도 → 실패 시 [CRIT] 알림.
6. **온톨로지 갱신**: PullRequest/Deployment/Incident/ADR/Dependency 엔티티 각 시나리오 완료 시 기록.
7. **ADR 생성 기준**: 아키텍처 결정, major 의존성 변경, 반복 인시던트 패턴 → 자동 ADR 후보 등록.
8. **상태 갱신**: 각 Role 완료 시 state.json.roles.<role>.monthly_* 카운터 증분 + outbox에 role_executed 기록.
