# Advanced Orchestration v6.0

`deep/full`은 별도 파이프라인이 아니라 canonical pipeline의 강화 프로필이다. 즉 기본 경로를 버리고 다른 엔진으로 가는 것이 아니라, 같은 discovery-first 단계 중 일부를 더 깊게 활성화한다.

## 언제 읽는가

- 사용자가 `deep`, `full`, `update`, `extend`, `deep dive`를 명시
- 비교/실사/문헌리뷰처럼 반증과 증거 체인이 중요함
- 표면적 candidate discovery만으로는 답이 약한 주제
- high-rigor 도메인에서 검증 강도를 높여야 함

## deep/full에서 추가로 강화되는 것

- `Open-World Discovery` 예산 증가
- `Deep Reading` 예산 증가
- `Targeted Gap Search` 기본 활성화
- `CoverageLedger` 기준 강화
- `Self-Verify` 필수화

## 단계별 차이

- `standard`: discovery + normalization + dynamic taxonomy 필수
- `deep`: deep reading + targeted gap search + stronger self-verify
- `full`: deep의 모든 요소 + 더 넓은 fan-out + 더 엄격한 completeness 기준

## 읽을 순서

1. `orchestrator/orchestrator.md`
2. `references/canonical-schemas.md`
3. `agents/index.md`
4. 필요한 `agents/*/config.yaml`
5. 필요한 `agents/*/prompts.md`
6. 필요한 `protocols/*.yaml`
