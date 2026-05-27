# Minimalist Portfolio 아키타입

## 정의
개인 브랜드 사이트. 단일 accent + 정밀한 마이크로인터랙션.

## 대표 레퍼런스 5개
| URL | 시그니처 |
|-----|---------|
| rauno.me | Rauno Freiberg (Vercel), 극정밀 마이크로인터랙션 |
| emilkowal.ski | Emil Kowalski, Sonner/Vaul 제작자 |
| paco.me | Paco Coursey, cmdk 제작자 |
| joshwcomeau.com | Josh Comeau, MDX 인터랙티브 튜토리얼 |
| malte-westphal.com | 독일 디자이너, 타이포 중심 |

## 시그니처 패턴
### 타이포그래피
- System font 또는 Inter/Geist
- 본문 15-17px
- line-height 1.6-1.7
- 제목-본문 대비 뚜렷

### 컬러
- 단일 accent color + 무채색 베이스
- 다크모드 기본 또는 system 연동
- OKLCH relative color로 hover/muted 자동 파생

### 모션
- Subtle transform (translate 2px, opacity 0.9)
- Link hover (underline animation)
- Custom cursor (선택적, 과용 금지)
- Page transition (View Transitions API)

### 레이아웃
- Max-width 640-720px 단일 컬럼
- Centered content
- Footer 최소 (links + 이메일)

## 기술 스택 관찰
- Next.js + MDX + Tailwind + Motion v12
- 일부 Astro + MDX
- Vercel 호스팅
- Contentlayer 또는 자체 MDX loader

## 핵심 컴포넌트 패턴
- Blog post MDX
- Interactive demo component (Comeau 스타일)
- About page (1 scroll)
- Projects list with thumbnail
- RSS feed
- View counter (선택적)

## Anti-pattern
- "미니멀" 명분으로 네비게이션 숨김 (탐색성 상실)
- 링크 언더라인 제거 + 색만 변경 (접근성 실패)
- 커스텀 커서 강제 (터치 디바이스/접근성 문제)
- 과도한 font 사용 (3+ 패밀리)

## Stage 1 적용 가이드
- 읽기 경험 최우선 (measure + line-height)
- View Transitions API 페이지 전환
- Motion Tier 1 위주 (Tier 2 선택적)
- MDX + interactive demo
- RSS + sitemap 필수 (SEO)
- 인쇄 스타일
