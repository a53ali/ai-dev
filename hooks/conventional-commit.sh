#!/usr/bin/env bash
# conventional-commit.sh — PreToolUse hook (Bash)
#
# When Claude runs a `git commit` command, validates the message follows
# Conventional Commits format: https://www.conventionalcommits.org
#
# Valid:   feat(auth): add JWT refresh endpoint
# Valid:   fix: correct null check in payment handler
# Valid:   chore!: drop Node 16 support
# Invalid: "updated stuff" or "WIP" or "fix bug"
#
# Wired via .claude/settings.json:
#   PreToolUse → matcher "Bash" → this script

set -euo pipefail

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // ""')

# Only check git commit commands
echo "$COMMAND" | grep -qE 'git\s+commit' || exit 0

# Extract the commit message from -m "..." or -m '...'
MSG=$(echo "$COMMAND" | grep -oE '\-m\s+["\047][^"'\'']+["\047]' | sed "s/-m ['\"]//;s/['\"]$//" | head -1)

[ -z "$MSG" ] && exit 0  # Can't extract message (multiline editor commit) — skip

# Conventional commits pattern
# type(scope)!: description
CC_PATTERN='^(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)(\([a-z0-9_/-]+\))?(!)?: .{1,100}'

if ! echo "$MSG" | grep -qE "$CC_PATTERN"; then
  jq -n --arg msg "$MSG" '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "deny",
      permissionDecisionReason: "Commit message does not follow Conventional Commits format.\n\nYour message: \($msg)\n\nExpected format: <type>(<scope>): <description>\n\nValid types: feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert\n\nExamples:\n  feat(auth): add JWT refresh endpoint\n  fix: correct null check in payment\n  chore!: drop Node 16 support (breaking change)"
    }
  }'
  exit 0
fi

exit 0
