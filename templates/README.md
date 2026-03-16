# Templates

Drop-in instruction files that give coding agents project context immediately. Place in your project root (or `~/.claude/` for user-level defaults) before starting a session.

> These templates work with Claude Code (`CLAUDE.md`), Codex CLI (`AGENTS.md`), and GitHub Copilot CLI (`.github/copilot-instructions.md`).

---

## Files

| Template | Agent | Best for |
|----------|-------|----------|
| `CLAUDE.md.engineer` | Claude Code | Backend, full-stack, or platform engineer projects |
| `CLAUDE.md.manager` | Claude Code | Managers: meeting notes, decision docs, roadmaps, OKRs |
| `AGENTS.md` | Codex CLI | Generic project — works for any role |
| `copilot-instructions.md` | GitHub Copilot CLI | Copilot-specific project instructions |

---

## Usage

```bash
# Engineer — Claude Code
cp templates/CLAUDE.md.engineer ./CLAUDE.md
# Edit the placeholders (PROJECT_NAME, STACK, etc.) then open Claude Code

# Manager — Claude Code
cp templates/CLAUDE.md.manager ./CLAUDE.md

# Codex CLI
cp templates/AGENTS.md ./AGENTS.md

# GitHub Copilot CLI
mkdir -p .github
cp templates/copilot-instructions.md .github/copilot-instructions.md
```

For user-level defaults (applies to all projects):
```bash
cp templates/CLAUDE.md.engineer ~/.claude/CLAUDE.md
```

---

## See also
- `skills/cross-cutting/context-engineering/SKILL.md` — full guide on what to put in these files and why
- [Claude Code docs — CLAUDE.md](https://docs.anthropic.com/en/docs/claude-code/memory)
- [Codex CLI docs — AGENTS.md](https://github.com/openai/codex/blob/main/docs/skills.md)
