# 태스크 분해 패턴

## 7개 내장 패턴

### 1. Research (리서치)
목표 → 하위 질문 → 소스 탐색 → 종합
- 위임: /research 스킬
- Risk: 0.1

### 2. Analysis (분석)
데이터 → 차원 분류 → 지표 계산 → 인사이트 도출
- 위임: worker 에이전트
- Risk: 0.1

### 3. Code (코드 구현)
아키텍처 → 모듈 → 함수 → 테스트
- 위임: worker + reviewer (품질 게이트)
- Risk: 0.3

### 4. Schedule (일정/계획)
Phase → 마일스톤 → 태스크 → 서브태스크
- 위임: 메인 스레드
- Risk: 0.1

### 5. Notification (알림)
트리거 → 채널 → 메시지 → 확인
- 위임: worker
- Risk: 0.2 (외부 발송 시 GATE)

### 6. Financial (금융)
예산 → 항목 → 계산 → 보고서
- 위임: worker (항상 GATE)
- Risk: 0.95

### 7. Document (문서)
아웃라인 → 섹션 → 초안 → 리뷰
- 위임: worker + reviewer
- Risk: 0.2

## MAX_DEPTH = 3
- Level 1: Phase (최대 10개)
- Level 2: Task (Phase당 최대 10개)
- Level 3: Subtask (Task당 최대 5개)
- 이 이상 분해하지 않음

## 의존성 그래프
각 태스크는 `deps: []` 배열로 다른 태스크 ID 참조.
실행 엔진은 위상 정렬(topological sort)로 순서 결정:
- 독립 태스크 → 병렬 (Swarm)
- 의존 태스크 → 순차 (Pipeline)
- 고위험 결정 → 합의 후 진행 (Parliament via AskUserQuestion)

## 프로젝트 규모별 분해 전략
- **Small (≤5)**: 1 Phase, 분해 불필요 → /workflow 위임
- **Medium (5-15)**: 2-3 Phase, 간단 분해
- **Large (15+)**: 3-5 Phase, 전체 분해 + 의존성 그래프
