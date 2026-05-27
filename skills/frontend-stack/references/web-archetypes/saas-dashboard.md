# SaaS Dashboard 아키타입

## 정의
데이터 밀도 + 키보드 중심 + 빠른 인터랙션. B2B SaaS 제품의 핵심 UI.

## 대표 레퍼런스 5개
| URL | 시그니처 |
|-----|---------|
| linear.app/app | 키보드 네비 + Cmd+K 명령 팔레트 |
| dashboard.stripe.com | 데이터 밀도·가독성 교과서 |
| vercel.com/dashboard | 모노크롬 + 미니멀 차트 |
| resend.com | shadcn 스타일 대시보드 대표 |
| cal.com | 오픈소스, 스케줄링 UI 레퍼런스 |

## 시그니처 패턴
### 타이포그래피
- 본문 14-16px
- `font-variant-numeric: tabular-nums` (숫자 정렬)
- Inter/Söhne/Geist Sans

### 컬러
- 모노크롬 + 단일 accent
- 차트: Recharts/visx 단색 + 단일 accent (무지개 금지)
- semantic color (success/warning/error/info) 4개만

### 모션
- Tier 1 CSS transition 중심 (번들 최소)
- Optimistic update
- Skeleton loading
- Toast notification (slide-up)

### 레이아웃
- 3-pane: 좌 사이드바 + 상단 breadcrumb + 우 detail panel
- 또는 2-pane: 좌 nav + 본문
- Sticky 테이블 헤더
- Full-height with overflow

## 기술 스택 관찰
- Next.js + shadcn/ui + Radix
- TanStack Query v5 + TanStack Table
- Zustand v5 / Jotai
- tRPC or Server Actions (타입 안전)
- Tailwind v4 @theme

## 핵심 컴포넌트 패턴
- Cmd+K 명령 팔레트 (cmdk library)
- Data table with sorting/filtering/pagination
- Empty state / Skeleton / Optimistic 3종 세트
- Detail drawer (sheet slide-in)
- Multi-select with bulk actions
- Deep-linkable filters (nuqs/searchParams)

## Anti-pattern
- 무지개 차트 팔레트 (접근성+정보량 모두 손해)
- 모달 남용 (딥링크 불가, 공유 불가)
- dense 테이블의 hover-only 액션 (키보드/터치 접근성 실패)
- 무한 스크롤 (페이지네이션 선호)

## Stage 1 적용 가이드
- 키보드 네비 필수 (모든 액션 단축키)
- target-size 24×24 WCAG 2.2
- URL 상태 보존 (새로고침/공유)
- Cmd+K 팔레트 필수
- Motion Tier 1 중심 (번들 최소)
- INP 엄격 관리 (< 200ms)
