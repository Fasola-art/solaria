
## Contents

- [팀 구성 (3명)](#팀-구성-3명)
- [파이프라인 (3-Stage)](#파이프라인-3-stage)
  - [Stage 1: Structure (Story Architect)](#stage-1-structure-story-architect)
  - [Stage 2: Design + Data Viz (병렬)](#stage-2-design-data-viz-병렬)
  - [Stage 3: QA (Slide Designer + Story Architect)](#stage-3-qa-slide-designer-story-architect)
- [프리셋](#프리셋)
  - [PPT](#ppt)
  - [PDF 문서](#pdf-문서)
- [위임 스킬](#위임-스킬)

---
case: document
version: 2.1
team_bindings:
  marketing:
    - { role: CMO Strategist, stage: S1 }
    - { role: Copy & Content Chief, stage: S1-S2 }
    - { role: Growth & GTM Ops, stage: S2 }
  external:
    - { team: team-secretary, stage: S1, policy: SILENT }
pipeline:
  - stage: S1
    name: Structure
    personas: [architect, frontend]
    inputs: [PMC.ICP, PMC.Differentiation, PMC.ProofPoint]
    outputs: [narrative-structure.md, slide-map.md]
    checks: [brand_consistency]
  - stage: S2
    name: Design
    personas: [frontend]
    inputs: [narrative-structure.md, PMC.BrandVoice]
    outputs: [slides/, design-tokens.css]
    checks: [tokens, a11y, copy_sweeps, license]
  - stage: S3
    name: QA + Export
    personas: [qa]
    inputs: [slides/]
    outputs: [qa-report.md, exports/]
    checks: [brand, copy_sweeps, license]
pmc_inputs: [ICP, BrandVoice, Differentiation, Objection, ProofPoint]
delegate_skills:
  - marketing-skills:sales-enablement
quality_gates: [tokens, a11y, perf, brand, copy_sweeps, license]
ontology_emits: [DesignAsset, Archetype, DesignToken, MotionSignature]
guide_refs:
  - guides/frontend.md
  - guides/decision-trees.md
  - rules/design-marketing-integration.md
---

# Document 케이스 (PPT / PDF)

## 팀 구성 (3명)

| 역할 | 담당 | 에이전트 |
|------|------|---------|
| **Story Architect** | 내러티브 구조, 흐름, 한 슬라이드=한 아이디어 | 메인(opus) |
| **Slide Designer** | 비대칭 레이아웃, 타이포 계층, whitespace | worker(sonnet) |
| **Data Viz Specialist** | 차트/그래프/인포그래픽, 인사이트 콜아웃 | worker(sonnet) |

## 파이프라인 (3-Stage)

### Stage 1: Structure (Story Architect)

**핵심 원칙:**
- **한 슬라이드 = 하나의 아이디어** (One Idea Per Slide)
- **내러티브 스캐폴딩**: 데이터 → 인사이트 → 행동
- **AIDA 변형**: Problem → Solution → Evidence → Ask

**피치 덱 표준 구조 (투자 제안):**
1. Vision / Problem
2. Solution
3. Product Demo
4. Market Size (TAM/SAM/SOM)
5. Business Model
6. Traction
7. Competition
8. Team
9. Financials
10. Ask / Roadmap

**내부 보고서 구조:**
1. Executive Summary (핵심 3줄)
2. Context / Background
3. Analysis / Findings
4. Insights (So What?)
5. Recommendations (Now What?)
6. Next Steps

### Stage 2: Design + Data Viz (병렬)

**Slide Designer:**
- `design-tokens.md` 로딩
- **비대칭 레이아웃** (2026 트렌드, 균형 대신 대담함)
- **타이포 계층**: 대형 bold 헤드라인 (텍스트가 디자인)
  - Title: 44-60pt
  - Headline: 32-40pt
  - Body: 18-24pt
  - Caption: 12-14pt
- **Whitespace 전략**: 30-50% 빈 공간
- **Gradient 색상** (2026 부활)
- 최대 2-3 폰트 (Display + Body)

**Data Viz Specialist — 차트 선택 매트릭스:**

| 질문 | 차트 | 용도 |
|------|------|------|
| 카테고리 비교 | Bar (horizontal) | 지역별 매출, 제품 성과 |
| 시간 변화 | Line | 월별 매출, 트래픽 |
| 변수 관계 | Scatter | 마케팅비 vs 매출 |
| 분포 | Histogram | 연령, 응답 시간 |
| 부분-전체 | Pie (3-5 segments) | 예산, 시장점유 |
| 순차 변화 | Waterfall | 매출 브릿지, 예산 분산 |
| 다차원 패턴 | Heat Map | 상관관계, 지역 밀도 |
| 4-10 차원 | Parallel Coordinates | 제품 스펙 비교 |

**차트 디자인 규칙:**
- 색상 **3-7개 제한**
- Y축 **0부터 시작** (bar chart)
- 접근성: 최소 4.5:1 대비, 색상 단독 금지 (redundant encoding)
- 출처/방법론/기간 명시 (신뢰도)
- 3D 효과/과도한 gridline 제거
- 15+ 데이터 시리즈 금지

**인포그래픽 성과:**
- 텍스트 전용 대비 **+650% 참여**
- 3배 더 공유
- **+178% 인바운드 링크**
- 전략적 색상: 가독성 **+82%**

**레이아웃 원칙**:
- 각 요소가 중심 메시지에 기여해야 함 (기능적 vs 장식적)
- 색상 = 미학 + 의미 인코딩

### Stage 3: QA (Slide Designer + Story Architect)

**자동 검증:**
- [ ] 타이포 계층 일관성
- [ ] 색상 팔레트 준수
- [ ] 차트 범례/축 레이블 완전성
- [ ] 인용 출처 명시

**수동 검증:**
- [ ] 슬라이드당 아이디어 1개 유지
- [ ] 내러티브 흐름 (슬라이드 간 논리)
- [ ] 인쇄 여백 (PDF의 경우 최소 0.5" = 1.27cm)
- [ ] 가독성 (뒷자리에서 읽힘)
- [ ] 청중 적응 (투자자 vs 고객 vs 팀)

## 프리셋

### PPT
- 16:9 비율 (1920x1080 또는 1280x720)
- 슬라이드당 최대 6개 불릿
- 풋터: 로고 + 페이지번호
- 섹션 구분 슬라이드 (title-only)

### PDF 문서
- Letter (8.5x11") 또는 A4 (210x297mm)
- 인쇄 여백: 최소 0.5" (1.27cm)
- Body: 11-12pt, line-height 1.5
- Heading: 명확한 계층 (H1-H3 충분)
- 페이지번호 + 목차 (5페이지 이상)

## 위임 스킬

- `pptx` — PowerPoint 생성/편집
- `pdf` — PDF 조작/폼/추출
- `xlsx` — 차트 데이터 소스 (필요 시)
