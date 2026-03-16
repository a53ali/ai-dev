#!/usr/bin/env bash
# block-destructive.sh — PreToolUse hook (Bash)
#
# Blocks shell commands that could cause irreversible data loss:
#   - rm -rf on non-temp paths
#   - git push --force / git push -f (without --force-with-lease)
#   - DROP TABLE / DROP DATABASE SQL statements
#   - Pipe to /dev/null on important paths
#
# Wired via .claude/settings.json:
#   PreToolUse → matcher "Bash" → this script

set -euo pipefail

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // ""')

deny() {
  local reason="$1"
  jq -n --arg reason "$reason" '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "deny",
      permissionDecisionReason: $reason
    }
  }'
  exit 0
}

# Block rm -rf on non-tmp paths
if echo "$COMMAND" | grep -qE 'rm\s+-[a-z]*r[a-z]*f|rm\s+-[a-z]*f[a-z]*r'; then
  # Allow on /tmp, /var/tmp, node_modules, .git/tmp, build/ dist/ artifacts
  if ! echo "$COMMAND" | grep -qE '/tmp|/var/tmp|node_modules|\.git/tmp|/dist/|/build/|/target/|/__pycache__/'; then
    deny "Blocked: 'rm -rf' on a non-temporary path is irreversible. Use 'rm -i' or move to trash instead. If intentional, run this command directly in your shell with '! command'."
  fi
fi

# Block git force push (but allow --force-with-lease which is safer)
if echo "$COMMAND" | grep -qE 'git\s+push.*\s(--force|-f)\b'; then
  if ! echo "$COMMAND" | grep -q 'force-with-lease'; then
    deny "Blocked: 'git push --force' rewrites remote history. Use '--force-with-lease' instead to protect against overwriting others' work."
  fi
fi

# Block destructive SQL DDL
if echo "$COMMAND" | grep -qiE '\b(DROP\s+(TABLE|DATABASE|SCHEMA)|TRUNCATE\s+TABLE)\b'; then
  deny "Blocked: Destructive SQL statement detected (DROP/TRUNCATE). Run this manually after reviewing the impact."
fi

exit 0
