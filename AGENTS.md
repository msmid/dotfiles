# AGENTS.md

Guide for AI coding agents working in this dotfiles repository.

## Project Overview

Personal dotfiles repository for macOS (Apple Silicon). Shell-based configuration
manager that symlinks config files into `$HOME`. No application code, no compiled
languages -- pure shell scripts and config files.

**Author:** Martin Smid (`msmid` on GitHub)
**Target platform:** macOS ARM64 (`/opt/homebrew`)

## Repository Structure

```
dotfiles/
├── setup.sh                     # Main installer (symlinks *.prop files)
├── version-managers-cleanup.sh  # Utility: clean unused rbenv/pyenv versions
├── brew/
│   ├── bootstrap.sh             # Homebrew package manifest
│   └── install.sh               # Homebrew installer
├── git/
│   ├── .gitconfig               # Global git config
│   ├── aliases.zsh              # Git aliases (delegates to oh-my-zsh plugin)
│   └── symlinks.prop            # Symlink: .gitconfig -> ~/.gitconfig
├── iterm2/
│   ├── Default.json             # iTerm2 profile
│   └── root-loops.itermcolors   # Color scheme
├── macos/
│   ├── bootstrap.sh             # Minimal macOS bootstrap
│   └── configuration.sh         # macOS defaults (957 lines)
├── nvm/
│   └── bootstrap.sh             # Creates ~/.nvm directory
├── sdkman/
│   └── install.sh               # SDKMAN installer
├── tmux/
│   ├── .tmux.conf               # tmux config (catppuccin theme, TPM plugins)
│   └── symlinks.prop            # Symlink: .tmux.conf -> ~/.tmux.conf
└── zsh/
    ├── .zshrc                   # Zsh config (oh-my-zsh, PATH, tool init)
    ├── aliases.zsh              # Custom aliases
    └── symlinks.prop            # Symlink: .zshrc -> ~/.zshrc
```

## Build / Run Commands

There is no build system, test runner, or linter configured.

```sh
./setup.sh                               # Create symlinks (interactive conflict resolution)
./brew/install.sh                        # Install Homebrew itself
./brew/bootstrap.sh                      # Install all packages, casks, and fonts
./macos/configuration.sh                 # Configure macOS defaults
./version-managers-cleanup.sh ruby -n    # Dry-run cleanup of unused rbenv versions
./version-managers-cleanup.sh python     # Actually uninstall unused pyenv versions
```

No test runner, linter, or formatter is configured. If adding shell linting,
use `shellcheck` (one directive already exists in `setup.sh:25`).

## Symlinks Mechanism

Symlink definitions live in `symlinks.prop` files using `key=value` format:

```
$DOTFILES/zsh/.zshrc=$HOME/.zshrc
```

`$DOTFILES` and `$HOME` are expanded via `eval` at runtime.
`setup.sh` discovers these files with `find -maxdepth 3 -name 'symlinks.prop'`.

## Code Style Guidelines

### Shell Scripts

- **Shebang:** Use `#!/bin/sh` for POSIX-compatible scripts, `#!/usr/bin/env bash`
  for scripts requiring Bash features (arrays, `[[ ]]`, `set -euo pipefail`).
- **Strict mode:** Use `set -euo pipefail` in utility scripts
  (see `version-managers-cleanup.sh`). Not enforced in interactive/setup scripts.
- **Quoting:** Quote variables in most contexts (`"$var"`), especially in paths and
  conditionals. Unquoted expansion is acceptable in `PATH` assignments.
- **Indentation:** 2 spaces. No tabs.
- **Functions:** Use `function_name ()` syntax (space before parens, no `function` keyword).
  Use `local` for function-scoped variables.
- **Conditionals:** Use `[ ]` in `sh` scripts, `[[ ]]` in `bash` scripts.
  String comparison uses `==` (not `=`).
- **Comments:** Use `#` with a space after. Section headers use banner-style comments:
  ```sh
  #
  # Section Name
  #
  ```
  In `macos/configuration.sh`, use `###...###` box-style headers for major sections.
- **Output/logging:** Use ANSI color codes for user feedback:
  - `info` (blue), `user` (yellow), `success` (green), `fail` (red)
  - Pattern: `printf "\r  [ \033[COLOR] ICON \033[0m ] message\n"`
- **Error handling:** Use `exit` (no code) on failure in interactive scripts.
  Use `exit 1` in utility scripts with proper error messages.

### Configuration Files

- **`.zshrc`:** Heavy inline comments. Environment tool initialization order matters --
  SDKMAN must be at the end. Homebrew eval must come before tools that depend on it.
- **`.tmux.conf`:** Use comments to explain non-obvious bindings. Group related
  settings with blank-line separators.
- **`.gitconfig`:** Minimal -- only user identity and LFS filter.

### Naming Conventions

- **Directories:** Lowercase, named after the tool they configure (`git/`, `zsh/`, `tmux/`).
- **Scripts:** `snake-case.sh` for standalone utilities, `bootstrap.sh` / `install.sh`
  for setup scripts within tool directories.
- **Symlink files:** Always named `symlinks.prop`.
- **Aliases files:** Always named `aliases.zsh`.
- **Variables:** `UPPER_SNAKE_CASE` for exported env vars and constants.
  `lower_snake_case` for local variables.
- **Functions:** `lower_snake_case` with descriptive names (`install_dotfiles`,
  `symlink_file`, `source_if_exists`).

### Git Conventions

- **Commit messages:** Conventional commits format: `type: description`
  - Types used: `feat:`, `fix:`
  - Lowercase description, no period at end
  - Examples: `feat: add catppucin/tmux and config`, `fix: order of tmux plugins load`
- **Branch:** `main`
- **Remote:** `git@github.com:msmid/dotfiles.git`
- **Git LFS:** Configured (hooks installed). Avoid committing large binaries without LFS.

### Adding New Tool Configurations

When adding a new tool:

1. Create a directory named after the tool (e.g., `neovim/`).
2. Place the config file in that directory (e.g., `neovim/init.lua`).
3. Add a `symlinks.prop` file mapping source to destination.
4. If Homebrew install is needed, add `brew install <package>` to `brew/bootstrap.sh`.
5. If shell initialization is needed, add it to `zsh/.zshrc` (respect ordering constraints).

### Known Issues

- Alias sourcing in `.zshrc` (lines 131-133) is commented out with note "This is not working".
