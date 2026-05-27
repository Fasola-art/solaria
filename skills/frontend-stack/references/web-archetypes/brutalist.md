# Brutalist / Experimental 아키타입

## 정의
실험적 시각 표현 + WebGL/3D + 의도적 비대칭. 어워드 사이트 + 에이전시 포트폴리오.

## 대표 레퍼런스 5개
| URL | 시그니처 |
|-----|---------|
| bruno-simon.com | Three.js 3D 포트폴리오 대명사 |
| awwwards.com (SOTD) | 큐레이션, 트렌드 리딩 |
| godly.website | 큐레이션 갤러리 자체가 브루탈 |
| cassie.codes | Cassie Evans, SVG/GSAP 정밀 |
| active-theory.com | 실험적 에이전시 |

## 시그니처 패턴
### 타이포그래피
- Variable font 극단 사용 (weight 100↔900, width 축 애니메이션)
- System mono 또는 커스텀 디스플레이
- 큰 마진/border, raw HTML 느낌

### 컬러
- 강한 대비 또는 노이즈 텍스처
- Glitch / chromatic aberration / CRT 필터
- 단색 + 1-2 강조

### 모션
- WebGL/Three.js/R3F 인터랙티브 씬
- Scroll-driven 3D 카메라
- GSAP Flip / ScrollTrigger 복잡 시퀀스
- Theatre.js 시각 에디터 시퀀스
- Custom shader

### 레이아웃
- 비대칭/오버래핑 레이아웃
- 의도적 "깨진" 그리드
- Fullscreen canvas + UI overlay
- Variable font 모핑

## 기술 스택 관찰
- Three.js + React Three Fiber + drei + postprocessing
- GSAP + ScrollTrigger + Flip
- Lenis smooth scroll
- Rive (인터랙티브 애니메이션)
- Theatre.js (저작 도구)
- Next.js 또는 Vite

## 핵심 컴포넌트 패턴
- WebGL hero scene (R3F)
- Cursor-following effect
- Page transition with shader
- Variable font hover morph
- Audio-reactive visual

## Anti-pattern
- 접근성 완전 포기 (키보드/스크린리더 무시) ← 가장 흔한 실패
- 모바일 미대응
- 첫 로드 5s+ (LCP 완전 실패)
- prefers-reduced-motion 미대응
- 자동재생 사운드

## Stage 1 적용 가이드
- prefers-reduced-motion 폴백 필수 (정적 버전 제공)
- 키보드 네비 별도 트랙 (텍스트 ver)
- 모바일 폴백 (Three.js 비활성, 이미지/비디오 대체)
- WebGL → Canvas → 이미지 점진적 폴백
- LCP 명시적 관리 (poster 이미지 우선)
- Motion Tier 3 (GSAP) + Bonus (Theatre.js) 적극
- Video Engineer 참여 권장
