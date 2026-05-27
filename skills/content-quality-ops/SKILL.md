---
name: content-quality-ops
description: "콘텐츠·디자인 산출물 통합 검증 레이어. Seven Sweeps(카피) + WCAG 2.2 대비 + 라이선스 + BrandVoice 금지 어휘 + 출처 명시 자동 체크. team-marketing Copy & Content Chief 산하, 6 Case 전역 호출 가능. '카피 검수', 'copy review', '라이선스 검증', 'WCAG 대비', '브랜드 톤 체크' 키워드로 호출."
---

# Content Quality Ops

디자인 파이프라인(`frontend-stack` 6 Case) + 마케팅 콘텐츠(team-marketing) 산출물의 **통합 품질 게이트**. 글·이미지·영상·문서에 공통 적용 가능한 5축 검증 레이어.

**SSOT**: `~/.Codex/rules/design-marketing-integration.md` § 9 (Content Quality Ops Role 정의)

## 1. 책임 (5축 검증)

| 축 | 기준 | 차단 조건 |
|---|------|----------|
| **Seven Sweeps** | marketing-skills:copy-editing 7단계 QA (명확성/능동태/리듬/구체성/불필요한 단어/자신감/스캔성) | 7단계 중 1개라도 FAIL |
| **WCAG 2.2 대비** | 텍스트-배경 4.5:1 (AA), 대형 텍스트 3:1, 비텍스트 3:1, 포커스링 3:1 | AA 기준 미달 |
| **라이선스** | 폰트/이미지/음원/아이콘의 상업 이용·임베딩 허용 여부 | 미확인 또는 불허 |
| **금지 어휘** | BrandVoice.forbidden_terms 엔티티 전체 스캔 + 일반 금지(AI 인물·보라 그라디언트·Inter/Roboto/Arial 기본) | 1개 이상 검출 |
| **출처 명시** | 통계·인용·스크린샷·제3자 로고의 출처 링크 | 출처 없는 통계/인용 1개 이상 |

## 2. 입력 / 출력

### 입력
- **카피**: .md, .txt 원고 + 타겟 플랫폼 (web/email/sns/ppt)
- **디자인**: 스크린샷 파일 경로 or HTML 렌더 + 색상 토큰 JSON
- **영상**: 자막 SRT + 주요 프레임 샘플 이미지
- **메타**: `BrandVoice` 엔티티(product_id) + 해당 Case(DesignAsset) 참조

### 출력
- `~/workspace/reports/content-quality-<slug>-<YYYY-MM-DD>.md`
- 섹션: `## 결과 요약` → `## Seven Sweeps` → `## WCAG 대비` → `## 라이선스` → `## 금지 어휘` → `## 출처` → `## 조치 항목`
- 상태: `PASS / FAIL / PASS-with-warnings`

## 3. 호출 방법

```bash
# 자연어
"이 랜딩 카피 검수해줘"        # → Seven Sweeps 주력
"포스터 대비 체크"             # → WCAG 대비 주력
"폰트 라이선스 확인"           # → 라이선스 주력
"카피+이미지 전수 검증"         # → 5축 전체
```

위임 체인:
- `team-marketing` Copy & Content Chief가 자동 호출 (Seven Sweeps 필요 시)
- `frontend-stack` 각 case의 `quality_gates: [copy_sweeps, a11y, license, brand]` 트리거
- `quality-gate` 9단계 Brand Consistency Gate에서 단계 편입 (Phase C-B 예정)

## 4. 위임 대상
- `marketing-skills:copy-editing` — Seven Sweeps QA 엔진
- `worker` (haiku/sonnet) — 대비 계산, 폰트 메타 조회, 이미지 샘플링
- `reviewer` (sonnet) — 출처 검증, 금지 어휘 크로스 체크

## 5. 온톨로지 연계

- Pattern 레코드 생성: `type: design` or `type: brand_voice`
- 관계: `DesignAsset validated_by Pattern` (통과 시 자동 생성)
- BrandVoice 업데이트 제안 (반복 검출 어휘 → forbidden_terms 후보 보고)

## 6. 실행 흐름

```
1. 입력 파싱 (카피/디자인/영상 중 어떤 유형인지)
2. BrandVoice 엔티티 조회 (product_id 기반)
3. 5축 병렬 검증
   - Seven Sweeps: copy-editing 스킬 호출
   - WCAG: 대비 계산 (worker)
   - 라이선스: 폰트/이미지 메타 조회 (worker)
   - 금지 어휘: 정규식 스캔 (main)
   - 출처: 링크 추출 + 존재성 확인 (worker)
4. 통합 리포트 생성
5. FAIL 조건 충족 시 → 차단 신호 반환 + 조치 항목 리스트
6. PASS 시 → Pattern 레코드 + validated_by 관계 작성
```

## 7. 상태 파일

- 최근 검증 이력: `~/workspace/reports/content-quality-*.md` (FIFO 30개)
- 반복 검출 어휘 집계: `~/.Codex/memory/content-quality-stats.jsonl`

## 8. 참조

- 상위 SSOT: `~/.Codex/rules/design-marketing-integration.md` § 9
- 마케팅 통합 규약: `~/.Codex/rules/marketing-skills-integration.md`
- Copy & Content Chief Role: `~/.Codex/skills/team-marketing/roles/copy-content-chief.md` (존재 시)
- WCAG 참조: `~/.Codex/guides/frontend.md` (접근성 섹션)
