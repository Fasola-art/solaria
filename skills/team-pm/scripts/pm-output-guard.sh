#!/usr/bin/env bash
# PM Output Guard (team-pm 전용)
# SSOT: rules/pm-skills-integration.md §12
# 경고만 (exit 0), 차단은 기존 security-guard.sh 소관

set -euo pipefail

payload=$(cat)

text=$(echo "$payload" | /usr/bin/python3 -c "
import sys, json
try:
    p = json.load(sys.stdin)
    out = p.get('tool_response', {}).get('output', '') or ''
    inp = p.get('tool_input', {})
    if isinstance(inp, dict):
        for v in inp.values():
            if isinstance(v, str):
                out += '\n' + v
    print(out)
except Exception:
    pass
" 2>/dev/null || echo "")

patterns=(
  'sk-[A-Za-z0-9]{20,}'
  'AKIA[A-Z0-9]{16}'
  'ghp_[A-Za-z0-9]{20,}'
  'xoxb-[A-Za-z0-9-]{20,}'
  'DATABASE_URL=[a-z]+://[^[:space:]]+'
  'Bearer\s+[A-Za-z0-9_.-]{20,}'
)

detected=()
for pat in "${patterns[@]}"; do
  if echo "$text" | /usr/bin/grep -qE "$pat" 2>/dev/null; then
    detected+=("$pat")
  fi
done

if [ ${#detected[@]} -gt 0 ]; then
  echo "[PM-OUTPUT-GUARD] 경고: 민감 패턴 감지 (pm-data-analytics SQL 출력 주의)" >&2
  for p in "${detected[@]}"; do echo "  - $p" >&2; done
  echo "  rules/security.md § 재발급 프로토콜" >&2
fi

exit 0
