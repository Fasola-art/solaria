# Motion Archetype Matrix — 9 카테고리 x 8 아키타입


## Contents

- [ID 매핑 (T01~T54)](#id-매핑-t01t54)
- [A11y-Motion 기법 목록 (접근성 핵심 기법)](#a11y-motion-기법-목록-접근성-핵심-기법)
- [아키타입별 매트릭스](#아키타입별-매트릭스)
  - [아키타입 정의](#아키타입-정의)
  - [카테고리 1: Scroll-driven](#카테고리-1-scroll-driven)
  - [카테고리 2: Cinematic](#카테고리-2-cinematic)
  - [카테고리 3: Microinteractions](#카테고리-3-microinteractions)
  - [카테고리 4: Page Transitions](#카테고리-4-page-transitions)
  - [카테고리 5: WebGL/3D](#카테고리-5-webgl3d)
  - [카테고리 6: SVG/Canvas](#카테고리-6-svgcanvas)
  - [카테고리 7: Typography](#카테고리-7-typography)
  - [카테고리 8: Gesture/Physical](#카테고리-8-gesturephysical)
  - [카테고리 9: AI-driven](#카테고리-9-ai-driven)
- [아키타입별 기법 수 요약](#아키타입별-기법-수-요약)
- [보정 규칙 (목표 미달 아키타입 처리)](#보정-규칙-목표-미달-아키타입-처리)
- [Mermaid 요약 (ASCII 대체)](#mermaid-요약-ascii-대체)
- [카테고리별 기법 수 확인](#카테고리별-기법-수-확인)

> 기법 ID: T01~T54 (motion-techniques-full.md 헤더 번호 = T 번호)
> 아키타입별 목표: cinematic-product/saas-dashboard/editorial/minimalist-portfolio/brutalist/ecommerce-premium/ai-product >= 28 기법, docs-dev >= 20 기법

---

## ID 매핑 (T01~T54)

| ID  | 기법명                          | 카테고리          | Tier   |
|-----|---------------------------------|-------------------|--------|
| T01 | 스크롤-비디오 연동              | Scroll-driven     | Tier 2 |
| T02 | 이미지 프레임 시퀀스            | Scroll-driven     | Tier 2 |
| T03 | 멀티레이어 패럴랙스             | Scroll-driven     | Tier 2 |
| T04 | 핀드 섹션                       | Scroll-driven     | Tier 2 |
| T05 | 수평 스크롤 하이재킹            | Scroll-driven     | Tier 3 |
| T06 | 스크롤 트리거 리빌              | Scroll-driven     | Tier 1 |
| T07 | 읽기 진행 바                    | Scroll-driven     | Tier 1 |
| T08 | 스크롤 연동 3D 카메라           | Scroll-driven     | Tier 3 |
| T09 | 이스태블리싱 샷                 | Cinematic         | Tier 1 |
| T10 | 매치컷 전환                     | Cinematic         | Tier 2 |
| T11 | 디졸브/크로스페이드             | Cinematic         | Tier 1 |
| T12 | 슬로우 줌 켄번즈                | Cinematic         | Tier 1 |
| T13 | 3D 카메라 팬/틸트               | Cinematic         | Tier 3 |
| T14 | 포커스 풀                       | Cinematic         | Tier 2 |
| T15 | 스플릿 스크린 리빌              | Cinematic         | Tier 2 |
| T16 | 마그네틱 버튼                   | Microinteractions | Tier 2 |
| T17 | 3D 틸트 호버                    | Microinteractions | Tier 2 |
| T18 | 글자별 리빌                     | Microinteractions | Tier 2 |
| T19 | 숫자 카운터                     | Microinteractions | Tier 1 |
| T20 | CTA 펄스/브리즈                 | Microinteractions | Tier 1 |
| T21 | 리플 효과                       | Microinteractions | Tier 1 |
| T22 | 스켈레톤 로딩                   | Microinteractions | Tier 1 |
| T23 | 옵티미스틱 UI                   | Microinteractions | Tier 2 |
| T24 | View Transitions API SPA        | Page Transitions  | Tier 1 |
| T25 | View Transitions API MPA        | Page Transitions  | Tier 1 |
| T26 | 모핑 히어로                     | Page Transitions  | Tier 2 |
| T27 | FLIP 공유 요소 전환             | Page Transitions  | Tier 2 |
| T28 | 스와이프/제스처 전환            | Page Transitions  | Tier 2 |
| T29 | 라우트 페이드/슬라이드          | Page Transitions  | Tier 2 |
| T30 | 제품 회전 뷰어                  | WebGL/3D          | WebGL  |
| T31 | R3F 씬 통합                     | WebGL/3D          | WebGL  |
| T32 | 셰이더 왜곡                     | WebGL/3D          | WebGL  |
| T33 | 파티클 시스템                   | WebGL/3D          | WebGL  |
| T34 | GLTF 제품 쇼케이스              | WebGL/3D          | WebGL  |
| T35 | 포스트 프로세싱                 | WebGL/3D          | WebGL  |
| T36 | SVG 패스 모핑                   | SVG/Canvas        | Tier 2 |
| T37 | Lottie 애니메이션               | SVG/Canvas        | Tier 2 |
| T38 | Rive 상태 머신                  | SVG/Canvas        | Tier 2 |
| T39 | SVG 필터 효과                   | SVG/Canvas        | Tier 2 |
| T40 | Canvas 제너러티브 아트          | SVG/Canvas        | Tier 3 |
| T41 | 가변 폰트 축 애니메이션         | Typography        | Tier 1 |
| T42 | 키네틱 타이포그래피             | Typography        | Tier 2 |
| T43 | 텍스트 마스크 리빌              | Typography        | Tier 2 |
| T44 | 텍스트 셰이프 마스크            | Typography        | Tier 1 |
| T45 | 마키 루프                       | Typography        | Tier 1 |
| T46 | 웨이브 텍스트                   | Typography        | Tier 2 |
| T47 | 드래그 앤 드롭 물리             | Gesture/Physical  | Tier 2 |
| T48 | 스와이프 카드 스택              | Gesture/Physical  | Tier 2 |
| T49 | 핀치 줌                         | Gesture/Physical  | Tier 2 |
| T50 | 스크롤 모멘텀                   | Gesture/Physical  | Tier 2 |
| T51 | 햅틱 피드백                     | Gesture/Physical  | Tier 2 |
| T52 | 개인화 애니메이션 타이밍        | AI-driven         | Tier 3 |
| T53 | AI 생성 히어로 영상             | AI-driven         | Tier 3 |
| T54 | 시선 추적 a11y                  | AI-driven         | Doc    |

---

## A11y-Motion 기법 목록 (접근성 핵심 기법)

prefers-reduced-motion 폴백 + ARIA 속성이 필수로 명시된 기법 중 접근성이 주된 목적인 항목:

| ID  | 기법명                   | 접근성 특이사항                                   |
|-----|--------------------------|---------------------------------------------------|
| T06 | 스크롤 트리거 리빌       | opacity-only 폴백                                 |
| T07 | 읽기 진행 바             | hidden 속성으로 숨김 가능                         |
| T22 | 스켈레톤 로딩            | aria-busy + aria-label 명시                       |
| T23 | 옵티미스틱 UI            | aria-live="polite" 상태 알림                      |
| T24 | View Transitions API SPA | prefers-reduced-motion 즉시 전환                  |
| T25 | View Transitions API MPA | 모든 브라우저 폴백 지원                           |
| T29 | 라우트 페이드/슬라이드   | 포커스 관리 필수 (새 페이지 상단 focus())         |
| T54 | 시선 추적 a11y           | 접근성 보조 기술 자체가 목적                      |

**A11y-Motion 전용 기법 수: 8개** (T54 포함 접근성 보조 목적, T22/T23/T54 핵심 3개 포함)

---

## 아키타입별 매트릭스

형식: 필수(M) / 권장(R) / 금지(X) / 해당없음(-)

### 아키타입 정의
- **CP**: cinematic-product
- **SD**: saas-dashboard
- **ED**: editorial
- **MP**: minimalist-portfolio
- **BR**: brutalist
- **EC**: ecommerce-premium
- **AI**: ai-product
- **DD**: docs-dev

---

### 카테고리 1: Scroll-driven

| 기법 ID | CP | SD | ED | MP | BR | EC | AI | DD | 메모 |
|---------|----|----|----|----|----|----|----|----|------|
| T01 스크롤-비디오 연동 | M | - | R | - | - | R | R | - | 고bandwidth 전용 |
| T02 이미지 프레임 시퀀스 | M | - | R | - | - | M | - | - | 레이지로드 필수 |
| T03 멀티레이어 패럴랙스 | R | - | M | R | X | R | - | - | minimalist는 선택적 |
| T04 핀드 섹션 | M | M | R | - | R | M | M | - | feature-showcase |
| T05 수평 스크롤 하이재킹 | - | X | M | R | M | - | - | X | a11y 대체 네비 필수 |
| T06 스크롤 트리거 리빌 | M | M | M | M | R | M | M | M | 전 아키타입 기본 |
| T07 읽기 진행 바 | - | - | M | - | - | - | - | M | 콘텐츠 길이 클 때 |
| T08 스크롤 연동 3D 카메라 | R | - | - | - | - | R | R | - | WebGL 환경 전용 |

카테고리 기법 수: 8

---

### 카테고리 2: Cinematic

| 기법 ID | CP | SD | ED | MP | BR | EC | AI | DD | 메모 |
|---------|----|----|----|----|----|----|----|----|------|
| T09 이스태블리싱 샷 | M | M | M | M | R | M | M | R | hero 공통 기본 |
| T10 매치컷 전환 | M | - | M | R | M | R | R | - | VTA 활용 |
| T11 디졸브/크로스페이드 | R | R | M | M | X | R | R | R | brutalist는 hard cut 선호 |
| T12 슬로우 줌 켄번즈 | M | - | M | M | X | M | - | - | hero 이미지 |
| T13 3D 카메라 팬/틸트 | M | - | - | - | - | R | R | - | WebGL 전용 |
| T14 포커스 풀 | M | R | R | R | X | M | M | - | GPU 주의 |
| T15 스플릿 스크린 리빌 | R | - | M | R | M | R | - | - | 에디토리얼 강점 |

카테고리 기법 수: 7

---

### 카테고리 3: Microinteractions

| 기법 ID | CP | SD | ED | MP | BR | EC | AI | DD | 메모 |
|---------|----|----|----|----|----|----|----|----|------|
| T16 마그네틱 버튼 | R | - | R | M | M | R | R | - | hover 기기 전용 |
| T17 3D 틸트 호버 | M | R | - | R | R | M | R | - | 카드 UI 적합 |
| T18 글자별 리빌 | M | - | M | R | M | - | M | - | hero-text |
| T19 숫자 카운터 | R | M | R | - | R | M | M | R | 통계 섹션 |
| T20 CTA 펄스/브리즈 | M | M | R | R | X | M | M | R | CTA 필수 |
| T21 리플 효과 | - | M | - | - | R | R | M | R | 버튼/카드 |
| T22 스켈레톤 로딩 | R | M | - | - | - | M | M | M | 로딩 UX |
| T23 옵티미스틱 UI | - | M | - | - | - | M | M | R | aria-live 필수 |

카테고리 기법 수: 8

---

### 카테고리 4: Page Transitions

| 기법 ID | CP | SD | ED | MP | BR | EC | AI | DD | 메모 |
|---------|----|----|----|----|----|----|----|----|------|
| T24 View Transitions SPA | M | M | M | M | R | M | M | M | SPA 전용 |
| T25 View Transitions MPA | - | - | M | R | R | R | - | M | MPA/docs |
| T26 모핑 히어로 | M | R | M | M | - | M | R | - | Framer layoutId |
| T27 FLIP 공유 요소 | R | M | R | R | - | M | M | R | list-to-detail |
| T28 스와이프/제스처 전환 | - | - | - | - | - | R | - | - | 모바일 전용 |
| T29 라우트 페이드/슬라이드 | R | R | M | R | R | R | R | M | a11y focus 관리 |

카테고리 기법 수: 6 (T28 별도)

---

### 카테고리 5: WebGL/3D

| 기법 ID | CP | SD | ED | MP | BR | EC | AI | DD | 메모 |
|---------|----|----|----|----|----|----|----|----|------|
| T30 제품 회전 뷰어 | M | - | - | - | - | M | - | - | 정지 이미지 폴백 필수 |
| T31 R3F 씬 통합 | M | - | R | R | R | R | M | - | 성능 예산 필수 |
| T32 셰이더 왜곡 | M | - | R | - | M | R | M | - | 창의적 효과 |
| T33 파티클 시스템 | M | - | R | - | R | R | M | - | aria-hidden |
| T34 GLTF 쇼케이스 | M | - | - | - | - | M | - | - | e-commerce 핵심 |
| T35 포스트 프로세싱 | R | - | - | - | - | R | R | - | 저사양 비활성 |

카테고리 기법 수: 6

---

### 카테고리 6: SVG/Canvas

| 기법 ID | CP | SD | ED | MP | BR | EC | AI | DD | 메모 |
|---------|----|----|----|----|----|----|----|----|------|
| T36 SVG 패스 모핑 | R | - | M | R | M | R | R | - | 로고/아이콘 |
| T37 Lottie 애니메이션 | M | M | R | R | - | M | M | M | 온보딩/아이콘 |
| T38 Rive 상태 머신 | R | M | R | R | - | R | M | R | 인터랙티브 일러스트 |
| T39 SVG 필터 효과 | R | - | M | - | M | - | R | - | 모션 민감성 주의 |
| T40 Canvas 제너러티브 | R | - | R | - | M | - | R | - | 실험적 |

카테고리 기법 수: 5

---

### 카테고리 7: Typography

| 기법 ID | CP | SD | ED | MP | BR | EC | AI | DD | 메모 |
|---------|----|----|----|----|----|----|----|----|------|
| T41 가변 폰트 축 애니메이션 | M | M | M | M | M | M | M | R | 전 아키타입 적용 가능 |
| T42 키네틱 타이포그래피 | M | - | M | R | M | R | R | - | hero-text |
| T43 텍스트 마스크 리빌 | M | R | M | M | M | M | M | - | hero/landing |
| T44 텍스트 셰이프 마스크 | R | - | M | R | M | R | R | - | 대비 필수 |
| T45 마키 루프 | R | - | M | - | M | M | R | - | social-proof |
| T46 웨이브 텍스트 | R | - | M | - | R | - | R | - | 에디토리얼 강점 |

카테고리 기법 수: 6

---

### 카테고리 8: Gesture/Physical

| 기법 ID | CP | SD | ED | MP | BR | EC | AI | DD | 메모 |
|---------|----|----|----|----|----|----|----|----|------|
| T47 드래그 앤 드롭 물리 | - | M | - | - | - | R | M | R | kanban/대시보드 |
| T48 스와이프 카드 스택 | - | - | - | - | - | R | R | - | 모바일 전용 |
| T49 핀치 줌 | - | - | - | R | - | M | - | - | 모바일 갤러리 |
| T50 스크롤 모멘텀 | M | R | M | M | M | M | M | R | Lenis 8KB |
| T51 햅틱 피드백 | - | - | - | - | - | R | R | - | Android 전용 |

카테고리 기법 수: 5

---

### 카테고리 9: AI-driven

| 기법 ID | CP | SD | ED | MP | BR | EC | AI | DD | 메모 |
|---------|----|----|----|----|----|----|----|----|------|
| T52 개인화 애니메이션 타이밍 | R | M | - | - | - | M | M | - | RUM 인프라 필요 |
| T53 AI 생성 히어로 영상 | M | - | M | - | - | R | M | - | Remotion SSR |
| T54 시선 추적 a11y | - | - | - | - | - | - | R | R | Doc 단계 |

카테고리 기법 수: 3

---

## 아키타입별 기법 수 요약

아래 표는 필수(M) + 권장(R) 합계. 목표 달성 여부 표시.

| 아키타입 | 필수(M) | 권장(R) | 합계 | 목표 | 달성 |
|----------|---------|---------|------|------|------|
| CP cinematic-product | 22 | 16 | 38 | >=28 | 달성 |
| SD saas-dashboard | 13 | 12 | 25 | >=28 | 미달 — T01/T03/T13/T32/T33 권장 추가 시 30 |
| ED editorial | 19 | 14 | 33 | >=28 | 달성 |
| MP minimalist-portfolio | 10 | 16 | 26 | >=28 | 미달 — T03/T06/T11 M 추가 시 29 |
| BR brutalist | 6 | 15 | 21 | >=28 | 미달 — T06/T41/T43/T50 M 전환 + R 추가 시 28 |
| EC ecommerce-premium | 20 | 17 | 37 | >=28 | 달성 |
| AI ai-product | 18 | 15 | 33 | >=28 | 달성 |
| DD docs-dev | 9 | 10 | 19 | >=20 | 미달 — T09/T37/T25 M 유지 + T19/T22/T47 M 확보 시 20 |

---

## 보정 규칙 (목표 미달 아키타입 처리)

saas-dashboard, minimalist-portfolio, brutalist, docs-dev는 Phase 2 selector 알고리즘에서
(b) 권장 채움 단계가 자동으로 목표치까지 보충한다. 아래는 아키타입별 보충 우선순위 예시.

| 아키타입 | 보충 우선 기법 |
|----------|----------------|
| SD | T01, T03, T13 (Scroll-driven/Cinematic 고임팩트 순) |
| MP | T03, T11, T16 (시각 강도 낮은 순) |
| BR | T36, T39, T40 (SVG/Canvas 실험적 순) |
| DD | T22, T23, T47 (UX 기능성 순) |

---

## Mermaid 요약 (ASCII 대체)

```
+------------------+----+----+----+----+----+----+----+----+
| Category         | CP | SD | ED | MP | BR | EC | AI | DD |
+------------------+----+----+----+----+----+----+----+----+
| Scroll-driven(8) |  6 |  3 |  5 |  3 |  3 |  5 |  4 |  3 |
| Cinematic(7)     |  7 |  2 |  6 |  5 |  3 |  6 |  5 |  2 |
| Microinterac.(8) |  5 |  7 |  4 |  3 |  4 |  7 |  8 |  6 |
| Page Trans.(6)   |  5 |  5 |  6 |  5 |  3 |  6 |  5 |  5 |
| WebGL/3D(6)      |  6 |  0 |  2 |  1 |  2 |  5 |  4 |  0 |
| SVG/Canvas(5)    |  3 |  2 |  4 |  2 |  3 |  3 |  4 |  2 |
| Typography(6)    |  5 |  2 |  6 |  4 |  5 |  5 |  6 |  1 |
| Gesture/Phys.(5) |  2 |  3 |  2 |  3 |  2 |  4 |  4 |  2 |
| AI-driven(3)     |  2 |  2 |  1 |  0 |  0 |  2 |  3 |  1 |
+------------------+----+----+----+----+----+----+----+----+
| TOTAL (M+R)      | 41 | 26 | 36 | 26 | 25 | 43 | 43 | 22 |
+------------------+----+----+----+----+----+----+----+----+
(숫자 = 필수+권장 합계, 목표: CP/SD/ED/MP/BR/EC/AI>=28, DD>=20)
```

---

## 카테고리별 기법 수 확인

| 카테고리 | 기법 수 | ID 범위 |
|----------|---------|---------|
| Scroll-driven | 8 | T01~T08 |
| Cinematic | 7 | T09~T15 |
| Microinteractions | 8 | T16~T23 |
| Page Transitions | 6 | T24~T29 |
| WebGL/3D | 6 | T30~T35 |
| SVG/Canvas | 5 | T36~T40 |
| Typography | 6 | T41~T46 |
| Gesture/Physical | 5 | T47~T51 |
| AI-driven | 3 | T52~T54 |
| **합계** | **54** | T01~T54 |

> 참고: motion-techniques-full.md Index는 "52기법"으로 표기하나 실제 헤더 번호는 1~54 (Typography 5->6개, AI-driven 내 T52/T53/T54). 본 매트릭스는 실제 기법 54개 기준.
