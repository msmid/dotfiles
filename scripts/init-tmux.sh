#!/usr/bin/env bash
# Start a tmux session from a project.json configuration.
set -euo pipefail

usage () {
  cat <<'EOF'
Start a tmux session from a project.json configuration file.

Usage:
  dotfiles init-tmux <path-to-project.json>

project.json format:
  {
    "version": "1",
    "session": "my-app",
    "windows": [
      {
        "name": "code",
        "path": "/absolute/path/to/dir",
        "panes": [
          { "split": "h", "size": 30, "path": "/other/dir" },
          { "split": "v", "size": 50, "command": "npm run dev" }
        ]
      },
      { "name": "notes", "path": "/absolute/path/to/dir" }
    ]
  }

Window fields:
  name      Window name
  path      Working directory for the window
  command   Command to run in the window (optional)
  panes     Optional array of additional pane splits

Pane fields:
  split     "h" (side-by-side) or "v" (top-bottom)
  size      Percentage of the pane to split (optional)
  path      Working directory (optional, inherits from window)
  command   Command to run in the pane (optional)
EOF
}

if [[ $# -eq 0 ]] || [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
  usage
  exit 0
fi

CONFIG="$1"

if [[ ! -f "$CONFIG" ]]; then
  echo "Error: config file not found: $CONFIG"
  exit 1
fi

#
# Parse project.json with python3
#
PARSE_OUTPUT="$(CONFIG_PATH="$CONFIG" /usr/bin/python3 -c '
import json, os, shlex

with open(os.environ["CONFIG_PATH"]) as f:
    config = json.load(f)

session = config["session"]
windows = config["windows"]

print(f"SESSION={shlex.quote(session)}")
print(f"WINDOW_COUNT={len(windows)}")

for i, w in enumerate(windows):
    n = shlex.quote(w["name"])
    p = shlex.quote(w["path"])
    c = shlex.quote(w.get("command", ""))
    print(f"WINDOW_{i}_NAME={n}")
    print(f"WINDOW_{i}_PATH={p}")
    print(f"WINDOW_{i}_CMD={c}")

    panes = w.get("panes", [])
    print(f"WINDOW_{i}_PANE_COUNT={len(panes)}")

    for j, pane in enumerate(panes):
        split = shlex.quote(pane.get("split", "h"))
        size = pane.get("size", "")
        pane_path = shlex.quote(pane.get("path", w["path"]))
        cmd = shlex.quote(pane.get("command", ""))
        print(f"WINDOW_{i}_PANE_{j}_SPLIT={split}")
        print(f"WINDOW_{i}_PANE_{j}_SIZE={size}")
        print(f"WINDOW_{i}_PANE_{j}_PATH={pane_path}")
        print(f"WINDOW_{i}_PANE_{j}_CMD={cmd}")
')"

if [[ -z "$PARSE_OUTPUT" ]]; then
  echo "Error: failed to parse $CONFIG"
  exit 1
fi

eval "$PARSE_OUTPUT"

#
# Check if session already exists
#
if tmux has-session -t "$SESSION" 2>/dev/null; then
  echo "Session '$SESSION' already exists."
  if [[ -n "${TMUX:-}" ]]; then
    tmux switch-client -t "$SESSION"
  else
    tmux attach-session -t "$SESSION"
  fi
  exit 0
fi

#
# Create session with first window
#
tmux new-session -d -s "$SESSION" -n "$WINDOW_0_NAME" -c "$WINDOW_0_PATH"
[[ -n "$WINDOW_0_CMD" ]] && tmux send-keys -t "$SESSION" "$WINDOW_0_CMD" C-m

#
# Create panes for first window
#
eval "pane_count=\${WINDOW_0_PANE_COUNT:-0}"
for (( j = 0; j < pane_count; j++ )); do
  eval "split=\$WINDOW_0_PANE_${j}_SPLIT"
  eval "size=\$WINDOW_0_PANE_${j}_SIZE"
  eval "pane_path=\$WINDOW_0_PANE_${j}_PATH"
  eval "cmd=\$WINDOW_0_PANE_${j}_CMD"

  split_flag="-h"
  [[ "$split" == "v" ]] && split_flag="-v"

  split_args=("$split_flag")
  [[ -n "$size" ]] && split_args+=("-p" "$size")
  [[ -n "$pane_path" ]] && split_args+=("-c" "$pane_path")

  tmux split-window -t "$SESSION" "${split_args[@]}"

  [[ -n "$cmd" ]] && tmux send-keys -t "$SESSION" "$cmd" C-m
done

#
# Create remaining windows
#
for (( i = 1; i < WINDOW_COUNT; i++ )); do
  eval "name=\$WINDOW_${i}_NAME"
  eval "path=\$WINDOW_${i}_PATH"
  eval "cmd=\$WINDOW_${i}_CMD"
  tmux new-window -t "$SESSION" -n "$name" -c "$path"
  [[ -n "$cmd" ]] && tmux send-keys -t "$SESSION" "$cmd" C-m

  eval "pane_count=\${WINDOW_${i}_PANE_COUNT:-0}"
  for (( j = 0; j < pane_count; j++ )); do
    eval "split=\$WINDOW_${i}_PANE_${j}_SPLIT"
    eval "size=\$WINDOW_${i}_PANE_${j}_SIZE"
    eval "pane_path=\$WINDOW_${i}_PANE_${j}_PATH"
    eval "cmd=\$WINDOW_${i}_PANE_${j}_CMD"

    split_flag="-h"
    [[ "$split" == "v" ]] && split_flag="-v"

    split_args=("$split_flag")
    [[ -n "$size" ]] && split_args+=("-p" "$size")
    [[ -n "$pane_path" ]] && split_args+=("-c" "$pane_path")

    tmux split-window -t "$SESSION" "${split_args[@]}"

    [[ -n "$cmd" ]] && tmux send-keys -t "$SESSION" "$cmd" C-m
  done
done

#
# Select first window
#
tmux select-window -t "$SESSION:1"

#
# Attach or switch to session
#
if [[ -n "${TMUX:-}" ]]; then
  tmux switch-client -t "$SESSION"
else
  tmux attach-session -t "$SESSION"
fi
