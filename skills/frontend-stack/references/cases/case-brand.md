
## Contents

- [팀 구성 (4명)](#팀-구성-4명)
- [파이프라인 (4-Stage)](#파이프라인-4-stage)
  - [Stage 1: Brand Strategy](#stage-1-brand-strategy)
  - [Stage 2: Identity Design](#stage-2-identity-design)
  - [Stage 3: Visual System](#stage-3-visual-system)
  - [Stage 4: Brand Guidelines 문서](#stage-4-brand-guidelines-문서)
- [검증](#검증)
- [위임 스킬](#위임-스킬)

---
case: brand
version: 2.1
team_bindings:
  marketing:
    - { role: CMO Strategist, stage: S1 }
    - { role: Insight Analyst, stage: S1 }
    - { role: Copy & Content Chief, stage: "S1,S3" }
    - { role: Growth & GTM Ops, stage: S3 }
  external:
    - { team: team-business, stage: S1, policy: SILENT }
pipeline:
  - stage: S1
    name: Brand Strategy
    personas: [architect, frontend]
    inputs: [PMC.ICP, PMC.Differentiation, Competitor.data]
    outputs: [brand-strategy.md, positioning-map.md]
    checks: [brand_consistency]
  - stage: S2
    name: Identity Design
    personas: [frontend]
    inputs: [brand-strategy.md, PMC.BrandVoice]
    outputs: [logo-system/, design-tokens.css, color-palette.md]
    checks: [tokens, a11y, license]
  - stage: S3
    name: System Build
    personas: [frontend, architect]
    inputs: [logo-system/, design-tokens.css]
    outputs: [brand-guidelines.md, asset-library/]
    checks: [brand, copy_sweeps, license]
  - stage: S4
    name: QA + Handoff
    personas: [qa]
    inputs: [brand-guidelines.md, asset-library/]
    outputs: [qa-report.md, final-guidelines/]
    checks: [tokens, a11y, brand, copy_sweeps, license]
pmc_inputs: [ICP, BrandVoice, Differentiation, Objection, ProofPoint]
delegate_skills:
  - marketing-skills:competitor-alternatives
quality_gates: [tokens, a11y, perf, brand, copy_sweeps, license]
ontology_emits: [DesignAsset, Archetype, DesignToken, MotionSignature]
guide_refs:
  - guides/frontend.md
  - guides/decision-trees.md
  - rules/design-marketing-integration.md
---

# Brand 케이스 (브랜딩 / 로고 / 아이덴티티)

## 팀 구성 (4명)

| 역할 | 담당 | 에이전트 |
|------|------|---------|
| **Brand Strategist** | 미션/가치/타겟, 포지셔닝, 페르소나 | 메인(opus) |
| **Identity Designer** | 로고 시스템, 워드마크, 변형 | worker(sonnet) |
| **System Builder** | 컬러 코드, 타이포, clear space, 적용 규칙 | worker(sonnet) |
| **Guidelines Writer** | 가이드라인 문서 (Do/Don't) | worker(sonnet) |

## 파이프라인 (4-Stage)

### Stage 1: Brand Strategy

**4C 프레임워크** (핵심 진단):
- **Company**: 실제 가치, 역사, 자산
- **Category**: 카테고리의 획일성 (sea of sameness)
- **Customer**: 무시당하는 사람들의 니즈/동기/결정 패턴
- **Culture**: 시장 변화, 트렌드

> 포지셔닝 = "better"가 아닌 **"only"**를 찾는 것

**포지셔닝 맵 (Perceptual Map):**
- 2축 선택 (고객이 실제로 평가하는 기준)
  - 예: Premium vs Accessible
  - 예: Specialized vs Generalist
  - 예: Traditional vs Innovative
- 경쟁사 플로팅 → 화이트 스페이스 발견
- 의도된 포지셔닝 vs 인지된 포지셔닝 갭 분석

**브랜드 전략 3섹션:**

1. **Brand Core** (내부 기반)
   - Purpose: 존재 이유
   - Vision: 미래 상태
   - Values: 행동 원칙

2. **Brand Positioning** (시장 위치)
   - Target Audience (페르소나 상세)
   - Market Analysis
   - Awareness Goals

3. **Brand Persona** (인간적 연결)
   - Personality (5-7 형용사)
   - Voice (톤)
   - Tagline

**페르소나 프로필:**
- 인구통계 (기본)
- **동기 / 고통 / 결정 패턴** (핵심)
- 열망, 희망, 목표
- 행동 패턴

**Value Proposition:**
> "브랜드가 제공하는 변화" + "왜 우리를 선택해야 하는가"

### Stage 2: Identity Design

**로고 = 시스템** (2026 핵심):
- 고정 마크 X → 플랫폼/맥락 적응형
- 워드마크 중심 (타이포 > 심볼)
- 커스텀 타이포그래피로 성격 표현

**로고 변형:**
- Primary (풀 로고)
- Secondary (가로형)
- Mark / Icon (심볼만)
- Stacked (세로 배치)
- Monochrome (단색)
- Reverse (어두운 배경용)

**크기/공간 규칙:**
- **Clear Space**: 로고 주변 최소 여백 (x-height 또는 심볼 크기 단위)
- **Minimum Size**: 디지털 16px, 인쇄 0.5"
- "16px 브라우저 탭부터 16피트 광고판까지"

### Stage 3: Visual System

**컬러 시스템 (4층):**

| 층 | 용도 | 개수 |
|-----|------|------|
| Primary | 주 브랜드 색 | 2-3 |
| Secondary | 보조 | 2-3 |
| Neutral | 배경/텍스트 | 3-5 (흑백 + 회색 계조) |
| Accent | 강조 (유일한 attention grabber) | 1 |

**각 색상 스펙 (필수):**
- **HEX** (웹): `#RRGGBB`
- **RGB** (디지털): `rgb(R, G, B)` 또는 `oklch(L C H)` (2026)
- **CMYK** (인쇄): `C/M/Y/K`
- **Pantone** (특수 인쇄): PMS 번호
- **Use Case**: 사용 용도 명시

**타이포그래피:**
- **Headline** (bold/attention): 1개
- **Body** (legible): 1개
- 최대 2-3 폰트
- Weight 사용 규칙 (Light/Regular/Medium/Bold/Black 각각 언제)
- Size hierarchy (H1-H6 + body + caption + label)
- Line height / letter spacing 규칙

**이미지 스타일:**
- Photography 가이드라인 (무드, 구도, 컬러 그레이딩)
- Illustration 스타일
- Iconography (stroke width, corner radius, size grid)

### Stage 4: Brand Guidelines 문서

**5개 섹션 구조:**

1. **로고**
   - 변형 모음
   - Clear space + 최소 크기
   - Do / Don't (시각 참조)
   - 금지 사항 (왜곡, 회전, 색상 변경 등)

2. **컬러**
   - 팔레트 (HEX/RGB/CMYK/Pantone)
   - 사용 비율 (60-30-10 규칙)
   - 접근성 대비표
   - 배경별 사용 규칙

3. **타이포그래피**
   - 폰트 패밀리 + 라이선스
   - Weight 사용 규칙
   - Size hierarchy
   - Do / Don't

4. **이미지 / 일러스트**
   - 포토 스타일 가이드
   - 일러스트 스타일
   - 아이콘 시스템

5. **음성 / 톤**
   - Brand personality (5-7 형용사)
   - Voice principles
   - 예시 (on-brand vs off-brand)

**크로스플랫폼 적용:**
- 인쇄 (명함, 레터헤드, 브로셔)
- 웹 (favicon, OG 이미지, 배너)
- 영상 (인트로/아웃트로/Lower Third)
- SNS (프로필, 포스트 템플릿)
- 물리 (사이니지, 패키징)

**버전 관리:**
- 파일 명명 규칙: `brand-guidelines-v1.0.pdf`
- 변경 로그
- 접근성: 모든 이해관계자에게 공유

## 검증

- [ ] 4C 프레임워크 작성 완료
- [ ] 포지셔닝 맵 (2축 + 경쟁사 + 화이트 스페이스)
- [ ] 로고 최소 5개 변형
- [ ] 컬러 4층 + 모든 코드 (HEX/RGB/CMYK/Pantone)
- [ ] 타이포 계층 + 라이선스 확인
- [ ] 가이드라인 5섹션 완비
- [ ] 16px ~ 16ft 범위 테스트
- [ ] 라이트/다크 모드 적용 가능
- [ ] 접근성 대비비 검증

## 위임 스킬

- 자체 처리 (디자인 레이어 완결형)
- 필요 시: `image-processor` (로고 변형 생성), `pdf` (가이드라인 PDF 제작)
