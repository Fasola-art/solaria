# Motion Selector — 결정론적 알고리즘


## Contents

- [입출력 스키마](#입출력-스키마)
  - [입력 스키마](#입력-스키마)
  - [출력 스키마](#출력-스키마)
- [결정론적 선택 알고리즘 의사코드](#결정론적-선택-알고리즘-의사코드)
- [prefers-reduced-motion 기본 대체 매핑](#prefers-reduced-motion-기본-대체-매핑)
- [충돌 해결 규칙](#충돌-해결-규칙)
- [예시 출력 (실제 기법 ID 나열)](#예시-출력-실제-기법-id-나열)
  - [예시 1: cinematic-product / desktop / 기본 예산](#예시-1-cinematic-product-desktop-기본-예산)
  - [예시 2: saas-dashboard / both / 엄격 예산 (tier3Allowed: false)](#예시-2-saas-dashboard-both-엄격-예산-tier3allowed-false)
  - [예시 3: docs-dev / desktop / 기본 예산](#예시-3-docs-dev-desktop-기본-예산)
- [Tier 정의 참조](#tier-정의-참조)

> 입력: {archetype, viewport, perfBudget} → 출력: [{id, tier, lazy, fallback}]
> 기법 ID: motion-archetype-matrix.md T01~T54 기준
> 아키타입 목표: CP/SD/ED/MP/BR/EC/AI >= 28, DD >= 20

---

## 입출력 스키마

### 입력 스키마

```typescript
type Archetype =
  | 'cinematic-product'
  | 'saas-dashboard'
  | 'editorial'
  | 'minimalist-portfolio'
  | 'brutalist'
  | 'ecommerce-premium'
  | 'ai-product'
  | 'docs-dev';

type Viewport = 'desktop' | 'mobile' | 'both';

// perfBudget: Tier1 JS 추가 허용량 (KB). 기본 15KB
// tier3Allowed: WebGL/Tier3 허용 여부
// a11yStrict: true 시 prefers-reduced-motion 대체 강제
type PerfBudget = {
  tier1ExtraKB: number;   // 기본 15
  tier3Allowed: boolean;  // 기본 archetype에 따라 결정
  a11yStrict: boolean;    // 기본 false
};

type SelectorInput = {
  archetype: Archetype;
  viewport: Viewport;
  perfBudget?: Partial<PerfBudget>;
};
```

### 출력 스키마

```typescript
type TechniqueEntry = {
  id: string;         // 예: "T06"
  name: string;       // 예: "스크롤 트리거 리빌"
  tier: 'Tier1' | 'Tier2' | 'Tier3' | 'WebGL' | 'Doc';
  lazy: boolean;      // true = 지연 로드 필요 (Tier3/WebGL/large bundle)
  fallback: string;   // prefers-reduced-motion 대체 설명
  bundleKB: number;   // 예상 JS 추가 번들 (0=CSS 전용)
};

type SelectorOutput = {
  archetype: Archetype;
  totalCount: number;
  categoryCount: number;    // 활성 카테고리 수 (목표 >= 7)
  tier1ExtraKBUsed: number;
  techniques: TechniqueEntry[];
  conflicts: string[];      // 충돌 해결 로그
};
```

---

## 결정론적 선택 알고리즘 의사코드

```
FUNCTION selectMotionTechniques(input: SelectorInput) -> SelectorOutput:

  // 기본값 설정
  budget = {
    tier1ExtraKB: input.perfBudget.tier1ExtraKB ?? 15,
    tier3Allowed: input.perfBudget.tier3Allowed ?? archetype IN [
      'cinematic-product', 'editorial', 'ecommerce-premium', 'ai-product'
    ],
    a11yStrict: input.perfBudget.a11yStrict ?? false
  }
  target = (input.archetype == 'docs-dev') ? 20 : 28

  matrix = LOAD motion-archetype-matrix.md[input.archetype]

  // --- (a) 필수 기법 전부 선택 ---
  selected = []
  FOR each technique T IN matrix WHERE matrix[T][archetype] == 'M':
    IF T.tier == 'WebGL' AND NOT budget.tier3Allowed:
      SKIP  // WebGL 예산 없으면 제외, conflict 로그 기록
    ELSE IF T.tier == 'Doc':
      SKIP  // Doc 단계는 항상 제외
    ELSE:
      selected.APPEND(T)

  // --- (b) 권장에서 목표 미달분 채움 ---
  IF len(selected) < target:
    recommended = [T FOR T IN matrix WHERE matrix[T][archetype] == 'R'
                   AND T NOT IN selected
                   AND T.tier != 'Doc']
    // 우선순위: Tier1 > Tier2 > Tier3/WebGL
    recommended.SORT_BY(tier_priority ASC, bundleKB ASC)
    FOR T IN recommended WHILE len(selected) < target:
      IF T.tier IN ['Tier3', 'WebGL'] AND NOT budget.tier3Allowed:
        CONTINUE
      selected.APPEND(T)

  // --- (c) 카테고리 다양성 >= 7 보장 ---
  active_categories = UNIQUE(T.category FOR T IN selected)
  IF len(active_categories) < 7:
    missing_cats = ALL_CATEGORIES - active_categories
    FOR cat IN missing_cats WHILE len(active_categories) < 7:
      // 해당 카테고리에서 Tier1 우선으로 1개 추가 (금지 아닌 것)
      candidate = FIRST(T FOR T IN matrix
                        WHERE T.category == cat
                        AND matrix[T][archetype] != 'X'
                        AND T.tier != 'Doc'
                        AND T NOT IN selected,
                        ORDER_BY tier_priority ASC)
      IF candidate:
        selected.APPEND(candidate)
        active_categories.ADD(cat)

  // --- (d) Tier1 JS +15KB 이하 예산 관리 ---
  tier1_kb_used = SUM(T.bundleKB FOR T IN selected WHERE T.tier == 'Tier1')
  IF tier1_kb_used > budget.tier1ExtraKB:
    // 번들 큰 Tier1 기법을 CSS 대체 가능 버전으로 교체
    // 교체 불가 시 권장(R) Tier1 기법 제거 (필수는 유지)
    overflow = [T FOR T IN selected
                WHERE T.tier == 'Tier1'
                AND matrix[T][archetype] == 'R'
                ORDER_BY T.bundleKB DESC]
    REMOVE overflow UNTIL tier1_kb_used <= budget.tier1ExtraKB

  // --- (e) Tier3/WebGL lazy 플래그 설정 ---
  FOR T IN selected:
    T.lazy = (T.tier IN ['Tier3', 'WebGL']) OR (T.bundleKB >= 40)

  // --- (f) prefers-reduced-motion 대체 설정 ---
  FOR T IN selected:
    IF T.fallback IS EMPTY:
      T.fallback = DEFAULT_FALLBACKS[T.id]  // 아래 매핑 참조
    IF budget.a11yStrict AND T.fallback == 'none':
      selected.REMOVE(T)  // 대체 없는 기법 제거

  // --- 뷰포트 필터 ---
  IF input.viewport == 'mobile':
    // desktop-only 기법 제거: T05, T08, T13, T16 (마그네틱 버튼 hover 전용)
    selected.REMOVE_IF(T.id IN ['T05', 'T08', 'T13', 'T16'])
  ELSE IF input.viewport == 'desktop':
    // mobile-only 기법 제거: T28, T48, T49, T51
    selected.REMOVE_IF(T.id IN ['T28', 'T48', 'T49', 'T51'])

  RETURN SelectorOutput{
    archetype: input.archetype,
    totalCount: len(selected),
    categoryCount: len(UNIQUE(T.category FOR T IN selected)),
    tier1ExtraKBUsed: SUM(T.bundleKB FOR T IN selected WHERE T.tier == 'Tier1'),
    techniques: selected,
    conflicts: conflict_log
  }
```

---

## prefers-reduced-motion 기본 대체 매핑

| ID | 기법명 | 대체 (reduced-motion) |
|----|--------|-----------------------|
| T01 | 스크롤-비디오 연동 | video.pause() — 정지 프레임 |
| T02 | 이미지 프레임 시퀀스 | 첫 번째 프레임 정지 이미지 |
| T03 | 멀티레이어 패럴랙스 | transform 제거 — 정렬 유지 |
| T04 | 핀드 섹션 | 일반 스크롤, 섹션 점프 링크 |
| T05 | 수평 스크롤 하이재킹 | 수직 스크롤 + 키보드 대체 네비 |
| T06 | 스크롤 트리거 리빌 | opacity-only 전환 |
| T07 | 읽기 진행 바 | 숨김 처리 (hidden 속성) |
| T08 | 스크롤 연동 3D 카메라 | 정지 씬 렌더 |
| T09 | 이스태블리싱 샷 | 즉시 표시 (animation 없음) |
| T10 | 매치컷 전환 | 단순 opacity 페이드 |
| T11 | 디졸브/크로스페이드 | 즉시 전환 |
| T12 | 슬로우 줌 켄번즈 | 고정 이미지 |
| T13 | 3D 카메라 팬/틸트 | 정지 씬 |
| T14 | 포커스 풀 | blur 제거 |
| T15 | 스플릿 스크린 리빌 | 순차 표시 |
| T16 | 마그네틱 버튼 | hover 없음 — 일반 버튼 |
| T17 | 3D 틸트 호버 | hover:none 미적용 |
| T18 | 글자별 리빌 | aria-label 원본 즉시 표시 |
| T19 | 숫자 카운터 | 최종값 즉시 표시 |
| T20 | CTA 펄스/브리즈 | 정지 |
| T21 | 리플 효과 | focus-visible 링 유지 |
| T22 | 스켈레톤 로딩 | aria-busy + 즉시 콘텐츠 |
| T23 | 옵티미스틱 UI | aria-live="polite" 상태 알림 |
| T24 | View Transitions SPA | 즉시 전환 |
| T25 | View Transitions MPA | 즉시 로드 |
| T26 | 모핑 히어로 | 즉시 전환 |
| T27 | FLIP 공유 요소 | 즉시 이동 |
| T28 | 스와이프 전환 | 탭/버튼 네비 |
| T29 | 라우트 페이드/슬라이드 | 즉시 전환 + focus() 유지 |
| T30 | 제품 회전 뷰어 | 정지 이미지 |
| T31 | R3F 씬 통합 | canvas aria-label + 정지 |
| T32 | 셰이더 왜곡 | 셰이더 비활성 |
| T33 | 파티클 시스템 | aria-hidden 정지 배경 |
| T34 | GLTF 쇼케이스 | alt 텍스트 + 정지 이미지 |
| T35 | 포스트 프로세싱 | 비활성 (저사양 동일 처리) |
| T36 | SVG 패스 모핑 | 최종 상태 즉시 표시 |
| T37 | Lottie 애니메이션 | 첫 프레임 정지 |
| T38 | Rive 상태 머신 | 기본 상태 고정 |
| T39 | SVG 필터 효과 | 필터 제거 |
| T40 | Canvas 제너러티브 아트 | 정지 이미지 대체 |
| T41 | 가변 폰트 축 애니메이션 | 고정 weight |
| T42 | 키네틱 타이포그래피 | aria-label 즉시 표시 |
| T43 | 텍스트 마스크 리빌 | visibility 해제 즉시 표시 |
| T44 | 텍스트 셰이프 마스크 | color 대비 유지 고정 |
| T45 | 마키 루프 | 정지 + aria-hidden 중복 |
| T46 | 웨이브 텍스트 | 정지 텍스트 |
| T47 | 드래그 앤 드롭 물리 | 키보드 D&D (aria-grabbed) |
| T48 | 스와이프 카드 스택 | 버튼 대체 액션 |
| T49 | 핀치 줌 | 더블탭 확대 + 키보드 +/- |
| T50 | 스크롤 모멘텀 | Lenis duration: 0 |
| T51 | 햅틱 피드백 | 시각적 피드백으로 대체 |
| T52 | 개인화 타이밍 | 기본 duration 적용 |
| T53 | AI 생성 히어로 영상 | 자막 + 정지 이미지 |
| T54 | 시선 추적 a11y | 완전 폴백 필수 |

---

## 충돌 해결 규칙

| 충돌 유형 | 규칙 |
|-----------|------|
| T05(수평 스크롤) + T03(패럴랙스) 동시 | T05 우선, T03 해당 섹션 비활성 |
| WebGL(T30~T35) + 예산 미달 | Tier3 전체 lazy=true + deviceMemory < 4GB 시 정지 폴백 |
| T16(마그네틱) + mobile viewport | T16 제거, T20(펄스)로 대체 |
| T05 + a11yStrict | T05 제거 (키보드 대체 불충분) |
| T08 + T13 동시 (3D 카메라 중복) | archetype에 따라 T08(Scroll) 또는 T13(Cinematic) 1개 선택 |
| T53(AI 영상) + Doc 단계 T54 | T54는 항상 제외 (Doc 규칙), T53은 tier3Allowed 의존 |
| typography 기법 3개 이상 | T41+T43 필수 유지, 나머지 권장 순 1개 선택 (번들 최소화) |
| Framer Motion 중복 번들 | T26+T27+T47 동시 선택 시 단일 Framer 번들로 통합 (40KB 1회) |

---

## 예시 출력 (실제 기법 ID 나열)

### 예시 1: cinematic-product / desktop / 기본 예산

```
입력: { archetype: 'cinematic-product', viewport: 'desktop', perfBudget: { tier1ExtraKB: 15, tier3Allowed: true } }

(a) 필수 기법:
  T01(스크롤-비디오), T02(프레임 시퀀스), T04(핀드 섹션), T06(스크롤 리빌),
  T09(이스태블리싱 샷), T10(매치컷), T12(켄번즈), T13(3D 팬/틸트),
  T14(포커스 풀), T17(3D 틸트), T18(글자별 리빌), T20(CTA 펄스),
  T24(VTA SPA), T26(모핑 히어로), T30(제품 회전), T31(R3F 씬),
  T32(셰이더 왜곡), T33(파티클), T34(GLTF), T41(가변 폰트),
  T42(키네틱 타이포), T43(텍스트 마스크), T50(스크롤 모멘텀), T53(AI 영상)
  => 필수 24개

(b) 권장 채움 (목표 28):
  T08(3D 카메라 스크롤), T11(디졸브), T19(숫자 카운터), T37(Lottie)
  => +4개 = 28개 달성

(c) 카테고리 확인: 9개 모두 활성 (>= 7 충족)

(d) Tier1 JS 예산: T06=0KB, T07=0KB, T09=0KB ... Tier1 총 0KB (모두 CSS)

(e) lazy 설정: T08, T13, T30, T31, T32, T33, T34, T35, T40, T53 → lazy=true

(f) 대체: 전 기법 위 매핑 적용

최종 출력: 28기법, 카테고리 9개, Tier1 JS 0KB
```

기법 목록:
- Scroll-driven(6): T01 T02 T04 T06 T08 (lazy)
- Cinematic(6): T09 T10 T11 T12 T13(lazy) T14
- Microinteractions(3): T17 T18 T20
- Page Transitions(2): T24 T26
- WebGL/3D(5): T30(lazy) T31(lazy) T32(lazy) T33(lazy) T34(lazy)
- SVG/Canvas(1): T37
- Typography(3): T41 T42 T43
- Gesture/Physical(1): T50
- AI-driven(1): T53(lazy)

---

### 예시 2: saas-dashboard / both / 엄격 예산 (tier3Allowed: false)

```
입력: { archetype: 'saas-dashboard', viewport: 'both', perfBudget: { tier1ExtraKB: 15, tier3Allowed: false, a11yStrict: true } }

(a) 필수 기법 (WebGL 제외):
  T04(핀드 섹션), T06(스크롤 리빌), T09(이스태블리싱 샷), T19(숫자 카운터),
  T20(CTA 펄스), T21(리플), T22(스켈레톤), T23(옵티미스틱 UI),
  T24(VTA SPA), T27(FLIP), T37(Lottie), T38(Rive), T41(가변 폰트),
  T47(드래그&드롭), T52(개인화 타이밍)
  => 필수 15개 (T30~T35 WebGL 제외)

(b) 권장 채움 (목표 28):
  T01, T03, T11, T14, T17, T22(이미 포함), T25, T26, T29, T36, T43, T50, T54(Doc 제외)
  실제 추가: T01 T03 T11 T14 T17 T25 T26 T29 T36 T43 T50
  => +11개 = 26개

  추가 필요 2개: T02, T07
  => 28개 달성

(c) 카테고리: Scroll(3) Cinematic(3) Micro(6) PageTrans(4) SVG(2) Typo(2) Gesture(2) AI(1) => 8개 (>= 7 충족)
  (WebGL 0 — tier3Allowed: false로 의도적 제외)

(d) Tier1: T06=0KB, T09=0KB, T19=1KB, T20=0KB, T21=2KB, T22=0KB, T24=0KB, T41=0KB
  => 합계 3KB < 15KB 충족

(e) lazy: T37(60KB->lazy=true), T38(42KB->lazy=true), T47(40KB->lazy=true), T52(서버->lazy=true)

(f) a11yStrict: T39(SVG 필터, 모션 민감성) 제외됨

뷰포트 both: T28, T48, T49, T51 mobile-only는 포함 (both이므로 유지)
T16(마그네틱) 데스크탑 전용 — SD에서 M/R 아님, 미선택

최종 출력: 28기법, 카테고리 8개, Tier1 JS 3KB
```

기법 목록:
- Scroll-driven(4): T01 T02 T03 T06
- Cinematic(3): T09 T11 T14
- Microinteractions(6): T17 T19 T20 T21 T22 T23
- Page Transitions(4): T24 T25 T26 T27
- WebGL/3D(0): 전부 제외
- SVG/Canvas(3): T36 T37(lazy) T38(lazy)
- Typography(2): T41 T43
- Gesture/Physical(3): T29 T47(lazy) T50
- AI-driven(1): T52(lazy) + T07(진행 바) 추가

---

### 예시 3: docs-dev / desktop / 기본 예산

```
입력: { archetype: 'docs-dev', viewport: 'desktop', perfBudget: { tier1ExtraKB: 15, tier3Allowed: false } }

목표: 20기법, 카테고리 >= 7

(a) 필수 기법:
  T06(스크롤 리빌), T07(읽기 진행 바), T09(이스태블리싱 샷), T19(숫자 카운터),
  T20(CTA 펄스), T21(리플), T22(스켈레톤), T23(옵티미스틱 UI),
  T24(VTA SPA), T25(VTA MPA), T27(FLIP), T29(라우트 페이드),
  T37(Lottie), T38(Rive), T47(드래그&드롭)
  => 필수 15개

(b) 권장 채움 (목표 20):
  T11(디졸브), T41(가변 폰트), T50(스크롤 모멘텀), T54(시선추적 — Doc 제외), T52
  실제 추가: T11 T41 T50 T52(optional)
  => +3개 = 18개 (T52 추가 = 19개)
  추가 1개: T04(핀드 섹션 — R 미포함이나 카테고리 보충용)
  => 20개 달성

(c) 카테고리: Scroll(3) Cinematic(2) Micro(6) PageTrans(4) SVG(2) Typo(1) Gesture(2) AI(1)
  => 8개 (>= 7 충족)

(d) Tier1 JS: T19=1KB T21=2KB => 3KB < 15KB

(e) lazy: T37(lazy) T38(lazy) T47(lazy) T52(lazy)

(f) 대체: 전 기법 위 매핑 적용

최종 출력: 20기법, 카테고리 8개, Tier1 JS 3KB
```

기법 목록:
- Scroll-driven(3): T04 T06 T07
- Cinematic(2): T09 T11
- Microinteractions(6): T19 T20 T21 T22 T23 (+ T17 제외)
- Page Transitions(4): T24 T25 T27 T29
- WebGL/3D(0): 제외
- SVG/Canvas(2): T37(lazy) T38(lazy)
- Typography(1): T41
- Gesture/Physical(2): T47(lazy) T50
- AI-driven(1): T52(lazy)

---

## Tier 정의 참조

| Tier | lazy 기본값 | 번들 기준 |
|------|-------------|-----------|
| Tier1 | false | 0~최소 JS (CSS 전용) |
| Tier2 | false (>= 40KB 시 true) | GSAP/Framer ~30-60KB |
| Tier3 | true (항상) | WebGL/Three.js ~160KB+ |
| WebGL | true (항상) | Three.js/R3F ~160-200KB |
| Doc | 항상 제외 | 프로덕션 미적용 |
