# 3-Tier Motion v2 — 2026-04


## Contents

- [Tier 정의](#tier-정의)
- [선택 규칙](#선택-규칙)
- [시그니처 이징 카탈로그](#시그니처-이징-카탈로그)
  - [Apple spring](#apple-spring)
  - [Vercel/Linear cubic-bezier](#vercellinear-cubic-bezier)
  - [Motion v12 spring preset](#motion-v12-spring-preset)
- [마이크로인터랙션 Top 5](#마이크로인터랙션-top-5)
  - [1. Scroll Parallax Hero (Tier 1)](#1-scroll-parallax-hero-tier-1)
  - [2. Form 반응성 (Tier 2)](#2-form-반응성-tier-2)
  - [3. View Transitions 페이지 전환 (Doc)](#3-view-transitions-페이지-전환-doc)
  - [4. Skeleton Pulse (Tier 1)](#4-skeleton-pulse-tier-1)
  - [5. CTA 호흡 (Tier 1)](#5-cta-호흡-tier-1)
- [prefers-reduced-motion 자동 폴백](#prefers-reduced-motion-자동-폴백)
- [번들 예산](#번들-예산)
- [성능 게이트 (Stage 5 연동)](#성능-게이트-stage-5-연동)
- [Anti-AI-slop](#anti-ai-slop)
- [UI Overlap 금지 규칙 (콘텐츠 가림 방지)](#ui-overlap-금지-규칙-콘텐츠-가림-방지)
  - [규칙](#규칙)
  - [금지 패턴](#금지-패턴)
  - [reviewer 체크 추가 항목](#reviewer-체크-추가-항목)
- [Maximum Motion 프리셋 (기본값)](#maximum-motion-프리셋-기본값)
  - [필수 포함 (최소 15개 기법)](#필수-포함-최소-15개-기법)
  - [자동 폴백 (항상)](#자동-폴백-항상)
  - [산출물 상단 주석 템플릿](#산출물-상단-주석-템플릿)
  - [제약](#제약)
- [변경 이력](#변경-이력)

> GSAP 3.13 무료화(Webflow 인수)·CSS `animation-timeline: scroll()` native·View Transitions API cross-doc MPA 지원 반영. 번들 예산 재정의(Tier 1 +10KB hard cap, Tier 3 lazy import 강제).

## Tier 정의

| Tier | 도구 | 사용 조건 | 번들 | 2026 업데이트 |
|------|------|---------|------|-------------|
| 1 | TailwindCSS Motion + CSS `animation-timeline: scroll()` | CSS만 가능 | ~5KB | Safari 26+/Chrome 115+ native |
| 2 | Motion v12 (motion/react) | 상태·제스처·레이아웃 | ~85KB | layoutAnchor, OKLCH 보간 |
| 3 | GSAP 3.13 + ScrollTrigger + Flip | 시네마틱 타임라인 | ~78KB | **100% 무료**, lazy 필수 |
| Bonus | Theatre.js | 복잡 시퀀스 프리프로덕션 | ~15KB | JSON 직렬화 |
| Doc | View Transitions API | MPA cross-doc | 0KB native | Chrome 126+/Safari 18.2+ |

## 선택 규칙

- CSS만 가능 → Tier 1
- 상태/제스처/레이아웃 → Tier 2
- 시네마틱 타임라인 → Tier 3 (lazy import)
- MPA 페이지 전환 → View Transitions API + fallback

## 시그니처 이징 카탈로그

### Apple spring
```
smooth  duration 0.5s bounce 0.0   → 표준
snappy  duration 0.3s bounce 0.3   → 버튼
bouncy  duration 0.4s bounce 0.6   → 카드 진입
```

### Vercel/Linear cubic-bezier
```
expo-out     cubic-bezier(0.16, 1, 0.3, 1)          ← 웹 표준 임팩트
ease-out     cubic-bezier(0.215, 0.61, 0.355, 1)    ← 진입
ease-in      cubic-bezier(0.55, 0.055, 0.675, 0.19) ← 퇴장
ease-in-out  cubic-bezier(0.645, 0.045, 0.355, 1)   ← 양방향
```

### Motion v12 spring preset
```
smooth  { stiffness: 300, damping: 30 }
bouncy  { stiffness: 400, damping: 10 }
```

## 마이크로인터랙션 Top 5

### 1. Scroll Parallax Hero (Tier 1)
```css
@supports (animation-timeline: scroll()) {
  .parallax-hero {
    animation: parallax-move linear both;
    animation-timeline: scroll(root);
    animation-range: 0% 50%;
  }
  @keyframes parallax-move { to { transform: translateY(-20%); } }
}
```

### 2. Form 반응성 (Tier 2)
```tsx
import { motion } from "motion/react";
<motion.label
  animate={focused ? { y: -24, scale: 0.85 } : {}}
  transition={{ duration: 0.25, ease: [0.16, 1, 0.3, 1] }}
/>
<motion.div animate={error ? { x: [-4, 4, -4, 0] } : {}} />
```

### 3. View Transitions 페이지 전환 (Doc)
```ts
export function isViewTransitionSupported(): boolean {
  return typeof document !== "undefined" && "startViewTransition" in document;
}
export function navigateWithTransition(cb: () => void): void {
  if (!isViewTransitionSupported()) { cb(); return; }
  (document as any).startViewTransition(cb);
}
```

### 4. Skeleton Pulse (Tier 1)
```css
.skeleton {
  background: linear-gradient(90deg,
    oklch(from var(--muted) l c h / 0.5) 0%,
    oklch(from var(--muted) calc(l * 1.1) c h) 50%,
    oklch(from var(--muted) l c h / 0.5) 100%);
  background-size: 200% 100%;
  animation: skeleton-pulse 1.5s ease-in-out infinite;
}
@keyframes skeleton-pulse {
  0% { background-position: 200% 0; }
  100% { background-position: -200% 0; }
}
```

### 5. CTA 호흡 (Tier 1)
```css
.cta { animation: cta-breathe 2.5s ease-in-out infinite; }
.cta:hover { animation-play-state: paused; }
@keyframes cta-breathe {
  0%, 100% { opacity: 1; transform: scale(1); }
  50% { opacity: 0.85; transform: scale(1.02); }
}
@media (prefers-reduced-motion: reduce) { .cta { animation: none; } }
```

## prefers-reduced-motion 자동 폴백

```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}
```

Motion v12: `useReducedMotion()` hook + 조건부 animate.

Playwright: `test.use({ reducedMotion: "reduce" })` 1개 테스트 필수.

## 번들 예산

- **Tier 1**: +10KB hard cap (polyfill 포함)
- **Tier 2**: 85KB, Route-level 코드 스플리팅
- **Tier 3**: 반드시 `await import("gsap")` lazy
- **Bonus**: Theatre.js 개발 환경만, production은 JSON 재생만

## 성능 게이트 (Stage 5 연동)

- `@next/bundle-analyzer`로 Tier별 delta 측정
- Lighthouse CI에서 LCP/INP/CLS 회귀 0
- Playwright reduced-motion 테스트 통과
- CrUX: Safari<26 + Firefox < 10% 확인 후 Tier 1 CSS scroll-driven 전면 도입

## Anti-AI-slop

- 보라 그라디언트 금지
- 무의미한 무한 루프 금지 (사용자 행동/스크롤/상태 연결 필수)
- 전체 페이지 parallax 금지 (LCP 악화)
- 자동 슬라이드쇼 Hero 금지
- 즉흥 cubic-bezier 금지 (카탈로그 우선)

## UI Overlap 금지 규칙 (콘텐츠 가림 방지)

**사용자 피드백 2026-04-14**: 섹션 네비 dots(sdots)가 본문 콘텐츠를 가리는 사례 발견. 전 산출물 공통 준수.

### 규칙
1. **Sticky/Fixed 요소는 viewport safe-area 준수**:
   - 우측 사이드 네비 → `right: max(16px, env(safe-area-inset-right))` + `max-width: 32px`
   - 본문 wrapper에 `padding-right: 48px` 강제 (사이드 네비 폭 + 여유)
2. **좌우 끝 3% 이내로 제한**: viewport 너비 97% 이상 영역만 fixed 요소 허용
3. **모바일(<768px)에서는 자동 숨김** 또는 하단 페이지네이션으로 전환:
   ```css
   @media (max-width: 767px) { .sdots, .side-nav { display: none; } }
   ```
4. **z-index는 9999 금지**: 최대 z-index 100, 레이어 테이블 명시
5. **pointer-events 격리**: 장식 오버레이는 `pointer-events: none` 기본
6. **CTA/본문과 overlap 자동 검증**: Playwright로 각 뷰포트(360/768/1280/1920) 스크린샷 + 본문 텍스트 가림 검사

### 금지 패턴
- 중앙 정렬 영역에 fixed 요소 배치
- 스크롤 시 본문 위로 뜨는 전체폭 배너
- Cookie 배너가 CTA 가림
- Chat 위젯이 우하단 CTA 가림
- Intercom/Crisp 우하단 → 모바일에서 footer CTA 충돌

### reviewer 체크 추가 항목
각 산출물에 대해:
- [ ] fixed/sticky 요소 좌우 여백 ≥16px
- [ ] 모바일 overlay 요소 숨김/축소
- [ ] Playwright 다중 뷰포트 overlap 테스트 통과

## Maximum Motion 프리셋 (기본값)

사용자 피드백(feedback_max_motion_default.md)에 따라 웹 산출물은 **기본으로 최대 모션 세트**를 적용한다. 사용자가 "간결/최소/기본"을 명시한 경우만 축소.

> **Full Catalog**: 52개 기법 전체 매핑은 `motion-techniques-full.md` 참조 (9 카테고리: Scroll-driven/Cinematic/Microinteractions/Page Transitions/WebGL-3D/SVG-Canvas/Typography/Gesture/AI-driven). Maximum Motion 프리셋은 카테고리당 2개 이상 필수 + 케이스 적합 기법 추가 = 최소 **28개 이상** 적용 목표 (기본 15개의 확장판).

### 필수 포함 (최소 15개 기법)

**Tier 1 (항상 포함, ~10KB 이내)**:
1. Scroll Parallax Hero (`animation-timeline: scroll()`)
2. Staggered Reveal (`animation-timeline: view()`)
3. Skeleton Pulse
4. CTA Breathe Pulse
5. Letter-by-letter Hero reveal (split text)
6. Slow zoom (ken burns)

**Tier 2 (상태·레이아웃 필요 시)**:
7. 3D tilt hover (perspective + mousemove)
8. Form label float + underline
9. Match cut 섹션 전환
10. Number counter rAF

**Tier 3 또는 CSS 대체 (시네마틱)**:
11. Gradient mesh 배경 (Canvas/CSS keyframes)
12. Parallax depth (3-layer)
13. Dissolve/crossfade

**View Transitions / Doc**:
14. Modal cross-fade + scale
15. Shared element transition (FLIP)

### 자동 폴백 (항상)

- `prefers-reduced-motion: reduce` → 0.01ms 모든 애니메이션
- JS 비활성 환경 → CSS only 폴백
- CSS `animation-timeline` 미지원 → IntersectionObserver

### 산출물 상단 주석 템플릿

```
/* Applied Motion Techniques (15+):
   Tier 1: parallax-hero, staggered-reveal, skeleton-pulse, breathe-pulse, letter-reveal, slow-zoom
   Tier 2: 3d-tilt, form-label-float, match-cut, counter-rAF
   Tier 3/CSS: gradient-mesh, parallax-depth, dissolve
   View Transitions: modal-crossfade, flip-shared
*/
```

### 제약

- Tier 1 번들 +10KB hard cap
- Tier 3 반드시 lazy import
- target-size 44×44 유지
- WCAG 2.2 focus-appearance 유지

## 변경 이력

- v2 (2026-04-13): 3-Tier 재정의, GSAP 무료화, View Transitions, CSS scroll-timeline native, 이징 카탈로그, Top 5 스니펫, 번들 예산
- v1: Tailwind Motion → Motion v12 → GSAP(상용)
