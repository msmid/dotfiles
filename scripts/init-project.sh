#!/usr/bin/env bash
# Initialize a new project folder structure.
set -euo pipefail

SCRIPTS_DIR="$(dirname "$(readlink -f "$0")")"

usage () {
  cat <<'EOF'
Create a new project folder with a standard structure.

Usage:
  dotfiles init-project [absolute-path]

If no path is provided, the current directory is used.

Example:
  dotfiles init-project /Users/martin/dev/projects/my-app
  dotfiles init-project

Creates:
  <path>/
  ├── git/
  └── .dev/
      ├── dotdev.json
      ├── notes/
      │   └── dev.md
      └── scripts/
          └── start.sh
EOF
}

if [[ "${1:-}" == "-h" ]] || [[ "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

PROJECT_PATH="${1:-$(pwd)}"

if [[ "$PROJECT_PATH" != /* ]]; then
  echo "Error: path must be absolute (got: $PROJECT_PATH)"
  exit 1
fi

PROJECT_NAME="$(basename "$PROJECT_PATH")"

write_file () {
  local file="$1"
  local label="$2"
  if [[ -f "$file" ]]; then
    echo "  $label exists... skipped"
    return 1
  fi
  return 0
}

echo "Creating project: $PROJECT_NAME"
echo "  Path: $PROJECT_PATH"

#
# Create directory structure
#
mkdir -p "$PROJECT_PATH/git"
mkdir -p "$PROJECT_PATH/.dev/notes"
mkdir -p "$PROJECT_PATH/.dev/scripts"

#
# Create dev.md
#
if write_file "$PROJECT_PATH/.dev/notes/dev.md" "dev.md"; then
  cat > "$PROJECT_PATH/.dev/notes/dev.md" <<EOF
# $PROJECT_PATH
EOF
fi

#
# Create dotdev.json
#
if write_file "$PROJECT_PATH/.dev/dotdev.json" "dotdev.json"; then
  cat > "$PROJECT_PATH/.dev/dotdev.json" <<EOF
{
  "version": "1",
  "session": "$PROJECT_NAME",
  "cursor": {
    "path": "$PROJECT_PATH/git"
  },
  "windows": [
    { "name": "code", "path": "$PROJECT_PATH/git" },
    { "name": "notes", "path": "$PROJECT_PATH/.dev/notes" },
    { "name": "dev", "path": "$PROJECT_PATH/.dev" }
  ]
}
EOF
fi

#
# Create start.sh
#
if write_file "$PROJECT_PATH/.dev/scripts/start.sh" "start.sh"; then
  cat > "$PROJECT_PATH/.dev/scripts/start.sh" <<'SCRIPT'
#!/usr/bin/env bash
# Start tmux session for this project.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
dotfiles start "$SCRIPT_DIR/../dotdev.json"
SCRIPT

  chmod +x "$PROJECT_PATH/.dev/scripts/start.sh"
fi

echo ""
echo "Project created successfully."
echo ""
echo "Start tmux session:"
echo "  $PROJECT_PATH/.dev/scripts/start.sh"
echo "  # or"
echo "  dotfiles start $PROJECT_PATH/.dev/dotdev.json"
