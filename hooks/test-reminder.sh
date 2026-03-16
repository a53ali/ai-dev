#!/usr/bin/env bash
# test-reminder.sh — PostToolUse hook (Write / Edit)
#
# When Claude edits a source file without a corresponding test file change in
# the same session, prints a reminder to add or update tests.
# Non-blocking — informational only.
#
# Wired via .claude/settings.json:
#   PostToolUse → matcher "Write|Edit" → this script

set -euo pipefail

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.path // .tool_input.file_path // ""')

[ -z "$FILE_PATH" ] && exit 0

# Only trigger on production source files (not already a test file)
is_source_file() {
  local f="$1"
  # Skip test files themselves
  [[ "$f" == *test* || "$f" == *spec* || "$f" == *__tests__* ]] && return 1
  # Skip config, lock, docs, etc.
  case "${f##*.}" in
    md|json|yaml|yml|lock|sum|txt|env|toml|ini|cfg|conf) return 1 ;;
  esac
  return 0
}

is_source_file "$FILE_PATH" || exit 0

# Try to find a corresponding test file
BASE="${FILE_PATH%.*}"
EXT="${FILE_PATH##*.}"
DIR=$(dirname "$FILE_PATH")
FILENAME=$(basename "$BASE")

POSSIBLE_TESTS=(
  "${BASE}.test.${EXT}"
  "${BASE}.spec.${EXT}"
  "${DIR}/__tests__/${FILENAME}.test.${EXT}"
  "${DIR}/__tests__/${FILENAME}.spec.${EXT}"
  "${DIR}/tests/test_${FILENAME}.${EXT}"
  "${DIR}/tests/${FILENAME}_test.${EXT}"
  "${BASE}_test.${EXT}"
)

for TEST_FILE in "${POSSIBLE_TESTS[@]}"; do
  if [ -f "$TEST_FILE" ]; then
    # Test file exists — no reminder needed
    exit 0
  fi
done

# No test file found — print a gentle reminder
echo "🧪 No test file found for $(basename "$FILE_PATH"). Consider adding tests:"
for TEST_FILE in "${POSSIBLE_TESTS[@]:0:3}"; do
  echo "   → $TEST_FILE"
done

exit 0
