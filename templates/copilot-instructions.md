# Copilot Instructions — PROJECT_NAME

<!-- This file is read by GitHub Copilot CLI at session start -->
<!-- Place at .github/copilot-instructions.md in your repository -->
<!-- Replace UPPERCASE placeholders before committing -->

## Project context

PROJECT_NAME: DESCRIPTION

Stack: LANGUAGE / FRAMEWORK / DATABASE
Environment: INFRA

## Repository layout

```
src/          # Application source
tests/        # Tests (mirror src/ structure)
docs/         # Docs, ADRs, runbooks
.github/      # Workflows, issue templates, copilot config
```

## Running the project

```bash
INSTALL_CMD    # Install dependencies
DEV_CMD        # Start dev server / REPL
TEST_CMD       # Run test suite
LINT_CMD       # Lint and type-check
```

## Code standards

- Language version: LANGUAGE_VERSION
- Style guide: STYLE_GUIDE (e.g. Airbnb / PEP 8 / Google)
- All new features require tests
- Commits follow Conventional Commits format

## What to focus on

When making changes:
1. Understand the existing pattern before introducing a new one
2. Prefer editing existing files over creating new ones where appropriate
3. Keep changes small and focused — one concern per PR
4. Run tests and linter before considering a change complete

## What to avoid

- Don't add new dependencies without checking with the team
- Don't modify `*.lock` files manually
- Don't add `console.log` / `print` debug statements to committed code
- Don't bypass TypeScript types with `any` / `@ts-ignore`

## Relevant skills installed

If you have `a53ali/ai-dev` skills installed, prefer these for common tasks:
- `code-review` — reviewing PRs
- `test-driven-development` — writing new features
- `debugging` — diagnosing issues
- `refactoring` — improving code structure
- `security-review` — before merging security-sensitive changes
