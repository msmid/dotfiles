#!/usr/bin/env bash
# Initialize a new project folder structure.
set -euo pipefail

SCRIPTS_DIR="$(dirname "$(readlink -f "$0")")"

usage () {
  cat <<'EOF'
Create a new project folder with a standard structure.

Usage:
  dotfiles init-project <absolute-path>

Example:
  dotfiles init-project /Users/martin/dev/projects/my-app

Creates:
  <path>/
  ├── git/
  └── .dev/
      ├── project.json
      ├── notes/
      │   └── dev.md
      └── scripts/
          └── start.sh
EOF
}

if [[ $# -eq 0 ]] || [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
  usage
  exit 0
fi

PROJECT_PATH="$1"

if [[ "$PROJECT_PATH" != /* ]]; then
  echo "Error: path must be absolute (got: $PROJECT_PATH)"
  exit 1
fi

if [[ -d "$PROJECT_PATH" ]]; then
  echo "Error: directory already exists: $PROJECT_PATH"
  exit 1
fi

PROJECT_NAME="$(basename "$PROJECT_PATH")"

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
cat > "$PROJECT_PATH/.dev/notes/dev.md" <<EOF
# $PROJECT_PATH
EOF

#
# Create project.json
#
cat > "$PROJECT_PATH/.dev/project.json" <<EOF
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

#
# Create start.sh
#
cat > "$PROJECT_PATH/.dev/scripts/start.sh" <<'SCRIPT'
#!/usr/bin/env bash
# Start tmux session for this project.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
dotfiles start "$SCRIPT_DIR/../project.json"
SCRIPT

chmod +x "$PROJECT_PATH/.dev/scripts/start.sh"

echo ""
echo "Project created successfully."
echo ""
echo "Start tmux session:"
echo "  $PROJECT_PATH/.dev/scripts/start.sh"
echo "  # or"
echo "  dotfiles start $PROJECT_PATH/.dev/project.json"
