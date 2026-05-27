---
name: ontology
description: "지식 그래프 관리. 엔티티 CRUD + 관계 연결 + 관계 맵 탐색. /ontology, /ontology query, /ontology add, /ontology link, /ontology map, /ontology sync. '온톨로지', '지식 그래프', '관계 탐색' 키워드로도 호출."
---

# 지식 그래프 관리 스킬

$ARGUMENTS를 파싱하여 모드를 결정한다:
- 인자 없음 → **조회 모드** (전체 인덱스 출력)
- `query [검색어]` → **검색 모드**
- `add [타입] [이름]` → **생성 모드**
- `link [A] [관계] [B]` → **연결 모드**
- `map [엔티티]` → **맵 모드**
- `sync` → **동기화 모드**

## 파일 경로
- 스키마: ~/.Codex/memory/ontology/schema.yaml
- 그래프: ~/.Codex/memory/ontology/graph.jsonl
- 인덱스: ~/.Codex/memory/ontology/index.md

## 조회/검색 모드

1. ~/.Codex/memory/ontology/index.md 읽기
2. 검색어가 있으면 graph.jsonl에서 매칭되는 엔티티 필터
3. 결과 출력

## 생성 모드 (/ontology add [타입] [이름])

1. schema.yaml 읽어서 타입 검증
2. required 필드 확인 → 부족하면 사용자에게 질문
3. graph.jsonl에 JSON 라인 append:
   ```json
   {"op":"create","type":"[타입]","id":"[자동생성]","props":{...},"ts":"YYYY-MM-DD"}
   ```
4. index.md 갱신

## 연결 모드 (/ontology link [A] [관계] [B])

1. schema.yaml에서 관계 타입 검증 (from/to 타입 체크)
2. A, B 엔티티가 존재하는지 확인
3. graph.jsonl에 관계 append:
   ```json
   {"op":"relate","from":"[A_id]","rel":"[관계]","to":"[B_id]","ts":"YYYY-MM-DD"}
   ```
4. index.md 갱신

## 맵 모드 (/ontology map [엔티티])

1. graph.jsonl에서 해당 엔티티와 연결된 모든 관계 탐색
2. 트리 형식으로 출력:
   ```
   [엔티티명] ([타입])
   ├── [관계] → [대상] ([타입])
   ├── [관계] → [대상] ([타입])
   └── [관계] ← [출처] ([타입])
   ```

## 동기화 모드 (/ontology sync)

1. graph.jsonl 전체 파싱
2. index.md를 재생성 (엔티티 요약, 핵심 관계, 최근 변경)

## 규칙
- graph.jsonl은 append-only. 삭제 대신 `{"op":"archive","id":"..."}` 사용
- 모든 mutation에 타임스탬프 포함
- schema.yaml 외의 타입/관계 사용 금지
