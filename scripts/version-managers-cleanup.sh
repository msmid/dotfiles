#!/usr/bin/env bash
# Uninstall unused rbenv/pyenv versions. Run with -h for full usage.
set -euo pipefail

usage() {
  cat <<'EOF'
Uninstall unused rbenv/pyenv versions. Keeps system and one current version.

Usage:
  version-managers-cleanup.sh ruby | rbenv     Clean rbenv (keeps system + 3.4.2)
  version-managers-cleanup.sh python | pyenv   Clean pyenv (keeps system + 3.13.x)
  -n, --dry-run                     Print what would be removed, don't uninstall
  -h, --help                        Show this help

Override keep pattern via env:
  RBENV_KEEP='^system$|^3\.4\.2$'   (default)
  PYENV_KEEP='^system$|^3\.13\.'    (default; e.g. ^3\.12\. for 3.12.x)

Examples:
  ./version-managers-cleanup.sh ruby -n
  ./version-managers-cleanup.sh python --dry-run
  PYENV_KEEP='^system$|^3\.12\.' ./version-managers-cleanup.sh python
EOF
}

DRY_RUN=0
MODE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    -n|--dry-run) DRY_RUN=1; shift ;;
    -h|--help)    usage; exit 0 ;;
    ruby|rbenv)   MODE=rbenv; shift ;;
    python|pyenv) MODE=pyenv; shift ;;
    *) echo "Usage: $0 [ruby|python] [-n|--dry-run] [-h|--help]"; exit 1 ;;
  esac
done

[[ -z "$MODE" ]] && { usage; exit 1; }

# Versions to keep (regex): system + one current version
RBENV_KEEP="${RBENV_KEEP:-^system$|^3\.4\.2$}"
PYENV_KEEP="${PYENV_KEEP:-^system$|^3\.11\.11}"

if [[ "$MODE" == "rbenv" ]]; then
  KEEP_PATTERN="$RBENV_KEEP"
  CMD=rbenv
else
  KEEP_PATTERN="$PYENV_KEEP"
  CMD=pyenv
fi

(( DRY_RUN )) && echo "[dry run]"

$CMD versions --bare | while read -r ver; do
  [[ -z "$ver" ]] && continue
  if [[ "$ver" =~ $KEEP_PATTERN ]]; then
    echo "Keeping: $ver"
  else
    echo "Uninstalling: $ver"
    (( ! DRY_RUN )) && $CMD uninstall -f "$ver"
  fi
done

echo "Done. Remaining: $($CMD versions --bare | tr '\n' ' ')"
