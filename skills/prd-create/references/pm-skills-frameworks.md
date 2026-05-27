# PM Skills 프레임워크 포인터 (prd-create 보강용)

`prd-create` 스킬이 사업성 검토·전략 섹션을 작성할 때 참조할 수 있는 **phuryn/pm-skills 플러그인**의 프레임워크 목록.

**저작권**: pm-skills 프롬프트 전문을 복사하지 않고 **포인터와 구조만 표기**. 원문은 플러그인 호출 시 로드됨.
- 레포: https://github.com/phuryn/pm-skills (MIT, © 2026 Paweł Huryn, The Product Compass)
- 설치 경로: `~/.claude/plugins/cache/pm-skills/pm-skills/<sha>/`

## 용도별 스킬 매핑

### Phase 2 사업성 검토 (prd-create 기존 Phase 2)
| 필요 프레임워크 | pm-skills 스킬 | 호출 문구 예시 |
|---|---|---|
| Business Model Canvas (9블록) | `pm-product-strategy:business-model` | "BMC로 이 제품 분석해줘" |
| Lean Canvas (Ash Maurya) | `pm-product-strategy:lean-canvas` | "린 캔버스 작성해줘" |
| Value Proposition (JTBD 6파트) | `pm-product-strategy:value-proposition` | "JTBD 가치제안 정리" |
| Porter's 5 Forces | `pm-product-strategy:porters-five-forces` | "Porter 5 Forces 분석" |
| PESTLE | `pm-product-strategy:pestle-analysis` | "PESTLE 환경 분석" |
| SWOT | `pm-product-strategy:swot-analysis` | "SWOT 정리" |
| Ansoff Matrix | `pm-product-strategy:ansoff-matrix` | "Ansoff 성장 전략" |
| Pricing 전략 | `pm-product-strategy:pricing-strategy` | "Van Westendorp 가격 전략" |
| 9섹션 Product Strategy (Cagan) | `pm-product-strategy:product-strategy` | "Cagan 9섹션 전략" |

### Phase 1 아이디어·가설
| 필요 | 스킬 | 호출 |
|---|---|---|
| 가설 우선순위 (4x3 행렬) | `pm-product-discovery:prioritize-assumptions` | "가설 우선순위" |
| 가설 도출 (신규/기존) | `pm-product-discovery:identify-assumptions-new/existing` | "assumption mapping" |
| Opportunity Solution Tree (Torres) | `pm-product-discovery:opportunity-solution-tree` | "OST 기회 트리" |
| 아이디어 브레인스토밍 | `pm-product-discovery:brainstorm-ideas-new/existing` | "아이디어 정렬" |
| 실험 설계 | `pm-product-discovery:brainstorm-experiments-*` | "실험 설계" |
| 사용자 인터뷰 스크립트 | `pm-product-discovery:interview-script` | "인터뷰 스크립트" |
| 인터뷰 요약 | `pm-product-discovery:summarize-interview` | "인터뷰 요약" |

### Phase 2 시장 분석
| 필요 | 스킬 | 호출 |
|---|---|---|
| ICP / 페르소나 | `pm-market-research:user-personas` / `user-segmentation` | "페르소나 정의" |
| 시장 세그먼트 | `pm-market-research:market-segments` | "세그먼트 분석" |
| 고객 여정 맵 | `pm-market-research:customer-journey-map` | "CJM 작성" |
| TAM/SAM/SOM | `pm-market-research:market-sizing` | "시장 크기 TAM SAM SOM" |
| 경쟁 분석 | `pm-market-research:competitor-analysis` | "경쟁사 분석" |
| 감성 분석 | `pm-market-research:sentiment-analysis` | "sentiment 분석" |

### Phase 3 PRD 본문 강화
| 필요 | 스킬 | 호출 |
|---|---|---|
| 8섹션 PRD 프레임 | `pm-execution:create-prd` | "프레임워크 기반 PRD 8섹션" |
| OKR 설정 | `pm-execution:brainstorm-okrs` | "OKR 정의" |
| Outcome Roadmap | `pm-execution:outcome-roadmap` | "아웃컴 로드맵" |
| Pre-mortem (위험 사전 분석) | `pm-execution:pre-mortem` | "프리모템" |
| Stakeholder Map | `pm-execution:stakeholder-map` | "이해관계자 맵" |
| User/Job Stories | `pm-execution:user-stories` / `job-stories` / `wwas` | "유저 스토리" |
| Test Scenarios | `pm-execution:test-scenarios` | "테스트 시나리오" |
| Release Notes | `pm-execution:release-notes` | "릴리즈 노트" |

### Phase 3 GTM·성장 (선택적)
| 필요 | 스킬 | 호출 |
|---|---|---|
| GTM 전략 | `pm-go-to-market:gtm-strategy` | "GTM 전략" |
| Beachhead 시장 | `pm-go-to-market:beachhead-segment` | "Beachhead 비치헤드" |
| ICP 스코어링 | `pm-go-to-market:ideal-customer-profile` | "ICP 스코어링" |
| Growth Loops | `pm-go-to-market:growth-loops` | "성장 루프" |
| Battlecard | `pm-go-to-market:competitive-battlecard` | "배틀카드" |
| North Star Metric | `pm-marketing-growth:north-star-metric` | "노스스타 메트릭" (team-marketing CMO 위임) |

## 라우팅 원칙

1. **한국어 자연어 → prd-create 우선**. 사용자가 "PRD 만들어" 류 표현 시 기존 4-Phase 실행.
2. **프레임워크 명시 요청 시 team-pm 또는 pm-* 직접 호출**. 예: "BMC로 작성"·"9섹션"·"프레임워크 기반".
3. **보강**: prd-create Phase 2 종료 후 `pm-product-strategy:business-model` 호출하면 BMC 부록 추가 가능. 단, 중복 섹션 방지를 위해 사용자 확인 후 실행.

## 호출 체인 예시

```
사용자: "새 앱 PRD 써줘, BMC도 넣어"

1. /do → prd-create (한국어 자연어)
2. prd-create Phase 1-2 실행
3. Phase 2 말미 "BMC 섹션 추가할까요?" INFORM
4. 사용자 YES → pm-product-strategy:business-model 호출
5. 결과 → PRD 부록 섹션으로 통합
6. 온톨로지: Product (prd-create) + Assumption (BMC Key Assumptions 블록)
```

## 참고
- SSOT: `~/.claude/rules/pm-skills-integration.md` §3 (PRD 분기 규칙)
- team-pm 라우팅: `~/.claude/skills/team-pm/references/role-routing.yaml`
