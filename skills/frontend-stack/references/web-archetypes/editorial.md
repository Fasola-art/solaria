# Editorial / Content 아키타입

## 정의
저널리즘 + 인터랙티브 비주얼 스토리텔링. 가독성 최우선 + 데이터 시각화.

## 대표 레퍼런스 5개
| URL | 시그니처 |
|-----|---------|
| nytimes.com/interactive | 데이터 저널리즘 최상급 (The Upshot) |
| pitchfork.com | 리뷰 타이포 + 점수 시각화 |
| pudding.cool | Scrollytelling 대표 |
| vox.com | Explainer 카드형 레이아웃 |
| theverge.com | 브랜드 강한 모듈 그리드 (2022 리디자인) |

## 시그니처 패턴
### 타이포그래피
- Serif 헤드라인 (NYT Cheltenham, Pitchfork Publico, Tiempos)
- Sans 본문
- measure 65-75자 엄수
- line-height 1.5-1.7
- Drop cap, pull quote

### 컬러
- 중성 톤 + 브랜드 accent
- 이미지 fullbleed 시 overlay caption

### 모션
- Scrollytelling: sticky graphic + step narration (Scrollama)
- 인라인 데이터 시각화 (D3, visx, Observable Plot)
- 진행 표시 (reading progress bar)

### 레이아웃
- 본문 폭 제한 (centered measure)
- Fullbleed 이미지 간헐적
- Chart/graphic 사이드바 또는 인라인

## 기술 스택 관찰
- NYT: 자체 Samizdat + D3/Svelte
- The Pudding: Svelte + Scrollama
- Vox Media: Chorus CMS
- 신규: Next.js + MDX + Contentlayer, Astro + starlight

## 핵심 컴포넌트 패턴
- Scrollytelling step (sticky + step 트리거)
- Inline interactive chart
- Pull quote
- Image + caption overlay
- Related articles footer
- Newsletter CTA (비침투적)

## Anti-pattern
- 본문 풀블리드 100% (가독성 파괴)
- 쿠키/뉴스레터 모달 즉시/중첩
- 광고 CLS (Core Web Vitals 전멸)
- 자동재생 비디오 with sound

## Stage 1 적용 가이드
- 가독성 최우선 (measure 65-75자 엄수)
- 이미지 alt 텍스트 의무 (SEO + 접근성)
- Scrollytelling 시 Motion Tier 2 + Scrollama
- Core Web Vitals 관리 (광고 레이아웃 예약)
- 인쇄 스타일 고려 (`@media print`)
- Reader mode 호환성 확인
