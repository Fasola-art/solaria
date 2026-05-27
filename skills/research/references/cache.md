# Research Cache System


## Contents

- [개요](#개요)
- [캐시 계층](#캐시-계층)
- [캐시 설정](#캐시-설정)
- [캐시 키 생성](#캐시-키-생성)
  - [Query Cache Key](#query-cache-key)
  - [Source Cache Key](#source-cache-key)
  - [Evaluation Cache Key](#evaluation-cache-key)
- [캐시 동작](#캐시-동작)
  - [캐시 히트 시](#캐시-히트-시)
  - [캐시 미스 시](#캐시-미스-시)
  - [캐시 무효화](#캐시-무효화)
- [캐시 통계](#캐시-통계)
- [유사 쿼리 매칭](#유사-쿼리-매칭)
  - [Fuzzy Matching](#fuzzy-matching)
- [캐시 우회 조건](#캐시-우회-조건)
- [메모리 관리](#메모리-관리)
- [사용 예시](#사용-예시)
  - [캐시 활용 시나리오](#캐시-활용-시나리오)
- [로깅 형식](#로깅-형식)
- [L4: Research Archive (세션 간 지속) [v4.1, GAP-10]](#l4-research-archive-세션-간-지속-v41-gap-10)
  - [Archive 워크플로우](#archive-워크플로우)
  - [Archive 파일 형식](#archive-파일-형식)

> 검색 결과 캐싱으로 효율성 향상

---

## 개요

동일하거나 유사한 검색 쿼리에 대한 결과를 캐싱하여
불필요한 재검색을 방지하고 응답 속도를 향상시킵니다.

---

## 캐시 계층

```
┌─────────────────────────────────────────────────────┐
│                   Cache Layers                       │
├─────────────────────────────────────────────────────┤
│  L1: Query Cache (세션 내)                           │
│      TTL: 세션 종료까지                              │
│      Key: query_hash                                 │
├─────────────────────────────────────────────────────┤
│  L2: Source Cache (세션 내)                          │
│      TTL: 2시간                                      │
│      Key: url_hash                                   │
├─────────────────────────────────────────────────────┤
│  L3: Evaluation Cache (세션 내)                      │
│      TTL: 2시간                                      │
│      Key: source_id + evaluation_type               │
├─────────────────────────────────────────────────────┤
│  L4: Research Archive (세션 간) [v4.1, GAP-10]      │
│      TTL: 분야별 freshness-policy.yaml 기준          │
│      Key: domain/date_topic_slug                     │
│      Path: ~/.claude/research-cache/                 │
└─────────────────────────────────────────────────────┘
```

---

## 캐시 설정

```yaml
cache_config:
  enabled: true

  layers:
    query_cache:
      enabled: true
      ttl: "session"  # 세션 종료 시 만료
      max_entries: 100
      key_strategy: "query_hash"
      hit_log: true

    source_cache:
      enabled: true
      ttl: 7200  # 2시간 (초)
      max_entries: 500
      key_strategy: "url_hash"
      store_content: false  # URL만 저장 (메모리 절약)

    evaluation_cache:
      enabled: true
      ttl: 7200  # 2시간
      max_entries: 200
      key_strategy: "source_evaluation_hash"

  memory_limit: "50MB"  # 총 캐시 메모리
  eviction_policy: "LRU"  # Least Recently Used
```

---

## 캐시 키 생성

### Query Cache Key

```yaml
query_key:
  components:
    - query_text: "정규화된 쿼리"
    - depth: "검색 깊이"
    - source_types: "소스 유형 (정렬됨)"

  normalization:
    - lowercase: true
    - trim_whitespace: true
    - remove_stopwords: false
    - stem_words: false  # 한국어 지원 제한

  hash_algorithm: "SHA-256"
  truncate: 16  # 16자로 축소

  example:
    input:
      query: "AI 에이전트 시장 분석"
      depth: "deep"
      source_types: ["academic", "news"]
    output: "a1b2c3d4e5f6g7h8"
```

### Source Cache Key

```yaml
source_key:
  components:
    - url: "정규화된 URL"

  normalization:
    - remove_tracking_params: true  # utm_*, fbclid 등 제거
    - lowercase_host: true
    - remove_trailing_slash: true

  hash_algorithm: "SHA-256"
  truncate: 16

  example:
    input: "https://Example.com/Article?utm_source=twitter"
    normalized: "https://example.com/article"
    output: "x1y2z3a4b5c6d7e8"
```

### Evaluation Cache Key

```yaml
evaluation_key:
  components:
    - source_id: "소스 식별자"
    - evaluation_type: "평가 유형"
    - criteria_version: "평가 기준 버전"

  example:
    input:
      source_id: "S1"
      evaluation_type: "credibility"
      criteria_version: "v1.0"
    output: "e1v2a3l4c5a6c7h8"
```

---

## 캐시 동작

### 캐시 히트 시

```yaml
on_cache_hit:
  action: "캐시된 결과 반환"

  validation:
    - check_ttl: true
    - check_staleness: true  # 소스 업데이트 확인 (선택적)

  logging:
    log_hit: true
    fields:
      - cache_layer
      - key
      - age_seconds
      - hit_count

  performance:
    expected_speedup: "10-100x"
```

### 캐시 미스 시

```yaml
on_cache_miss:
  action: "실제 검색/평가 수행"

  post_action:
    store_result: true
    update_stats: true

  logging:
    log_miss: true
    fields:
      - cache_layer
      - key
      - reason  # not_found, expired, invalidated
```

### 캐시 무효화

```yaml
cache_invalidation:
  triggers:
    - user_request: "캐시 무시하고 새로 검색해줘"
    - time_sensitive: "오늘 뉴스"
    - conflict_detected: "이전 결과와 충돌"

  strategies:
    single_entry: "특정 키만 무효화"
    pattern_match: "패턴 매칭 무효화"
    full_clear: "전체 캐시 클리어"
```

---

## 캐시 통계

```yaml
cache_stats:
  metrics:
    hit_count: 0
    miss_count: 0
    hit_rate: 0.0  # hit / (hit + miss)
    eviction_count: 0
    memory_usage_bytes: 0

  per_layer:
    query_cache:
      entries: 0
      hits: 0
      misses: 0
    source_cache:
      entries: 0
      hits: 0
      misses: 0
    evaluation_cache:
      entries: 0
      hits: 0
      misses: 0

  reporting:
    interval: "session_end"
    format: "summary"
```

---

## 유사 쿼리 매칭

### Fuzzy Matching

```yaml
fuzzy_matching:
  enabled: true
  threshold: 0.85  # 85% 유사도 이상 시 캐시 히트

  algorithms:
    - levenshtein_distance: "편집 거리"
    - jaccard_similarity: "단어 집합 유사도"
    - semantic_similarity: false  # 비활성화 (비용)

  examples:
    - query_a: "AI 에이전트 시장 분석"
      query_b: "AI에이전트 시장분석"
      similarity: 0.92
      cache_hit: true

    - query_a: "AI 에이전트 시장 분석"
      query_b: "AI 에이전트 경쟁 분석"
      similarity: 0.75
      cache_hit: false
```

---

## 캐시 우회 조건

```yaml
cache_bypass:
  conditions:
    # 시간 민감 쿼리
    time_sensitive_keywords:
      - "오늘"
      - "최신"
      - "방금"
      - "실시간"
      - "2024"  # 연도 포함

    # 명시적 요청
    user_commands:
      - "새로 검색"
      - "캐시 무시"
      - "최신 결과"

    # 깊이 변경
    depth_change: true  # 이전보다 깊은 검색 시

    # 소스 유형 변경
    source_type_change: true
```

---

## 메모리 관리

```yaml
memory_management:
  limit: "50MB"

  eviction:
    policy: "LRU"  # Least Recently Used
    trigger: "memory_limit_80%"  # 80% 도달 시

  cleanup:
    expired_check_interval: 60  # 60초마다
    batch_size: 50  # 한 번에 50개 정리

  compression:
    enabled: false  # 메모리 절약 vs CPU 트레이드오프
```

---

## 사용 예시

### 캐시 활용 시나리오

```
사용자: "AI 에이전트 시장 분석해줘"
→ 캐시 미스 → 검색 수행 → 결과 캐싱

사용자: "아까 AI 에이전트 시장에서 성장률이 어땠지?"
→ 캐시 히트 → 즉시 반환 (검색 생략)

사용자: "AI 에이전트 시장 최신 뉴스 찾아줘"
→ 캐시 우회 ("최신" 키워드) → 새로 검색

사용자: "AI 에이전트 경쟁사 분석해줘"
→ 캐시 미스 (다른 쿼리) → 검색 수행
→ 이전 소스 일부 캐시 히트 (Source Cache)
```

---

## 로깅 형식

```yaml
cache_log_format:
  on_hit:
    message: "[HIT] Cache HIT"
    fields:
      - layer: "{layer}"
      - key: "{key}"
      - age: "{age}s"
      - saved_time: "~{estimated_ms}ms"

  on_miss:
    message: "[MISS] Cache MISS"
    fields:
      - layer: "{layer}"
      - key: "{key}"
      - reason: "{reason}"

  session_summary:
    message: "[STATS] Cache Summary"
    fields:
      - total_requests: "{n}"
      - hit_rate: "{pct}%"
      - estimated_time_saved: "{seconds}s"
```

---

## L4: Research Archive (세션 간 지속) [v4.1, GAP-10]

> 완료된 리서치 보고서를 세션 간 보존하여 유사 주제 재질문 시 활용

```yaml
research_archive:
  path: "~/.claude/research-cache/"
  classification: domain_auto_detect
  directory: "{domain}/{date}_{topic_slug}.md"
  content:
    - final_report
    - source_list
    - verification_summary
    - evidence_grades
  retention: domain_freshness  # freshness-policy.yaml TTL 기준
  cleanup:
    trigger: session_start
    max_files: 200
    max_size: "100MB"
  index:
    file: "_index.json"
    fields:
      - id
      - domain
      - query
      - depth
      - verification_summary
      - tags
      - created_at
  retrieval:
    method: keyword_tag_match
    similarity_threshold: 0.40  # jaccard 0.4+
    max_results: 5
```

### Archive 워크플로우

```
[리서치 완료]
  -> 보고서 + 소스 + 검증요약 + 증거등급을 archive 파일로 저장
  -> _index.json 갱신

[새 리서치 시작]
  -> _index.json에서 유사 쿼리 검색 (jaccard >= 0.4)
  -> 히트 시: 이전 보고서 컨텍스트로 제공 + 변경사항 확인
  -> 미스 시: 정상 파이프라인 실행
```

### Archive 파일 형식

```yaml
archive_format:
  header:
    query: "원본 쿼리"
    domain: "분야"
    depth: "deep|full"
    created_at: "ISO 8601"
    expires_at: "ISO 8601 (TTL 기반)"
    tags: ["keyword1", "keyword2"]
  summary:
    conclusions: ["결론 1", "결론 2"]
    maturity: "High"
    confidence_range: "70-95%"
  verification:
    sufficient: true
    level_distribution: {level_3: 2, level_2: 3, level_1: 1, level_0: 0, conflict: 1}
    evidence_grades: {A: 1, B: 3, C: 2, D: 0}
  sources:
    - id: "S1"
      url: "..."
      credibility: 4
      freshness_status: "FRESH"
```
