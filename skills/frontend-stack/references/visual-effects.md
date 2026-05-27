# Visual Effects CSS Reference


## Contents

- [1. Glassmorphism](#1-glassmorphism)
  - [기본 Glass 카드](#기본-glass-카드)
  - [Dark Glassmorphism (2026 트렌드)](#dark-glassmorphism-2026-트렌드)
  - [Tailwind 클래스](#tailwind-클래스)
  - [성능 규칙](#성능-규칙)
- [2. Grain / Noise 텍스처](#2-grain-noise-텍스처)
  - [SVG 필터 정의](#svg-필터-정의)
  - [CSS 적용](#css-적용)
  - [그라데이션 + 그레인 조합 (추천 패턴)](#그라데이션-그레인-조합-추천-패턴)
- [3. Gradient Mesh](#3-gradient-mesh)
  - [정적 Gradient Mesh](#정적-gradient-mesh)
  - [애니메이션 Gradient Mesh](#애니메이션-gradient-mesh)
- [4. 2026 트렌드](#4-2026-트렌드)
  - [Dark Glassmorphism](#dark-glassmorphism)
  - [Bento Grid (비대칭 레이아웃)](#bento-grid-비대칭-레이아웃)
  - [Variable Fonts (동적 가중치)](#variable-fonts-동적-가중치)
- [5. 케이스별 이펙트 추천](#5-케이스별-이펙트-추천)

복사-붙여넣기 가능한 CSS 이펙트 스니펫 모음 (2026 기준)

---

## 1. Glassmorphism

### 기본 Glass 카드

```css
/* 기본 유리 효과 */
.glass {
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.2);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
  border-radius: 16px;
}
```

### Dark Glassmorphism (2026 트렌드)

```css
/* 어두운 배경용 유리 효과 */
.glass-dark {
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
  background: rgba(0, 0, 0, 0.3);
  border: 1px solid rgba(255, 255, 255, 0.08);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.4);
  border-radius: 16px;
}
```

### Tailwind 클래스

```html
<!-- Light glass -->
<div class="backdrop-blur-md bg-white/10 border border-white/20 rounded-2xl shadow-lg">
</div>

<!-- Dark glass -->
<div class="backdrop-blur-md bg-black/30 border border-white/[0.08] rounded-2xl">
</div>
```

### 성능 규칙

```
- blur 범위: 8px ~ 15px 권장 (이하 효과 미약, 이상 성능 저하)
- 대면적(뷰포트 전체) 단독 사용 지양
- 동시 적용 요소 3개 이하로 최소화
- will-change: transform 으로 GPU 레이어 분리 권장
```

---

## 2. Grain / Noise 텍스처

### SVG 필터 정의

```html
<!-- body 최상단에 숨겨서 삽입 -->
<svg style="position:absolute;width:0;height:0">
  <filter id="noise">
    <feTurbulence
      type="fractalNoise"
      baseFrequency="0.65"
      numOctaves="3"
      stitchTiles="stitch"
    />
  </filter>
</svg>
```

### CSS 적용

```css
/* SVG 파일 방식 */
.grain {
  background: url('/noise.svg');
  mix-blend-mode: multiply;
  opacity: 0.15;
  pointer-events: none;
}

/* 인라인 SVG data URI 방식 (외부 파일 불필요) */
.grain-inline {
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.65' numOctaves='3' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)'/%3E%3C/svg%3E");
  mix-blend-mode: multiply;
  opacity: 0.15;
  pointer-events: none;
}
```

### 그라데이션 + 그레인 조합 (추천 패턴)

```css
/* 부모: isolation 설정 필수 */
.gradient-grain-wrapper {
  position: relative;
  isolation: isolate;
}

/* 레이어 1: 그라데이션 배경 */
.gradient-grain-wrapper::before {
  content: '';
  position: absolute;
  inset: 0;
  background: linear-gradient(135deg, oklch(0.6 0.2 250), oklch(0.4 0.15 320));
  z-index: 0;
}

/* 레이어 2: 노이즈 오버레이 */
.gradient-grain-wrapper::after {
  content: '';
  position: absolute;
  inset: 0;
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.65' numOctaves='3' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)'/%3E%3C/svg%3E");
  /* 고대비 그레인 효과 */
  filter: contrast(170%) brightness(1000%);
  mix-blend-mode: overlay;
  opacity: 0.06;
  z-index: 1;
}
```

---

## 3. Gradient Mesh

### 정적 Gradient Mesh

```css
/* oklch 색공간 사용 (더 균일한 채도) */
.gradient-mesh {
  background:
    radial-gradient(circle at 20% 30%, oklch(0.7 0.15 250 / 0.6), transparent 50%),
    radial-gradient(circle at 80% 70%, oklch(0.6 0.2 320 / 0.4), transparent 50%),
    radial-gradient(circle at 60% 20%, oklch(0.65 0.18 180 / 0.3), transparent 40%),
    oklch(0.15 0.01 280);
}
```

### 애니메이션 Gradient Mesh

```css
/* 각 그라데이션 레이어의 중심 위치를 이동 */
@keyframes mesh-shift-1 {
  0%   { background-position: 20% 30%; }
  50%  { background-position: 35% 50%; }
  100% { background-position: 20% 30%; }
}

@keyframes mesh-shift-2 {
  0%   { background-position: 80% 70%; }
  50%  { background-position: 65% 45%; }
  100% { background-position: 80% 70%; }
}

.gradient-mesh-animated {
  /* background-size 설정으로 position 이동 가능하게 */
  background:
    radial-gradient(circle, oklch(0.7 0.15 250 / 0.6), transparent 50%),
    radial-gradient(circle, oklch(0.6 0.2 320 / 0.4), transparent 50%),
    oklch(0.12 0.01 280);
  background-size: 60% 60%, 60% 60%, 100% 100%;
  background-repeat: no-repeat;
  background-position: 20% 30%, 80% 70%, 0 0;
  animation: mesh-float 8s ease-in-out infinite;
}

@keyframes mesh-float {
  0%, 100% { background-position: 20% 30%, 80% 70%, 0 0; }
  33%       { background-position: 50% 20%, 60% 80%, 0 0; }
  66%       { background-position: 30% 70%, 75% 30%, 0 0; }
}
```

---

## 4. 2026 트렌드

### Dark Glassmorphism

```css
/* 어두운 UI의 표준 카드 패턴 */
.card-2026 {
  background: rgba(10, 10, 15, 0.6);
  backdrop-filter: blur(20px) saturate(1.5);
  -webkit-backdrop-filter: blur(20px) saturate(1.5);
  border: 1px solid rgba(255, 255, 255, 0.06);
  box-shadow:
    0 0 0 1px rgba(255, 255, 255, 0.04) inset,
    0 16px 48px rgba(0, 0, 0, 0.5);
}
```

### Bento Grid (비대칭 레이아웃)

```css
/* 대시보드/포트폴리오용 벤토 그리드 */
.bento-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  grid-template-rows: auto;
  gap: 12px;
}

/* 각 셀 크기 조합 예시 */
.bento-wide   { grid-column: span 2; }
.bento-tall   { grid-row: span 2; }
.bento-large  { grid-column: span 2; grid-row: span 2; }
```

### Variable Fonts (동적 가중치)

```css
/* 폰트 로드 */
@font-face {
  font-family: 'Inter';
  src: url('/fonts/Inter-Variable.woff2') format('woff2-variations');
  font-weight: 100 900;
}

/* 커스텀 가중치 + 광학 크기 */
.headline-variable {
  font-family: 'Inter', sans-serif;
  font-variation-settings:
    'wght' 650,
    'opsz' 32;
}

/* 호버 시 가중치 애니메이션 */
.nav-link {
  font-variation-settings: 'wght' 400;
  transition: font-variation-settings 0.2s ease;
}
.nav-link:hover {
  font-variation-settings: 'wght' 700;
}
```

---

## 5. 케이스별 이펙트 추천

| 케이스 | 추천 이펙트 |
|--------|------------|
| Web 랜딩 | Glassmorphism + Gradient Mesh + Grain |
| 대시보드 | 미묘한 그림자 + 깔끔한 border |
| SNS 콘텐츠 | Bold Gradient + Grain overlay |
| 프레젠테이션 | Gradient Mesh 배경 + 깨끗한 타이포 |
| 영상 | Animated Gradient Mesh + Particle |
| 브랜딩 | Noise Texture + 미니멀 |
