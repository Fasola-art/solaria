# Web Motion Techniques Full Catalog — 52 기법


## Contents

- [Index (9 카테고리, 52 기법)](#index-9-카테고리-52-기법)
- [1. Scroll-driven (8)](#1-scroll-driven-8)
  - [1. 스크롤-비디오 연동 (Scroll-scrubbing Video)](#1-스크롤-비디오-연동-scroll-scrubbing-video)
  - [2. 이미지 프레임 시퀀스 (Frame Sequence Scrubbing)](#2-이미지-프레임-시퀀스-frame-sequence-scrubbing)
  - [3. 멀티레이어 패럴랙스 (Multi-layer Parallax)](#3-멀티레이어-패럴랙스-multi-layer-parallax)
  - [4. 핀드 섹션 (Pinned Sections / Sticky Scroll)](#4-핀드-섹션-pinned-sections-sticky-scroll)
  - [5. 수평 스크롤 하이재킹 (Horizontal Scroll Hijack)](#5-수평-스크롤-하이재킹-horizontal-scroll-hijack)
  - [6. 스크롤 트리거 리빌 (Scroll-triggered Reveal)](#6-스크롤-트리거-리빌-scroll-triggered-reveal)
  - [7. 읽기 진행 바 (Reading Progress Bar)](#7-읽기-진행-바-reading-progress-bar)
  - [8. 스크롤 연동 3D 카메라 (Scroll-linked 3D Camera)](#8-스크롤-연동-3d-카메라-scroll-linked-3d-camera)
- [2. Cinematic (7)](#2-cinematic-7)
  - [9. 이스태블리싱 샷 (Establishing Shot)](#9-이스태블리싱-샷-establishing-shot)
  - [10. 매치컷 전환 (Match Cut Transition)](#10-매치컷-전환-match-cut-transition)
  - [11. 디졸브 / 크로스페이드 (Dissolve / Crossfade)](#11-디졸브-크로스페이드-dissolve-crossfade)
  - [12. 슬로우 줌 켄번즈 (Slow Zoom / Ken Burns)](#12-슬로우-줌-켄번즈-slow-zoom-ken-burns)
  - [13. 3D 카메라 팬/틸트 (3D Camera Pan/Tilt)](#13-3d-카메라-팬틸트-3d-camera-pantilt)
  - [14. 포커스 풀 (Focus Pull / Blur Shift)](#14-포커스-풀-focus-pull-blur-shift)
  - [15. 스플릿 스크린 리빌 (Split Screen Reveal)](#15-스플릿-스크린-리빌-split-screen-reveal)
- [3. Microinteractions (8)](#3-microinteractions-8)
  - [16. 마그네틱 버튼 (Magnetic Button)](#16-마그네틱-버튼-magnetic-button)
  - [17. 3D 틸트 호버 (3D Tilt on Hover)](#17-3d-틸트-호버-3d-tilt-on-hover)
  - [18. 글자별 리빌 (Letter-by-letter Reveal / Split Text)](#18-글자별-리빌-letter-by-letter-reveal-split-text)
  - [19. 숫자 카운터 (Number Counter Animation)](#19-숫자-카운터-number-counter-animation)
  - [20. CTA 펄스/브리즈 (CTA Breathe / Pulse)](#20-cta-펄스브리즈-cta-breathe-pulse)
  - [21. 리플 효과 (Ripple Effect / Material)](#21-리플-효과-ripple-effect-material)
  - [22. 스켈레톤 로딩 (Skeleton Loading Pulse)](#22-스켈레톤-로딩-skeleton-loading-pulse)
  - [23. 옵티미스틱 UI (Optimistic UI Feedback)](#23-옵티미스틱-ui-optimistic-ui-feedback)
- [4. Page Transitions (5)](#4-page-transitions-5)
  - [24. View Transitions API SPA (SPA View Transitions)](#24-view-transitions-api-spa-spa-view-transitions)
  - [25. View Transitions API MPA (Cross-document View Transitions)](#25-view-transitions-api-mpa-cross-document-view-transitions)

> `~/workspace/reports/2026-04-13_web-motion-techniques-catalog.md` 기반. case-web.md Stage 4 Maximum Motion 프리셋 확장 소스.

---

## Index (9 카테고리, 52 기법)

1. Scroll-driven (8)
2. Cinematic (7)
3. Microinteractions (8)
4. Page Transitions (5)
5. WebGL/3D (6)
6. SVG/Canvas (5)
7. Typography (5)
8. Gesture/Physical (5)
9. AI-driven (3)

---

## 1. Scroll-driven (8)

### 1. 스크롤-비디오 연동 (Scroll-scrubbing Video)
- **카테고리**: Scroll-driven
- **Tier**: Tier 2
- **대표 사이트**: https://apple.com/iphone
- **구현**: `HTMLVideoElement.currentTime` + scroll event / GSAP ScrollTrigger
- **번들**: 없음 (native)
- **접근성**: `prefers-reduced-motion`: video.pause()
- **케이스 적합**: cinematic-product, hero-section

### 2. 이미지 프레임 시퀀스 (Frame Sequence Scrubbing)
- **카테고리**: Scroll-driven
- **Tier**: Tier 2
- **대표 사이트**: https://nike.com
- **구현**: WebP/AVIF 시퀀스 배열 + requestAnimationFrame, scroll progress 인덱스 매핑
- **번들**: 이미지 용량 주의 (레이지로드 필수)
- **접근성**: 대체 정지 이미지 제공
- **케이스 적합**: cinematic-product, storytelling

### 3. 멀티레이어 패럴랙스 (Multi-layer Parallax)
- **카테고리**: Scroll-driven
- **Tier**: Tier 2
- **대표 사이트**: https://stripe.com
- **구현**: CSS `transform: translateY()` + IntersectionObserver / GSAP ScrollTrigger
- **번들**: GSAP ~30KB
- **접근성**: `prefers-reduced-motion`: transform 제거
- **케이스 적합**: editorial, landing-page

### 4. 핀드 섹션 (Pinned Sections / Sticky Scroll)
- **카테고리**: Scroll-driven
- **Tier**: Tier 2
- **대표 사이트**: https://webflow.com
- **구현**: `position: sticky` + CSS `animation-timeline: scroll()` / GSAP pin
- **번들**: GSAP ~30KB
- **접근성**: 섹션 간 점프 링크 제공
- **케이스 적합**: feature-showcase, saas-dashboard

### 5. 수평 스크롤 하이재킹 (Horizontal Scroll Hijack)
- **카테고리**: Scroll-driven
- **Tier**: Tier 3
- **대표 사이트**: https://locomotive.ca
- **구현**: GSAP ScrollTrigger `horizontal: true` / Lenis + CSS
- **번들**: GSAP+Lenis ~50KB
- **접근성**: 키보드/스크린리더 대체 네비게이션 필수
- **케이스 적합**: portfolio, editorial, agency

### 6. 스크롤 트리거 리빌 (Scroll-triggered Reveal)
- **카테고리**: Scroll-driven
- **Tier**: Tier 1
- **대표 사이트**: https://vercel.com
- **구현**: CSS `animation-timeline: view()` (Chrome 115+, Safari 18+) / IO polyfill
- **번들**: 네이티브 CSS 0KB
- **접근성**: `prefers-reduced-motion`: opacity only
- **케이스 적합**: saas-dashboard, blog, landing-page

### 7. 읽기 진행 바 (Reading Progress Bar)
- **카테고리**: Scroll-driven
- **Tier**: Tier 1
- **대표 사이트**: 블로그/미디어 일반
- **구현**: CSS `animation-timeline: scroll(root)` + `scaleX`
- **번들**: 0KB (pure CSS)
- **접근성**: 숨김 처리 가능 (`hidden` 속성)
- **케이스 적합**: editorial, blog, documentation

### 8. 스크롤 연동 3D 카메라 (Scroll-linked 3D Camera)
- **카테고리**: Scroll-driven
- **Tier**: Tier 3
- **대표 사이트**: https://obys.agency
- **구현**: Three.js + GSAP ScrollTrigger + `camera.position` lerp
- **번들**: Three.js ~160KB
- **접근성**: 정지 대체 씬 제공
- **케이스 적합**: WebGL, agency, cinematic-product

> 브라우저 지원: `animation-timeline: scroll()/view()` — Chrome 115+, Edge 115+, Safari 18+, Firefox (플래그 해제 예정 2026 H2)

---

## 2. Cinematic (7)

### 9. 이스태블리싱 샷 (Establishing Shot)
- **카테고리**: Cinematic
- **Tier**: Tier 1
- **대표 사이트**: https://linear.app
- **구현**: CSS `scale(1.2→1.0)` + opacity 페이드 on load
- **번들**: 0KB
- **접근성**: `prefers-reduced-motion`: 즉시 표시
- **케이스 적합**: cinematic-product, saas-dashboard, hero-section

### 10. 매치컷 전환 (Match Cut Transition)
- **카테고리**: Cinematic
- **Tier**: Tier 2
- **대표 사이트**: https://basement.studio
- **구현**: View Transitions API `view-transition-name` + GSAP clip-path
- **번들**: VTA 네이티브 0KB
- **접근성**: 비활성 브라우저 단순 페이드 폴백
- **케이스 적합**: portfolio, editorial, agency

### 11. 디졸브 / 크로스페이드 (Dissolve / Crossfade)
- **카테고리**: Cinematic
- **Tier**: Tier 1
- **대표 사이트**: https://cargo.site
- **구현**: CSS `opacity` transition / View Transitions API
- **번들**: 0KB
- **접근성**: `prefers-reduced-motion`: 즉시 전환
- **케이스 적합**: portfolio, editorial, gallery

### 12. 슬로우 줌 켄번즈 (Slow Zoom / Ken Burns)
- **카테고리**: Cinematic
- **Tier**: Tier 1
- **대표 사이트**: 포트폴리오 사이트 다수
- **구현**: CSS `@keyframes` `scale(1.0→1.1)` 10-20s
- **번들**: 0KB
- **접근성**: `prefers-reduced-motion`: 고정
- **케이스 적합**: photography, editorial, hero-section

### 13. 3D 카메라 팬/틸트 (3D Camera Pan/Tilt)
- **카테고리**: Cinematic
- **Tier**: Tier 3
- **대표 사이트**: https://activetheory.net
- **구현**: Three.js `camera.lookAt()` lerp + GSAP
- **번들**: Three.js ~160KB
- **접근성**: 고정 씬 대체
- **케이스 적합**: WebGL, agency, cinematic-product

### 14. 포커스 풀 (Focus Pull / Blur Shift)
- **카테고리**: Cinematic
- **Tier**: Tier 2
- **대표 사이트**: https://figma.com 랜딩
- **구현**: CSS `filter: blur()` transition / `backdrop-filter`
- **번들**: 0KB (GPU 가속 주의)
- **접근성**: `prefers-reduced-motion`: blur 제거
- **케이스 적합**: saas-dashboard, modal, hero-section

### 15. 스플릿 스크린 리빌 (Split Screen Reveal)
- **카테고리**: Cinematic
- **Tier**: Tier 2
- **대표 사이트**: https://awwwards.com/websites/sites_of_the_day/
- **구현**: CSS `clip-path` 애니메이션 / GSAP `clipPath`
- **번들**: GSAP ~30KB
- **접근성**: 순차 표시 대체
- **케이스 적합**: agency, portfolio, landing-page

---

## 3. Microinteractions (8)

### 16. 마그네틱 버튼 (Magnetic Button)
- **카테고리**: Microinteractions
- **Tier**: Tier 2
- **대표 사이트**: https://locomotive.ca
- **구현**: `mousemove` delta → `translate(x, y)` + GSAP quickTo
- **번들**: GSAP ~30KB
- **접근성**: hover 불가 기기에서 비활성
- **케이스 적합**: agency, portfolio, CTA

### 17. 3D 틸트 호버 (3D Tilt on Hover)
- **카테고리**: Microinteractions
- **Tier**: Tier 2
- **대표 사이트**: https://tympanus.net/codrops
- **구현**: `rotateX/Y` + `perspective` + mouse position 정규화
- **번들**: VanillaJS ~2KB
- **접근성**: `hover:none` 미디어 쿼리로 비활성
- **케이스 적합**: card, product-card, portfolio

### 18. 글자별 리빌 (Letter-by-letter Reveal / Split Text)
- **카테고리**: Microinteractions
- **Tier**: Tier 2
- **대표 사이트**: https://hihello.me
- **구현**: GSAP SplitText / 자체 `span` 분리 + stagger
- **번들**: GSAP+SplitText ~35KB
- **접근성**: `aria-label` 원본 텍스트 유지
- **케이스 적합**: hero-text, editorial, agency

### 19. 숫자 카운터 (Number Counter Animation)
- **카테고리**: Microinteractions
- **Tier**: Tier 1
- **대표 사이트**: https://stripe.com 통계 섹션
- **구현**: `requestAnimationFrame` + easing 함수
- **번들**: VanillaJS ~1KB
- **접근성**: 최종값 즉시 표시 폴백
- **케이스 적합**: saas-dashboard, stats-section, landing-page

### 20. CTA 펄스/브리즈 (CTA Breathe / Pulse)
- **카테고리**: Microinteractions
- **Tier**: Tier 1
- **대표 사이트**: SaaS 랜딩 다수
- **구현**: CSS `@keyframes scale(1→1.05)` + `box-shadow`
- **번들**: 0KB
- **접근성**: `prefers-reduced-motion`: 정지
- **케이스 적합**: CTA, button, saas-dashboard

### 21. 리플 효과 (Ripple Effect / Material)
- **카테고리**: Microinteractions
- **Tier**: Tier 1
- **대표 사이트**: https://m3.material.io
- **구현**: `pointerdown` 좌표 → `transform: scale(0→2.5)` Circle
- **번들**: VanillaJS ~2KB
- **접근성**: focus-visible 링 병행 제공
- **케이스 적합**: button, card, interactive-element

### 22. 스켈레톤 로딩 (Skeleton Loading Pulse)
- **카테고리**: Microinteractions
- **Tier**: Tier 1
- **대표 사이트**: https://github.com, https://linkedin.com
- **구현**: CSS `@keyframes` gradient shimmer / `background-position`
- **번들**: 0KB
- **접근성**: `aria-busy="true"` + `aria-label`
- **케이스 적합**: saas-dashboard, feed, list-page

### 23. 옵티미스틱 UI (Optimistic UI Feedback)
- **카테고리**: Microinteractions
- **Tier**: Tier 2
- **대표 사이트**: https://vercel.com/dashboard
- **구현**: 상태 업데이트 즉시 반영 + 실패 시 롤백 애니메이션
- **번들**: 프레임워크 의존
- **접근성**: `aria-live="polite"` 상태 알림
- **케이스 적합**: saas-dashboard, form, interactive-app

---

## 4. Page Transitions (5)

### 24. View Transitions API SPA (SPA View Transitions)
- **카테고리**: Page Transitions
- **Tier**: Tier 1
- **대표 사이트**: https://nextjs.org (Next.js 15)
- **구현**: `document.startViewTransition()` + CSS `::view-transition` pseudo
- **번들**: 0KB (네이티브)
- **접근성**: `prefers-reduced-motion`: 즉시 전환
- **케이스 적합**: SPA, saas-dashboard, editorial

### 25. View Transitions API MPA (Cross-document View Transitions)
- **카테고리**: Page Transitions
- **Tier**: Tier 1
- **대표 사이트**: https://view-transitions.chrome.dev
- **구현**: `@view-transition { navigation: auto }` CSS only, JS 불필요
- **번들**: 0KB
- **접근성**: 모든 브라우저 폴백 지원 (단순 로드)
- **케이스 적합**: MPA, blog, documentation

### 26. 모핑 히어로 (Morphing Hero to Detail)
- **카테고리**: Page Transitions
- **Tier**: Tier 2
- **대표 사이트**: https://framer.com
- **구현**: `view-transition-name` 매핑 + VTA / Framer Motion `layoutId`
- **번들**: Framer Motion ~40KB
- **접근성**: 화면 흔들림 최소화
- **케이스 적합**: product-detail, portfolio, gallery

### 27. FLIP 공유 요소 전환 (Shared Element / FLIP)
- **카테고리**: Page Transitions
- **Tier**: Tier 2
- **대표 사이트**: https://motion.dev
- **구현**: Framer Motion `layoutId` / 수동 FLIP (getBoundingClientRect + invert)
- **번들**: Framer Motion ~40KB
- **접근성**: 이동 거리 최소 권고
- **케이스 적합**: list-to-detail, card-expand, saas-dashboard

### 28. 스와이프/제스처 전환 (Swipe/Gesture-based)
- **카테고리**: Page Transitions
- **Tier**: Tier 2
- **대표 사이트**: 모바일 웹앱 일반
- **구현**: `TouchEvent` / Pointer Events + `translate` + velocity 기반 snap
- **번들**: VanillaJS ~5KB
- **접근성**: 탭/버튼 대체 네비게이션 제공
- **케이스 적합**: mobile-app, PWA, gallery

### 29. 라우트 페이드/슬라이드 (Route-level Fade/Slide)
- **카테고리**: Page Transitions
- **Tier**: Tier 2
- **대표 사이트**: https://astro.build + Barba.js
- **구현**: Barba.js + GSAP / Astro View Transitions 내장
- **번들**: Barba+GSAP ~60KB
- **접근성**: 포커스 관리 필수 (새 페이지 상단 `focus()`)
- **케이스 적합**: MPA, blog, agency

> 브라우저 지원: Cross-document VTA — Chrome 126+, Edge 126+, Safari 18.2+, Firefox 133+

---

## 5. WebGL/3D (6)

### 30. 제품 회전 뷰어 (Three.js Product Rotation)
- **카테고리**: WebGL/3D
- **Tier**: WebGL
- **대표 사이트**: https://apple.com/apple-vision-pro
- **구현**: Three.js OrbitControls + GLTF loader
- **번들**: Three.js ~160KB
- **접근성**: 정지 이미지 대체 제공
- **케이스 적합**: cinematic-product, e-commerce, showcase

### 31. R3F 씬 통합 (React Three Fiber Scene)
- **카테고리**: WebGL/3D
- **Tier**: WebGL
- **대표 사이트**: https://lusion.co
- **구현**: `@react-three/fiber` + `@react-three/drei`
- **번들**: R3F ~200KB
- **접근성**: `aria-label` + canvas 대체 설명
- **케이스 적합**: agency, WebGL, interactive-experience

### 32. 셰이더 왜곡 (Shader Distortion / Noise/Glitch/Chromatic Aberration)
- **카테고리**: WebGL/3D
- **Tier**: WebGL
- **대표 사이트**: https://tympanus.net/codrops/2026/01/28/webgpu-gommage-effect-dissolving-msdf-text-into-dust-and-petals-with-three-js-tsl/
- **구현**: Three.js TSL (Three Shader Language) / GLSL fragment shader
- **번들**: Three.js + shader 코드
- **접근성**: `prefers-reduced-motion`: 셰이더 비활성
- **케이스 적합**: agency, WebGL, cinematic-product

### 33. 파티클 시스템 (Point Cloud / Particle System)
- **카테고리**: WebGL/3D
- **Tier**: WebGL
- **대표 사이트**: https://awwwards.com SOTD 다수
- **구현**: Three.js `Points` / WebGPU GPGPU compute shader (1M+ 파티클)
- **번들**: Three.js ~160KB + compute
- **접근성**: 데코레이션 표시 → `aria-hidden`
- **케이스 적합**: agency, hero-section, WebGL

### 34. GLTF 제품 쇼케이스 (GLTF Product Model Showcase)
- **카테고리**: WebGL/3D
- **Tier**: WebGL
- **대표 사이트**: https://shopify.com
- **구현**: Three.js GLTFLoader + Draco 압축 / `<model-viewer>` 웹컴포넌트
- **번들**: `<model-viewer>` ~100KB
- **접근성**: `alt` 텍스트, 키보드 회전 지원
- **케이스 적합**: e-commerce, product-showcase, cinematic-product

### 35. 포스트 프로세싱 (Post-processing / Bloom/DOF/SSAO)
- **카테고리**: WebGL/3D
- **Tier**: WebGL
- **대표 사이트**: https://activetheory.net
- **구현**: Three.js WebGPU `BloomNode` / `@react-three/postprocessing`
- **번들**: +50-80KB
- **접근성**: 저사양 기기 감지 후 비활성 (`deviceMemory` API)
- **케이스 적합**: WebGL, agency, cinematic-product

> 2026 업데이트: WebGPU 전 브라우저 지원 (Safari 26 포함), TSL로 WGSL/GLSL 통합 작성 가능

---

## 6. SVG/Canvas (5)

### 36. SVG 패스 모핑 (SVG Path Morph)
- **카테고리**: SVG/Canvas
- **Tier**: Tier 2
- **대표 사이트**: https://codepen.io
- **구현**: GSAP MorphSVGPlugin / flubber.js / CSS `d` property (Chrome 130+)
- **번들**: GSAP+MorphSVG ~40KB
- **접근성**: `aria-hidden` + 텍스트 설명 병행
- **케이스 적합**: logo-animation, icon, editorial

### 37. Lottie 애니메이션 (Lottie / AE Export)
- **카테고리**: SVG/Canvas
- **Tier**: Tier 2
- **대표 사이트**: https://airbnb.com, https://lottiefiles.com
- **구현**: `lottie-player` (SVG/Canvas 렌더러) / dotLottie 포맷
- **번들**: lottie-web ~60KB / dotLottie ~30KB
- **접근성**: `aria-label`, `role="img"`
- **케이스 적합**: icon, illustration, onboarding

### 38. Rive 상태 머신 (Rive / State Machine / Interactive)
- **카테고리**: SVG/Canvas
- **Tier**: Tier 2
- **대표 사이트**: https://rive.app
- **구현**: Rive runtime (~42KB) + `.riv` 파일, 제스처/hover/click 상태 연동
- **번들**: Rive ~42KB
- **접근성**: 키보드 트리거 가능한 입력 연결
- **케이스 적합**: interactive-illustration, game-ui, onboarding

### 39. SVG 필터 효과 (SVG Filter Effects / Displacement/Turbulence)
- **카테고리**: SVG/Canvas
- **Tier**: Tier 2
- **대표 사이트**: https://tympanus.net/codrops
- **구현**: `<feTurbulence>` + `<feDisplacementMap>` + `animate` 또는 JS
- **번들**: 0KB (인라인 SVG)
- **접근성**: 모션 민감성 주의
- **케이스 적합**: editorial, agency, art-direction

### 40. Canvas 제너러티브 아트 (Canvas Generative Art)
- **카테고리**: SVG/Canvas
- **Tier**: Tier 3
- **대표 사이트**: https://georgefrancis.dev
- **구현**: HTML5 Canvas 2D / p5.js / WebGPU compute
- **번들**: p5.js ~800KB (선택적) 또는 VanillaJS
- **접근성**: `aria-hidden` + 정지 이미지 대체
- **케이스 적합**: creative-coding, agency, hero-section

---

## 7. Typography (5)

### 41. 가변 폰트 축 애니메이션 (Variable Font Weight/Width Animation)
- **카테고리**: Typography
- **Tier**: Tier 1
- **대표 사이트**: https://v-fonts.com, https://fonts.google.com
- **구현**: CSS `font-variation-settings: "wght" 100→900` + `transition` / GSAP
- **번들**: 0KB (CSS transition)
- **접근성**: `prefers-reduced-motion`: 고정 weight
- **케이스 적합**: hero-text, editorial, saas-dashboard

### 42. 키네틱 타이포그래피 (Kinetic Typography)
- **카테고리**: Typography
- **Tier**: Tier 2
- **대표 사이트**: https://monotype.com, Awwwards SOTD
- **구현**: GSAP Timeline + SplitText / CSS `animation-timeline: view()`
- **번들**: GSAP ~30KB
- **접근성**: `aria-label` 원본 텍스트
- **케이스 적합**: editorial, agency, hero-section

### 43. 텍스트 마스크 리빌 (Text Mask Reveal)
- **카테고리**: Typography
- **Tier**: Tier 2
- **대표 사이트**: https://linear.app
- **구현**: CSS `clip-path: inset(100% 0 0 0)→inset(0%)` / GSAP fromTo
- **번들**: GSAP ~30KB
- **접근성**: 애니메이션 전 `visibility: hidden` 방지
- **케이스 적합**: hero-text, landing-page, editorial

### 44. 텍스트 셰이프 마스크 (Text as Shape / Clip Mask)
- **카테고리**: Typography
- **Tier**: Tier 1
- **대표 사이트**: https://basement.studio
- **구현**: CSS `background-clip: text` + 동영상/이미지 배경
- **번들**: 0KB
- **접근성**: `color` 대비 유지 필수
- **케이스 적합**: editorial, agency, hero-section

### 45. 마키 루프 (Marquee Seamless Loop)
- **카테고리**: Typography
- **Tier**: Tier 1
- **대표 사이트**: 에이전시 사이트 다수
- **구현**: CSS `@keyframes translateX` + `calc` / Framer Motion `animate`
- **번들**: 0KB ~ Framer ~40KB
- **접근성**: `prefers-reduced-motion`: 정지, `aria-hidden` 중복 콘텐츠
- **케이스 적합**: social-proof, agency, landing-page

### 46. 웨이브 텍스트 (Wave Text Animation)
- **카테고리**: Typography
- **Tier**: Tier 2
- **대표 사이트**: https://tympanus.net/codrops/2026/01/15/building-a-scroll-driven-dual-wave-text-animation-with-gsap/
- **구현**: GSAP + sin 함수 기반 stagger / SplitText
- **번들**: GSAP+SplitText ~35KB
- **접근성**: `prefers-reduced-motion` 조건 분기
- **케이스 적합**: editorial, agency, hero-section

---

## 8. Gesture/Physical (5)

### 47. 드래그 앤 드롭 물리 (Drag & Drop Physics)
- **카테고리**: Gesture/Physical
- **Tier**: Tier 2
- **대표 사이트**: https://linear.app, https://framer.com
- **구현**: Framer Motion `drag` + `dragConstraints` / React DnD
- **번들**: Framer Motion ~40KB
- **접근성**: 키보드 D&D 대체 (ARIA `aria-grabbed`)
- **케이스 적합**: kanban, saas-dashboard, project-management

### 48. 스와이프 카드 스택 (Swipe Card Stack)
- **카테고리**: Gesture/Physical
- **Tier**: Tier 2
- **대표 사이트**: Tinder-style UI 일반
- **구현**: Pointer Events + `translate` + velocity snap / `react-spring`
- **번들**: react-spring ~40KB
- **접근성**: 버튼 대체 액션 제공
- **케이스 적합**: mobile-app, PWA, onboarding

### 49. 핀치 줌 (Pinch Zoom)
- **카테고리**: Gesture/Physical
- **Tier**: Tier 2
- **대표 사이트**: 모바일 갤러리, 지도 일반
- **구현**: Pointer Events `pointerId` 다중 트래킹 + `scale()` / Hammer.js
- **번들**: VanillaJS / Hammer ~8KB
- **접근성**: 더블탭 확대 대체, 키보드 +/-
- **케이스 적합**: mobile-gallery, map, image-viewer

### 50. 스크롤 모멘텀 (Scroll Momentum / Lenis)
- **카테고리**: Gesture/Physical
- **Tier**: Tier 2
- **대표 사이트**: https://scroll.locomotive.ca
- **구현**: Lenis (`@studio-freight/lenis`) — 물리 기반 smooth scroll, GSAP ScrollTrigger 연동
- **번들**: Lenis ~8KB
- **접근성**: `prefers-reduced-motion`: Lenis `duration: 0`
- **케이스 적합**: agency, portfolio, editorial

### 51. 햅틱 피드백 (Haptic Feedback / Mobile Web)
- **카테고리**: Gesture/Physical
- **Tier**: Tier 2
- **대표 사이트**: PWA, 모바일 게임 일반
- **구현**: `navigator.vibrate([50])` / Vibration API (Android Chrome)
- **번들**: 0KB
- **접근성**: iOS 미지원, progressive enhancement
- **케이스 적합**: mobile-app, PWA, game-ui

---

## 9. AI-driven (3)

### 52. 개인화 애니메이션 타이밍 (Personalized Animation Timing / RUM-based)
- **카테고리**: AI-driven
- **Tier**: Tier 3 (Doc)
- **대표 사이트**: 대형 커머스 실험적 적용
- **구현**: RUM 데이터(FID/INP) → 사용자 기기 성능 기반 duration 조정, `navigator.deviceMemory` + `navigator.hardwareConcurrency` 활용
- **번들**: 서버 로직 의존
- **접근성**: 저성능 기기 `prefers-reduced-motion` 강제
- **케이스 적합**: performance-optimization, e-commerce, large-scale

### 53. AI 생성 히어로 영상 (AI-generated Hero / Remotion SSR)
- **카테고리**: AI-driven
- **Tier**: Tier 3
- **대표 사이트**: https://remotion.dev/docs/ai/
- **구현**: Remotion + Claude Code 자동 생성 → Lambda SSR 렌더링 → CDN 배포
- **번들**: Remotion 렌더 서버
- **접근성**: 자막/텍스트 대체 필수
- **케이스 적합**: content-automation, hero-section, editorial

### 54. 시선 추적 a11y (Gaze-tracking for Accessibility)
- **카테고리**: AI-driven
- **Tier**: Doc
- **대표 사이트**: 연구/실험 단계
- **구현**: WebGazer.js / Eye Tracking API (비표준) → 포커스 자동 이동
- **번들**: WebGazer ~2MB
- **접근성**: 폴백 완전 제공 필수 (미지원 기기 대다수)
- **케이스 적합**: accessibility-research, experimental

---

## Maximum Motion 프리셋 (기본)

카테고리당 2개씩 필수 18개 + 선택 10개 = 최소 28개 적용 목표. 15+ 기본 준수.

| 카테고리 | 필수 #1 | 필수 #2 |
|----------|---------|---------|
| Scroll-driven | 6. 스크롤 트리거 리빌 | 4. 핀드 섹션 |
| Cinematic | 9. 이스태블리싱 샷 | 15. 스플릿 스크린 리빌 |
| Microinteractions | 22. 스켈레톤 로딩 | 19. 숫자 카운터 |
| Page Transitions | 24. View Transitions API SPA | 27. FLIP 공유 요소 전환 |
| WebGL/3D | 30. 제품 회전 뷰어 | 33. 파티클 시스템 |
| SVG/Canvas | 37. Lottie 애니메이션 | 38. Rive 상태 머신 |
| Typography | 41. 가변 폰트 축 애니메이션 | 45. 마키 루프 |
| Gesture/Physical | 50. 스크롤 모멘텀 | 47. 드래그 앤 드롭 물리 |
| AI-driven | 52. 개인화 애니메이션 타이밍 | 53. AI 생성 히어로 영상 |

---

## Tier 정의

| Tier | 설명 |
|------|------|
| Tier 1 | CSS 네이티브, 0~최소 JS, 즉시 프로덕션 적용 가능 |
| Tier 2 | 경량 라이브러리 (GSAP/Framer/Lenis), 번들 예산 관리 필요 |
| Tier 3 | WebGL/Three.js/R3F, 고성능 요구, 폴백 전략 필수 |
| Doc | 실험적/문서화 단계, 프로덕션 적용 전 검토 필요 |
| WebGL | Three.js/R3F 전용 (별도 분류, Tier 3 상위 호환) |

---

## 접근성 공통

- `prefers-reduced-motion` 미디어 쿼리 전 기법 필수 처리
- target-size 44x44px (interactive element)
- WCAG 2.2 기준 준수
- Tier 1 기법 +10KB 번들 cap
- 스크린리더 대체 텍스트: `aria-label`, `aria-hidden`, `aria-live`
- 포커스 관리: 페이지 전환 시 상단 `focus()` 필수
- 저사양 기기: `navigator.deviceMemory` 감지 후 WebGL/Tier 3 비활성

---

## 변경 이력

- v1 (2026-04-13): 52 기법 전체 통합 (원본 카탈로그 기준)
