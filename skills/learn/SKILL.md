---
name: learn
description: "자기학습 스킬. 세션 분석 → 패턴 추출 → instinct 기록 → 반복 시 메모리 승격 → 온톨로지 등록. /learn, /learn --evolve, /learn --prune 세 가지 모드. '학습', 'learn', '패턴 저장' 키워드로도 호출."
---

# 자기학습 스킬

$ARGUMENTS를 파싱하여 모드를 결정한다:
- 인자 없음 또는 기본 → **캡처 모드**
- `--evolve` → **진화 모드**
- `--prune` → **정리 모드**
- `--auto` → **비대화형 플래그** (--evolve / --prune 과 함께 사용)
  - 대화형 선택지(Option A/B/C 등)가 있을 때 가장 안전한 기본값(전체 스캔 / 보수적 승격)을 자동 선택하고 진행
  - 사용자 확인 질문 출력 금지
  - 결과 요약만 stdout에 출력
  - `Codex -p` 크론 환경에서 hang 방지 용도

## 캡처 모드 (/learn)

현재 세션을 분석하여 재사용 가능한 패턴을 추출한다.

1. **분석 항목**:
   - 사용된 도구/MCP 시퀀스 (워크플로우 패턴)
   - 사용자가 교정한 사항 (선호 패턴)
   - 성공한 접근법 vs 실패한 접근법 (기술 패턴)

2. **중복 검사**: ~/.Codex/memory/instincts.md를 읽고 동일 패턴이 있는지 확인
   - 동일 패턴 존재 → ★ 업그레이드 (★☆☆→★★☆→★★★)
   - 새 패턴 → ★☆☆로 신규 기록

3. **기록 형식** (references/pattern-template.md 참조):
   ```
   ## [YYYY-MM-DD] 태그: 짧은 설명
   - 맥락: 무엇이 트리거했는가
   - 패턴: 재사용 가능한 인사이트
   - 신뢰도: ★☆☆
   - 출처: 세션/프로젝트
   ```

4. ~/.Codex/memory/instincts.md에 append

## 진화 모드 (/learn --evolve [--auto])

instincts.md에서 ★★☆ 이상 패턴을 분석하여 승격한다.

1. instincts.md 읽기 → ★★☆+ 패턴 식별
2. 패턴 유형별 승격:
   - 기술 패턴 → ~/.Codex/memory/patterns.md에 등록
   - 워크플로우 패턴 → ~/.Codex/memory/workflows.md에 등록
   - 선호 패턴 → ~/.Codex/memory/preferences.md에 등록
3. ★★★ 패턴 → ~/.Codex/memory/skill-candidates.md에 추가
4. **온톨로지 등록**: ~/.Codex/memory/ontology/graph.jsonl에 Pattern 엔티티 생성 + 관련 Tool/Project와 관계 연결
5. ~/.Codex/memory/ontology/index.md 갱신

## 정리 모드 (/learn --prune [--auto])

1. instincts.md에서 30일+ 된 ★☆☆ 항목 삭제
2. 60일+ 된 ★★☆ (진화 안 됨) → ★☆☆로 강등
3. 결과 요약 출력
