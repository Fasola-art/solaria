# E-commerce Premium 아키타입

## 정의
럭셔리/디자인-드리븐 이커머스. 제품 이미지 중심 + 절제된 톤.

## 대표 레퍼런스 5개
| URL | 시그니처 |
|-----|---------|
| aesop.com | 미니멀 럭셔리 이커머스 원형 |
| nomos-glashuette.com | 독일 시계, 제품 상세 타이포 |
| hermes.com | 브랜드 월드 + 커머스 하이브리드 |
| on-running.com | 퍼포먼스 스포츠, 컨피규레이터 |
| apc.fr | APC, 절제된 패션 커머스 |

## 시그니처 패턴
### 타이포그래피
- Serif 또는 Neue Haas Grotesk 계열 산세리프
- 본문 14-15px, 제목은 큼지막
- letter-spacing 미세 조정 (브랜드감)

### 컬러
- 컬러 팔레트 2-3개로 극도 제한
- 흰색 베이스 + 단일 accent
- 제품 이미지가 컬러를 주도

### 모션
- Tier 1 + Tier 2 위주
- Hover 시 second image crossfade
- Sticky add-to-cart bar
- Mini-cart drawer slide-in
- Smooth scroll (선택)

### 레이아웃
- 제품 이미지 fullbleed, 4:5 또는 1:1 통일
- Generous whitespace
- Product detail: 좌 이미지 캐러셀 + 우 정보
- Filter sidebar (또는 top bar)

## 기술 스택 관찰
- Shopify Hydrogen (Remix) — 신규 표준
- Next.js + Shopify Storefront API / commercetools
- Aesop: Shopify Plus
- Sanity / Contentful (CMS)

## 핵심 컴포넌트 패턴
- Product gallery (zoom on hover)
- Variant selector (color/size 그리드)
- Quick add (mini cart drawer)
- Wishlist
- Size guide modal
- Recently viewed
- Related products

## Anti-pattern
- 자동 슬라이드쇼 히어로 (전환율 손해)
- 즉시 팝업 이메일 캡처
- 체크아웃 5+ 단계 (cart abandonment)
- 가격/재고 클라이언트 렌더 (LCP 지연)
- 무거운 zoom 라이브러리

## Stage 1 적용 가이드
- 제품 이미지 LCP 우선 (fetchpriority="high")
- Sticky add-to-cart (스크롤 시 표시)
- 결제 흐름 최소화 (express checkout: Apple Pay/Shop Pay)
- Schema.org Product / Offer 마크업
- 인앱 브라우저 호환 (Instagram/Facebook)
- 다국어/다통화 지원 검토
