# AI Product 아키타입

## 정의
LLM/AI 제품 마케팅 사이트. Live demo + 따뜻한 톤 또는 모노크롬.

## 대표 레퍼런스 5개
| URL | 시그니처 |
|-----|---------|
| anthropic.com | Claude, Serif + 따뜻한 크림 팔레트 |
| openai.com | 모노크롬 + 대형 타이포 |
| perplexity.ai | 검색 UX, 답변 스트리밍 데모 |
| elevenlabs.io | 음성 데모 인라인 플레이어 |
| suno.com | 음악 생성, 피드형 홈 |

## 시그니처 패턴
### 타이포그래피
- Serif: Anthropic Styrene B / Tiempos
- Sans: Inter / Söhne / Geist
- 대형 헤드라인 (제품의 자신감)
- 본문 16-17px

### 컬러
- 크림/오프화이트 (Anthropic) — 따뜻한 톤
- 순수 모노크롬 (OpenAI) — 중립
- 그라디언트 "영감" 오브 (Perplexity, Gemini)

### 모션
- Live/simulated 프롬프트 데모 (스트리밍 텍스트 애니메이션)
- 그라디언트 오브 (Canvas/WebGL)
- Tabbed capability showcase
- Stream-as-typing 효과

### 레이아웃
- Hero에 라이브 데모 임베드
- Capability tabs (use case별)
- Pricing 명시적 (또는 명확히 없음)
- Trust section (고객 로고)

## 기술 스택 관찰
- Next.js + Vercel (Anthropic, Perplexity)
- Framer Motion (Motion v12)
- 자체 디자인 시스템
- ElevenLabs: Next.js + WebAudio API

## 핵심 컴포넌트 패턴
- Live prompt demo (typing animation + skeleton)
- Capability tabs with examples
- Pricing card (Free / Pro / Enterprise)
- API docs CTA (개발자 페이지)
- Safety / responsible use 섹션
- Use case showcase (B2B/B2C 분리)

## Anti-pattern
- "매직" 오브/파티클만 있고 실제 기능 데모 부재
- 과장된 벤치마크 차트 (편향 노출)
- 안전/정책 링크 숨김
- 가격 불투명 ("Contact sales" 강제)
- 환각/한계 미언급

## Stage 1 적용 가이드
- Live demo 필수 (또는 simulated streaming)
- Hero에 명확한 가치 제안 (한 문장)
- 안전/정책 페이지 표시 (footer 또는 헤더)
- API 문서 링크 prominent
- Pricing 투명성 (사용량 기반 명시)
- Streaming UI 패턴 (Server Actions + useOptimistic)
- 음성/영상 데모는 prefers-reduced-motion 폴백
- Motion Tier 2 (Motion v12 streaming text) + Tier 1 폴백
