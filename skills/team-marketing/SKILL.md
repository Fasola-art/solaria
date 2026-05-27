---
name: team-marketing
description: "마케팅 팀 오케스트레이터. 6-Role 가상 팀(CMO/Insight/Copy/CRO/Acquisition/Growth) + 캠페인 상태 머신. marketing-skills 플러그인(36 스킬) + content-creator + 미디어 스킬 + /research 프리셋 위임. '@team-marketing', '카피', '랜딩 최적화', 'CRO', 'SEO', 'VOC', '이탈률', '레퍼럴', '콘텐츠 게시', '캠페인', 'SNS' 키워드로 호출. L3 완전 자율."
---

# Team Marketing — 6-Role 가상 마케팅팀 + 캠페인 오케스트레이터

## 자율성 등급
**L3** — 체크포인트 없음 (SILENT). 게시·보고까지 자동 실행.
예외: 광고 예산 집행은 team-accounting 공유 + 코드 변경은 team-dev INFORM.

## 호출 방법
- `@team-marketing [요청]` (명시 태그)
- `/do` Tier 1 키워드: 카피·헤드라인·랜딩·CRO·전환율·A/B·온보딩·팝업·페이월·SEO·스키마·유료 광고·광고 소재·analytics·GA·VOC·JTBD·페르소나·경쟁사·포지셔닝·ICP·이탈률·리텐션·레퍼럴·커뮤니티·리드 매그넷·피치덱·RevOps·런칭·가격 전략·이메일 시퀀스·콜드 이메일·SNS·콘텐츠 게시·캠페인 등
- `/jarvis` Phase 3에서 `domain:marketing:{strategy/insight/copy/cro/acquisition/growth}` 6개 + legacy `domain:content/sns` (→ `marketing:copy` alias)

## 6-Role 구조

내부 6개 Role이 담당 영역 분리 + DAG 순서 협업. 정의: `roles/<role>.md`.

| Role | 담당 스킬 | 트리거 키워드 | jarvis domain |
|---|---|---|---|
| **CMO Strategist** | marketing-skills:{product-marketing-context, marketing-ideas, marketing-psychology, launch-strategy, pricing-strategy} | 포지셔닝, ICP, 런칭, 가격, 전략 | `marketing:strategy` |
| **Insight Analyst** | marketing-skills:{customer-research, competitor-alternatives, content-strategy} + /research 프리셋 4개 | VOC, JTBD, 페르소나, 경쟁사, 콘텐츠 갭 | `marketing:insight` |
| **Copy & Content Chief** | marketing-skills:{copywriting, copy-editing, cold-email, email-sequence, social-content} + content-creator(블로그·브랜드보이스·SNS 원본) | 카피, 헤드라인, 랜딩, 리라이트, 이메일, SNS, 블로그 | `marketing:copy` |
| **CRO Engineer** | marketing-skills:{page-cro, signup-flow-cro, onboarding-cro, form-cro, popup-cro, paywall-upgrade-cro, aso-audit, ab-test-setup} | CRO, 전환율, 랜딩 최적화, 온보딩, A/B | `marketing:cro` |
| **Acquisition Lead** | marketing-skills:{seo-audit, ai-seo, schema-markup, programmatic-seo, site-architecture, paid-ads, ad-creative, analytics-tracking} | SEO, 스키마, 유료 광고, GA, 추적 | `marketing:acquisition` |
| **Growth & GTM Ops** | marketing-skills:{churn-prevention, referral-program, community-marketing, free-tool-strategy, lead-magnets, revops, sales-enablement} | 이탈, 리텐션, 레퍼럴, 커뮤니티, 피치덱 | `marketing:growth` |

**우선순위** (키워드 다중 매칭 시): CMO > Insight > Copy > CRO > Acquisition > Growth.

상세 키워드 → Role → 스킬 라우팅: `references/role-routing.yaml`
실행 시나리오 5종: `references/scenarios.md`
브랜드 보이스·Role 책임 분담·캠페인 정책: `references/policies.md`

## content-creator vs marketing-skills 분기

| 요청 유형 | 담당 |
|---|---|
| 블로그 본문 작성 / 브랜드 보이스 분석 / 일반 콘텐츠 캘린더 / SNS 원본 생성 | **content-creator** |
| 랜딩/페이지/세일즈 카피 | **marketing-skills:copywriting** |
| 모든 카피 최종 검수 (Seven Sweeps) | **marketing-skills:copy-editing** |
| SNS 플랫폼별 리퍼포징·engagement 루틴 | **marketing-skills:social-content** |
| 이메일 자동화 시퀀스 | **marketing-skills:email-sequence** |
| 세일즈 콜드 아웃리치 | **marketing-skills:cold-email** |

## 위임 대상 (확장)
- **marketing-skills:*** — 36개 스킬, 네임스페이스 격리. 플러그인: coreyhaines31/marketingskills (Codex 플러그인, /plugin marketplace add로 설치됨)
- **content-creator** — 블로그·브랜드보이스·SNS 원본 (축소된 역할)
- **/research** — Insight Analyst가 `marketing_research` 도메인으로 4개 프리셋 자동 로드 (marketing-voc-sources, marketing-competitor-queries, marketing-content-gap, marketing-interview-bias)
- **/ontology** — 전 Role 공유. Product/ICP/Persona/Competitor/ProofPoint 엔티티 관리
- **/marketing-context-sync** (신규) — 온톨로지 ↔ `.agents/product-marketing-context.md` 양방향 동기화
- **/video-editor, /image-processor, /audio-processor** — 미디어 작업
- **/frontend-stack** — 랜딩/마케팅 사이트 구현 시
- **/workflow marketing-*** — 5개 내장 워크플로우 (launch/cro-audit/seo-recovery/retention/weekly-content)
- **/prd-create** — 대규모 캠페인 기획
- **외부 팀 연동**: team-business(경쟁사 모니터링) ↔ Insight Analyst / team-accounting(광고 예산) ↔ Acquisition Lead / team-secretary(캠페인 일정) ↔ CMO Strategist / team-dev(코드 변경) ↔ CRO Engineer

## 실행 흐름

### 캠페인 상태 머신
```
draft → review → approved → scheduled → published
```
- **draft**: `/content-creator`로 초안 생성
- **review**: reviewer 품질 검사 (L3이므로 자동 통과)
- **approved**: `brand_voice.json` 일관성 검사
- **scheduled**: 게시 시간 예약
- **published**: 게시 실행 + outbox 기록

### 콘텐츠 생성
1. 요청 파싱 (플랫폼, 주제, 톤)
2. `/content-creator` 호출 → 초안 작성
3. 미디어 필요 시:
   - 이미지: `/image-processor`
   - 영상: `/video-editor`
   - 오디오: `/audio-processor`
4. 플랫폼별 포맷 변환 (Twitter 280자, Instagram 캡션, YouTube 설명)
5. `~/workspace/content/sns/` 또는 `~/workspace/content/blog/` 저장
6. outbox 기록, `monthly_content_published++`

### SNS 게시 (수동/자동)
- SNS MCP 서버 있을 때: 자동 게시
- 없을 때: 사용자에게 "게시 준비 완료, 수동 게시 링크" Telegram 전송

## 상태 파일 (6-Role 확장)
- **상태**: `~/.Codex/teams/marketing/state.json` — `roles.<role>.{status, current_task, monthly_*}` 서브구조
- **이력**: `~/.Codex/teams/marketing/history.jsonl`
- **버스**: `~/.Codex/teams/_bus/{inbox,outbox}/marketing.jsonl` — outbox `metrics.role_executed` 필드 추가 (Role 단위 감사)

### state.json 스키마 (v2, 6-Role)
```json
{
  "team": "marketing", "autonomy": "L3", "campaign_state": "idle",
  "roles": {
    "cmo-strategist":     { "status": "idle", "current_task": null, "monthly_strategies_drafted": 0, "monthly_positions_updated": 0 },
    "insight-analyst":    { "status": "idle", "current_task": null, "monthly_voc_reports": 0, "monthly_competitor_intel": 0 },
    "copy-content-chief": { "status": "idle", "current_task": null, "monthly_copies_written": 0, "monthly_content_published": 0, "monthly_copy_edits": 0 },
    "cro-engineer":       { "status": "idle", "current_task": null, "monthly_cro_audits": 0, "monthly_ab_tests_set": 0 },
    "acquisition-lead":   { "status": "idle", "current_task": null, "monthly_seo_audits": 0, "monthly_ad_campaigns": 0, "monthly_analytics_events": 0 },
    "growth-gtm-ops":     { "status": "idle", "current_task": null, "monthly_retention_ops": 0, "monthly_referrals_shipped": 0 }
  }
}
```

## 브랜드 정책
`references/policies.md`에 브랜드 보이스 가이드. `/content-creator` 내장 기능 재사용.

## 활동 카운터
- `monthly_content_published++`: 실제 게시 또는 초안 저장 시
- `monthly_campaigns_completed++`: 캠페인 상태 머신이 `published`에 도달 시
- `monthly_decisions++`: 모든 요청 처리 시

## SSOT 준수
- `/content-creator`의 브랜드 보이스/SEO 로직 복제 금지
- team-marketing은 **캠페인 상태 머신 + 위임 라우팅**만 담당

## 참조
- `~/.Codex/skills/team-common/SKILL.md`
- `~/.Codex/skills/content-creator/SKILL.md` (위임 대상)
- `~/workspace/reports/jarvis-merge-plan.md` 섹션 11.7 team-marketing
