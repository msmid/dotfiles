#!/usr/bin/env bash
# Dotfiles CLI — run utility scripts from anywhere.
set -euo pipefail

SCRIPTS_DIR="$(dirname "$(readlink -f "$0")")"

list_commands () {
  echo "Usage: dotfiles <command> [args...]"
  echo ""
  echo "Available commands:"
  for script in "$SCRIPTS_DIR"/*.sh; do
    local name
    name="$(basename "$script" .sh)"
    [[ "$name" == "dotfiles" ]] && continue
    local desc
    desc="$(sed -n '2s/^# *//p' "$script")"
    printf "  %-30s %s\n" "$name" "$desc"
  done
}

if [[ $# -eq 0 ]] || [[ "$1" == "help" ]] || [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
  list_commands
  exit 0
fi

CMD="$1"; shift
SCRIPT="$SCRIPTS_DIR/$CMD.sh"

if [[ ! -f "$SCRIPT" ]]; then
  echo "Unknown command: $CMD"
  echo ""
  list_commands
  exit 1
fi

exec bash "$SCRIPT" "$@"
