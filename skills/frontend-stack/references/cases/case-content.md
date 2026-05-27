
## Contents

- [팀 구성 (3명)](#팀-구성-3명)
- [파이프라인 (3-Stage)](#파이프라인-3-stage)
  - [Stage 1: Strategy](#stage-1-strategy)
  - [Stage 2: Design](#stage-2-design)
  - [Stage 3: Optimize + Export](#stage-3-optimize-export)
- [플랫폼별 프리셋](#플랫폼별-프리셋)
  - [Instagram](#instagram)
  - [YouTube 썸네일](#youtube-썸네일)
  - [OG 이미지 (Open Graph)](#og-이미지-open-graph)
  - [블로그 썸네일](#블로그-썸네일)
  - [기타 플랫폼](#기타-플랫폼)
- [디자인 원칙](#디자인-원칙)
  - [AIDA 썸네일 적용](#aida-썸네일-적용)
  - [단순성 규칙](#단순성-규칙)
- [위임 스킬](#위임-스킬)

---
case: content
version: 2.1
team_bindings:
  marketing:
    - { role: CMO Strategist, stage: S1 }
    - { role: Insight Analyst, stage: S1 }
    - { role: Copy & Content Chief, stage: S1-S3 }
    - { role: Acquisition Lead, stage: "S0,S3" }
    - { role: Growth & GTM Ops, stage: S2 }
  external:
    - { team: team-business, stage: S1, policy: SILENT }
    - { team: team-secretary, stage: S2, policy: SILENT }
    - { team: team-accounting, stage: S2, policy: INFORM_5m }
pipeline:
  - stage: S0
    name: Information Architecture
    personas: [architect, frontend]
    inputs: [PMC.ICP, PMC.Differentiation]
    outputs: [content-map.md]
    checks: [a11y_landmarks]
  - stage: S1
    name: Strategy
    personas: [frontend, critic]
    inputs: [PMC.ICP, PMC.BrandVoice, Competitor.data]
    outputs: [content-strategy.md, platform-spec.md]
    checks: [brand_consistency]
  - stage: S2
    name: Design
    personas: [frontend, architect]
    inputs: [content-strategy.md, PMC.BrandVoice]
    outputs: [design-tokens.css, content-drafts/]
    checks: [tokens, copy_sweeps, license]
  - stage: S3
    name: Optimize + Export
    personas: [frontend, performance]
    inputs: [content-drafts/]
    outputs: [exports/]
    checks: [perf, a11y, brand]
pmc_inputs: [ICP, BrandVoice, Differentiation, Objection, ProofPoint]
delegate_skills:
  - marketing-skills:site-architecture
  - marketing-skills:schema-markup
quality_gates: [tokens, a11y, perf, brand, copy_sweeps, license]
ontology_emits: [DesignAsset, Archetype, DesignToken, MotionSignature]
guide_refs:
  - guides/frontend.md
  - guides/decision-trees.md
  - rules/design-marketing-integration.md
---

# Content 케이스 (SNS / OG / 블로그)

## 팀 구성 (3명)

| 역할 | 담당 | 에이전트 |
|------|------|---------|
| **Content Strategist** | 플랫폼별 전략, 타겟, 메시지 프레이밍 | 메인(opus) |
| **Visual Designer** | 레이아웃, 컬러, 타이포, 세이프존 | worker(sonnet) |
| **Platform Specialist** | 사이즈 규격, 최적화, export | worker(sonnet) |

## 파이프라인 (3-Stage)

### Stage 1: Strategy
- **플랫폼 네이티브 필수** — 크로스포스트 금지 (알고리즘 패널티)
- **타겟팅**: 행동 + 의도 기반 (인구통계만으로 부족)
- **페르소나 문서화**: 참여율 +28%
- **콘텐츠 유형**: 교육 / 오락 / 문제해결 > 순수 프로모션
- **2026 핵심**: 창의성 > 타겟팅, 휴먼 콘텐츠 우선

### Stage 2: Design
- `design-tokens.md` OKLCH 컬러 + 타이포 로딩
- `visual-effects.md` — Bold Gradient + Grain 추천
- 폰트: **최소 24pt**, sans-serif, 고대비
- 텍스트: **간결** (5-6단어 이하)
- 가독성: 텍스트 뒤 그림자/배경
- 라이트/다크 모드 둘 다 테스트

### Stage 3: Optimize + Export
- 플랫폼별 사이즈/포맷 자동 적용
- 포맷: JPEG(사진), PNG(텍스트/그래픽)
- 압축: 플랫폼 제한 내 최대 품질

---

## 플랫폼별 프리셋

### Instagram

| 유형 | 사이즈 | 비율 | 세이프존 |
|------|--------|------|---------|
| 피드 (추천) | 1080x1350 | 4:5 | 중앙 1080x1420 |
| 피드 정사각형 | 1080x1080 | 1:1 | - |
| 스토리/릴스 | 1080x1920 | 9:16 | 상하 250px 여백 |
| 가로 | 1080x608 | 1.91:1 | - |

- **2026 변경**: 프로필 그리드 기본 4:5 (1:1 아님)
- 텍스트/로고/CTA는 중앙 정렬
- 최대 2-3 폰트

### YouTube 썸네일

| 항목 | 값 |
|------|-----|
| 사이즈 | **1920x1080** (전문) / 1280x720 (최소) |
| 비율 | 16:9 |
| 포맷 | JPG/PNG |
| 파일 크기 | **2MB 이하** |
| 컬러 규칙 | **60-30-10** (배경60 / 주제30 / 강조10) |
| 텍스트 | **3-5단어**, bold sans-serif |
| 대비 | **4.5:1** (WCAG AA) |
| 금지 영역 | 하단 15% (프로그레스바), 우하단 (시간 배지) |
| 얼굴+감정 | CTR **+20-30%** |

**The Squint Test**: 모바일 크기(120-160px)로 축소 시 핵심이 보이지 않으면 단순화.

**시선 방향**: 얼굴이 텍스트/핵심 요소를 향하도록 (viewers follow gaze).

**레이아웃 템플릿**:
- Rule of Thirds: 9분할 교차점에 주제
- Negative Space: 30-40% 빈 공간
- Layering: Background → Subject (middle) → Text (top)

**복합 색상 페어** (최대 대비):
- Blue / Orange
- Yellow / Violet
- Red / Cyan

### OG 이미지 (Open Graph)

| 항목 | 값 |
|------|-----|
| 사이즈 | **1200x630** |
| 비율 | 1.91:1 |
| 포맷 | JPEG / PNG |
| 파일 크기 | **5MB 이하** |
| 텍스트 비중 | **20-25% 이하** |
| 카피 길이 | 5-6단어 이하 |
| 포함 | 브랜드 로고 + 태그라인 |

**메타 태그**:
```html
<meta property="og:image" content="..." />
<meta property="og:image:width" content="1200" />
<meta property="og:image:height" content="630" />
```

### 블로그 썸네일
- OG 이미지와 동일 사이즈 (1200x630)
- 제목 → 시각 훅 변환
- 브랜드 색상/폰트 일관성
- 2초 내 스캔 가능

### 기타 플랫폼

| 플랫폼 | 사이즈 |
|--------|--------|
| X/트위터 카드 | 1200x628 |
| X 헤더 | 1500x500 (3:1) |
| Facebook 커버 | 820x312 |
| LinkedIn 포스트 | 1200x627 |
| LinkedIn 커버 | 1584x396 |
| 유튜브 쇼츠 커버 | 1080x1920 |
| 틱톡 | 1080x1920 (9:16) |

---

## 디자인 원칙

### AIDA 썸네일 적용
- **Attention**: 고대비 + 대형 포컬 포인트 + 최소 요소
- **Interest**: 제목과의 curiosity gap (동일 텍스트 금지)
- **Desire**: 감정 훅 (질문/놀람/궁금)
- **Action**: 모바일 가독성 + 클릭 장벽 제거

### 단순성 규칙
- **2-3 시각 요소 최대**
- 복잡함은 썸네일 크기에서 시각 카오스로 변환됨

## 위임 스킬

- `content-creator` (SEO + 브랜드 보이스 + 프레임워크)
- `image-processor` (ImageMagick 리사이즈 + 텍스트 오버레이 + 워터마크 + 배치)
