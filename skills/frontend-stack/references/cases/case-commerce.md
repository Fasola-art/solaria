
## Contents

- [팀 구성 (5명)](#팀-구성-5명)
- [핵심 지표](#핵심-지표)
- [파이프라인 (4-Stage)](#파이프라인-4-stage)
  - [Stage 1: Conversion Strategy](#stage-1-conversion-strategy)
  - [Stage 2: Design + Copy (병렬)](#stage-2-design-copy-병렬)
  - [Stage 3: Implementation](#stage-3-implementation)
  - [Stage 4: QA (CRO 체크리스트)](#stage-4-qa-cro-체크리스트)
- [제품 이미지 프리셋](#제품-이미지-프리셋)
  - [Amazon 메인 규격](#amazon-메인-규격)
  - [추가 이미지 (최대 9장)](#추가-이미지-최대-9장)
  - [AI 생성 규칙](#ai-생성-규칙)
- [AI 프롬프트 4카테고리](#ai-프롬프트-4카테고리)
  - [모델별 프롬프트 스타일](#모델별-프롬프트-스타일)
- [목업 (AI 기반)](#목업-ai-기반)
- [위임 스킬](#위임-스킬)

---
case: commerce
version: 2.1
team_bindings:
  marketing:
    - { role: CMO Strategist, stage: S1 }
    - { role: Insight Analyst, stage: S1 }
    - { role: Copy & Content Chief, stage: S2-S3 }
    - { role: CRO Engineer, stage: "S3,S5" }
    - { role: Acquisition Lead, stage: "S0,S3" }
    - { role: Growth & GTM Ops, stage: S3 }
  external:
    - { team: team-dev, stage: S3, policy: INFORM_5m }
    - { team: team-business, stage: S1, policy: SILENT }
    - { team: team-accounting, stage: S4, policy: INFORM_5m }
pipeline:
  - stage: S0
    name: Information Architecture
    personas: [architect, frontend]
    inputs: [PMC.ICP, PMC.Differentiation, Competitor.sitemap]
    outputs: [sitemap.json, url-structure.md]
    checks: [a11y_landmarks, url_canonicalization]
  - stage: S1
    name: Conversion Strategy
    personas: [frontend, critic]
    inputs: [PMC.ICP, PMC.ProofPoint, Competitor.data]
    outputs: [conversion-strategy.md, cta-map.md]
    checks: [brand_consistency]
  - stage: S2
    name: Design + Copy
    personas: [frontend, architect]
    inputs: [conversion-strategy.md, PMC.BrandVoice]
    outputs: [design-tokens.css, copy-draft.md]
    checks: [tokens, copy_sweeps]
  - stage: S3
    name: Implement
    personas: [frontend, backend]
    inputs: [design-tokens.css, copy-draft.md]
    outputs: [pages/, components/]
    checks: [perf, a11y, license]
  - stage: S4
    name: Ad Budget & Motion
    personas: [frontend, performance]
    inputs: [motion-guide.md]
    outputs: [motion-tokens.css]
    checks: [perf]
  - stage: S5
    name: QA
    personas: [qa]
    inputs: [pages/, components/]
    outputs: [qa-report.md]
    checks: [tokens, a11y, perf, brand, copy_sweeps, license]
pmc_inputs: [ICP, BrandVoice, Differentiation, Objection, ProofPoint]
delegate_skills:
  - marketing-skills:site-architecture
  - marketing-skills:schema-markup
  - marketing-skills:competitor-alternatives
quality_gates: [tokens, a11y, perf, brand, copy_sweeps, license]
ontology_emits: [DesignAsset, Archetype, DesignToken, MotionSignature]
guide_refs:
  - guides/frontend.md
  - guides/decision-trees.md
  - rules/design-marketing-integration.md
---

# Commerce 케이스 (PDP / 제품이미지 / 목업)

## 팀 구성 (5명)

| 역할 | 담당 | 에이전트 |
|------|------|---------|
| **Conversion Strategist** | CTA 배치, 소셜 프루프, 모바일 퍼스트 | 메인(opus) |
| **Visual Designer** | 이미지 레이아웃, 갤러리, 줌 UX | worker(sonnet) |
| **Copywriter** | 혜택 중심 카피, SEO 키워드 | worker(sonnet) |
| **Image Specialist** | AI 프롬프트, 배경 생성, 후보정 | worker(sonnet) |
| **QA Reviewer** | 전환율 체크리스트, 모바일, 로딩 속도 | reviewer(sonnet) |

## 핵심 지표

- 이미지 품질: 구매 결정 **67%** (최고 요인)
- 리뷰 확인: 구매자 **98%**
- 로딩 1초 지연: 전환율 **-7%**
- 모바일 매출 비중: **57%**
- 비디오 삽입: 장바구니 추가 **+144%**
- 줌 가능 이미지: 전환율 **+30%**
- 전문 이미지: 매출 **2.5배**

## 파이프라인 (4-Stage)

### Stage 1: Conversion Strategy
- CTA above-fold 필수
- 모바일 퍼스트 설계
- 1초 이내 핵심 정보 도달

### Stage 2: Design + Copy (병렬)

**Visual Designer:**
- 상품 이미지 갤러리 (줌 가능)
- 비디오 삽입 위치 결정
- Social proof 배치 (CTA 근처)
- 모바일 첫 fold: 제품명 + 이미지 + 가격 + USP + CTA

**Copywriter:**
- **AIDA**: Attention(헤드라인) → Interest(통계/스토리) → Desire(혜택) → Action(CTA)
- **PAS**: Problem(고통점) → Agitation(감정 증폭) → Solution(제품)
- **BAB**: Before(현재) → After(이상) → Bridge(제품)
- 혜택 중심 (기능 X → 결과 O): "사람은 혜택을 산다, 기능이 아니다"
- SEO 키워드 자연 삽입
- 상세한 설명 (70% 이탈 방지)

### Stage 3: Implementation
- 이미지 최적화: WebP, lazy load, srcset
- LCP < 2.5s (Core Web Vitals)
- 리뷰/평점 섹션 구현
- Sticky add-to-cart (모바일)

### Stage 4: QA (CRO 체크리스트)

**필수 항목:**
- [ ] CTA above-fold 배치
- [ ] Sticky add-to-cart 모바일 (+5-12% 전환)
- [ ] 프리 쉬핑 임계값 표시 (+12-18% AOV)
- [ ] Exit-intent 팝업 (+8-15% 옵트인)
- [ ] 리뷰/평점 프로미넌트
- [ ] 반품/배송 정보 CTA 근처
- [ ] 재고 상태/긴급성 표시
- [ ] 관련 상품 크로스셀
- [ ] 게스트 체크아웃 옵션
- [ ] 카트 진행 표시기
- [ ] 실시간 구매 알림 (FOMO)
- [ ] 트러스트 뱃지 CTA 근처

**모바일 검증:**
- 터치 친화 (버튼 44x44px+)
- 엄지 도달 범위 주요 CTA
- 팝업 작은 화면 호환
- 자동완성 폼 필드

## 제품 이미지 프리셋

### Amazon 메인 규격
| 항목 | 값 |
|------|-----|
| 배경 | 순수 흰색 RGB(255, 255, 255) |
| 제품 비율 | 85% 프레임 |
| 최소 크기 | 2000px (최장변) |
| 줌 활성 | 1600x1600 이상 |
| 텍스트/그래픽 | 금지 |

### 추가 이미지 (최대 9장)
- 다양한 각도
- 기능 하이라이트
- **라이프스타일**: on-model, 실사용 환경
- 인포그래픽 (치수, 기능 설명)

### AI 생성 규칙
- **허용**: 라이프스타일 배경, 인포그래픽 오버레이, 배경 교체
- **금지**: 제품 자체 AI 날조 (상장 정지 + 계정 정지)

## AI 프롬프트 4카테고리

```
1. Subject: 제품 상세 (소재, 색상, 크기)
   "premium glass water bottle with bamboo cap, matte black"

2. Camera: 렌즈, 각도, 구도
   "85mm f/1.4, eye-level, center composition, 3/4 angle"

3. Lighting: 조명 설정
   "soft diffused natural light from left, clean white seamless bg"

4. Negative: 제외 항목
   "no text, no watermark, no distortion, no reflection artifacts"
```

### 모델별 프롬프트 스타일

| 모델 | 스타일 | 예시 |
|------|-------|------|
| **GPT-5 / 4o** | 문장형 자연어 | "A premium glass water bottle photographed on pure white seamless background with soft natural lighting from the left side..." |
| **Midjourney V7** | 단문 + 참조 이미지 | `product photo, glass bottle, white bg, 85mm --ar 1:1 --style raw` |
| **Stable Diffusion 3.5** | 가중 키워드 | `(glass bottle:1.3), (white background:1.2), studio lighting, 85mm lens, (sharp focus:1.1)` |
| **Flux** | 상세 자연어 | "Full sentences with specific camera/lens details, lighting descriptions, and composition cues" |

## 목업 (AI 기반)

- **도구**: Flair.ai, Smartmockups, Artificial Studio
- **기능**: 텍스트 → 3D 패키징 (bottle/box/jar/pouch/can)
- **자동화**: API 연동 50~50,000 SKU 확장
- **검증**: 브랜드 가이드 + 플랫폼 규격 준수

## 위임 스킬

- `image-processor` (ImageMagick): 리사이즈, 포맷 변환, 워터마크, 배치 처리
- 외부 AI 도구: Flair.ai / Midjourney / Stable Diffusion
