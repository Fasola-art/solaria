# Design Tokens Reference


## Contents

- [1. OKLCH 컬러 시스템](#1-oklch-컬러-시스템)
  - [1-1. Base 레이어 — OKLCH 원시값](#1-1-base-레이어-oklch-원시값)
  - [1-2. Semantic 레이어 — 역할 기반 (라이트 모드 기본)](#1-2-semantic-레이어-역할-기반-라이트-모드-기본)
  - [1-3. Component 레이어 — 컴포넌트별 로컬 변수](#1-3-component-레이어-컴포넌트별-로컬-변수)
  - [1-4. 상태 변환 — Relative Color Syntax](#1-4-상태-변환-relative-color-syntax)
  - [1-5. P3 와이드 가멋 — 채도 증가](#1-5-p3-와이드-가멋-채도-증가)
  - [1-6. 접근성 기준](#1-6-접근성-기준)
- [2. 타이포그래피 시스템](#2-타이포그래피-시스템)
  - [2-1. 모듈러 스케일 — Major Third (×1.25)](#2-1-모듈러-스케일-major-third-125)
  - [2-2. 타입 계층 정의](#2-2-타입-계층-정의)
  - [2-3. 타입 스타일 적용 예](#2-3-타입-스타일-적용-예)
- [3. 스페이싱 시스템](#3-스페이싱-시스템)
  - [3-1. 8px 그리드 토큰](#3-1-8px-그리드-토큰)
  - [3-2. Gestalt 근접 원칙 적용 규칙](#3-2-gestalt-근접-원칙-적용-규칙)
- [4. Tailwind v4 @theme 통합](#4-tailwind-v4-theme-통합)
  - [4-1. 단일 @theme 블록 — 모든 토큰 통합](#4-1-단일-theme-블록-모든-토큰-통합)
  - [4-2. 순수 CSS 변수 시스템 (Tailwind 없이 사용)](#4-2-순수-css-변수-시스템-tailwind-없이-사용)
- [5. DTCG 2025.10 Stable 포맷 (W3C)](#5-dtcg-202510-stable-포맷-w3c)
  - [5-1. $value / $type / alias 구조](#5-1-value-type-alias-구조)
  - [5-2. theming / multi-brand 지원](#5-2-theming-multi-brand-지원)
  - [5-3. 10개+ 도구 호환 현황](#5-3-10개-도구-호환-현황)
- [6. CSS Relative Color Syntax](#6-css-relative-color-syntax)
  - [6-1. 핵심 패턴](#6-1-핵심-패턴)
  - [6-2. 토큰 수 감소 효과](#6-2-토큰-수-감소-효과)
  - [6-3. 폴백](#6-3-폴백)
- [7. Style Dictionary 6 + Tokens Studio Git Sync 파이프라인](#7-style-dictionary-6-tokens-studio-git-sync-파이프라인)
- [8. Tailwind v4 @theme 통합 (CSS 변수 자동 노출)](#8-tailwind-v4-theme-통합-css-변수-자동-노출)
- [9. Figma Variables <-> 코드 동기화 워크플로우](#9-figma-variables---코드-동기화-워크플로우)
- [참고: 브라우저 지원 기준](#참고-브라우저-지원-기준)

> OKLCH 컬러, 타이포그래피, 스페이싱의 3계층 토큰 시스템 + Tailwind v4 통합

---

## 1. OKLCH 컬러 시스템

### 1-1. Base 레이어 — OKLCH 원시값

```css
/* 원시 팔레트: 외부에서 직접 참조 금지 — Semantic 레이어를 통해서만 사용 */
:root {
  /* Primary (blue ~220) */
  --base-primary-100: oklch(0.95 0.03 220);
  --base-primary-300: oklch(0.80 0.10 220);
  --base-primary-500: oklch(0.58 0.22 220);
  --base-primary-700: oklch(0.40 0.18 220);
  --base-primary-900: oklch(0.22 0.10 220);

  /* Secondary (purple ~320) */
  --base-secondary-100: oklch(0.95 0.03 320);
  --base-secondary-500: oklch(0.55 0.20 320);
  --base-secondary-900: oklch(0.22 0.09 320);

  /* Neutral */
  --base-neutral-0:   oklch(1.00 0.00 0);
  --base-neutral-100: oklch(0.97 0.00 0);
  --base-neutral-200: oklch(0.93 0.00 0);
  --base-neutral-400: oklch(0.72 0.00 0);
  --base-neutral-600: oklch(0.50 0.00 0);
  --base-neutral-800: oklch(0.28 0.00 0);
  --base-neutral-950: oklch(0.10 0.00 0);

  /* Accent (yellow ~90) */
  --base-accent-400: oklch(0.88 0.18 90);
  --base-accent-600: oklch(0.68 0.20 90);

  /* Status — green ~140 / red ~20 */
  --base-success-500: oklch(0.58 0.18 140);
  --base-error-500:   oklch(0.55 0.22 20);
  --base-warning-500: oklch(0.75 0.18 70);
  --base-info-500:    oklch(0.60 0.18 240);
}
```

### 1-2. Semantic 레이어 — 역할 기반 (라이트 모드 기본)

```css
/* 역할 기반 변수: 이 레이어만 다크 모드에서 오버라이드 */
:root {
  /* 배경/전경 */
  --color-background:         var(--base-neutral-0);
  --color-background-subtle:  var(--base-neutral-100);
  --color-foreground:         var(--base-neutral-950);

  /* 액션 */
  --color-action-primary:     var(--base-primary-500);
  --color-action-secondary:   var(--base-secondary-500);
  --color-action-accent:      var(--base-accent-600);

  /* 테두리 */
  --color-border:             var(--base-neutral-200);
  --color-border-strong:      var(--base-neutral-400);

  /* 텍스트 */
  --text-primary:             var(--base-neutral-950);
  --text-secondary:           var(--base-neutral-600);
  --text-muted:               var(--base-neutral-400);
  --text-on-action:           var(--base-neutral-0);

  /* 상태 */
  --color-success:            var(--base-success-500);
  --color-error:              var(--base-error-500);
  --color-warning:            var(--base-warning-500);
  --color-info:               var(--base-info-500);
}

/* 다크 모드: Semantic 레이어만 오버라이드 — Base는 그대로 유지 */
@media (prefers-color-scheme: dark) {
  :root {
    --color-background:         var(--base-neutral-950);
    --color-background-subtle:  var(--base-neutral-800);
    --color-foreground:         var(--base-neutral-0);

    --color-action-primary:     var(--base-primary-300);
    --color-action-secondary:   var(--base-secondary-100);

    --color-border:             var(--base-neutral-800);
    --color-border-strong:      var(--base-neutral-600);

    --text-primary:             var(--base-neutral-0);
    --text-secondary:           var(--base-neutral-400);
    --text-muted:               var(--base-neutral-600);
  }
}
```

### 1-3. Component 레이어 — 컴포넌트별 로컬 변수

```css
/* 컴포넌트는 Semantic 레이어를 지역 변수로 매핑 — Base 직접 참조 금지 */
.btn {
  --btn-bg:      var(--color-action-primary);
  --btn-text:    var(--text-on-action);
  --btn-border:  transparent;
  --btn-radius:  0.375rem;

  background: var(--btn-bg);
  color:      var(--btn-text);
  border:     1px solid var(--btn-border);
  border-radius: var(--btn-radius);
}

.btn--secondary {
  --btn-bg:     transparent;
  --btn-text:   var(--color-action-primary);
  --btn-border: var(--color-action-primary);
}

.card {
  --card-bg:     var(--color-background-subtle);
  --card-border: var(--color-border);

  background:    var(--card-bg);
  border:        1px solid var(--card-border);
}
```

### 1-4. 상태 변환 — Relative Color Syntax

```css
/* CSS Level 5 Relative Color: 베이스 색상에서 파생 */
.btn:hover {
  /* 밝기 +0.08 올려 hover 표현 */
  background: oklch(from var(--btn-bg) calc(l + 0.08) c h);
}

.btn:active {
  /* 밝기 -0.06, 채도 +0.03 */
  background: oklch(from var(--btn-bg) calc(l - 0.06) calc(c + 0.03) h);
}

.btn:disabled {
  /* 채도 제거, 밝기 중립화 */
  background: oklch(from var(--btn-bg) 0.72 0 0);
  cursor: not-allowed;
}
```

### 1-5. P3 와이드 가멋 — 채도 증가

```css
/* P3 디스플레이에서 더 선명한 색상 제공 */
@media (color-gamut: p3) {
  :root {
    --base-primary-500: oklch(0.58 0.28 220); /* chroma 0.22 → 0.28 */
    --base-success-500: oklch(0.58 0.24 140); /* chroma 0.18 → 0.24 */
    --base-error-500:   oklch(0.55 0.30 20);  /* chroma 0.22 → 0.30 */
  }
}
```

### 1-6. 접근성 기준

```
L(Lightness) ≥ 0.87 → 검정 텍스트(oklch 0.10) 안전
L(Lightness) < 0.50 → 흰 텍스트(oklch 1.00) 안전

배경이 --base-primary-100(L=0.95) → 검정 텍스트 사용
배경이 --base-primary-500(L=0.58) → 흰 텍스트 사용
배경이 --base-primary-700(L=0.40) → 흰 텍스트 사용
```

---

## 2. 타이포그래피 시스템

### 2-1. 모듈러 스케일 — Major Third (×1.25)

```
Base 16px 기준 × 1.25 누적 곱:
  Caption:  12px  (16 / 1.25 / 1.07 ≈ 12)
  Small:    14px
  Body:     16px  ← 기준
  H3:       20px  (16 × 1.25)
  H2:       25px  (16 × 1.25²)
  H1:       31px  (16 × 1.25³)
  Display:  39px  (16 × 1.25⁴)
  Hero:     49px  (16 × 1.25⁵)
```

### 2-2. 타입 계층 정의

```css
:root {
  /* 폰트 패밀리: 최대 2-3개 */
  --font-display: 'Pretendard Variable', 'Inter', system-ui, sans-serif;
  --font-body:    'Pretendard Variable', 'Inter', system-ui, sans-serif;
  --font-mono:    'JetBrains Mono', 'Fira Code', monospace;

  /* 고정 스케일 */
  --text-caption:  0.75rem;  /* 12px */
  --text-small:    0.875rem; /* 14px */
  --text-body:     1rem;     /* 16px */
  --text-h3:       1.25rem;  /* 20px */
  --text-h2:       1.563rem; /* 25px */
  --text-h1:       1.953rem; /* 31px */
  --text-display:  2.441rem; /* 39px */
  --text-hero:     3.052rem; /* 49px */

  /* 반응형 유동 타입 */
  --text-h1-fluid:      clamp(1.953rem, 1.5rem + 2vw, 2.441rem);
  --text-display-fluid: clamp(2.441rem, 1.8rem + 3vw, 3.052rem);

  /* Line Height */
  --leading-none:    1.0;   /* Display/Hero */
  --leading-tight:   1.2;   /* H1, H2 */
  --leading-snug:    1.3;   /* H3 */
  --leading-normal:  1.5;   /* Body */
  --leading-relaxed: 1.6;   /* Body 여유 */
  --leading-loose:   1.8;   /* Small, Caption */

  /* Letter Spacing */
  --tracking-tight:   -0.04em; /* 대형 Display */
  --tracking-snug:    -0.02em; /* H1~H2 */
  --tracking-normal:   0em;    /* Body */
  --tracking-wide:    +0.05em; /* 소형 UI 레이블 */
  --tracking-wider:   +0.10em; /* ALL CAPS */
  --tracking-widest:  +0.15em; /* ALL CAPS 강조 */

  /* Measure (최적 읽기 너비) */
  --measure-body: 65ch;
  --measure-wide:  80ch;
}
```

### 2-3. 타입 스타일 적용 예

```css
.text-display {
  font-family:    var(--font-display);
  font-size:      var(--text-display-fluid);
  line-height:    var(--leading-none);
  letter-spacing: var(--tracking-tight);
  font-weight: 700;
}

.text-h1 {
  font-size:      var(--text-h1-fluid);
  line-height:    var(--leading-tight);
  letter-spacing: var(--tracking-snug);
  font-weight: 600;
}

.text-body {
  font-family: var(--font-body);
  font-size:   var(--text-body);
  line-height: var(--leading-normal);
  max-width:   var(--measure-body);
}

.text-label-caps {
  font-size:      var(--text-small);
  letter-spacing: var(--tracking-wider);
  text-transform: uppercase;
  font-weight: 600;
}
```

---

## 3. 스페이싱 시스템

### 3-1. 8px 그리드 토큰

```css
:root {
  /* 기본 단위 */
  --space-0: 0px;
  --space-px: 1px;         /* hairline 구분선 */

  /* 4px — 타이포그래피 미세 조정 전용 */
  --space-0-5: 0.25rem;    /* 4px  */

  /* 8px 그리드 */
  --space-xs:  0.5rem;     /* 8px  — XS  */
  --space-s:   0.75rem;    /* 12px — 중간 */
  --space-m:   1rem;       /* 16px — M   */
  --space-l:   1.5rem;     /* 24px — L   */
  --space-xl:  2rem;       /* 32px — XL  */
  --space-2xl: 3rem;       /* 48px — 2XL */
  --space-3xl: 4rem;       /* 64px — 3XL */
  --space-4xl: 6rem;       /* 96px — 섹션 간격 */
  --space-5xl: 8rem;       /* 128px — 페이지 여백 */
}
```

### 3-2. Gestalt 근접 원칙 적용 규칙

```
규칙: 내부 간격 ≤ 외부(컨테이너) 간격

카드 내부 패딩:     --space-m (16px)
카드 간 갭:         --space-l (24px)  ← 내부보다 큼

버튼 내부 패딩:     0.5rem 1rem
버튼 그룹 간 갭:    --space-xs (8px)

레이블 → 입력 간:  --space-0-5 (4px)  ← 강한 연관
입력 → 다음 입력:  --space-m (16px)

섹션 헤딩 → 본문:  --space-xs (8px)
섹션 간 여백:       --space-3xl (64px)
```

---

## 4. Tailwind v4 @theme 통합

### 4-1. 단일 @theme 블록 — 모든 토큰 통합

```css
/* styles/tokens.css — 진입점, 이 파일 하나로 모든 토큰 관리 */
@import "tailwindcss";

@theme {
  /* ── 컬러 ─────────────────────────────────── */
  --color-background:        oklch(1.00 0.00 0);
  --color-background-subtle: oklch(0.97 0.00 0);
  --color-foreground:        oklch(0.10 0.00 0);
  --color-action-primary:    oklch(0.58 0.22 220);
  --color-action-secondary:  oklch(0.55 0.20 320);
  --color-border:            oklch(0.93 0.00 0);
  --color-border-strong:     oklch(0.72 0.00 0);
  --color-success:           oklch(0.58 0.18 140);
  --color-error:             oklch(0.55 0.22 20);
  --color-warning:           oklch(0.75 0.18 70);
  --color-info:              oklch(0.60 0.18 240);

  /* ── 폰트 패밀리 ─────────────────────────── */
  --font-family-display: 'Pretendard Variable', 'Inter', system-ui, sans-serif;
  --font-family-body:    'Pretendard Variable', 'Inter', system-ui, sans-serif;
  --font-family-mono:    'JetBrains Mono', monospace;

  /* ── 폰트 크기 ───────────────────────────── */
  --font-size-caption: 0.75rem;
  --font-size-small:   0.875rem;
  --font-size-base:    1rem;
  --font-size-h3:      1.25rem;
  --font-size-h2:      1.563rem;
  --font-size-h1:      clamp(1.953rem, 1.5rem + 2vw, 2.441rem);
  --font-size-display: clamp(2.441rem, 1.8rem + 3vw, 3.052rem);

  /* ── Line Height ─────────────────────────── */
  --line-height-none:    1;
  --line-height-tight:   1.2;
  --line-height-snug:    1.3;
  --line-height-normal:  1.5;
  --line-height-relaxed: 1.6;
  --line-height-loose:   1.8;

  /* ── Letter Spacing ──────────────────────── */
  --letter-spacing-tighter: -0.04em;
  --letter-spacing-tight:   -0.02em;
  --letter-spacing-normal:   0em;
  --letter-spacing-wide:     0.05em;
  --letter-spacing-wider:    0.10em;
  --letter-spacing-widest:   0.15em;

  /* ── 스페이싱 ────────────────────────────── */
  --spacing-0-5: 0.25rem;  /* 4px  */
  --spacing-1:   0.5rem;   /* 8px  */
  --spacing-2:   0.75rem;  /* 12px */
  --spacing-3:   1rem;     /* 16px */
  --spacing-4:   1.5rem;   /* 24px */
  --spacing-5:   2rem;     /* 32px */
  --spacing-6:   3rem;     /* 48px */
  --spacing-7:   4rem;     /* 64px */
  --spacing-8:   6rem;     /* 96px */
  --spacing-9:   8rem;     /* 128px */
}

/* 다크 모드: Semantic 컬러만 오버라이드 */
@media (prefers-color-scheme: dark) {
  @theme {
    --color-background:        oklch(0.10 0.00 0);
    --color-background-subtle: oklch(0.28 0.00 0);
    --color-foreground:        oklch(1.00 0.00 0);
    --color-action-primary:    oklch(0.80 0.10 220);
    --color-action-secondary:  oklch(0.95 0.03 320);
    --color-border:            oklch(0.28 0.00 0);
    --color-border-strong:     oklch(0.50 0.00 0);
  }
}
```

### 4-2. 순수 CSS 변수 시스템 (Tailwind 없이 사용)

```css
/* 비웹 환경 또는 Tailwind 미사용 시 독립 동작 가능 */
/* styles/tokens-standalone.css */

:root {
  /* 컬러 */
  --color-background:        oklch(1.00 0.00 0);
  --color-background-subtle: oklch(0.97 0.00 0);
  --color-foreground:        oklch(0.10 0.00 0);
  --color-action-primary:    oklch(0.58 0.22 220);
  --color-action-secondary:  oklch(0.55 0.20 320);
  --color-border:            oklch(0.93 0.00 0);
  --text-primary:            oklch(0.10 0.00 0);
  --text-secondary:          oklch(0.50 0.00 0);
  --text-muted:              oklch(0.72 0.00 0);
  --text-on-action:          oklch(1.00 0.00 0);
  --color-success:           oklch(0.58 0.18 140);
  --color-error:             oklch(0.55 0.22 20);
  --color-warning:           oklch(0.75 0.18 70);

  /* 타이포그래피 */
  --font-display: 'Pretendard Variable', 'Inter', system-ui, sans-serif;
  --font-body:    'Pretendard Variable', 'Inter', system-ui, sans-serif;
  --font-mono:    'JetBrains Mono', monospace;
  --text-base:    1rem;
  --text-h3:      1.25rem;
  --text-h2:      1.563rem;
  --text-h1:      clamp(1.953rem, 1.5rem + 2vw, 2.441rem);
  --text-display: clamp(2.441rem, 1.8rem + 3vw, 3.052rem);
  --leading-normal:  1.5;
  --leading-tight:   1.2;

  /* 스페이싱 */
  --space-xs:  0.5rem;
  --space-s:   0.75rem;
  --space-m:   1rem;
  --space-l:   1.5rem;
  --space-xl:  2rem;
  --space-2xl: 3rem;
  --space-3xl: 4rem;
}

/* JS 런타임 테마 전환 예시 */
/* document.documentElement.style.setProperty('--color-action-primary', 'oklch(0.65 0.25 150)') */
```

---

## 5. DTCG 2025.10 Stable 포맷 (W3C)

### 5-1. $value / $type / alias 구조

```json
{
  "color": {
    "brand": {
      "primary": {
        "$value": "oklch(0.58 0.22 220)",
        "$type": "color",
        "$description": "Primary brand color - blue"
      },
      "primary-hover": {
        "$value": "{color.brand.primary}",
        "$type": "color",
        "$description": "alias - relative color은 CSS에서 파생"
      }
    },
    "semantic": {
      "action": { "$value": "{color.brand.primary}", "$type": "color" }
    }
  },
  "spacing": {
    "m": { "$value": "1rem", "$type": "dimension" }
  }
}
```

규칙:
- $value: 실제값 또는 {path.to.token} alias 참조
- $type: color / dimension / fontFamily / fontWeight / duration / cubicBezier
- alias는 반드시 동일 $type 토큰만 참조

### 5-2. theming / multi-brand 지원

```json
{
  "brand-a": { "color": { "primary": { "$value": "oklch(0.58 0.22 220)", "$type": "color" } } },
  "brand-b": { "color": { "primary": { "$value": "oklch(0.55 0.20 140)", "$type": "color" } } }
}
```

### 5-3. 10개+ 도구 호환 현황

```
Figma Variables    - 2024년부터 DTCG import/export 지원
Tokens Studio      - Figma 플러그인, Git two-way sync (섹션 7 참조)
Style Dictionary 6 - DTCG 네이티브 파싱, 다중 플랫폼 변환 (섹션 7 참조)
Supernova          - 디자인 시스템 문서화 + 코드 생성
Theo (Primer)      - GitHub 내부 사용, DTCG 기반
Cobalt UI          - 오픈소스 DTCG 빌드 툴
Diez               - 크로스플랫폼 (iOS/Android/Web)
Specify            - 디자인 에셋 + 토큰 자동화
Zeroheight         - 문서화 + DTCG 렌더링
Amazon Style Dict  - AWS 내부, DTCG 채택
```

---

## 6. CSS Relative Color Syntax

### 6-1. 핵심 패턴

```css
/* 브랜드 베이스에서 상태별 색상 자동 파생 - 추가 토큰 불필요 */
.btn:hover {
  background: oklch(from var(--color-action-primary) calc(l * 0.9) c h);
}
.btn:active {
  background: oklch(from var(--color-action-primary) calc(l * 0.85) calc(c * 1.05) h);
}
/* 다크모드 자동 파생 */
.surface-muted {
  background: oklch(from var(--color-background) calc(l * 0.95) c h);
}
/* muted 텍스트 자동 파생 */
.text-muted {
  color: oklch(from var(--text-primary) calc(l * 1.4) calc(c * 0.5) h);
}
```

### 6-2. 토큰 수 감소 효과

```
기존: color-primary / color-primary-hover / color-primary-active / color-primary-disabled = 4개+
신규: color-primary 1개 + CSS 계산식 파생

결과: 토큰 수 70%+ 감소, 브랜드 변경 시 단일 토큰만 수정
```

### 6-3. 폴백

```css
@supports not (color: oklch(from white l c h)) {
  .btn:hover { background: hsl(220, 80%, 45%); }
}
/* 지원: Chrome 119+ / Safari 16.2+ / Firefox 128+ */
```

---

## 7. Style Dictionary 6 + Tokens Studio Git Sync 파이프라인

```
[Figma Variables]
      |
      | Tokens Studio 플러그인 (two-way sync)
      v
[GitHub: tokens/]  <-- DTCG JSON (brand-a.json, brand-b.json, global.json)
      |
      | CI 트리거 (push to main)
      v
[Style Dictionary 6]
      |
      +-- css/   -> tokens.css   (CSS 변수, @theme 주입용)
      +-- js/    -> tokens.js    (ESM)
      +-- ios/   -> tokens.swift
      +-- android/ -> tokens.xml
      v
[npm publish / CDN 배포]
      |
      v
소비처: Next.js @theme / React Native JS 토큰 / iOS / Android
```

Style Dictionary 6 설정 (sd.config.ts):

```typescript
import { defineConfig } from "style-dictionary";

export default defineConfig({
  source: ["tokens/**/*.json"],   // DTCG JSON 입력
  platforms: {
    css: {
      transformGroup: "css",
      prefix: "",
      buildPath: "styles/",
      files: [{ destination: "tokens.css", format: "css/variables" }],
    },
  },
});
```

two-way sync 규칙:
- 디자이너 수정 -> Tokens Studio "Push to GitHub" -> PR 생성 -> 개발자 리뷰 merge
- 개발자 tokens/*.json 수정 -> Tokens Studio "Pull from GitHub" -> Figma Variables 업데이트
- 충돌 해결: GitHub PR 리뷰 기준

---

## 8. Tailwind v4 @theme 통합 (CSS 변수 자동 노출)

```css
/* styles/tokens.css - Style Dictionary 출력을 @theme 블록에 배치 */
@import "tailwindcss";

@theme {
  /* Tailwind가 자동으로 유틸리티 클래스 생성:
     bg-color-action-primary / text-color-foreground / p-spacing-m 등 */
  --color-action-primary:   oklch(0.58 0.22 220);
  --color-action-secondary: oklch(0.55 0.20 320);
  --color-background:       oklch(1.00 0.00 0);
  --color-foreground:       oklch(0.10 0.00 0);
  --color-border:           oklch(0.93 0.00 0);

  --spacing-xs:  0.5rem;
  --spacing-m:   1rem;
  --spacing-l:   1.5rem;
  --spacing-xl:  2rem;
  --spacing-3xl: 4rem;
}
/* Relative Color hover 파생: oklch(from var(--color-action-primary) calc(l * 0.9) c h) */
```

---

## 9. Figma Variables <-> 코드 동기화 워크플로우

```
1. 초기 설정
   Figma Variables 컬렉션 생성 (Global, Brand-A, Brand-B)
   Tokens Studio 플러그인 -> GitHub 저장소 연결

2. 디자인 -> 코드
   Figma Variables 수정 -> "Push to GitHub" -> PR -> merge
   -> CI: Style Dictionary 빌드 -> npm publish

3. 코드 -> 디자인
   tokens/*.json 직접 수정 -> PR merge
   -> "Pull from GitHub" -> Figma Variables 자동 업데이트

4. multi-brand 전환
   tokens/brand-a.json + global.json -> brand-a.css
   tokens/brand-b.json + global.json -> brand-b.css
   런타임: <link rel="stylesheet" href="/brand-a.css"> 교체

5. 검증 게이트
   - 토큰 삭제 감지 -> breaking change 경고
   - WCAG 컬러 대비 자동 체크 (Style Dictionary 플러그인)
   - 미사용 토큰 감지 -> 분기별 정리 알림
```

---

## 참고: 브라우저 지원 기준

```
OKLCH:                Chrome 111+ / Safari 15.4+ / Firefox 113+
Relative Color Syntax: Chrome 119+ / Safari 16.2+ / Firefox 128+
color-gamut: p3:       대부분 모던 브라우저 지원
clamp():               Chrome 79+ / Safari 13.1+ / Firefox 75+

폴백 전략: oklch 미지원 시 @supports not (color: oklch(0 0 0)) 블록으로
           hsl/hex 폴백 정의
```
