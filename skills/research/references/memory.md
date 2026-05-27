# Research Session Memory


## Contents

- [개요](#개요)
- [메모리 구조](#메모리-구조)
- [메모리 컴포넌트](#메모리-컴포넌트)
  - [1. Query History (질문 히스토리)](#1-query-history-질문-히스토리)
  - [2. Source Memory (소스 메모리)](#2-source-memory-소스-메모리)
  - [3. User Preferences (사용자 선호도)](#3-user-preferences-사용자-선호도)
  - [4. Finding Memory (발견 메모리)](#4-finding-memory-발견-메모리)
  - [5. Context Stack (컨텍스트 스택)](#5-context-stack-컨텍스트-스택)
  - [6. Feedback Log (피드백 로그)](#6-feedback-log-피드백-로그)
- [메모리 활용](#메모리-활용)
  - [후속 질문 처리](#후속-질문-처리)
  - [연속 리서치](#연속-리서치)
- [메모리 참조 구문](#메모리-참조-구문)
  - [사용자 참조](#사용자-참조)
  - [시스템 참조](#시스템-참조)
- [메모리 관리](#메모리-관리)
  - [용량 관리](#용량-관리)
  - [세션 종료 처리](#세션-종료-처리)
- [메모리 검색](#메모리-검색)
  - [검색 인터페이스](#검색-인터페이스)
- [설정](#설정)

> 세션 내 컨텍스트 및 히스토리 관리

---

## 개요

리서치 세션 동안 이전 질문, 검색 결과, 사용자 선호도를
기억하여 연속적이고 맥락 있는 리서치를 제공합니다.

---

## 메모리 구조

```
┌─────────────────────────────────────────────────────┐
│                  Session Memory                      │
├─────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  │
│  │   Query     │  │   Source    │  │   User      │  │
│  │   History   │  │   Memory    │  │   Prefs     │  │
│  └─────────────┘  └─────────────┘  └─────────────┘  │
│                                                      │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  │
│  │   Finding   │  │   Context   │  │   Feedback  │  │
│  │   Memory    │  │   Stack     │  │   Log       │  │
│  └─────────────┘  └─────────────┘  └─────────────┘  │
└─────────────────────────────────────────────────────┘
```

---

## 메모리 컴포넌트

### 1. Query History (질문 히스토리)

```yaml
query_history:
  description: "세션 내 모든 리서치 질문 기록"

  storage:
    max_queries: 20
    retention: "session"

  fields:
    - query_id: "고유 ID"
    - text: "질문 텍스트"
    - timestamp: "질문 시간"
    - research_type: "리서치 유형"
    - depth: "검색 깊이"
    - status: "완료/진행중/실패"

  usage:
    - "후속 질문 맥락 파악"
    - "관련 이전 질문 참조"
    - "질문 패턴 분석"

  example:
    - query_id: "Q1"
      text: "AI 에이전트 시장 분석"
      timestamp: "2024-01-15T10:00:00Z"
      research_type: "market_research"
      depth: "deep"
      status: "completed"
```

### 2. Source Memory (소스 메모리)

```yaml
source_memory:
  description: "수집된 소스 정보 저장"

  storage:
    max_sources: 100
    retention: "session"

  fields:
    - source_id: "고유 ID"
    - url: "소스 URL"
    - title: "제목"
    - credibility: "신뢰도 점수"
    - relevance: "관련성 점수"
    - related_queries: "관련 질문 ID"
    - key_facts: "핵심 사실"
    - last_used: "마지막 사용 시간"

  usage:
    - "이전 소스 재활용"
    - "교차 참조"
    - "누적 신뢰도 업데이트"
```

### 3. User Preferences (사용자 선호도)

```yaml
user_preferences:
  description: "세션 중 파악된 사용자 선호"

  auto_detected:
    - preferred_depth: "선호 깊이"
    - preferred_format: "선호 출력 형식"
    - language_preference: "언어 선호"
    - detail_level: "상세도 선호"

  explicit:
    - source_preferences: "선호/배제 소스"
    - format_requests: "형식 요청"

  learning:
    update_on: "피드백 수신 시"
    decay: false  # 세션 내 유지

  example:
    preferred_depth: "deep"
    preferred_format: "comparison"
    excluded_sources: ["example.com"]
    detail_level: "high"
```

### 4. Finding Memory (발견 메모리)

```yaml
finding_memory:
  description: "도출된 결론 및 인사이트 저장"

  storage:
    max_findings: 50
    retention: "session"

  fields:
    - finding_id: "고유 ID"
    - statement: "결론 문장"
    - confidence: "확신도"
    - supporting_sources: "지지 소스"
    - related_queries: "관련 질문"
    - maturity_level: "성숙도"

  usage:
    - "이전 결론 참조"
    - "일관성 유지"
    - "누적 인사이트 구축"
```

### 5. Context Stack (컨텍스트 스택)

```yaml
context_stack:
  description: "현재 리서치 컨텍스트"

  layers:
    - current_query: "현재 질문"
    - current_hypotheses: "현재 가설"
    - current_focus: "현재 초점 영역"
    - pending_gaps: "해결 필요 갭"

  operations:
    push: "새 컨텍스트 추가"
    pop: "컨텍스트 제거"
    peek: "현재 컨텍스트 확인"

  max_depth: 5
```

### 6. Feedback Log (피드백 로그)

```yaml
feedback_log:
  description: "사용자 피드백 기록"

  types:
    - positive: "유용했음"
    - negative: "유용하지 않음"
    - correction: "정정 요청"
    - preference: "선호도 표현"

  usage:
    - "선호도 업데이트"
    - "소스 신뢰도 조정"
    - "검색 전략 개선"
```

---

## 메모리 활용

### 후속 질문 처리

```yaml
follow_up_handling:
  triggers:
    - "아까"
    - "그"
    - "이전"
    - "방금"
    - "그거"

  resolution:
    1. 대명사 해결: "그 → 이전 질문의 주제"
    2. 컨텍스트 연결: "이전 결론 참조"
    3. 소스 재활용: "관련 소스 재사용"

  example:
    previous: "AI 에이전트 시장 분석해줘"
    current: "그 중에서 성장률이 가장 높은 분야는?"
    resolved: "AI 에이전트 시장 중에서 성장률이 가장 높은 분야"
```

### 연속 리서치

```yaml
continuous_research:
  description: "관련 질문들의 누적 분석"

  behavior:
    - 이전 소스 재활용: "관련성 높은 소스"
    - 결론 연결: "이전 결론 참조"
    - 갭 추적: "미해결 질문 추적"

  example:
    session_flow:
      Q1: "AI 에이전트 시장 규모"
      Q2: "주요 플레이어 분석"  # Q1 소스 재활용
      Q3: "미래 전망"  # Q1, Q2 결론 참조
```

---

## 메모리 참조 구문

### 사용자 참조

```yaml
user_references:
  patterns:
    - "아까 찾은 {topic}": "Query History 검색"
    - "그 소스에서": "최근 Source 참조"
    - "이전 결론": "Finding Memory 참조"
    - "방금 말한 것처럼": "Context Stack 참조"

  resolution_priority:
    1. 현재 컨텍스트
    2. 최근 질문
    3. 관련 소스
    4. 이전 결론
```

### 시스템 참조

```yaml
system_references:
  auto_include:
    - related_previous_findings: "관련 이전 결론"
    - high_quality_sources: "재활용 가능한 고품질 소스"
    - unresolved_gaps: "미해결 갭"

  format:
    finding_reference: "📌 이전 발견: {finding}"
    source_reference: "💡 관련 소스: {source}"
    gap_reference: "⚠️ 미해결: {gap}"
```

---

## 메모리 관리

### 용량 관리

```yaml
capacity_management:
  limits:
    query_history: 20
    source_memory: 100
    finding_memory: 50
    feedback_log: 30

  eviction:
    strategy: "relevance_weighted_lru"
    factors:
      - recency: 0.4
      - relevance: 0.4
      - quality: 0.2

  compression:
    trigger: "80% 용량"
    method: "summarize_old_entries"
```

### 세션 종료 처리

```yaml
session_end:
  actions:
    - clear_all_memory: true
    - export_summary: false  # 선택적

  summary_export:
    enabled: false
    format: "markdown"
    includes:
      - query_list
      - key_findings
      - source_list
```

---

## 메모리 검색

### 검색 인터페이스

```yaml
memory_search:
  queries:
    find_related_queries:
      input: "현재 질문"
      output: "관련 이전 질문들"
      method: "semantic_similarity"

    find_reusable_sources:
      input: "현재 주제"
      output: "재활용 가능 소스"
      method: "relevance_match"

    find_relevant_findings:
      input: "현재 가설"
      output: "관련 이전 결론"
      method: "hypothesis_match"
```

---

## 설정

```yaml
memory_config:
  enabled: true

  components:
    query_history: true
    source_memory: true
    user_preferences: true
    finding_memory: true
    context_stack: true
    feedback_log: true

  limits:
    max_memory_mb: 20
    auto_cleanup: true

  behavior:
    auto_reference: true  # 자동 참조
    explicit_only: false  # 명시적 요청만 (false = 자동)

  logging:
    log_references: true
    log_updates: false
```
