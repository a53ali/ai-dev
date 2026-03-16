#!/usr/bin/env bash
# lint-on-write.sh — PostToolUse hook (Write / Edit)
#
# Runs the project's linter after every file write or edit.
# Non-blocking: lint failures are surfaced as warnings, not hard blocks.
#
# Wired via .claude/settings.json:
#   PostToolUse → matcher "Write|Edit" → this script

set -euo pipefail

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.path // .tool_input.file_path // ""')

[ -z "$FILE_PATH" ] && exit 0

# Detect project type and run the right linter
run_lint() {
  local file="$1"
  local ext="${file##*.}"

  # Walk up to find the project root (contains package.json, pyproject.toml, etc.)
  local dir
  dir=$(dirname "$(realpath "$file" 2>/dev/null || echo "$file")")

  case "$ext" in
    js|jsx|ts|tsx|mjs|cjs)
      # Try eslint
      if command -v eslint &>/dev/null; then
        eslint --no-eslintrc --quiet "$file" 2>&1 | head -20
      elif [ -f "$dir/node_modules/.bin/eslint" ]; then
        "$dir/node_modules/.bin/eslint" --quiet "$file" 2>&1 | head -20
      fi
      ;;
    py)
      if command -v ruff &>/dev/null; then
        ruff check "$file" 2>&1 | head -20
      elif command -v flake8 &>/dev/null; then
        flake8 "$file" 2>&1 | head -20
      fi
      ;;
    go)
      if command -v golint &>/dev/null; then
        golint "$file" 2>&1 | head -20
      fi
      ;;
    rb)
      if command -v rubocop &>/dev/null; then
        rubocop --no-color "$file" 2>&1 | head -20
      fi
      ;;
    sh|bash)
      if command -v shellcheck &>/dev/null; then
        shellcheck "$file" 2>&1 | head -20
      fi
      ;;
  esac
}

LINT_OUTPUT=$(run_lint "$FILE_PATH" 2>/dev/null || true)

if [ -n "$LINT_OUTPUT" ]; then
  # Print as a warning so Claude sees it and can fix
  echo "⚠️  Lint issues in $FILE_PATH:"
  echo "$LINT_OUTPUT"
fi

exit 0
