# Documentation / Dev Tool 아키타입

## 정의
개발자 대상 문서 사이트. 검색 + 코드블록 + 인터랙티브 데모.

## 대표 레퍼런스 5개
| URL | 시그니처 |
|-----|---------|
| ui.shadcn.com | 컴포넌트 문서의 현재 표준 |
| radix-ui.com | Primitive 문서의 원형 |
| tailwindcss.com | 검색/예시 밀도 최상 |
| trpc.io | 개념 문서 + live 타입 데모 |
| docs.stripe.com | API 레퍼런스의 고전 |

## 시그니처 패턴
### 타이포그래피
- Inter / Geist Sans / IBM Plex
- 본문 16px, 코드 14px Mono
- 제목 hierarchy 명확 (h1-h4)

### 컬러
- 모노크롬 + 단일 accent
- 코드 하이라이트 (Shiki + light/dark)
- semantic 알림 (info/warning/error)

### 모션
- 최소 (가독성 우선)
- Cmd+K 검색 모달 fade-in
- Sidebar collapse animation
- Code copy feedback (toast)

### 레이아웃
- 3컬럼: 좌 네비 / 본문 / 우 ToC
- 모바일: nav drawer + bottom sticky search
- max-width 본문 65-75자

## 기술 스택 관찰
- Next.js + Nextra / Fumadocs
- Astro Starlight
- Shiki (코드 하이라이트)
- Algolia DocSearch (또는 자체 Pagefind)
- Radix + Tailwind

## 핵심 컴포넌트 패턴
- Cmd+K 검색 (Algolia DocSearch / cmdk)
- Code block with copy + tabs (npm/pnpm/yarn/bun)
- Interactive playground (sandpack/StackBlitz embed)
- API reference (auto-generated from types)
- Version selector
- Edit on GitHub link

## Anti-pattern
- 검색 부재 또는 부실
- 버전 전환 UI 없음
- 예시 코드 복사 불가
- 모바일에서 좌측 네비 영구 노출
- 코드 블록 가로 스크롤 (긴 줄)

## Stage 1 적용 가이드
- 검색 우선 (Algolia DocSearch 또는 Pagefind)
- 코드 블록 copy 버튼 + 패키지 매니저 탭
- Dark/Light 토글 + prefers-color-scheme 기본
- Edit on GitHub + Last updated 표시
- LLM-friendly markdown (raw .md endpoint 제공)
- 버전별 문서 분리 (또는 inline 버전 토글)
- Motion Tier 1 위주 (번들 최소)
