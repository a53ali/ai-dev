#!/usr/bin/env bash
# secrets-scanner.sh — PreToolUse hook (Write / Edit)
#
# Blocks writing common secret patterns to files before the write executes.
# Wired via .claude/settings.json:
#   PreToolUse → matcher "Write|Edit" → this script
#
# Input (stdin): JSON with tool_name and tool_input fields
# Output: JSON permissionDecision if a secret is detected; exit 0 to allow

set -euo pipefail

INPUT=$(cat)

# Extract the content being written (Write tool uses "content"; Edit uses "new_content")
CONTENT=$(echo "$INPUT" | jq -r '
  if .tool_input.content then .tool_input.content
  elif .tool_input.new_content then .tool_input.new_content
  else ""
  end
')

FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.path // .tool_input.file_path // ""')

# Skip binary-ish files and lockfiles
case "$FILE_PATH" in
  *.lock|*.sum|*.png|*.jpg|*.jpeg|*.gif|*.ico|*.wasm|*.bin) exit 0 ;;
esac

# Patterns that suggest a real secret (not a placeholder)
PATTERNS=(
  # Generic high-entropy tokens (32+ hex chars)
  '[0-9a-fA-F]{32,}'
  # AWS
  'AKIA[0-9A-Z]{16}'
  'aws_secret_access_key\s*=\s*[A-Za-z0-9+/]{40}'
  # GitHub
  'ghp_[A-Za-z0-9]{36}'
  'github_pat_[A-Za-z0-9_]{82}'
  # Slack
  'xox[baprs]-[A-Za-z0-9-]+'
  # Stripe
  'sk_live_[A-Za-z0-9]{24,}'
  # Generic API key assignments (key = "value" with long value)
  '(api_key|apikey|secret_key|private_key|auth_token|access_token)\s*[=:]\s*["\047][A-Za-z0-9+/._-]{20,}["\047]'
  # Private key block
  '-----BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY-----'
)

for PATTERN in "${PATTERNS[@]}"; do
  if echo "$CONTENT" | grep -qEi "$PATTERN"; then
    MATCHED=$(echo "$CONTENT" | grep -Eio "$PATTERN" | head -1 | cut -c1-20)
    jq -n \
      --arg reason "Potential secret detected (matched: '${MATCHED}...'). Use an environment variable or secrets manager instead. If this is a false positive, use \`! skip-secrets-check\` in your prompt." \
      '{
        hookSpecificOutput: {
          hookEventName: "PreToolUse",
          permissionDecision: "deny",
          permissionDecisionReason: $reason
        }
      }'
    exit 0
  fi
done

exit 0
