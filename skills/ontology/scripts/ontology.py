#!/usr/bin/env python3
"""온톨로지 그래프 CLI - Python 3.9 호환
사용법:
  python3 ontology.py query [검색어]
  python3 ontology.py create --type Person --props '{"name":"홍길동","role":"dev"}'
  python3 ontology.py relate --from user_001 --rel uses --to tool_node
  python3 ontology.py validate
  python3 ontology.py sync
"""

import json
import sys
import os
from datetime import datetime
from pathlib import Path

ONTOLOGY_DIR = Path.home() / ".claude" / "memory" / "ontology"
GRAPH_FILE = ONTOLOGY_DIR / "graph.jsonl"
SCHEMA_FILE = ONTOLOGY_DIR / "schema.yaml"
INDEX_FILE = ONTOLOGY_DIR / "index.md"


def load_graph():
    """graph.jsonl에서 모든 엔트리 로드"""
    entries = []
    if GRAPH_FILE.exists():
        with open(GRAPH_FILE, "r", encoding="utf-8") as f:
            for line in f:
                line = line.strip()
                if line:
                    entries.append(json.loads(line))
    return entries


def get_entities(entries):
    """활성 엔티티 딕셔너리 반환 (archive 제외)"""
    entities = {}
    archived = set()
    for e in entries:
        if e.get("op") == "create":
            entities[e["id"]] = e
        elif e.get("op") == "archive":
            archived.add(e["id"])
    return {k: v for k, v in entities.items() if k not in archived}


def get_relations(entries):
    """활성 관계 리스트 반환"""
    relations = []
    for e in entries:
        if e.get("op") == "relate":
            relations.append(e)
    return relations


def cmd_query(search_term=None):
    """엔티티 조회/검색"""
    entries = load_graph()
    entities = get_entities(entries)
    relations = get_relations(entries)

    if search_term:
        search_lower = search_term.lower()
        results = {}
        for eid, ent in entities.items():
            props_str = json.dumps(ent.get("props", {}), ensure_ascii=False).lower()
            if search_lower in eid.lower() or search_lower in props_str or search_lower in ent.get("type", "").lower():
                results[eid] = ent
        entities = results

    print("# 온톨로지 조회 결과")
    print("")
    for eid, ent in entities.items():
        props = ent.get("props", {})
        name = props.get("name", props.get("title", eid))
        print("- [%s] %s (%s)" % (eid, name, ent.get("type", "?")))

    if not entities:
        print("(결과 없음)")


def cmd_create(entity_type, props_json):
    """새 엔티티 생성"""
    props = json.loads(props_json)
    name = props.get("name", props.get("title", "unnamed"))
    eid = "%s_%s" % (entity_type.lower(), name.lower().replace(" ", "_")[:20])

    entry = {
        "op": "create",
        "type": entity_type,
        "id": eid,
        "props": props,
        "ts": datetime.now().strftime("%Y-%m-%d"),
    }

    with open(GRAPH_FILE, "a", encoding="utf-8") as f:
        f.write(json.dumps(entry, ensure_ascii=False) + "\n")

    print("생성됨: [%s] %s (%s)" % (eid, name, entity_type))


def cmd_relate(from_id, rel, to_id):
    """관계 추가"""
    entry = {
        "op": "relate",
        "from": from_id,
        "rel": rel,
        "to": to_id,
        "ts": datetime.now().strftime("%Y-%m-%d"),
    }

    with open(GRAPH_FILE, "a", encoding="utf-8") as f:
        f.write(json.dumps(entry, ensure_ascii=False) + "\n")

    print("관계 추가: %s --%s--> %s" % (from_id, rel, to_id))


def cmd_validate():
    """그래프 무결성 검증"""
    entries = load_graph()
    entities = get_entities(entries)
    relations = get_relations(entries)
    errors = []

    for rel in relations:
        if rel["from"] not in entities:
            errors.append("관계 출발점 없음: %s" % rel["from"])
        if rel["to"] not in entities:
            errors.append("관계 도착점 없음: %s" % rel["to"])

    if errors:
        print("검증 실패: %d개 오류" % len(errors))
        for err in errors:
            print("  - %s" % err)
    else:
        print("검증 통과: %d 엔티티, %d 관계" % (len(entities), len(relations)))


def cmd_sync():
    """index.md 재생성"""
    entries = load_graph()
    entities = get_entities(entries)
    relations = get_relations(entries)

    # 타입별 그룹핑
    by_type = {}
    for eid, ent in entities.items():
        t = ent.get("type", "Unknown")
        if t not in by_type:
            by_type[t] = []
        name = ent.get("props", {}).get("name", ent.get("props", {}).get("title", eid))
        by_type[t].append((eid, name))

    # index.md 생성
    lines = ["# 온톨로지 인덱스", ""]
    lines.append("## 엔티티 요약 (총 %d개)" % len(entities))
    for t, items in sorted(by_type.items()):
        names = ", ".join(["%s(%s)" % (name, eid) for eid, name in items])
        lines.append("- %s: %s" % (t, names))

    lines.append("")
    lines.append("## 핵심 관계")
    for rel in relations[:20]:
        lines.append("- %s --%s--> %s" % (rel["from"], rel["rel"], rel["to"]))
    if len(relations) > 20:
        lines.append("- ... 외 %d개" % (len(relations) - 20))

    lines.append("")
    lines.append("## 최근 변경 (최신 10건)")
    for entry in entries[-10:]:
        op = entry.get("op", "?")
        ts = entry.get("ts", "?")
        if op == "create":
            name = entry.get("props", {}).get("name", entry.get("id", "?"))
            lines.append("- [%s] %s: %s 생성" % (ts, entry.get("type", "?"), name))
        elif op == "relate":
            lines.append("- [%s] %s --%s--> %s" % (ts, entry["from"], entry["rel"], entry["to"]))

    with open(INDEX_FILE, "w", encoding="utf-8") as f:
        f.write("\n".join(lines) + "\n")

    print("index.md 갱신 완료: %d 엔티티, %d 관계" % (len(entities), len(relations)))


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(0)

    cmd = sys.argv[1]

    if cmd == "query":
        search = sys.argv[2] if len(sys.argv) > 2 else None
        cmd_query(search)
    elif cmd == "create":
        if "--type" in sys.argv and "--props" in sys.argv:
            t_idx = sys.argv.index("--type") + 1
            p_idx = sys.argv.index("--props") + 1
            cmd_create(sys.argv[t_idx], sys.argv[p_idx])
        else:
            print("사용법: ontology.py create --type [타입] --props '{...}'")
    elif cmd == "relate":
        if "--from" in sys.argv and "--rel" in sys.argv and "--to" in sys.argv:
            f_idx = sys.argv.index("--from") + 1
            r_idx = sys.argv.index("--rel") + 1
            t_idx = sys.argv.index("--to") + 1
            cmd_relate(sys.argv[f_idx], sys.argv[r_idx], sys.argv[t_idx])
        else:
            print("사용법: ontology.py relate --from [ID] --rel [관계] --to [ID]")
    elif cmd == "validate":
        cmd_validate()
    elif cmd == "sync":
        cmd_sync()
    else:
        print("알 수 없는 명령: %s" % cmd)
        print(__doc__)
