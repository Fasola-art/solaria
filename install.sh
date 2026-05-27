#!/usr/bin/env bash
set -euo pipefail

DRY_RUN=0
DO_BACKUP=1
LINK_CLAUDE=1
LINK_CODEX=1

usage() {
  cat <<'EOF'
Usage: ./install.sh [options]

Install Solaria into ~/.agents and expose skill-management to Claude/Codex.

Options:
  --dry-run      Show what would happen without changing files.
  --no-backup    Do not create a timestamped backup of an existing ~/.agents.
  --no-claude    Do not create ~/.claude/skills/skill-management symlink.
  --no-codex     Do not create ~/.codex/skills/skill-management symlink.
  -h, --help     Show this help.
EOF
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --dry-run) DRY_RUN=1 ;;
    --no-backup) DO_BACKUP=0 ;;
    --no-claude) LINK_CLAUDE=0 ;;
    --no-codex) LINK_CODEX=0 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage; exit 2 ;;
  esac
  shift
done

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
AGENTS_HOME="${HOME}/.agents"
BACKUP_ROOT="${HOME}/.agents-backups"
STAMP="$(date +%Y%m%d-%H%M%S)"

copy_items=(
  "bin"
  "skills"
  "personas"
  "ontology"
  "evals"
  "external-skills"
  "reports"
  "skills-registry.json"
)

run() {
  if [ "$DRY_RUN" -eq 1 ]; then
    printf '[dry-run] %q' "$1"
    shift
    for arg in "$@"; do
      printf ' %q' "$arg"
    done
    printf '\n'
  else
    "$@"
  fi
}

backup_path() {
  local path="$1"
  local label="$2"
  if [ ! -e "$path" ] && [ ! -L "$path" ]; then
    return
  fi
  if [ "$DO_BACKUP" -ne 1 ]; then
    return
  fi
  local dest="${BACKUP_ROOT}/${STAMP}/${label}"
  run mkdir -p "$(dirname "$dest")"
  run cp -R "$path" "$dest"
}

link_skill_management() {
  local runtime_root="$1"
  local label="$2"
  local link_path="${runtime_root}/skills/skill-management"
  local target="../../.agents/skills/skill-management"

  if [ -e "$link_path" ] || [ -L "$link_path" ]; then
    if [ -L "$link_path" ] && [ "$(readlink "$link_path")" = "$target" ]; then
      echo "${label}: skill-management symlink already exists"
      return
    fi
    backup_path "$link_path" "${label}-skill-management"
    run rm -rf "$link_path"
  fi

  run mkdir -p "${runtime_root}/skills"
  run ln -s "$target" "$link_path"
}

echo "Solaria installer"
echo "Source: ${ROOT_DIR}"
echo "Target: ${AGENTS_HOME}"

if ! command -v rsync >/dev/null 2>&1; then
  echo "rsync is required but was not found." >&2
  exit 1
fi

if [ "$DO_BACKUP" -eq 1 ] && { [ -e "$AGENTS_HOME" ] || [ -L "$AGENTS_HOME" ]; }; then
  echo "Backing up existing ~/.agents to ${BACKUP_ROOT}/${STAMP}/agents"
  backup_path "$AGENTS_HOME" "agents"
fi

run mkdir -p "$AGENTS_HOME"
run mkdir -p "${AGENTS_HOME}/research/creation-briefs"

for item in "${copy_items[@]}"; do
  src="${ROOT_DIR}/${item}"
  if [ ! -e "$src" ]; then
    echo "Missing expected install item: ${src}" >&2
    exit 1
  fi
  run rsync -a \
    --exclude '.git/' \
    --exclude '__pycache__/' \
    --exclude '*.pyc' \
    --exclude '.DS_Store' \
    "$src" \
    "$AGENTS_HOME/"
done

if [ "$LINK_CLAUDE" -eq 1 ]; then
  link_skill_management "${HOME}/.claude" "claude"
fi

if [ "$LINK_CODEX" -eq 1 ]; then
  link_skill_management "${HOME}/.codex" "codex"
fi

if [ "$DRY_RUN" -eq 0 ] && [ -x "${AGENTS_HOME}/bin/skill-health-check" ]; then
  "${AGENTS_HOME}/bin/skill-health-check" --write
fi

echo "Install complete."
