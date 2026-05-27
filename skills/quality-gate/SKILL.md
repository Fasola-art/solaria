---
name: quality-gate
description: 8단계 품질 게이트 + Writer-Reviewer 루프. /quality-gate [경로]로 호출. 코드 변경 후 종합 품질 검증이 필요할 때 사용.
---

# Quality Gate 스킬

4-reviewer 병렬 검증 + 8단계 파이프라인으로 코드 품질을 종합 검증한다.

## 트리거
- `/quality-gate [파일/디렉토리]` 명시적 호출
- 코드 생성/수정 완료 후 자동 (선택적)
- Vibe 키워드 "확인해/chk" 사용 시

## 9단계 파이프라인

| 단계 | 실행 조건 | 도구 | 판정 |
|------|----------|------|------|
| 1.Syntax | .ts/.tsx/.js 존재 | tsc | 컴파일 성공 |
| 2.Type | tsconfig.json 존재 | tsc --noEmit | 0 errors |
| 3.Lint | eslint.config.* 존재 | eslint . | 0 errors |
| 4.Security | 항상 | reviewer 에이전트 호출 | 0 high-risk |
| 5.Test | *.test.* 존재 | vitest run | 통과 |
| 6.Performance | L/XL 작업만 | Lighthouse/수동 | 임계값 |
| 7.Docs | 공개 API | TSDoc 검증 | 문서화 |
| 8.Integration | e2e/ 존재 | playwright test | 통과 |
| **9.Brand** | DesignAsset/카피 산출물 존재 | content-quality-ops 위임 | WCAG AA + 금지어 0 + 라이선스 OK |

### 9단계 Brand Consistency Gate 상세
- **SSOT**: `~/.Codex/rules/design-marketing-integration.md` § 9 + `~/.Codex/skills/content-quality-ops/SKILL.md`
- **입력**: 대상 경로의 DesignAsset(이미지·HTML·SVG) + 카피 md/txt
- **5축 검증**: Seven Sweeps · WCAG 2.2 대비(AA 4.5:1) · 라이선스 · BrandVoice 금지 어휘 · 출처 명시
- **차단 조건**: 금지 어휘 1개 이상 OR 라이선스 미확인 OR 대비 AA 미달
- **PostToolUse 연동**: Write/Edit 대상이 `~/workspace/content/**` 또는 `design-tokens.*` 일 때 자동 트리거

실행 규칙:
- 단계 1-4: 모든 코드 변경에 필수
- 단계 5: 테스트 파일 존재 시 필수
- 단계 6-8: L/XL 작업에서만 (XS/S/M 스킵)
- 각 단계 실패 시: 다음 단계 진행 불가, 에러 피드백 반환

## Writer-Reviewer Loop

### 프로세스
1. Writer(worker 에이전트): 코드 생성/수정
2. 4-Reviewer 병렬 실행 (Agent tool, subagent_type: reviewer x 4)
3. 점수 집계 -> 85% 미만 시 피드백 -> Writer 재작업
4. 최대 3회 반복

### Reviewer 가중치 (기본)
| Reviewer | 가중치 | 검토 항목 |
|----------|--------|----------|
| Quality | 30% | 가독성, 타입 안전성, SOLID, DRY, UI/Hook 분리 |
| Security | 30% | XSS, 인젝션, 인증/인가, 민감정보, OWASP |
| Performance | 20% | 알고리즘, 렌더링, 메모리, N+1, 번들 |
| Accessibility | 20% | 시맨틱, ARIA, 키보드, 포커스 |

### 적응형 가중치 (코드 유형별)
| 코드 유형 | Quality | Security | Performance | Accessibility |
|-----------|---------|----------|-------------|---------------|
| Frontend Component | 25% | 25% | 20% | 30% |
| Backend API | 25% | 40% | 25% | 10% |
| Utility Function | 35% | 25% | 30% | 10% |
| Database Query | 20% | 40% | 35% | 5% |

### 기준
- 목표 점수: 85%
- 최대 재시도: 3회
- 판정: 종합 85% AND 보안 85% = PASS

## 스킵 조건
- 단순 질문/설명 요청
- 한 줄 수정
- 설정 파일 변경 (config, env)
- 문서/README 작성
- Vibe 키워드 "빠르게/qk" 사용 시

## 기존 Mac 훅과의 연동
- 단계 2(Type): ~/.Codex/hooks/type-check-gate.sh와 동일 -> 결과 재활용
- 단계 4(Security): reviewer 에이전트 보안 체크 호출
- 새로운 단계(1,3,5-8)만 추가 실행

## 출력 형식
```
Quality Score: 87% (2 iterations)
-- Quality: 88% | Security: 90% | Performance: 83% | Accessibility: 85%
-- Issues resolved: [요약]
-- Remaining: [남은 이슈 또는 PASS]
```

## 실행 가이드
1. 대상 코드 식별 (변경된 파일)
2. 8단계 파이프라인 순차 실행
3. 실패 시 에러 메시지 + 해결 가이드 반환
4. 통과 시 Writer-Reviewer 루프 진입
5. 4명의 reviewer 에이전트를 Agent tool로 병렬 호출
6. 점수 집계 후 피드백 정리
7. 85% 미만이면 worker 에이전트로 재작업 요청
8. 최대 3회 반복 후 결과 보고
