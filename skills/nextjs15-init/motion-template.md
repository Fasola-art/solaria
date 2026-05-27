## 웹 모션 설정 (Motion Pipeline)

플랜 `transient-sprouting-whale.md` Phase 4 산출물.
프로젝트 CLAUDE.md에 append하는 motion 섹션.

---

### 기본값: Maximum Motion ON

이 프로젝트는 웹 모션 파이프라인이 활성화되어 있다.
기법 선정 알고리즘: `~/.claude/skills/web-motion/references/motion-selector.md`
아키타입 매트릭스: `~/.claude/skills/web-motion/references/motion-archetype-matrix.md`
검증 체크리스트: `~/.claude/agents/reviewer/AGENT.md` — 웹 모션 산출물 검증 섹션

---

### 아키타입 선택 가이드

프로젝트 성격에 맞는 아키타입 1개를 선택한다. 선택 후 motion-selector.md가 기법 목록을 자동 출력한다.

**질문 1. 주요 콘텐츠 형태는?**
- 제품/서비스 소개 영상 중심 → cinematic-product
- 데이터 차트·테이블 중심 → saas-dashboard
- 텍스트·기사·매거진 중심 → editorial

**질문 2. 시각적 강도는?**
- 몰입형, 풀스크린, 영화적 → cinematic-product 또는 brutalist
- 절제, 여백 중심 → minimalist-portfolio
- 고급스러운 쇼핑 경험 → ecommerce-premium

**질문 3. 기술 독자 비중은?**
- 개발자·기술 문서 50% 이상 → docs-dev (기법 목표 20개, WebGL/Physics 금지)
- AI 인터페이스·실시간 피드백 강조 → ai-product

**8 아키타입 요약**:

| 아키타입 | 키워드 | 기법 목표 | WebGL |
|---|---|---|---|
| cinematic-product | 영화적, 스크롤 연출, 제품 쇼케이스 | 28 | 권장 |
| saas-dashboard | 데이터 시각화, 마이크로인터랙션 | 28 | 금지 |
| editorial | 타이포그래피, 기사, 매거진 | 28 | 금지 |
| minimalist-portfolio | 여백, 절제, 포트폴리오 | 28 | 권장 |
| brutalist | 과감한 레이아웃, 충격적 전환 | 28 | 필수 |
| ecommerce-premium | 상품 탐색, 장바구니, 고급스러움 | 28 | 선택 |
| docs-dev | 문서, 튜토리얼, 기술 사이트 | 20 | 금지 |
| ai-product | AI 인터페이스, 스트리밍, 상태 피드백 | 28 | 권장 |

아키타입 미선택 시 기본값: `cinematic-product`.

---

### motion-selector.md 자동 호출 절차

웹 UI 컴포넌트 작업 시작 전 motion-selector를 호출하여 기법 목록을 확정한다.

```bash
# 1. 아키타입 확인 (이 파일 상단 MOTION_ARCHETYPE 값)
ARCHETYPE="cinematic-product"

# 2. motion-selector.md 참조 — 아키타입 입력 시 기법 ID 목록 반환
# ~/.claude/skills/web-motion/references/motion-selector.md
# 입력 스키마: { archetype, viewport, perfBudget }
# 출력 스키마: [{ id, tier, lazy, fallback }]

# 3. 반환된 ID 목록을 파일 상단 주석에 기록
# <!-- motion: T01,T03,T07,T12,... archetype: cinematic-product -->
```

호출 트리거 키워드: "모션", "애니메이션", "motion", "animation", "시네마틱", "cinematic", "scroll-driven", "parallax"
— persona-activator.js가 자동으로 frontend + performance + researcher 페르소나 활성화.

---

### 번들 예산 규칙

```
Tier1 (CSS native + 경량 JS):
  - CSS animation-timeline, @keyframes, transition: 0KB 추가
  - Framer Motion LazyMotion (기능 분리): +4.6KB
  - 기타 Tier1 JS 합산 상한: +15KB (초기 번들 기준)

Tier2 (중간 라이브러리):
  - Framer Motion 전체: +50KB — 사용 시 LazyMotion으로 분리 필수
  - GSAP core: +30KB — 필요 플러그인만 import

Tier3 (heavy, lazy 필수):
  - Three.js, @react-three/fiber, WebGL 라이브러리
  - 반드시 dynamic import 또는 IntersectionObserver lazy 초기화
  - 초기 번들 포함 금지
```

Tier3 dynamic import 예시 (Next.js):

```typescript
// heavy WebGL 컴포넌트는 dynamic import 필수
import dynamic from 'next/dynamic';

const ThreeScene = dynamic(
  () => import('@/components/motion/ThreeScene'),
  {
    ssr: false,
    loading: () => <div aria-label="로딩 중" />,
  }
);
```

번들 예산 추적:

```bash
# 빌드 후 번들 크기 확인 (필수)
next build --profile
# .next/analyze/ 디렉토리에서 번들 리포트 확인
# 또는
ANALYZE=true next build
```

---

### 산출물 파일 메타 주석 규칙

모든 웹 모션 산출물 파일 최상단에 기록:

```html
<!-- motion: T01,T03,T07,T12,T15,T18,T20 archetype: cinematic-product -->
```

React/TSX 파일:

```typescript
{/* motion: T01,T03,T07,T12,T15,T18,T20 archetype: cinematic-product */}
```

주석 ID는 실제 구현된 기법만 기록. 구현 없는 ID 기록 금지 (reviewer 항목 1 코드 증거 병행 검증으로 탐지됨).

---

### prefers-reduced-motion 처리 규칙

모든 모션 컴포넌트에서 접근성 대체 처리 필수:

```typescript
// Framer Motion 사용 시
import { useReducedMotion } from 'framer-motion';

export function AnimatedHero() {
  const shouldReduceMotion = useReducedMotion();

  const variants = {
    hidden: { opacity: 0, y: shouldReduceMotion ? 0 : 40 },
    visible: { opacity: 1, y: 0 },
  };
  // ...
}
```

```css
/* CSS 애니메이션 사용 시 */
@media (prefers-reduced-motion: reduce) {
  *,
  *::before,
  *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}
```

---

### reviewer 체크 연동

웹 UI 컴포넌트 완성 후 reviewer 에이전트 6항 검증 필수:

```
검증 대상: ~/.claude/agents/reviewer/AGENT.md — 웹 모션 산출물 검증 섹션
빠른 점검: bash motion-review.sh [대상 경로]
Playwright 감사: npx playwright test playwright-axe-scan.spec.ts
```

판정 기준:
- 6/6 PASS → 산출물 완료
- FAIL 항목 존재 → 수정 후 재검증
- 롤백 트리거: Lighthouse perf < 85 또는 a11y < 95 → 기법 수 28 → 15로 축소, Tier3 off

---

### 현재 프로젝트 모션 설정

```
MOTION_ARCHETYPE=cinematic-product   # 변경 시 motion-selector.md 재실행
MOTION_MAX=true                       # false로 변경 시 목표 기법 수 15로 하향
MOTION_TIER3_ENABLED=true             # false로 변경 시 WebGL/heavy 기법 제외
MOTION_BUDGET_TIER1_KB=15             # Tier1 JS 상한 (KB)
```
