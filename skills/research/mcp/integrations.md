# MCP Integrations

> Research 스킬을 위한 MCP 서버 통합 설정

---

## 개요

MCP(Model Context Protocol) 서버를 활용하여
리서치 소스의 품질과 다양성을 향상시킵니다.

---

## 통합 아키텍처

```
┌─────────────────────────────────────────────────────────────┐
│                      Research Skill                          │
│                                                              │
│  ┌──────────────────────────────────────────────────────┐   │
│  │                    MCP Router                         │   │
│  │         (우선순위 기반 소스 라우팅)                    │   │
│  └──────────────────────────────────────────────────────┘   │
│           │              │              │                    │
│           ↓              ↓              ↓                    │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐           │
│  │   arXiv     │ │   Scholar   │ │   News      │           │
│  │   MCP       │ │   MCP       │ │   MCP       │           │
│  └─────────────┘ └─────────────┘ └─────────────┘           │
│           │              │              │                    │
│           └──────────────┼──────────────┘                    │
│                          ↓                                   │
│                  ┌─────────────┐                            │
│                  │  WebSearch  │                            │
│                  │  (Fallback) │                            │
│                  └─────────────┘                            │
└─────────────────────────────────────────────────────────────┘
```

---

## MCP 소스 설정

### 학술 소스

#### arXiv MCP

```yaml
arxiv:
  name: "arXiv MCP"
  type: "academic"
  priority: 1

  capabilities:
    - paper_search: "논문 검색"
    - abstract_fetch: "초록 가져오기"
    - citation_info: "인용 정보"

  config:
    categories:
      - "cs.AI"
      - "cs.LG"
      - "cs.CL"
      - "stat.ML"
    max_results: 20
    sort_by: "relevance"  # relevance, lastUpdatedDate, submittedDate

  credibility:
    base_score: 5
    peer_reviewed: true

  usage:
    research_types:
      - "literature_review"
      - "technology_research"
      - "academic"
    depth: ["deep", "full"]

  fallback:
    to: "WebSearch"
    query_template: "site:arxiv.org {query}"
```

#### Google Scholar MCP

```yaml
google_scholar:
  name: "Google Scholar MCP"
  type: "academic"
  priority: 2

  capabilities:
    - paper_search: "논문 검색"
    - citation_count: "인용 수"
    - author_info: "저자 정보"

  config:
    max_results: 20
    include_patents: false
    include_citations: true

  credibility:
    base_score: 5
    citation_boost: true  # 인용 수에 따른 가중치

  usage:
    research_types:
      - "literature_review"
      - "academic"
    depth: ["deep", "full"]

  fallback:
    to: "WebSearch"
    query_template: "site:scholar.google.com {query}"
```

#### PubMed MCP

```yaml
pubmed:
  name: "PubMed MCP"
  type: "medical_academic"
  priority: 1

  capabilities:
    - article_search: "논문 검색"
    - abstract_fetch: "초록 가져오기"
    - mesh_terms: "MeSH 용어"

  config:
    max_results: 20
    sort_by: "relevance"

  credibility:
    base_score: 5
    peer_reviewed: true

  usage:
    research_types:
      - "health_research"
      - "literature_review"
    depth: ["standard", "deep", "full"]

  fallback:
    to: "WebSearch"
    query_template: "site:pubmed.ncbi.nlm.nih.gov {query}"
```

### 뉴스/정보 소스

#### News API MCP

```yaml
news_api:
  name: "News API MCP"
  type: "news"
  priority: 3

  capabilities:
    - headline_search: "헤드라인 검색"
    - article_search: "기사 검색"
    - source_filter: "소스 필터"

  config:
    language: ["ko", "en"]
    sort_by: "relevancy"  # relevancy, popularity, publishedAt
    from_date: "7 days ago"

  credibility:
    base_score: 3
    source_dependent: true  # 소스에 따라 조정

  usage:
    research_types:
      - "market_research"
      - "trend_analysis"
      - "competitive_analysis"
    depth: ["quick", "standard", "deep", "full"]

  fallback:
    to: "WebSearch"
    query_template: "{query} news"
```

### 데이터/통계 소스

#### 통계청 API MCP

```yaml
kostat:
  name: "통계청 API MCP"
  type: "government_stats"
  priority: 2

  capabilities:
    - stat_search: "통계 검색"
    - data_fetch: "데이터 조회"
    - time_series: "시계열 데이터"

  config:
    language: "ko"
    format: "json"

  credibility:
    base_score: 5
    official: true

  usage:
    research_types:
      - "market_research"
      - "policy_analysis"
      - "real_estate"
    depth: ["standard", "deep", "full"]

  fallback:
    to: "WebSearch"
    query_template: "site:kostat.go.kr {query}"
```

---

## 라우팅 설정

### 리서치 유형별 MCP 우선순위

```yaml
routing_priorities:
  # 학술 리서치
  literature_review:
    order:
      1: "arxiv"
      2: "google_scholar"
      3: "pubmed"
    fallback: "WebSearch"

  academic:
    order:
      1: "google_scholar"
      2: "arxiv"
    fallback: "WebSearch"

  # 시장 리서치
  market_research:
    order:
      1: "news_api"
      2: "kostat"
    fallback: "WebSearch"

  # 기술 리서치
  technology_research:
    order:
      1: "arxiv"
      2: "news_api"
    fallback: "WebSearch"

  # 건강 리서치
  health_research:
    order:
      1: "pubmed"
    fallback: "WebSearch"

  # 기본
  default:
    order:
      1: "news_api"
    fallback: "WebSearch"
```

### 병렬 쿼리 전략

```yaml
parallel_strategy:
  enabled: true

  mode: "best_effort"  # best_effort, all_required

  max_concurrent: 3

  timeout_ms: 10000

  aggregation:
    method: "merge_dedupe"
    priority_by: "credibility"
```

---

## Fallback 체인

### WebSearch Fallback

```yaml
websearch_fallback:
  trigger:
    - "MCP 서버 미등록"
    - "MCP 서버 timeout"
    - "MCP 서버 에러"
    - "결과 부족 (< 3개)"

  behavior:
    convert_query: true  # MCP 쿼리 → WebSearch 쿼리 변환
    add_site_filter: true  # 관련 사이트 필터 추가
    retry_count: 1

  query_templates:
    arxiv: "site:arxiv.org {query}"
    scholar: "site:scholar.google.com {query}"
    pubmed: "site:pubmed.ncbi.nlm.nih.gov {query}"
    news: "{query} news recent"
    stats: "{query} statistics data"
```

### Graceful Degradation

```yaml
graceful_degradation:
  levels:
    1_all_mcp:
      description: "모든 MCP 활성"
      quality: "highest"

    2_partial_mcp:
      description: "일부 MCP + WebSearch"
      quality: "high"

    3_websearch_only:
      description: "WebSearch만"
      quality: "standard"

  notification:
    show_degradation_level: true
    message_template: |
      ⚠️ {mcp_name} 연결 불가로 WebSearch로 대체합니다.
```

---

## MCP 응답 처리

### 응답 정규화

```yaml
response_normalization:
  fields:
    common:
      - id: "고유 ID"
      - title: "제목"
      - url: "URL"
      - snippet: "요약"
      - date: "발행일"
      - source_type: "소스 유형"

    academic:
      - authors: "저자"
      - citation_count: "인용 수"
      - journal: "저널"
      - abstract: "초록"

    news:
      - source_name: "매체명"
      - published_at: "발행 시간"

  date_format: "ISO 8601"
  encoding: "UTF-8"
```

### 중복 제거

```yaml
deduplication:
  enabled: true

  methods:
    - url_match: "URL 일치"
    - title_similarity: "제목 유사도 > 0.9"
    - content_hash: "콘텐츠 해시"

  priority:
    when_duplicate:
      prefer: "higher_credibility"
      tiebreaker: "first_seen"
```

---

## 모니터링

### MCP 상태 체크

```yaml
health_check:
  interval: 60  # 초

  checks:
    - connectivity: "연결 가능 여부"
    - response_time: "응답 시간"
    - error_rate: "에러율"

  thresholds:
    response_time_warn: 5000  # 5초
    response_time_fail: 10000  # 10초
    error_rate_warn: 0.10  # 10%
    error_rate_fail: 0.30  # 30%

  actions:
    on_warn: "log"
    on_fail: "activate_fallback"
```

### 사용 통계

```yaml
usage_stats:
  track:
    - mcp_calls_total
    - mcp_calls_success
    - mcp_calls_failed
    - fallback_activations
    - response_times

  report:
    frequency: "session_end"
    format: "summary"
```

---

## 설정

```yaml
mcp_config:
  enabled: true

  sources:
    arxiv:
      enabled: true
      priority: 1
    google_scholar:
      enabled: true
      priority: 2
    pubmed:
      enabled: true
      priority: 1
    news_api:
      enabled: true
      priority: 3
    kostat:
      enabled: false  # 미구현
      priority: 2

  behavior:
    parallel_queries: true
    auto_fallback: true
    cache_mcp_results: true

  timeouts:
    connect_ms: 5000
    read_ms: 10000
    total_ms: 15000

  retry:
    max_attempts: 2
    backoff_ms: 1000
```

---

## 구현 노트

### 현재 상태

```yaml
implementation_status:
  arxiv:
    status: "available"
    note: "WebSearch fallback으로 대체 가능"

  google_scholar:
    status: "available"
    note: "WebSearch fallback으로 대체 가능"

  pubmed:
    status: "available"
    note: "WebSearch fallback으로 대체 가능"

  news_api:
    status: "partial"
    note: "WebSearch로 대부분 커버"

  kostat:
    status: "planned"
    note: "추후 구현 예정"
```

### 향후 계획

```yaml
future_integrations:
  - name: "Semantic Scholar API"
    type: "academic"
    priority: "high"

  - name: "Statista API"
    type: "statistics"
    priority: "medium"

  - name: "Crunchbase API"
    type: "business"
    priority: "medium"

  - name: "SEC EDGAR"
    type: "financial"
    priority: "low"
```
