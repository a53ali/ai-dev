# PROJECT_NAME — Agent Context

<!-- This file is read by Codex CLI (and compatible agents) at session start -->
<!-- Replace UPPERCASE placeholders before committing -->

## Project

PROJECT_NAME — DESCRIPTION (1-2 sentences)

**Stack:** LANGUAGE · FRAMEWORK · DATABASE
**Repo:** https://github.com/ORG/REPO

## Structure

```
src/         # Application source
tests/       # Test files mirror src/ structure
docs/        # Architecture decisions, runbooks
scripts/     # Build, deploy, maintenance scripts
```

## Commands

```bash
# Setup
SETUP_COMMAND          # e.g. npm install / pip install -e ".[dev]"

# Dev
DEV_COMMAND            # e.g. npm run dev / make dev

# Test
TEST_COMMAND           # e.g. npm test / pytest / go test ./...

# Lint
LINT_COMMAND           # e.g. npm run lint / ruff check . / golangci-lint run

# Build
BUILD_COMMAND          # e.g. npm run build / docker build -t app .
```

## Conventions

- **Commits:** Conventional Commits (`feat:`, `fix:`, `chore:`, `docs:`)
- **Branch naming:** `feature/<ticket>-description` or `fix/<ticket>-description`
- **Tests:** Required for all new behaviour in `src/`
- **Secrets:** Environment variables only — never hardcoded

## Do not

- Modify migration files that have already been applied
- Push directly to `main` — always use a PR
- Use deprecated APIs listed in `docs/deprecated.md`

## Key files

- `docs/ARCHITECTURE.md` — system overview and data flows
- `docs/adr/` — Architecture Decision Records
- `.env.example` — required environment variables
- `CONTRIBUTING.md` — contribution guidelines
