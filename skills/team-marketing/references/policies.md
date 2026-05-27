# team-marketing 정책 (브랜드 보이스 + Role 책임 + 캠페인 규약)


## Contents

- [1. 브랜드 보이스 기본값](#1-브랜드-보이스-기본값)
  - [기본 보이스 (fallback)](#기본-보이스-fallback)
  - [금지 클리셰](#금지-클리셰)
- [2. Role 책임 분담 (SSOT)](#2-role-책임-분담-ssot)
- [3. content-creator vs marketing-skills 분기 (SSOT)](#3-content-creator-vs-marketing-skills-분기-ssot)
- [4. 캠페인 상태 머신](#4-캠페인-상태-머신)
- [5. 체크포인트 (L3 + 선택적 INFORM)](#5-체크포인트-l3-선택적-inform)
- [6. 산출물 저장 경로](#6-산출물-저장-경로)
- [7. outbox 메시지 스키마 (team-common 확장)](#7-outbox-메시지-스키마-team-common-확장)
- [8. 사용자 노출 원칙 (비전문가 대응)](#8-사용자-노출-원칙-비전문가-대응)

team-common 규약 준수. outbox/decisions/manifest/trust SSOT는 team-common/SKILL.md 참조.

## 1. 브랜드 보이스 기본값

PMC(`product-marketing-context.md`)에 Brand Voice 섹션이 있으면 **그것이 SSOT**. 이 파일은 PMC 부재 시 기본값.

### 기본 보이스 (fallback)
- **톤**: 전문가이되 친근 (peer-to-peer)
- **금지어**: "혁신적", "최고의 솔루션", "차별화된" 같은 추상 단어
- **권장**: 구체 숫자·고객 어휘·재현 가능한 결과
- **문장 길이**: 짧게. 복문 금지
- **한국어 사용**: 사용자 대화·일반 콘텐츠는 한국어. 기술 용어·코드·SEO 키워드는 영어 병기 허용

### 금지 클리셰
- "우리는 ~를 믿습니다"
- "이메일을 열어주셔서 감사합니다" (콜드 이메일)
- "혁신·솔루션·최고"
- 기능 나열(dump) — Jobs-to-be-Done 관점으로 변환

## 2. Role 책임 분담 (SSOT)

| 경계 | 소유 Role | 비고 |
|---|---|---|
| Product Marketing Context 12섹션 | CMO Strategist | 온톨로지가 SSOT, 파일은 파생 |
| 고객 리서치 프레임·VOC 마이닝 | Insight Analyst | /research 프리셋 호출 |
| 모든 카피 원본 + 최종 검수 | Copy & Content Chief | Seven Sweeps QA 레이어 |
| 블로그 본문 · 브랜드 보이스 분석기 · SNS 원본 | content-creator (Copy Chief 하위) | 파이썬 자산(brand_voice_analyzer.py) |
| 페이지·플로우·폼·팝업·결제 CRO 진단 | CRO Engineer | A/B 설계 포함 |
| SEO·유료광고·측정 이벤트 네이밍 규약 | Acquisition Lead | analytics-tracking이 팀 전체 이벤트 SSOT |
| 리텐션·추천·커뮤니티·세일즈 자료 | Growth & GTM Ops | |

## 3. content-creator vs marketing-skills 분기 (SSOT)

| 요청 유형 | 담당 |
|---|---|
| 블로그 본문 | content-creator |
| 브랜드 보이스 분석(brand_voice_analyzer.py) | content-creator |
| 일반 콘텐츠 캘린더 | content-creator |
| SNS 원본 생성 | content-creator |
| 랜딩·페이지·세일즈 카피 | marketing-skills:copywriting |
| 모든 카피 최종 검수 | marketing-skills:copy-editing |
| SNS 플랫폼별 리퍼포징 | marketing-skills:social-content |
| 이메일 시퀀스 자동화 | marketing-skills:email-sequence |
| 세일즈 콜드 아웃리치 | marketing-skills:cold-email |

## 4. 캠페인 상태 머신

```
idle → draft → review → approved → scheduled → published → completed
                  ↓
               rejected → idle (되돌림)
```

- **draft**: Role 작업 진행 중
- **review**: copy-editing Seven Sweeps + (선택) reviewer 에이전트
- **approved**: 사용자 승인 필요 포인트(예산·코드 배포) 없을 때 자동. 있으면 사용자 승인 후.
- **scheduled**: 게시 시간 예약
- **published**: 게시 실행 + outbox 기록 + monthly_content_published++
- **completed**: 성과 리포트 생성(Acquisition) + 캠페인 종료

## 5. 체크포인트 (L3 + 선택적 INFORM)

기본 SILENT. 다음 액션은 INFORM:

| 액션 | 유형 | 유예 |
|---|---|---|
| 광고 예산 집행 | INFORM | 5분. team-accounting 공유 |
| 코드 배포(랜딩 변경 등) | INFORM | 5분. team-dev 경유 |
| 대량 이메일 발송(500통+) | INFORM | 5분. 수신자 승인 상태 검증 |
| SNS 게시(외부 공개) | SILENT | 되돌릴 수 있으므로 즉시 |
| 카피 작성/편집/분석 | SILENT | 되돌리기 쉬움 |

## 6. 산출물 저장 경로

| 유형 | 경로 |
|---|---|
| 블로그 | `~/workspace/content/blog/<date>-<slug>.md` |
| SNS | `~/workspace/content/sns/<platform>/<date>-<slug>.md` |
| 이메일 시퀀스 | `~/workspace/content/emails/<sequence-name>/` |
| CRO 리포트 | `~/workspace/reports/cro-audit-<domain>-<date>.md` |
| SEO 리포트 | `~/workspace/reports/seo-audit-<domain>-<date>.md` |
| VOC 리포트 | `~/workspace/reports/marketing-insight-<slug>-<date>.md` |
| PMC 파생 파일 | `<project-root>/.agents/product-marketing-context.md` (프로젝트별) |
| 캠페인 상태 | `~/.claude/teams/marketing/state.json` |
| outbox | `~/.claude/teams/_bus/outbox/marketing.jsonl` |

## 7. outbox 메시지 스키마 (team-common 확장)

```json
{
  "msg_id": "uuid",
  "ts": "ISO8601",
  "from": "team-marketing",
  "to": "<target_team_or_role>",
  "result": "success|partial|failed",
  "summary": "1-2줄 요약",
  "artifacts": ["경로1", "경로2"],
  "metrics": {
    "role_executed": "cmo-strategist|insight-analyst|copy-content-chief|cro-engineer|acquisition-lead|growth-gtm-ops",
    "scenario": "launch|cro-audit|seo-recovery|retention|weekly-content|ad-hoc",
    "tokens_used": 0
  },
  "trace_id": "uuid"
}
```

## 8. 사용자 노출 원칙 (비전문가 대응)

1. **전문 용어 금지**: CRO/JTBD/VOC/UTM/LCP/INP/CTR/ROAS/MQL 등 사용자에게 노출 금지. 일반어 번역.
2. **결과 구조**: "원인 N가지 → 해결안 → 다음 단계 체크리스트 + 승인 필요 포인트"
3. **선택지**: 추천 + 이유 + 대안 단점 3요소 명시 (feedback_recommendation_with_reasoning.md 준수)
4. **승인 포인트**: 예산 집행·코드 배포·대량 발송만 명시적 승인. 그 외 L3 자율
5. **외부 팀 전달**: team-dev/accounting/secretary 자동 위임 후 "다음 단계" 항목으로만 안내
6. **DAG 순서**: 사용자에겐 Role 이름 노출 안 함. 결과만 통합 제시
