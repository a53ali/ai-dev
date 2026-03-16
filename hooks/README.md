# Hooks

Shell scripts that run automatically at key points in Claude Code's lifecycle — before/after file writes, before shell commands, and on git commits. **Hooks enforce behaviour; skills guide it.**

> Hooks are Claude Code only. Codex CLI and GitHub Copilot CLI do not currently support hooks.

---

## What's included

| Script | Event | What it does |
|--------|-------|--------------|
| `secrets-scanner.sh` | PreToolUse (Write/Edit) | Blocks writing API keys, tokens, private keys before they reach disk |
| `lint-on-write.sh` | PostToolUse (Write/Edit) | Runs the project linter after every file edit (ESLint, Ruff, shellcheck, etc.) |
| `test-reminder.sh` | PostToolUse (Write/Edit) | Reminds Claude to add tests when a source file is changed with no corresponding test file |
| `block-destructive.sh` | PreToolUse (Bash) | Blocks `rm -rf` on non-temp paths, `git push --force`, `DROP TABLE` |
| `conventional-commit.sh` | PreToolUse (Bash) | Validates `git commit -m "..."` messages follow [Conventional Commits](https://www.conventionalcommits.org) |

---

## Install

### Option A — copy to your user-level hooks dir (applies to all projects)

```bash
mkdir -p ~/.claude/hooks
cp hooks/*.sh ~/.claude/hooks/
chmod +x ~/.claude/hooks/*.sh
```

Then merge `hooks/settings.json` into your `~/.claude/settings.json`:

```bash
# If you don't have a settings.json yet:
cp hooks/settings.json ~/.claude/settings.json

# If you already have one, merge manually or use jq:
jq -s '.[0] * .[1]' ~/.claude/settings.json hooks/settings.json > /tmp/merged.json \
  && mv /tmp/merged.json ~/.claude/settings.json
```

### Option B — project-level hooks (applies to this repo only, shareable with team)

```bash
mkdir -p .claude/hooks
cp hooks/*.sh .claude/hooks/
chmod +x .claude/hooks/*.sh
cp hooks/settings.json .claude/settings.json
```

Update the paths in `.claude/settings.json` to use relative paths:
```json
"command": ".claude/hooks/secrets-scanner.sh"
```

Commit `.claude/settings.json` and `.claude/hooks/` to share with your team.

---

## Hook reference

### `secrets-scanner.sh`
Blocks 8 secret patterns: AWS keys, GitHub PATs, Slack tokens, Stripe live keys, generic long API key assignments, and private key PEM blocks. **Denies** the write before it touches disk.

To bypass a false positive (e.g. test fixtures):
```
! skip-secrets-check — use this phrase in your prompt to skip the scanner once
```
Or run the write directly in your shell: `! echo "fake-key" > test-fixtures/mock.env`

### `lint-on-write.sh`
Auto-detects the linter based on file extension. Supported:
- `.js/.ts/.tsx` → ESLint (local or global)
- `.py` → Ruff (preferred) or Flake8
- `.go` → golint
- `.rb` → RuboCop
- `.sh/.bash` → shellcheck

Output is printed as a warning; the write is not blocked. Claude will see the lint output and can fix it in the next step.

### `test-reminder.sh`
Checks for a corresponding test file alongside the edited source file. Looks for:
- `foo.test.ts` / `foo.spec.ts`
- `__tests__/foo.test.ts`
- `tests/test_foo.py` / `tests/foo_test.py`

If none found, prints the 3 most likely test file paths as a reminder.

### `block-destructive.sh`
Blocks:
- `rm -rf` on paths that aren't `/tmp`, `node_modules`, `dist/`, `build/`, etc.
- `git push --force` (but **allows** `--force-with-lease`)
- `DROP TABLE` / `DROP DATABASE` / `TRUNCATE TABLE` SQL

To override intentionally: run the command directly in your shell with `!`.

### `conventional-commit.sh`
Validates commit messages match: `<type>(<scope>): <description>`

Valid types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`

Breaking changes use `!`: `feat(api)!: remove deprecated endpoint`

---

## Docs
- [Claude Code Hooks reference](https://docs.anthropic.com/en/docs/claude-code/hooks)
- [Hook configuration](https://docs.anthropic.com/en/docs/claude-code/settings#hook-configuration)
