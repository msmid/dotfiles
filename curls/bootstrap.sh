#!/usr/bin/env bash
# Run curl-style installers listed in installs.txt.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
LIST="$ROOT/installs.txt"

info () {
  printf "\r  [ \033[00;34m..\033[0m ] %s\n" "$1"
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] %s\n" "$1"
}

fail () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] %s\n" "$1"
}

if [[ ! -f "$LIST" ]]; then
  fail "missing $LIST"
  exit 1
fi

failed=0

while IFS= read -r line || [[ -n "${line:-}" ]]; do
  # Trim leading and trailing whitespace.
  line="${line#"${line%%[![:space:]]*}"}"
  line="${line%"${line##*[![:space:]]}"}"

  [[ -z "$line" || "$line" == \#* ]] && continue

  info "$line"
  if bash -c "$line"; then
    success "$line"
  else
    fail "$line"
    failed=1
  fi
done < "$LIST"

exit "$failed"
