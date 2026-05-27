# Domain Authority Database


## Contents

- [개요](#개요)
- [신뢰도 등급 체계](#신뢰도-등급-체계)
- [도메인 카테고리](#도메인-카테고리)
  - [🏛️ Tier 1: 최고 신뢰 (Score: 5)](#tier-1-최고-신뢰-score-5)
  - [📊 Tier 2: 높은 신뢰 (Score: 4)](#tier-2-높은-신뢰-score-4)
  - [📰 Tier 3: 보통 신뢰 (Score: 3)](#tier-3-보통-신뢰-score-3)
  - [⚠️ Tier 4: 낮은 신뢰 (Score: 2)](#tier-4-낮은-신뢰-score-2)
  - [🚫 Tier 5: 매우 낮음 (Score: 1)](#tier-5-매우-낮음-score-1)
- [컨텍스트별 신뢰도 조정](#컨텍스트별-신뢰도-조정)
- [도메인 매칭 규칙](#도메인-매칭-규칙)
- [동적 업데이트](#동적-업데이트)
- [조회 인터페이스](#조회-인터페이스)
- [설정](#설정)

> 도메인별 사전 정의된 신뢰도 등급

---

## 개요

웹 도메인의 신뢰도를 사전 정의하여 소스 평가 시
일관되고 빠른 신뢰도 판단을 지원합니다.

---

## 신뢰도 등급 체계

```yaml
authority_tiers:
  tier_1:
    score: 5
    label: "최고 신뢰"
    description: "공식 기관, 학술 저널, 정부 사이트"
    examples: ["nature.com", "whitehouse.gov", "ieee.org"]

  tier_2:
    score: 4
    label: "높은 신뢰"
    description: "권위 있는 리서치/뉴스, 전문가 플랫폼"
    examples: ["gartner.com", "reuters.com", "hbr.org"]

  tier_3:
    score: 3
    label: "보통 신뢰"
    description: "일반 뉴스, 인정된 블로그, 커뮤니티"
    examples: ["techcrunch.com", "stackoverflow.com"]

  tier_4:
    score: 2
    label: "낮은 신뢰"
    description: "개인 블로그, 오래된 자료, 소규모 사이트"
    examples: ["개인 블로그", "포럼 게시글"]

  tier_5:
    score: 1
    label: "매우 낮음"
    description: "출처 불명, 익명, 의심스러운 사이트"
    examples: ["익명 게시판", "스팸 사이트"]
```

---

## 도메인 카테고리

### 🏛️ Tier 1: 최고 신뢰 (Score: 5)

#### 정부/공공기관

```yaml
government:
  korea:
    - "*.go.kr": "대한민국 정부"
    - "korea.kr": "정부 포털"
    - "bok.or.kr": "한국은행"
    - "kostat.go.kr": "통계청"
    - "kosis.kr": "국가통계포털"

  us:
    - "*.gov": "미국 정부"
    - "whitehouse.gov": "백악관"
    - "sec.gov": "증권거래위원회"
    - "fda.gov": "식품의약국"
    - "cdc.gov": "질병통제예방센터"

  international:
    - "un.org": "유엔"
    - "who.int": "세계보건기구"
    - "worldbank.org": "세계은행"
    - "imf.org": "국제통화기금"
    - "oecd.org": "OECD"
```

#### 학술/연구

```yaml
academic:
  journals:
    - "nature.com": "Nature"
    - "science.org": "Science"
    - "cell.com": "Cell"
    - "thelancet.com": "Lancet"
    - "nejm.org": "New England Journal of Medicine"

  databases:
    - "pubmed.ncbi.nlm.nih.gov": "PubMed"
    - "arxiv.org": "arXiv"
    - "scholar.google.com": "Google Scholar"
    - "ieee.org": "IEEE"
    - "acm.org": "ACM"

  universities:
    - "*.edu": "미국 대학"
    - "*.ac.kr": "한국 대학"
    - "*.ac.uk": "영국 대학"
    - "mit.edu": "MIT"
    - "stanford.edu": "Stanford"
    - "harvard.edu": "Harvard"
```

### 📊 Tier 2: 높은 신뢰 (Score: 4)

#### 리서치/컨설팅

```yaml
research_consulting:
  - "gartner.com": "Gartner"
  - "mckinsey.com": "McKinsey"
  - "bcg.com": "BCG"
  - "bain.com": "Bain"
  - "deloitte.com": "Deloitte"
  - "pwc.com": "PwC"
  - "kpmg.com": "KPMG"
  - "ey.com": "EY"
  - "forrester.com": "Forrester"
  - "idc.com": "IDC"
  - "statista.com": "Statista"
```

#### 주요 뉴스

```yaml
major_news:
  international:
    - "reuters.com": "Reuters"
    - "apnews.com": "AP News"
    - "bbc.com": "BBC"
    - "nytimes.com": "New York Times"
    - "wsj.com": "Wall Street Journal"
    - "ft.com": "Financial Times"
    - "economist.com": "Economist"
    - "bloomberg.com": "Bloomberg"

  korea:
    - "yonhapnews.co.kr": "연합뉴스"
    - "khan.co.kr": "경향신문"
    - "hani.co.kr": "한겨레"
    - "chosun.com": "조선일보"
    - "donga.com": "동아일보"
    - "joongang.co.kr": "중앙일보"
```

#### 전문 플랫폼

```yaml
professional:
  business:
    - "hbr.org": "Harvard Business Review"
    - "forbes.com": "Forbes"
    - "fortune.com": "Fortune"
    - "businessinsider.com": "Business Insider"

  tech:
    - "wired.com": "Wired"
    - "arstechnica.com": "Ars Technica"
    - "theverge.com": "The Verge"
    - "techreview.com": "MIT Technology Review"
```

### 📰 Tier 3: 보통 신뢰 (Score: 3)

#### 테크 뉴스/블로그

```yaml
tech_news:
  - "techcrunch.com": "TechCrunch"
  - "venturebeat.com": "VentureBeat"
  - "zdnet.com": "ZDNet"
  - "cnet.com": "CNET"
  - "engadget.com": "Engadget"
  - "mashable.com": "Mashable"
  - "thenextweb.com": "The Next Web"
```

#### 개발자 커뮤니티

```yaml
developer_community:
  - "stackoverflow.com": "Stack Overflow"
  - "github.com": "GitHub"
  - "dev.to": "DEV Community"
  - "medium.com": "Medium"
  - "hashnode.com": "Hashnode"
```

#### 리뷰/비교 사이트

```yaml
review_sites:
  - "g2.com": "G2"
  - "capterra.com": "Capterra"
  - "trustpilot.com": "Trustpilot"
  - "producthunt.com": "Product Hunt"
```

#### 한국 커뮤니티

```yaml
korea_community:
  - "naver.com": "네이버"
  - "daum.net": "다음"
  - "tistory.com": "티스토리"
  - "velog.io": "벨로그"
  - "brunch.co.kr": "브런치"
```

### ⚠️ Tier 4: 낮은 신뢰 (Score: 2)

```yaml
low_trust:
  categories:
    - "개인 블로그 (미검증)"
    - "소규모 뉴스 사이트"
    - "익명 포럼"
    - "오래된 자료 (3년+)"
    - "광고성 콘텐츠"

  indicators:
    - no_author: true
    - no_date: true
    - excessive_ads: true
    - poor_design: true
```

### 🚫 Tier 5: 매우 낮음 (Score: 1)

```yaml
very_low_trust:
  categories:
    - "출처 불명"
    - "스팸/스캠 사이트"
    - "가짜 뉴스"
    - "편향된 선전"

  blacklist:
    - 알려진 가짜 뉴스 사이트
    - 스팸 도메인
    - 악성 사이트
```

---

## 컨텍스트별 신뢰도 조정

```yaml
context_adjustments:
  # 주제별 신뢰도 보정
  topic_based:
    medical:
      boost:
        - "pubmed.ncbi.nlm.nih.gov": +1
        - "who.int": +1
        - "cdc.gov": +1
      reduce:
        - "일반 블로그": -1

    finance:
      boost:
        - "sec.gov": +1
        - "bloomberg.com": +1
      reduce:
        - "소셜 미디어": -1

    technology:
      boost:
        - "arxiv.org": +1
        - "github.com": +0.5
      reduce:
        - "오래된 자료": -1

  # 최신성 보정
  recency:
    within_1_year: 0
    1_to_2_years: -0.5
    2_to_3_years: -1
    over_3_years: -1.5
```

---

## 도메인 매칭 규칙

```yaml
matching_rules:
  exact_match:
    priority: 1
    example: "arxiv.org" matches "arxiv.org"

  subdomain_match:
    priority: 2
    example: "docs.google.com" matches "*.google.com"

  tld_match:
    priority: 3
    example: "example.edu" matches "*.edu"

  pattern_match:
    priority: 4
    example: "blog.example.com" matches "blog.*"
```

---

## 동적 업데이트

```yaml
dynamic_updates:
  # 사용자 피드백 기반
  user_feedback:
    enabled: true
    adjustment_range: [-1, +1]
    min_feedback_count: 3

  # 교차검증 결과 기반
  cross_validation:
    consistent_high_quality: +0.5
    consistent_low_quality: -0.5

  # 세션 내 학습
  session_learning:
    enabled: true
    persistence: "session_only"
```

---

## 조회 인터페이스

```yaml
lookup_interface:
  get_authority:
    input: "domain or url"
    output:
      domain: "example.com"
      tier: 2
      score: 4
      label: "높은 신뢰"
      category: "research_consulting"
      adjustments: []

  batch_lookup:
    input: ["url1", "url2", "url3"]
    output: [{domain, tier, score}, ...]

  suggest_alternatives:
    input: "low_quality_domain"
    output: "higher_quality_alternatives"
```

---

## 설정

```yaml
domain_authority_config:
  enabled: true

  default_score: 2.5  # 미등록 도메인 기본값

  adjustments:
    topic_based: true
    recency_based: true
    user_feedback: true

  caching:
    enabled: true
    ttl: 86400  # 24시간
```
