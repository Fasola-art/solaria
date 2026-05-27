# Cinematic Product 아키타입

## 정의
제품 스토리텔링을 영화 언어(쇼트/페이싱/트랜지션)로 웹에 구현. Hero 중심 + 스크롤 연결 애니메이션.

## 대표 레퍼런스 5개
| URL | 시그니처 |
|-----|---------|
| apple.com | 스크롤 기반 제품 쇼트 시퀀스 + video-scrub |
| linear.app | 다크 그라디언트 + 정밀 마이크로 인터랙션 |
| arc.net | 컬러풀 블롭 + 대형 variable font 타이포 |
| framer.com | 인터랙티브 컴포넌트 데모가 곧 마케팅 |
| vercel.com/ship | 이벤트 페이지 live-streaming 연출 |

## 시그니처 패턴
### 타이포그래피
- Fluid/Clamp 48-120px 헤드라인, weight 400-600
- Variable font 사용 (Inter/Geist/커스텀)
- line-height 1.0-1.1 (대형) / 1.5 (본문)

### 컬러
- Dark 또는 단색 고대비 배경
- 네온/그라디언트 액센트 1-2개
- OKLCH 기반 perceptually uniform 팔레트

### 모션
- Scroll-linked (IntersectionObserver / GSAP ScrollTrigger / Motion v12 useScroll)
- Staggered reveal (240ms 간격)
- Parallax depth (배경/중층/전경)
- Match Cut 섹션 전환
- Hero 영상/Canvas/WebGL 1개 고정

### 레이아웃
- Generous whitespace
- 12-column → 비대칭 그리드
- Fullbleed 이미지/비디오
- sticky + scroll-scrubbing

## 기술 스택 관찰
- Next.js + Framer Motion (Motion v12)
- GSAP 3.13 + ScrollTrigger + Flip
- Lenis smooth scroll
- Vercel 호스팅 (Apple은 자체 스택)

## 핵심 컴포넌트 패턴
- Hero with sticky video scrub
- Pinned section with horizontal scroll
- Product gallery (4:5 fullbleed)
- Staggered feature reveal
- Match cut transitions between sections

## Anti-pattern
- 스크롤 훅킹으로 네이티브 속도 오버라이드 (접근성 파괴)
- 모든 섹션 parallax 남용 (LCP 악화)
- 무거운 Lottie/비디오 autoplay → LCP 4s+

## Stage 1 적용 가이드
- 3-Act 내러티브 필수 (Setup → Confrontation → Resolution)
- LUT 팔레트 선언 (teal-orange 등 영화적 톤)
- Hero 쇼트: establishing → medium → close-up 진행
- prefers-reduced-motion 폴백 필수
- Motion Tier 2·3 적극 사용 (Tier 3 lazy import)
- Video Engineer 참여 권장 (코덱 폴백 + CMAF)
