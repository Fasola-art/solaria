
## Contents

- [팀 구성 (8명)](#팀-구성-8명)
  - [코어 팀 (5명)](#코어-팀-5명)
  - [영상 팀 (3명, 신규 — Stage 1/3/4/5 교차 투입)](#영상-팀-3명-신규-stage-1345-교차-투입)
- [Stage × 페르소나 자동 매핑](#stage-페르소나-자동-매핑)
- [파이프라인 (5-Stage)](#파이프라인-5-stage)
  - [Stage 1: Design Direction (페르소나: frontend+critic+realist)](#stage-1-design-direction-페르소나-frontendcriticrealist)
  - [Stage 2: Design System (페르소나: architect+frontend)](#stage-2-design-system-페르소나-architectfrontend)
  - [Stage 3: Implementation (페르소나: frontend+backend+refactorer)](#stage-3-implementation-페르소나-frontendbackendrefactorer)
  - [Stage 4: Motion & Interaction (페르소나: frontend+performance)](#stage-4-motion-interaction-페르소나-frontendperformance)
  - [Stage 5: Quality Gate (페르소나: qa+security+performance)](#stage-5-quality-gate-페르소나-qasecurityperformance)
- [페이지 구조 (랜딩, 아키타입에 따라 변형)](#페이지-구조-랜딩-아키타입에-따라-변형)
- [기술 스택 (2026-04)](#기술-스택-2026-04)
- [위임 스킬](#위임-스킬)
- [팀 모드 전환 기준](#팀-모드-전환-기준)
- [변경 이력](#변경-이력)

---
case: web
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
pipeline:
  - stage: S0
    name: Information Architecture
    personas: [architect, frontend]
    inputs: [PMC.ICP, PMC.Differentiation, Competitor.sitemap]
    outputs: [sitemap.json, url-structure.md]
    checks: [a11y_landmarks, url_canonicalization]
  - stage: S1
    name: Direction
    personas: [frontend, critic, realist]
    inputs: [PMC.BrandVoice, PMC.ICP, Competitor.data]
    outputs: [archetype.md, moodboard.md, token-seed.json]
    checks: [brand_consistency, archetype_selected]
  - stage: S2
    name: System
    personas: [architect, frontend]
    inputs: [token-seed.json, archetype.md]
    outputs: [design-tokens.css, component-map.md]
    checks: [tokens, a11y]
  - stage: S3
    name: Implement
    personas: [frontend, backend, refactorer]
    inputs: [component-map.md, PMC.ProofPoint]
    outputs: [pages/, components/]
    checks: [perf, copy_sweeps, license]
  - stage: S4
    name: Motion
    personas: [frontend, performance]
    inputs: [motion-guide.md, motion-archetype-matrix.md]
    outputs: [motion-tokens.css, animation-map.md]
    checks: [perf, a11y]
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
  - marketing-skills:onboarding-cro
  - marketing-skills:churn-prevention
  - marketing-skills:programmatic-seo
archetype_refs:
  - references/web-archetypes/{archetype}.md
quality_gates: [tokens, a11y, perf, brand, copy_sweeps, license]
ontology_emits: [DesignAsset, Archetype, DesignToken, MotionSignature]
guide_refs:
  - guides/frontend.md
  - guides/decision-trees.md
  - rules/design-marketing-integration.md
---

# Web 케이스 v2 (랜딩/대시보드/SaaS) — 2026-04 개편

> 변경: 5인 → 8인 팀 (영상 팀 3인 추가), Stage 1에 사이트 성향 분류 단계 신설, Stage×페르소나 자동 매핑, Next.js 16 Cache Components+React Compiler 패턴, 3-Tier Motion v2, INP RUM/WCAG 2.2 강화.

## 팀 구성 (8명)

### 코어 팀 (5명)
| 역할 | 담당 | 에이전트 |
|------|------|---------|
| Design Director | 디자인 방향, 톤/무드, 인지심리, 사이트 성향 분류 | 메인(opus) |
| System Architect | OKLCH 토큰(DTCG 2025.10), Tailwind v4 @theme, shadcn/ui | worker(sonnet) |
| Frontend Developer | Next.js 16 App Router + Cache Components + Server Actions, RHF+Zod | worker(sonnet) |
| Motion Engineer | 3-Tier Motion v2 적용, View Transitions API | worker(sonnet) |
| QA Reviewer | Lighthouse CI + axe-core 4.10 + Sentry RUM + Playwright | reviewer(sonnet) |

### 영상 팀 (3명, 신규 — Stage 1/3/4/5 교차 투입)
| 역할 | 담당 | 에이전트 | 진입 Stage |
|------|------|---------|----------|
| Cinematic Director | 3-Act 내러티브, 쇼트 시퀀스, LUT, 트랜지션, Anti-AI-slop | 메인 or worker | 1, 5 자문 |
| Video Engineer | 코덱(AV1/VP9/H.264), CMAF, Mux/Cloudflare Stream, Remotion SSR | worker | 3, 5 |
| Motion Designer | 3-Tier Motion v2 (motion-guide.md), 시그니처 이징, View Transitions | worker | 4 |

## Stage × 페르소나 자동 매핑

| Stage | 활성 페르소나 (최대 3, 우선순위 security>architect>analyzer) | 페르소나 → 체크리스트 |
|-------|------------------------------------------------------|------------------|
| 1 Direction | frontend + critic + realist | 사용자 가치 / 비판적 검증 / MVP 범위 |
| 2 System | architect + frontend | SSOT 토큰 / 진화적 설계 / a11y |
| 3 Implement | frontend + backend + refactorer | Result 패턴 / Schema-First / 함수 50줄·파일 500줄 |
| 4 Motion | frontend + performance | 측정 먼저 / 번들 델타 / prefers-reduced-motion |
| 5 QA | qa + security + performance | 엣지 케이스 / CSP·XSS / LCP·INP·CLS |

훅 연동: `~/.claude/hooks/persona-activator.js`에 `frontend-stack:web:stage{1..5}` 키워드 트리거 (60s TTL 캐시).

## 파이프라인 (5-Stage)

### Stage 1: Design Direction (페르소나: frontend+critic+realist)

**1.1 사이트 성향 분류 (신규 최상단)**
- 8개 아키타입 중 1개 선택 → `references/web-archetypes/{name}.md` 자동 로드
- 아키타입: cinematic-product / saas-dashboard / editorial / minimalist-portfolio / brutalist / ecommerce-premium / docs-dev / ai-product
- 성향이 모호하면 frontend-design 플러그인 4질문 (Purpose/Tone/Constraints/Differentiation)

**1.2 시네마틱 체크리스트 (Cinematic Director, video-cinematic.md 위임)**
- 3-Act 내러티브 맵핑 (Setup → Confrontation → Resolution)
- 쇼트 시퀀스 스토리보드, LUT 팔레트, 트랜지션 타입
- Anti-AI-slop: Inter/Roboto/Arial 금지, 보라 그라디언트 금지, AI 인물+음성 금지

**1.3 인지심리 원칙** — design-psychology.md 체크리스트

### Stage 2: Design System (페르소나: architect+frontend)

- design-tokens.md 로딩 → DTCG 2025.10 JSON SSOT
- Tailwind v4 `@theme` CSS-first 적용 (OKLCH 기본)
- CSS relative color syntax로 다크/hover/muted 자동 파생: `oklch(from var(--brand) calc(l * 0.9) c h)`
- shadcn/ui (Radix 기반) — 성향에 따라 Park UI / Origin UI / daisyUI 대안 검토
- Style Dictionary 6 + Tokens Studio Git two-way sync 파이프라인

### Stage 3: Implementation (페르소나: frontend+backend+refactorer)

**3.1 Next.js 16 Cache Components 패턴 (신규)**
```typescript
// next.config.ts
const config = {
  cacheComponents: true,
  reactCompiler: true,
  reactCompilerOptions: { compilationMode: "all" },
};

// Server Action read-your-writes
"use server";
async function updateUser(formData: FormData) {
  await db.user.update(...);
  updateTag("user");  // 즉시 클라이언트 재검증
}
```

- Server Components 기본, 클라이언트 컴포넌트 최소화
- `useActionState` + `useOptimistic` + RHF + Zod 폼 패턴
- Result 패턴 (throws 금지) — `Result<T, E>`
- 컴포넌트=UI / Hook=로직 분리, 파일 500줄/함수 50줄
- middleware → proxy.ts (Edge → Node), Async params/cookies 강제
- 영상 통합: Video Engineer Stage 3 체크리스트 (video-cinematic.md)
  - poster `fetchpriority="high"` + `preload="metadata"`
  - 코덱 폴백 `<source>` AV1 webm → VP9 webm → H.264 mp4
  - IntersectionObserver lazy load, Remotion SSR via API Route

### Stage 4: Motion & Interaction (페르소나: frontend+performance)

> 상세: `references/motion-guide.md` (3-Tier Motion v2 + **Maximum Motion 프리셋**)
> **기본 동작**: 사용자가 "간결/최소/기본"을 명시하지 않는 한 Maximum Motion 프리셋(15+ 기법) 적용

- **Tier 1**: TailwindCSS Motion + CSS `animation-timeline: scroll()` (~5KB, Safari 26+/Chrome 115+)
- **Tier 2**: Motion v12 motion/react (~85KB, layoutAnchor, OKLCH 보간)
- **Tier 3**: GSAP 3.13 + ScrollTrigger + Flip (~78KB, **100% 무료**)
- **Bonus**: Theatre.js 시퀀스 / View Transitions API (0KB native, Chrome 126+/Safari 18.2+)

선택 규칙: CSS만 가능 → Tier1, 상태/제스처/레이아웃 → Tier2, 시네마틱 시퀀스 → Tier3.
번들 예산: Tier 1 +10KB hard cap, Tier 3 lazy import 강제.

시그니처 이징: Apple bounce(0/0.3/0.6), Vercel/Linear `cubic-bezier(0.16, 1, 0.3, 1)`.

마이크로인터랙션 Top 5: Scroll Parallax Hero / Form 반응성 / View Transitions 페이지 전환 / Skeleton Pulse / CTA 호흡.

prefers-reduced-motion 자동 폴백 + Playwright 자동 테스트.

### Stage 5: Quality Gate (페르소나: qa+security+performance)

**5.1 자동 게이트**
- TypeScript: `pnpm tsc --noEmit` (에러 0)
- Lint: ESLint + Prettier (또는 Biome)
- 빌드: `pnpm build` 그린

**5.2 성능 (3중 트래킹)**
- **Lighthouse CI** — PR 게이트 (lab)
- **Vercel Speed Insights** — RUM CrUX p75
- **Sentry Performance** — INP attribution (어느 컴포넌트 핸들러)
- 임계값: LCP<2.5s / INP<200ms / CLS<0.1
- 번들 예산: 클라이언트 컴포넌트 트리 150-170KB(gzip), Route-level + Third-party 분리
- Long Task: 단일 50ms 이하, TBT 200ms 이하

**5.3 접근성**
- axe-core 4.10 + Storybook a11y addon + Playwright axe
- WCAG 2.2 AA: target-size 24×24, focus-appearance, dragging movements, accessible authentication
- EU EAA 준수 (2025-06 시행)

**5.4 보안 (security 페르소나)**
- CSP, 입력 sanitize, 시크릿 하드코딩 금지
- Server Action 인증/인가 검증

**5.5 영상 QA 게이트** (Video Engineer, video-cinematic.md)
- 자막 WCAG (Whisper→WebVTT, 95%+ 정확도 검수)
- prefers-reduced-motion 정지 프레임 폴백
- 간질 방지 <3Hz 깜빡임 (FFmpeg 분석)

**5.6 시각적 회귀** — Playwright screenshot diff
**5.7 수동** — 반응형(모바일/태블릿/데스크톱) + 다크모드 + 키보드 + VoiceOver

## 페이지 구조 (랜딩, 아키타입에 따라 변형)

기본: Hero(Von Restorff+Fitts) → Problem(Loss Aversion) → Solution(Gestalt) → Features(Miller 3-4) → Social Proof(구체 숫자) → CTA(Hick).
아키타입별 변형은 `web-archetypes/{name}.md` 참조.

## 기술 스택 (2026-04)

- **Next.js 16** App Router + TypeScript strict
- **React 19** + Compiler stable (annotation→all 단계 전환)
- **TanStack Query v5** (서버) + **Zustand v5** (전역) + **RHF + Zod** (폼) + **nuqs** (URL) + useState (로컬)
- **Tailwind v4** @theme + OKLCH 기본 + container queries core
- **shadcn/ui** (Radix) — 성향 따라 대안 가능
- **DTCG 2025.10** + Style Dictionary 6 + Tokens Studio
- **Motion**: 3-Tier v2 (`motion-guide.md`)
- **Video**: AV1/VP9/H.264 + CMAF + Mux/Cloudflare Stream + Remotion (`video-cinematic.md`)

## 위임 스킬

- `references/motion-guide.md` — 3-Tier Motion v2 + 이징 카탈로그 + 5 스니펫
- `references/video-cinematic.md` — 영상 팀 가이드 (Cinematic Director 10기법 + Video Engineer 게이트)
- `references/web-archetypes/{name}.md` — 8개 사이트 성향 레퍼런스팩
- `references/design-tokens.md` — DTCG + OKLCH + relative color syntax
- `references/design-psychology.md` — 인지심리 체크리스트
- `references/visual-effects.md` — Glassmorphism/Grain/Mesh
- `guides/frontend.md` — 구현 패턴 자동 주입
- `nextjs15-init` (또는 nextjs16) — 신규 프로젝트 스캐폴딩
- `frontend-design` 플러그인 — Anti-AI-slop 미학

## 팀 모드 전환 기준

`/frontend-team` 8-agent 오케스트레이션 적용:
- 5+ 섹션 랜딩페이지 또는 시네마틱 영상 통합
- 복잡 인터랙션 + 고품질 모션 (Tier 2·3 사용)
- 접근성/성능 검증 중요 (EU EAA, 공공 부문)
- 사이트 성향이 Cinematic Product / Brutalist 등 고품질 요구

## 변경 이력

- v2 (2026-04-13): 8인 팀 + Stage×페르소나 매핑 + 사이트 성향 분류 + Cache Components + 3-Tier Motion v2 + INP RUM + WCAG 2.2 + DTCG 2025.10
- v1: Next.js 15 + 5인 팀 + 3-Tier Motion v1
