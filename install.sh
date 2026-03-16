#!/usr/bin/env bash
set -euo pipefail

# ai-dev skills installer
# Usage:
#   ./install.sh [--profile=PROFILE] [--agent=AGENT]
#   curl -fsSL https://raw.githubusercontent.com/a53ali/ai-dev/main/install.sh | bash -s -- [--profile=PROFILE] [--agent=AGENT]
#
# Profiles: recommended (default), engineer, manager, planning, cross-cutting, all
# Agents:   claude (default), codex, copilot

REPO="a53ali/ai-dev"
BRANCH="main"
RAW_BASE="https://raw.githubusercontent.com/${REPO}/${BRANCH}"
REPO_URL="https://github.com/${REPO}"

PROFILE="recommended"
AGENT="claude"

# ── Parse arguments ───────────────────────────────────────────────────────────
for arg in "$@"; do
  case "$arg" in
    --profile=*) PROFILE="${arg#*=}" ;;
    --agent=*)   AGENT="${arg#*=}" ;;
    --help|-h)
      echo "Usage: install.sh [--profile=PROFILE] [--agent=AGENT]"
      echo ""
      echo "Profiles:"
      echo "  recommended   Starter set (refactoring, code-review, debugging, tdd, backlog-refinement)"
      echo "  engineer      All 8 engineer / IC skills"
      echo "  manager       All 5 engineering manager skills"
      echo "  planning      Planning-focused skills (tdd, adr, backlog, flow-metrics)"
      echo "  cross-cutting Strangler fig + observability"
      echo "  all           All 15 skills"
      echo ""
      echo "Agents:"
      echo "  claude    → ~/.claude/skills/   (Claude Code, agentskills.io format)"
      echo "  codex     → ~/.agents/skills/   (Codex CLI, agentskills.io format)"
      echo "  copilot   → ~/.copilot/skills/  (GitHub Copilot CLI, flat .md format)"
      exit 0
      ;;
    *) echo "Unknown argument: $arg"; exit 1 ;;
  esac
done

# ── Resolve install destination ───────────────────────────────────────────────
case "$AGENT" in
  claude)  DEST="$HOME/.claude/skills" ;;
  codex)   DEST="$HOME/.agents/skills" ;;
  copilot) DEST="$HOME/.copilot/skills" ;;
  *)
    echo "Unknown agent: $AGENT. Choose from: claude, codex, copilot"
    exit 1
    ;;
esac

# ── Skill lists per profile ───────────────────────────────────────────────────
skills_recommended=(
  "skills/engineer/refactoring"
  "skills/engineer/code-review"
  "skills/engineer/debugging"
  "skills/engineer/test-driven-development"
  "skills/manager/backlog-refinement"
)

skills_engineer=(
  "skills/engineer/refactoring"
  "skills/engineer/test-driven-development"
  "skills/engineer/architecture-decision-record"
  "skills/engineer/code-review"
  "skills/engineer/debugging"
  "skills/engineer/continuous-delivery"
  "skills/engineer/api-design"
  "skills/engineer/feature-flags"
)

skills_manager=(
  "skills/manager/backlog-refinement"
  "skills/manager/incident-retrospective"
  "skills/manager/technical-debt-prioritization"
  "skills/manager/engineering-metrics"
  "skills/manager/flow-metrics-analysis"
)

skills_planning=(
  "skills/engineer/test-driven-development"
  "skills/engineer/architecture-decision-record"
  "skills/manager/backlog-refinement"
  "skills/manager/flow-metrics-analysis"
)

skills_cross_cutting=(
  "skills/cross-cutting/strangler-fig"
  "skills/cross-cutting/observability"
)

skills_all=(
  "${skills_engineer[@]}"
  "${skills_manager[@]}"
  "${skills_cross_cutting[@]}"
)

case "$PROFILE" in
  recommended)   skills=("${skills_recommended[@]}") ;;
  engineer)      skills=("${skills_engineer[@]}") ;;
  manager)       skills=("${skills_manager[@]}") ;;
  planning)      skills=("${skills_planning[@]}") ;;
  cross-cutting) skills=("${skills_cross_cutting[@]}") ;;
  all)           skills=("${skills_all[@]}") ;;
  *)
    echo "Unknown profile: $PROFILE. Choose from: recommended, engineer, manager, planning, cross-cutting, all"
    exit 1
    ;;
esac

# ── Detect local vs remote install ───────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-install.sh}")" 2>/dev/null && pwd || echo "")"
LOCAL_MODE=false
if [[ -n "$SCRIPT_DIR" && -d "$SCRIPT_DIR/skills" ]]; then
  LOCAL_MODE=true
fi

# ── Install functions ─────────────────────────────────────────────────────────
install_skill_local_dir() {
  local skill_path="$1"        # e.g. skills/engineer/refactoring
  local skill_name
  skill_name="$(basename "$skill_path")"
  local src="$SCRIPT_DIR/$skill_path"
  local dst="$DEST/$skill_name"

  mkdir -p "$dst"
  cp "$src/SKILL.md" "$dst/SKILL.md"
}

install_skill_local_flat() {
  local skill_path="$1"
  local skill_name
  skill_name="$(basename "$skill_path")"
  local src="$SCRIPT_DIR/$skill_path/SKILL.md"
  local dst="$DEST/${skill_name}.md"

  cp "$src" "$dst"
}

install_skill_remote_dir() {
  local skill_path="$1"
  local skill_name
  skill_name="$(basename "$skill_path")"
  local url="${RAW_BASE}/${skill_path}/SKILL.md"
  local dst="$DEST/$skill_name"

  mkdir -p "$dst"
  curl -fsSL "$url" -o "$dst/SKILL.md"
}

install_skill_remote_flat() {
  local skill_path="$1"
  local skill_name
  skill_name="$(basename "$skill_path")"
  local url="${RAW_BASE}/${skill_path}/SKILL.md"
  local dst="$DEST/${skill_name}.md"

  curl -fsSL "$url" -o "$dst"
}

# ── Main install ──────────────────────────────────────────────────────────────
echo ""
echo "  ai-dev skills installer"
echo "  Profile : $PROFILE (${#skills[@]} skills)"
echo "  Agent   : $AGENT"
echo "  Dest    : $DEST"
echo "  Mode    : $([ "$LOCAL_MODE" = true ] && echo local || echo remote)"
echo ""

mkdir -p "$DEST"

for skill in "${skills[@]}"; do
  skill_name="$(basename "$skill")"
  echo -n "  installing $skill_name ... "

  if [[ "$AGENT" == "copilot" ]]; then
    # Copilot CLI uses flat .md files
    if [[ "$LOCAL_MODE" == true ]]; then
      install_skill_local_flat "$skill"
    else
      install_skill_remote_flat "$skill"
    fi
  else
    # Claude Code and Codex use skill-name/SKILL.md directories
    if [[ "$LOCAL_MODE" == true ]]; then
      install_skill_local_dir "$skill"
    else
      install_skill_remote_dir "$skill"
    fi
  fi

  echo "done"
done

echo ""
echo "  ✓ Installed ${#skills[@]} skills to $DEST"
echo ""

# ── Post-install hints ────────────────────────────────────────────────────────
case "$AGENT" in
  claude)
    echo "  Use in Claude Code:"
    echo "    /<skill-name>   to invoke directly"
    echo "    Or Claude loads automatically when relevant"
    ;;
  codex)
    echo "  Use in Codex CLI:"
    echo "    \$<skill-name>   to invoke directly"
    echo "    Or Codex loads automatically when relevant"
    ;;
  copilot)
    echo "  Use in Copilot CLI:"
    echo "    /skills         to browse and select"
    ;;
esac

echo ""
echo "  Full skill library: ${REPO_URL}"
echo ""
