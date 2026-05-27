---
name: frontend-stack
description: "Design system router. Auto-detects design case (Web/Commerce/Content/Document/Media/Brand) → loads case-specific team + presets + pipeline. Design layer only — delegates implementation to existing skills."
---

# Design System Router

디자인 작업 자동 감지 → 케이스별 팀 구성 → 토큰/프리셋 적용 → 기존 스킬에 구현 위임.

## 역할 분리

- **이 스킬** = Design Layer (방향 + 토큰 + 프리셋)
- **기존 스킬** = Implementation Layer (구현 + 출력)
- `guides/frontend.md` = 구현 패턴 (자동 주입, HOW)
- `frontend-design` 플러그인 = UI 미학 가이드 (Anti-AI-slop)

## 케이스 감지

### 3단계 감지 로직

1. **키워드 매칭** — 아래 테이블에서 확정적 매칭
2. **컨텍스트 추론** — 프로젝트 디렉토리, 최근 작업, 파일 확장자
3. **Fallback 인터뷰** — 모호할 때 사용자에게 케이스 선택 질문:
   "어떤 디자인 작업인가요? 1) 웹 UI 2) 상품/제품 3) SNS/콘텐츠 4) 문서/PPT 5) 영상/모션 6) 브랜딩"

### 케이스 테이블

| 케이스 | 키워드 | 로드할 reference | 위임 스킬 |
|--------|--------|-----------------|----------|
| **Web** | 랜딩, landing, 대시보드, dashboard, SaaS, 웹앱, 홈페이지 | `cases/case-web.md` | guides/frontend.md, nextjs15-init |
| **Commerce** | 상세페이지, PDP, 제품사진, 제품이미지, 목업, mockup, 패키징 | `cases/case-commerce.md` | image-processor |
| **Content** | 인스타, 유튜브, 썸네일, OG, SNS, 배너, 블로그 이미지 | `cases/case-content.md` | content-creator, image-processor |
| **Document** | PPT, 슬라이드, 발표, 제안서, 보고서, PDF, 문서 디자인 | `cases/case-document.md` | pptx, pdf |
| **Media** | 영상, 인트로, 아웃트로, 자막, 모션그래픽, 타이틀, 릴스 | `cases/case-media.md` | video-editor, Remotion, audio-processor |
| **Brand** | 로고, 브랜드, CI, 브랜딩, 아이덴티티, 가이드라인 | `cases/case-brand.md` | - (자체 처리) |

## 공통 reference (모든 케이스)

| reference | 용도 | 로딩 조건 |
|-----------|------|----------|
| `design-tokens.md` | OKLCH 컬러 + 타이포 + 스페이싱 | 항상 |
| `design-psychology.md` | 인지심리학 체크리스트 | Stage 1 (방향 설정) |
| `motion-guide.md` | 3-Tier 모션 전략 | 웹/영상 케이스 |
| `visual-effects.md` | Glassmorphism/Grain/Mesh | 웹/콘텐츠 케이스 |

## Animation Domain Packs

When a frontend task specifically needs JavaScript animation, scroll-driven animation, parallax, pinned sections, React animation cleanup, or animation performance guidance, check `~/.agents/external-skills/import-plan.json` for the staged GSAP skill pack.

Use GSAP candidates only when the project benefits from timeline control, ScrollTrigger, or runtime animation control. Keep simple hover/focus transitions in CSS.

## 자동화 흐름

```
[요청] → [케이스 감지 (3단계)]
  → [공통 reference 로딩: design-tokens.md]
  → [케이스 reference 로딩: cases/case-*.md]
  → [팀 구성 (case 파일에 정의)]
  → [파이프라인 실행 (case 파일에 정의)]
  → [QA (case 파일에 정의)]
  → [구현 위임 (위임 스킬)]
```

## 에이전트 원칙

| 페르소나 유형 | 에이전트 | 모델 |
|-------------|---------|------|
| Director / Strategist | 메인 스레드 (판단/설계) | opus |
| Designer / Engineer / Implementer | worker (실행) | sonnet |
| QA / Checker | reviewer (검증) | sonnet |
| Copywriter / Writer | worker (창작) | sonnet |

- Brains(메인) & Muscles(sub-agent) 원칙
- 같은 파일 동시 수정 금지
- 병렬 에이전트 3-5개 최적

## 케이스별 파이프라인 요약

| 케이스 | 파이프라인 | 단계 |
|--------|----------|------|
| Web | Direction → System → Implement → Motion → QA | 5 |
| Commerce | Strategy → Design+Copy → Implement → QA | 4 |
| Content | Strategy → Design → Optimize+Export | 3 |
| Document | Structure → Design+DataViz → QA | 3 |
| Media | Concept → Design → Implement → QA | 4 |
| Brand | Strategy → Design → System → Guidelines | 4 |

상세는 각 `cases/case-*.md` 참조.
