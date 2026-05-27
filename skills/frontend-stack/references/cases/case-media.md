
## Contents

- [팀 구성 (4명)](#팀-구성-4명)
- [파이프라인 (4-Stage)](#파이프라인-4-stage)
  - [Stage 1: Concept (Director)](#stage-1-concept-director)
  - [Stage 2: Design (Motion Designer)](#stage-2-design-motion-designer)
  - [Stage 3: Implementation](#stage-3-implementation)
  - [Stage 4: QA](#stage-4-qa)
- [플랫폼별 프리셋](#플랫폼별-프리셋)
  - [YouTube (가로)](#youtube-가로)
  - [YouTube Shorts / Instagram Reels / TikTok (세로)](#youtube-shorts-instagram-reels-tiktok-세로)
  - [Instagram Feed (정사각형)](#instagram-feed-정사각형)
- [디렉토리 구조 (영상 프로젝트)](#디렉토리-구조-영상-프로젝트)
- [위임 스킬](#위임-스킬)
- [향후 템플릿 (Remotion Composition)](#향후-템플릿-remotion-composition)

---
case: media
version: 2.1
team_bindings:
  marketing:
    - { role: CMO Strategist, stage: S1 }
    - { role: Insight Analyst, stage: S1 }
    - { role: Copy & Content Chief, stage: "S1,S3" }
    - { role: CRO Engineer, stage: S3 }
    - { role: Acquisition Lead, stage: S3 }
    - { role: Growth & GTM Ops, stage: S3 }
  external:
    - { team: team-dev, stage: S3, policy: INFORM_5m }
    - { team: team-secretary, stage: S1, policy: SILENT }
    - { team: team-accounting, stage: S3, policy: INFORM_5m }
pipeline:
  - stage: S1
    name: Concept
    personas: [frontend, architect]
    inputs: [PMC.ICP, PMC.BrandVoice, PMC.Differentiation]
    outputs: [concept.md, storyboard.md, style-guide.md]
    checks: [brand_consistency]
  - stage: S2
    name: Design
    personas: [frontend]
    inputs: [concept.md, PMC.BrandVoice]
    outputs: [motion-assets/, design-tokens.css]
    checks: [tokens, license]
  - stage: S3
    name: Implement
    personas: [frontend, backend]
    inputs: [motion-assets/, storyboard.md]
    outputs: [video-output/, remotion-src/]
    checks: [perf, a11y, copy_sweeps, license]
  - stage: S4
    name: QA + Export
    personas: [qa]
    inputs: [video-output/]
    outputs: [qa-report.md, final-exports/]
    checks: [brand, copy_sweeps, license]
pmc_inputs: [ICP, BrandVoice, Differentiation, Objection, ProofPoint]
delegate_skills:
  - marketing-skills:onboarding-cro
quality_gates: [tokens, a11y, perf, brand, copy_sweeps, license]
ontology_emits: [DesignAsset, Archetype, DesignToken, MotionSignature]
guide_refs:
  - guides/frontend.md
  - guides/decision-trees.md
  - rules/design-marketing-integration.md
---

# Media 케이스 (영상 / 모션 그래픽)

## 팀 구성 (4명)

| 역할 | 담당 | 에이전트 |
|------|------|---------|
| **Director** | 콘셉트, 스토리보드, 톤/타이밍, 시각 스타일 | 메인(opus) |
| **Motion Designer** | 인트로/아웃트로/Lower Third/타이틀 카드 | worker(sonnet) |
| **Implementer** | Remotion/FFmpeg 코드, 렌더링 | worker(sonnet) |
| **Sound Designer** | 오디오 트랙, 효과음, 자막 | worker(sonnet) |

## 파이프라인 (4-Stage)

### Stage 1: Concept (Director)
- **비전 정의**: 목적, 톤, 타겟
- **스토리보드**: 씬 단위 스케치 + 타이밍
- **시각 스타일**: 컬러 팔레트, 폰트, 무드
- **타이밍**: 인트로 3-5초, 섹션 전환 0.5-1초

### Stage 2: Design (Motion Designer)

**일관성 원칙:**
- 동일 컬러 스킴 / 폰트 / 애니메이션 스타일
- 간결한 텍스트
- **단순함 > 복잡함** (복잡한 모션은 주의 분산)

**인트로 (3-5초):**
- 브랜드 로고 + 타이틀 + 태그라인
- Staggered reveal (design-tokens + motion-guide 참조)
- 이징: 기본 `cubic-bezier(0.16, 1, 0.3, 1)`

**아웃트로:**
- CTA (구독/팔로우/링크)
- 브랜딩 강화 (로고 재노출)
- Next video / Playlist suggestion

**Lower Third:**
- **세이프존 내 배치** (하단 15% 피하기 — YouTube 진행바)
- 간결한 텍스트 (이름 + 직함, 최대 2줄)
- 배경 모양/반투명 바로 가독성 확보
- 브랜드 로고 포함 (선택)
- 애니메이션: 좌측 슬라이드인 (0.3-0.5초)

**타이틀 카드 (섹션 전환):**
- 0.5-1초 표시
- 배경 + 타이포 강조
- 다음 내용의 티저

### Stage 3: Implementation

**Remotion (React 기반 영상 생성):**
```tsx
// 경로: ~/workspace/content/video/remotion/
import { useCurrentFrame, interpolate } from 'remotion'

const frame = useCurrentFrame()
const opacity = interpolate(frame, [0, 30], [0, 1])
const y = interpolate(frame, [0, 30], [50, 0])
return <div style={{ opacity, transform: `translateY(${y}px)` }}>...</div>
```

- 명령어: `bun run dev` (스튜디오), `remotion render`
- Tailwind v4 @theme 연동 (`remotion.config.ts`)

**FFmpeg (후처리):**
- `video-editor` 스킬의 `ffmpeg-recipes.md` 참조
- YouTube 1080p: `libx264 -preset slow -crf 18`
- 쇼츠 크롭 (16:9 → 9:16): `crop=ih*9/16:ih`
- 자막 번인: subtitles 필터 + force_style

**Sound Designer (audio-processor 위임):**
- 오디오 추출/교체 (ffmpeg)
- 노이즈 감소 (`afftdn`)
- 볼륨 정규화 (`loudnorm`)
- Whisper 자막 생성 (large-v3-turbo 한국어 권장)

### Stage 4: QA

**기술 검증:**
- [ ] 프레임레이트 (영화 24fps / 일반 30fps / 게임 60fps)
- [ ] 코덱 (YouTube 1080p=H.264 CRF 18 / 4K=VP9)
- [ ] 해상도 (YouTube 1920x1080, 쇼츠 1080x1920)
- [ ] 파일 크기 (플랫폼 제한)
- [ ] 오디오 레벨 (-14 LUFS YouTube 표준)

**세이프존 검증:**
- [ ] Title-safe area (90% 중앙)
- [ ] Action-safe area (95% 중앙)
- [ ] 하단 15% 프로그레스바 피하기 (YouTube)
- [ ] 자막 위치 (중앙 하단, 세이프존 내)

**품질 검증:**
- [ ] 색상/폰트/애니메이션 일관성
- [ ] 오디오 품질 (노이즈, 클리핑)
- [ ] 자막 동기화
- [ ] 타이밍 (너무 빠르거나 느리지 않음)

## 플랫폼별 프리셋

### YouTube (가로)
- 1920x1080 (1080p) 또는 3840x2160 (4K)
- 16:9
- H.264 CRF 18
- -14 LUFS

### YouTube Shorts / Instagram Reels / TikTok (세로)
- 1080x1920
- 9:16
- H.264 CRF 18
- 60초 이하

### Instagram Feed (정사각형)
- 1080x1080
- 1:1
- 60초 이하

## 디렉토리 구조 (영상 프로젝트)

```
~/workspace/content/video/projects/YYYYMMDD_프로젝트명/
├── 01_footage/    (원본 영상)
├── 02_audio/      (오디오 파일)
├── 03_graphics/   (그래픽/이미지)
├── 04_project/    (편집 파일)
├── 05_exports/    (최종 출력)
├── 06_subtitles/  (자막)
└── 07_notes/      (작업 노트)
```

## 위임 스킬

- `video-editor` (ffmpeg 레시피 + 코덱 가이드)
- `audio-processor` (Whisper 자막 + 오디오 레시피)
- Remotion (React 기반 영상 생성) — `~/workspace/content/video/remotion/`
- `remotion-best-practices` 스킬

## 향후 템플릿 (Remotion Composition)

현재 `Composition.tsx`는 비어있음. 향후 구축할 템플릿:
1. 인트로 (로고 + 타이틀 + 태그라인)
2. 아웃트로 (CTA + 브랜딩)
3. Lower Third (이름 + 직함)
4. 타이틀 카드 (섹션 전환)
5. 제품 쇼케이스 (이미지 → 영상 변환)
6. SNS 광고 (쇼츠/릴스 사이즈)
