# Video Cinematic Reference


## Contents

- [1. 영상 팀 3인 역할 정의](#1-영상-팀-3인-역할-정의)
  - [1-1. Cinematic Director](#1-1-cinematic-director)
  - [1-2. Video Engineer](#1-2-video-engineer)
  - [1-3. Motion Designer](#1-3-motion-designer)
- [2. Cinematic Director 시그니처 기법 카탈로그 (10종)](#2-cinematic-director-시그니처-기법-카탈로그-10종)
- [3. Stage 1 시네마틱 체크리스트 (기획 단계)](#3-stage-1-시네마틱-체크리스트-기획-단계)
- [4. 안티패턴 (Anti-pattern) - 사용 금지](#4-안티패턴-anti-pattern---사용-금지)
- [5. Video Engineer - 코덱 폴백 체인](#5-video-engineer---코덱-폴백-체인)
  - [5-1. 우선순위 체인](#5-1-우선순위-체인)
  - [5-2. HTML 구현](#5-2-html-구현)
- [6. 스트리밍 플랫폼 비교](#6-스트리밍-플랫폼-비교)
- [7. Stage 3 영상 구현 체크리스트 (개발 단계)](#7-stage-3-영상-구현-체크리스트-개발-단계)
- [8. Stage 5 QA - 영상 성능 게이트](#8-stage-5-qa---영상-성능-게이트)
- [9. Remotion SSR 패턴](#9-remotion-ssr-패턴)
  - [9-1. 아키텍처 선택 기준](#9-1-아키텍처-선택-기준)
  - [9-2. Vercel Functions API Route 패턴](#9-2-vercel-functions-api-route-패턴)
  - [9-3. Lambda 트레이드오프 요약](#9-3-lambda-트레이드오프-요약)
- [참고: motion-guide.md 위임 범위](#참고-motion-guidemd-위임-범위)
- [스톡 영상/푸티지 소스](#스톡-영상푸티지-소스)
  - [무료 CC0 소스](#무료-cc0-소스)
  - [검색 키워드 템플릿](#검색-키워드-템플릿)
  - [Remotion 통합](#remotion-통합)
  - [라이선스 체크리스트](#라이선스-체크리스트)
  - [해상도/코덱 최소 기준](#해상도코덱-최소-기준)
  - [AI 생성 vs 스톡 혼용 원칙](#ai-생성-vs-스톡-혼용-원칙)

> 영상 팀 3인 역할 정의, 시네마틱 기법 카탈로그, 코덱/스트리밍/QA 게이트

---

## 1. 영상 팀 3인 역할 정의

### 1-1. Cinematic Director

책임: 스토리텔링 구조와 시각 언어 설계

- 3-Act 내러티브: Hook(0-3s) -> Development(3-15s) -> Resolution(15s+)
- 쇼트 시퀀스: Establishing -> Mid -> Close-Up -> Detail 순서 설계
- LUT 팔레트: 브랜드 감성에 맞는 색조 선택 및 강도 조정
- 트랜지션: Cut / Dissolve / Match Cut / Wipe 중 내러티브 목적에 따라 선택
- 영상 vs 정적 콘텐츠 판단: ROI 기준 - 정적으로 전달 가능하면 영상 금지

### 1-2. Video Engineer

책임: 기술 구현, 코덱 파이프라인, 성능 게이트

- 코덱 폴백 체인 관리 (섹션 3 참조)
- 스트리밍 플랫폼 선택 및 통합 (섹션 4 참조)
- Remotion SSR 파이프라인 구축 (섹션 5 참조)
- Stage 3 구현 체크리스트 실행 (섹션 6 참조)
- Stage 5 성능 게이트 통과 검증 (섹션 7 참조)

### 1-3. Motion Designer

책임: UI 모션, 마이크로인터랙션, 애니메이션 시스템

- 3-Tier Motion v2 시스템 적용
- Tier 1: CSS animation-timeline (0KB)
- Tier 2: Motion for React (경량)
- Tier 3: GSAP (복잡한 시퀀스)
- 상세 정의: motion-guide.md로 위임 (SSOT)

---

## 2. Cinematic Director 시그니처 기법 카탈로그 (10종)

| 기법 | 설명 | 적용 시점 | 주의 |
|------|------|----------|------|
| Establishing Shot Hero | 전체 맥락을 설정하는 첫 쇼트. 넓은 앵글로 공간/제품 전체 노출 | Act 1 시작 | 3초 이내 핵심 제시 |
| Staggered Reveal | 요소를 순차적으로 등장시켜 긴장감 형성 | 기능 소개 시퀀스 | 간격 100-150ms, 8개 이하 |
| Parallax Depth | 전/중/후경 이동 속도 차이로 입체감 생성 | 히어로 배경 | will-change 제한, 모바일 비활성화 |
| Match Cut | 형태/색상/움직임이 유사한 두 쇼트를 이음새 없이 전환 | Act 1->2 전환 | 연결 논리 명확해야 함 |
| LUT Apply | 색조 룩업 테이블로 일관된 색감 부여 | 모든 영상 소재 | 강도 0.6-0.8 권장, 1.0 금지 |
| Close-Up Detail | 제품/UI 세부 요소 클로즈업으로 품질 강조 | 기능 설명 후 | 포커스 흐림 전환과 쌍 사용 |
| Dissolve | 두 장면을 서서히 오버랩 전환 | 시간 경과 표현 | 0.3-0.5s 권장, 남용 금지 |
| 3D Camera Pan | 카메라가 3D 공간을 이동하며 제품 전체 탐색 | 제품 소개 | Remotion 또는 CSS transform3d |
| Frame Sequence Loop | 핵심 동작을 짧게 루프 (3-5초) | 기능 데모 | 완벽한 루프포인트 필수, 무한루프 금지 |
| Slow Zoom | 서서히 줌인/줌아웃으로 집중도 상승 | 클라이맥스 직전 | 배율 1.0->1.15 이하, 과도한 줌 금지 |

---

## 3. Stage 1 시네마틱 체크리스트 (기획 단계)

1. 3-Act 맵핑: Hook / Development / Resolution 각 구간 초 단위 정의 완료 여부
2. 쇼트 스토리보드: 각 쇼트 앵글, 지속 시간, 전환 방식 문서화 여부
3. LUT 팔레트: 브랜드 무드보드 대비 LUT 2-3개 후보 선정 및 강도 결정 여부
4. 트랜지션 타입: 각 컷마다 전환 방식(Cut/Dissolve/Match Cut) 명시 여부
5. 영상 vs 정적 판단: 정적 이미지로 대체 가능한 구간 식별 및 제거 여부
6. 포커싱 흐름: 시청자 시선 유도 경로(왼쪽->오른쪽, 중앙->주변) 설계 여부
7. Anti-slop 검토: 아래 3개 안티패턴 해당 없음 확인 여부

---

## 4. 안티패턴 (Anti-pattern) - 사용 금지

**포화도 과다 AI 영상**
- 증상: AI 생성 영상의 과포화 색상, 부자연스러운 움직임, 불일치 조명
- 금지 이유: 브랜드 신뢰도 훼손, 시청자 이탈
- 대안: 실제 촬영 + LUT 후보정, 또는 Remotion 코드 기반 영상

**무한 루프 (uncontrolled loop)**
- 증상: 루프 포인트 불명확, 시작/끝 튐, 자동재생 무한 반복
- 금지 이유: 주의 분산, 인지 과부하, 배터리 소모
- 대안: Frame Sequence Loop (3-5초, 명확한 루프포인트, loop 횟수 제한)

**AI 인물 + 음성 합성**
- 증상: AI 생성 인물 영상에 TTS 음성 합성 조합
- 금지 이유: 신뢰도 훼손, 법적 리스크, 플랫폼 정책 위반 가능성
- 대안: 실제 인물 촬영 또는 인물 없는 제품/UI 중심 영상

---

## 5. Video Engineer - 코덱 폴백 체인

### 5-1. 우선순위 체인

```
AV1 (.webm)  -> 최고 압축률, Chrome 90+ / Firefox 93+ / Safari 17+
VP9 (.webm)  -> 차선, Chrome 29+ / Firefox 28+ / Edge 18+
H.264 (.mp4) -> 최후 폴백, 모든 모던 브라우저
```

### 5-2. HTML 구현

```html
<!-- source 순서가 곧 우선순위 - 브라우저가 위에서부터 지원 여부 확인 -->
<video
  poster="/hero-poster.avif"
  fetchpriority="high"
  muted
  autoplay
  playsinline
  loop
  preload="none"
>
  <source src="/hero.av1.webm" type="video/webm; codecs=av01.0.05M.08">
  <source src="/hero.vp9.webm" type="video/webm; codecs=vp9">
  <source src="/hero.h264.mp4" type="video/mp4">
  <!-- 자막: Whisper 변환 WebVTT -->
  <track kind="captions" src="/hero.ko.vtt" srclang="ko" label="한국어">
</video>
```

---

## 6. 스트리밍 플랫폼 비교

| 플랫폼 | 우선순위 | 가격 | 특징 | 적합 사례 |
|--------|---------|------|------|----------|
| Mux DX | 1순위 | $0.015/분 저장 + $0.010/분 전송 | 개발자 DX 최고, 분석 내장, HLS/DASH 자동 | 제품 데모, 마케팅 영상 |
| Cloudflare Stream | 2순위 (Vercel 통합) | $0.005/분 | Vercel 통합 간편, 글로벌 CDN, 저렴 | Vercel 프로젝트 기본값 |
| Bunny Stream | 3순위 | $0.004/GB 저장 + $0.01/GB 전송 | 최저가, 심플 API | 대용량 아카이브, 비용 우선 시 |

선택 기준: Vercel 배포 -> Cloudflare Stream 우선 / 분석 필요 -> Mux DX / 대용량 저비용 -> Bunny Stream

---

## 7. Stage 3 영상 구현 체크리스트 (개발 단계)

1. poster + fetchpriority="high": LCP 최적화 - poster 이미지에 fetchpriority="high" 속성 적용 여부
2. 다중 코덱 source 순서: AV1 -> VP9 -> H.264 순서로 source 태그 배치 여부
3. IntersectionObserver lazy load: 뷰포트 밖 영상 autoplay 비활성화 구현 여부
4. muted + autoplay + playsinline: 자동재생 정책 준수 3속성 모두 적용 여부
5. 반응형 poster: srcset 또는 picture 태그로 모바일/데스크톱 poster 분기 여부
6. Remotion API Route: 동적 영상 생성 시 Vercel Functions 또는 Lambda 연동 여부
7. Rive/Lottie 지연 로드: 인터랙티브 애니메이션 라이브러리 dynamic import 처리 여부

---

## 8. Stage 5 QA - 영상 성능 게이트

| 항목 | 기준 | 측정 방법 | 미통과 시 |
|------|------|----------|----------|
| LCP | < 2.5s | Lighthouse / CrUX | poster 최적화, preload 조정 |
| 초기 JS 번들 | 영상 기능 추가분 +50KB 이내 | webpack-bundle-analyzer | 동적 import 분리 |
| 대역폭 | 최대 해상도 <= 3Mbps | Mux/Cloudflare 대시보드 | 해상도/비트레이트 하향 |
| autoplay muted | muted 속성 필수 | 코드 리뷰 | muted 추가 또는 자동재생 제거 |
| prefers-reduced-motion | 모션 중단 또는 정적 대체 | CSS 미디어 쿼리 확인 | @media (prefers-reduced-motion) 블록 추가 |
| WCAG 자막 | 음성 포함 영상에 WebVTT 자막 | Whisper 변환 -> .vtt 파일 | Whisper API로 자동 생성 |
| 간질 방지 | 깜빡임 3Hz 이하 | PEAT 툴 또는 수동 확인 | 해당 구간 제거 또는 속도 조정 |

---

## 9. Remotion SSR 패턴

### 9-1. 아키텍처 선택 기준

```
Vercel Functions (서버리스)
  - 적합: 짧은 영상 (30초 이하), 단발성 렌더링
  - 제한: 실행 시간 10초 (Hobby) / 60초 (Pro)
  - 비용: 함수 실행 비용만 발생

AWS Lambda (@remotion/lambda)
  - 적합: 긴 영상 (30초+), 배치 렌더링, 병렬 처리
  - 장점: 병렬 청크 렌더링으로 5분 영상도 수십 초 완료
  - 비용: Lambda 실행 + S3 저장 비용
```

### 9-2. Vercel Functions API Route 패턴

```typescript
// app/api/render-video/route.ts
import { bundle } from "@remotion/bundler";
import { renderMedia, selectComposition } from "@remotion/renderer";

export async function POST(req: Request) {
  const { compositionId, inputProps } = await req.json();

  // 번들링 (캐시 활용 권장)
  const bundled = await bundle({ entryPoint: "./src/remotion/index.ts" });

  const composition = await selectComposition({
    serveUrl: bundled,
    id: compositionId,
    inputProps,
  });

  // 렌더링 (Vercel Pro: 60초 제한 주의)
  await renderMedia({
    composition,
    serveUrl: bundled,
    codec: "h264",
    outputLocation: `/tmp/${compositionId}.mp4`,
    inputProps,
  });

  // 결과 반환 (실제 운영: S3/Cloudflare R2에 업로드 후 URL 반환)
  return Response.json({ status: "done", path: `/tmp/${compositionId}.mp4` });
}
```

### 9-3. Lambda 트레이드오프 요약

```
선택 기준          Vercel Functions    AWS Lambda
영상 길이          ~30초              무제한 (병렬)
설정 복잡도        낮음               높음 (IAM, 배포)
비용 예측          단순               가변 (병렬 수 x 청크)
기존 인프라 연동   Vercel 프로젝트    AWS 생태계
```

---

## 참고: motion-guide.md 위임 범위

Motion Designer의 3-Tier Motion v2 상세 정의는 motion-guide.md가 SSOT.
이 파일에서 중복 정의 금지. 참조만 한다.

---

## 스톡 영상/푸티지 소스

### 무료 CC0 소스

| 소스 | URL | 특징 |
|------|-----|------|
| Pexels Video | https://www.pexels.com/videos/ | 고품질, 다양한 카테고리 |
| Pixabay Video | https://pixabay.com/videos/ | CC0, 귀속 불필요 |
| Videvo | https://www.videvo.net/ | CC0 + Attribution 혼용, 필터 확인 필수 |
| Mixkit | https://mixkit.co/free-stock-video/ | 상업용 무료, 고해상도 |
| Coverr | https://coverr.co/ | 배경 영상 특화, 루프 최적화 |

### 검색 키워드 템플릿

AI, tech, neural, data, code, server, abstract, particles, cyber, network, circuit, algorithm, digital, futuristic, matrix

### Remotion 통합

```tsx
// 기본 삽입 (타임라인 싱크 허용)
<Video src={staticFile("stock/clip.mp4")} />

// 프레임 정확성 우선 시 (렌더링 품질 보장)
<OffthreadVideo src={staticFile("stock/clip.mp4")} />
```

에셋 디렉토리: `public/stock/` — 클립 파일명에 출처 주석 권장 (예: `cyber-loop_pexels.mp4`)

### 라이선스 체크리스트

1. CC0 또는 Unsplash License 여부 확인
2. 저작자 표기(Attribution) 필요 여부
3. 상업적 사용 가능 여부
4. 파생물(편집/합성) 허용 여부
- 파일명에 출처 주석 권장: `클립명_출처.mp4` (예: `server-room_pixabay.mp4`)

### 해상도/코덱 최소 기준

- 최소 해상도: 1080p (1920x1080) 이상
- 허용 코덱: H.264 / H.265 (HEVC)
- 권장 클립 길이: 5-15초 (릴스 B-roll 최적)
- 비트레이트: 최소 8Mbps (1080p 기준)

### AI 생성 vs 스톡 혼용 원칙

- AI 생성 클립: 컷당 8초 이내로 제한
- 스톡 푸티지: 전체 릴스의 30% 이하 유지
- 근거: 2026 트렌드 "의도된 불완전함(Intentional Imperfection)" — 과도한 AI/스톡 의존은 진정성 훼손
- 실제 촬영 + Remotion 코드 기반 영상을 1순위로 유지
