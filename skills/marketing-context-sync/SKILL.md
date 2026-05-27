---
name: marketing-context-sync
description: "온톨로지 ↔ .agents/product-marketing-context.md 양방향 동기화. marketing-skills 플러그인이 요구하는 PMC 파일을 온톨로지 Product/ICP/Persona 엔티티에서 렌더링하거나 역으로 파일 수정분을 온톨로지에 반영. '컨텍스트 sync', 'PMC 동기화', '마케팅 컨텍스트 갱신' 키워드로 호출. team-marketing CMO Strategist가 자동 사용."
---

# Marketing Context Sync

## 목적

coreyhaines31/marketingskills 플러그인은 `.agents/product-marketing-context.md` 파일(12섹션)을 읽어 동작. 내 시스템은 온톨로지(graph.jsonl)가 SSOT. 이 두 곳을 충돌 없이 동기화.

## 호출 방법

- `/marketing-context-sync` — 양방향 자동 동기화 (drift 감지 후 최신 쪽 승격)
- `/marketing-context-sync --from-ontology` — 온톨로지 → 파일 (일방)
- `/marketing-context-sync --from-file` — 파일 → 온톨로지 (일방)
- `/marketing-context-sync --dry-run` — 변경사항 미리보기

## 매핑 스키마

`.agents/product-marketing-context.md` 12섹션 ↔ 온톨로지 엔티티:

| PMC 섹션 | 온톨로지 엔티티 | 비고 |
|---|---|---|
| 1. Product Overview | Product | 속성: name, one_liner, description, category, type |
| 2. Target Audience | ICP | 속성: segment, roles, company_size, industries |
| 3. Personas | Persona × N | 각 5-10 data points, Product에 linked |
| 4. Problems | Problem × N | ICP/Persona에 linked |
| 5. Competition | Competitor × N | team-business와 공유 엔티티 |
| 6. Differentiation | Differentiation | Competitor 대비 Delta 속성 |
| 7. Objections | Objection × N | switching_dynamics 포함 |
| 8. Switching Dynamics | → Objection 속성 | 별도 엔티티 X, Objection에 흡수 |
| 9. Customer Language | CustomerLanguage | verbatim quotes, VOC quote bank |
| 10. Brand Voice | BrandVoice | 속성: tone, forbidden_phrases, style |
| 11. Proof Points | ProofPoint × N | 속성: type, claim, evidence |
| 12. Goals | Goal × N | 속성: period, target, kpi |

## 동기화 알고리즘

### 1. Drift 감지
- 파일 해시 + 온톨로지 version 비교
- 둘 중 더 최신(mtime/version)이 source
- 양쪽 다 변경됐으면 수동 병합 모드로 사용자에게 요청

### 2. 온톨로지 → 파일 (Render)
- 활성 Product 엔티티 기준으로 linked 엔티티 조회
- 템플릿(`references/pmc-template.md`)에 값 치환
- 저장: 프로젝트 루트 `.agents/product-marketing-context.md`
- 경로 없으면 `mkdir -p .agents` 생성

### 3. 파일 → 온톨로지 (Parse)
- 12섹션 파서로 파일 분해
- 각 섹션 내용을 온톨로지 엔티티로 upsert
- 빈 섹션은 스킵, 새 Persona/Competitor/ProofPoint는 엔티티 신규 생성

## 프로젝트 경로 규칙

현재 디렉토리가 `~/workspace/projects/<project-name>/` 하위면 해당 프로젝트의 `.agents/` 사용.
그 외 위치면 `~/workspace/projects/<현재-감지-프로젝트>/` 추정 또는 사용자에게 질문.

## 외부 팀 연동

- `team-business` → 경쟁사 모니터링이 Competitor 엔티티 업데이트 → 다음 sync 때 PMC Competition 섹션 자동 갱신
- `team-marketing` → CMO Strategist가 런칭 전 자동 호출하여 최신 PMC 보장

## 호출 시점 (자동)

1. `team-marketing` 6-Role 작업 시작 전 (PMC 필요한 Role: Copy/CRO/Acquisition/Growth)
2. 온톨로지 Product/ICP/Competitor 엔티티 변경 감지 시
3. marketing-skills 스킬 실행 전 (파일 부재 시 자동 렌더링)

## 참조
- marketingskills PMC 스펙: https://github.com/coreyhaines31/marketingskills/blob/main/skills/product-marketing-context/SKILL.md
- 온톨로지 스킬: `~/.Codex/skills/ontology/SKILL.md`
- 템플릿: 이 스킬의 references/pmc-template.md (12섹션 마크다운 템플릿)

## 사용자 노출

- 전문 용어 번역: "PMC" → "제품 정보 문서", "ICP" → "주요 고객층", "Proof Points" → "실적 근거"
- drift 발생 시: "프로젝트 파일과 시스템이 다르게 수정됐어요. 어느 쪽 내용을 살릴까요?" + A/B 선택지
