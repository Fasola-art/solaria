---
name: workflow
description: "업무 워크플로우 오케스트레이터. 여러 스킬을 체이닝하여 파이프라인 실행. /workflow [이름]으로 호출. 내장 워크플로우: briefing, research, content, code, monitor, revenue-content, revenue-course, revenue-saas, revenue-freelance, revenue-scout."
---

# 워크플로우 오케스트레이터

$ARGUMENTS에서 워크플로우 이름과 추가 인자를 파싱한다.

## 내장 워크플로우

| 이름 | 호출 | 자동화 | 설명 |
|------|------|--------|------|
| briefing | `/workflow briefing` | /schedule 매일 9AM | 아침 브리핑 |
| research | `/workflow research [주제]` | 수동 또는 주간 | 리서치 + 보고서 |
| content | `/workflow content [유형] [주제]` | 수동 | 콘텐츠 제작 |
| code | `/workflow code [설명]` | 수동 | 코딩/프로젝트 |
| monitor | `/workflow monitor` | /schedule 매시간 | 조건부 알림 |
| revenue-content | `/workflow revenue-content` | /schedule 주 3회 | 콘텐츠 자동 발행 |
| revenue-course | `/workflow revenue-course [주제]` | 수동 | 강의 제작 |
| revenue-saas | `/workflow revenue-saas [아이디어]` | 수동 | Micro SaaS 개발 |
| revenue-freelance | `/workflow revenue-freelance [설명]` | 수동 | 프리랜서 프로젝트 |
| revenue-scout | `/workflow revenue-scout` | /schedule 주 1회 | 수익 기회 탐색 |
| media | `/workflow media [작업설명]` | 수동 | 미디어 작업 (영상 편집/생성/자막/썸네일) |
| marketing-launch | `/workflow marketing-launch [제품명]` | 수동 | 신제품 런칭 풀 파이프라인 (CMO → Insight → Copy → CRO → Acquisition → Growth) |
| marketing-cro-audit | `/workflow marketing-cro-audit [URL]` | 수동 | 전환율 진단 + A/B 설계 (CRO → Insight → Copy → Analytics) |
| marketing-seo-recovery | `/workflow marketing-seo-recovery [도메인]` | 수동 | SEO 트래픽 회복 (Acquisition → Insight → Copy → schema) |
| marketing-retention | `/workflow marketing-retention` | 수동 | 이탈률 대응 + 리텐션 캠페인 (Growth → Insight → Copy → CRO) |
| marketing-weekly-content | `/workflow marketing-weekly-content` | /schedule 주 1회 | 주간 SNS 콘텐츠 루틴 (Copy → Acquisition → 캠페인 상태머신) |

## 실행 원칙

1. **상태 파일 생성**: ~/workspace/workflows/state/wf_[이름]_[날짜].json
2. **오케스트레이션**: Wave 11 원칙 따름 (의존성 없으면 병렬, 있으면 순차)
3. **에러 처리**: 실패 시 error 필드에 기록 → 실패 단계부터 재실행 또는 사용자 보고
4. **결과 저장**: ~/workspace/ 표준 디렉토리 구조 따름
5. **텔레그램**: Channels 연결 시 결과 전송
6. **자동 학습**: 워크플로우 완료 시 learner 에이전트로 패턴 자동 캡처 (사용자 호출 불필요)

## WF-1: 아침 브리핑

```
[Fan-Out & Merge 패턴]
[순차] 온톨로지 활성 프로젝트 조회
[병렬] Gmail | Calendar | GitHub | Telegram 수집 (haiku sub-agent × N)
[순차] 합치기 → 브리핑 생성 → ~/workspace/briefings/ 저장 → 텔레그램
```

## WF-2: 리서치 + 보고

```
[Sequential 패턴]
/research 호출 → 핵심 인사이트 추출 → 온톨로지 등록 → ~/workspace/reports/ 저장 → 텔레그램
```

## WF-3: 콘텐츠 제작

유형: lecture(강의), book(책), blog(블로그), sns(SNS)

```
[Hybrid 패턴]
[순차] /research 조사 → 유형별 구조 생성
[병렬] 각 섹션 초안 동시 작성 (worker × N)
[순차] 통합 → reviewer 검토 → 수정 → ~/workspace/content/[유형]/ 저장 → 텔레그램
```

템플릿: references/workflow-catalog.md, templates/ 참조

## WF-4: 코딩/프로젝트

```
[Sequential + Conditional + Convergence 패턴]
온톨로지 패턴 조회 → 코드 작성 → Back-Pressure 훅
→ reviewer 품질 게이트 (4차원: 품질/보안/성능/접근성)
→ PASS → Git 커밋 → GitHub PR → 텔레그램
→ FAIL → /autofix (Error KB 3중 검색) → reviewer 재검증
  → 수렴 감지: 점수 변화 < 0.015 → 재시도 중단
  → 최대 5회 반복
```

### --vibe 모드
"빠르게/qk/바로" 키워드 또는 --vibe 플래그 감지 시:
- Phase 1만 실행 (탐색 → 즉시 구현)
- reviewer 품질 게이트 건너뜀
- 단, 보안 관련 파일(.env, auth, credentials 등) 변경 시 → vibe 무시, 전체 검증 강제

## WF-5: 조건부 알림 (오픈클로 스타일)

```
[Fan-Out & Merge + Conditional 패턴]
[병렬] Gmail | GitHub | Calendar 체크
[조건] 변동 있으면 → 텔레그램 알림 / 없으면 → 무동작
```

## WF-6~10: 수익 워크플로우

상세는 references/workflow-catalog.md 참조.

## WF-11: 미디어 작업

```
[Hybrid 패턴 — 스킬 라우팅 기반]

1. 요청 분석 → 스킬 라우팅:
   - 편집(변환/트리밍/크롭/인코딩) → video-editor (ffmpeg)
   - 생성(쇼츠/광고/모션그래픽) → Remotion
   - 자막(음성→텍스트) → audio-processor (whisper)
   - 이미지(썸네일/리사이즈) → image-processor (imagemagick)

2. 프로젝트 폴더 생성:
   - 영상: ~/workspace/content/video/projects/YYYYMMDD_프로젝트명/
   - 이미지: ~/workspace/content/images/projects/YYYYMMDD_프로젝트명/

3. 소스 분석 (mediainfo/exiftool)

4. 작업 실행:
   [병렬 가능] 독립 작업은 worker 병렬 실행
   [순차 필수] 자막→번인, 프레임추출→썸네일 등 의존 관계

5. 출력물 검증 (reviewer):
   - 파일 존재/크기 확인
   - 코덱/해상도/비트레이트 검증 (mediainfo)
   - 플랫폼별 세이프존/스펙 준수 확인

6. 내보내기 → 05_exports/final/ 저장
```

### 크로스 파이프라인 예시
```
"영상에서 자막 뽑아서 합쳐줘"
  → audio-processor(오디오추출→whisper→SRT) → video-editor(자막번인)

"제품 사진으로 광고 영상 + 썸네일"
  → Remotion(광고 MP4) + image-processor(썸네일 JPG)

"유튜브에서 다운받아서 쇼츠로"
  → yt-dlp(다운로드) → video-editor(9:16 크롭) 또는 Remotion(리메이크)
```

## 상태 파일 형식

```json
{
  "id": "wf_[이름]_YYYYMMDD",
  "workflow": "[이름]",
  "started_at": "ISO8601",
  "tasks": [
    { "id": "step_1", "status": "completed", "deps": [] },
    { "id": "step_2", "status": "in_progress", "deps": ["step_1"] }
  ],
  "results": {},
  "error": null
}
```
