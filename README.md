# ai-dev — Skills Library for Engineers & Engineering Managers

A curated set of **51 AI agent skills** for engineers, QA engineers, and engineering managers. Works with **Claude Code**, **Codex CLI**, and **GitHub Copilot CLI**. Language-agnostic, grounded in industry-proven principles.

---

## Quick Start

### One-liner install (no clone required)

**Claude Code**
```bash
curl -fsSL https://raw.githubusercontent.com/a53ali/ai-dev/main/install.sh | bash -s -- --profile=recommended --agent=claude

# Engineer skills
curl -fsSL https://raw.githubusercontent.com/a53ali/ai-dev/main/install.sh | bash -s -- --profile=engineer --agent=claude

# Manager skills
curl -fsSL https://raw.githubusercontent.com/a53ali/ai-dev/main/install.sh | bash -s -- --profile=manager --agent=claude

# QA skills
curl -fsSL https://raw.githubusercontent.com/a53ali/ai-dev/main/install.sh | bash -s -- --profile=qa --agent=claude
```

**Codex CLI**
```bash
curl -fsSL https://raw.githubusercontent.com/a53ali/ai-dev/main/install.sh | bash -s -- --profile=recommended --agent=codex
curl -fsSL https://raw.githubusercontent.com/a53ali/ai-dev/main/install.sh | bash -s -- --profile=engineer --agent=codex
```

**GitHub Copilot CLI**
```bash
curl -fsSL https://raw.githubusercontent.com/a53ali/ai-dev/main/install.sh | bash -s -- --profile=recommended --agent=copilot
curl -fsSL https://raw.githubusercontent.com/a53ali/ai-dev/main/install.sh | bash -s -- --profile=all --agent=copilot
```

### Clone + auto-discover (no install needed)

If you work from inside this cloned repo, **Codex** and **Claude Code** discover skills automatically:

```bash
git clone https://github.com/a53ali/ai-dev.git
cd ai-dev
./install.sh --profile=all --agent=claude     # installs to ~/.claude/skills/
./install.sh --profile=all --agent=codex      # installs to ~/.codex/skills/
./install.sh --profile=all --agent=copilot    # installs to ~/.copilot/skills/
```

---

## Profiles

| Profile | Skills | Best for |
|---------|--------|----------|
| `recommended` | skill-router, refactoring, code-review, debugging, tdd, backlog-refinement, observability | Anyone — start here |
| `engineer` | All 12 engineer skills | ICs and senior engineers |
| `manager` | All 11 manager skills | EMs, tech leads, staff+ |
| `qa` | test-strategy, bug-reporting, acceptance-criteria, exploratory-testing + 4 cross-cutting | QA engineers and SDETs |
| `planning` | tdd, adr, backlog-refinement, flow-metrics, sprint-health, roadmap | Sprint planning and delivery |
| `cross-cutting` | skill-router, strangler-fig, observability, team-topology, event-driven, monolith-to-services, ci-cd, agent-quality, mcp-safety-review, jira-intelligence, context-engineering, platform-engineering, slo-sla-management, developer-experience | Architecture and platform work |
| `all` | All 51 skills | Full library |

---

## What's in this repo

| Directory | Purpose |
|-----------|---------|
| `skills/` | 51 AI agent skills (guidance documents) |
| `hooks/` | Claude Code lifecycle hooks — enforce behaviour automatically |
| `templates/` | Drop-in `CLAUDE.md` / `AGENTS.md` / `copilot-instructions.md` templates |
| `mcp/` | Curated MCP server configs (Jira, Confluence, GitHub, Linear) |
| `profiles/` | Skill bundles by role for `install.sh` |

---

## Agent Compatibility

| Agent | Install path | Format |
|-------|-------------|--------|
| **Claude Code** | `~/.claude/skills/` | `skill-name/SKILL.md` |
| **Codex CLI** | `~/.codex/skills/` | `skill-name/SKILL.md` |
| **Copilot CLI** | `~/.copilot/skills/` | flat `skill-name.md` |

Skills follow the [agentskills.io](https://agentskills.io) open standard — natively compatible with Claude Code and Codex CLI.

---

## How to use a skill

**Claude Code:** type `/skill-name` or Claude loads it automatically when relevant
**Codex CLI:** type `$skill-name` or Codex loads it automatically when relevant
**Copilot CLI:** run `/skills` to browse, or reference the skill name in your prompt

> **Tip:** Start with `skill-router` — describe your problem and it will recommend which skills to apply and in what order.

---

## Philosophy

These skills are built on two bodies of knowledge:
- **[martinfowler.com](https://martinfowler.com)** — Refactoring, architecture patterns, continuous delivery, tech debt, ADRs, strangler fig, feature toggles, evolutionary database design, event-driven architecture
- **[leaddev.com](https://leaddev.com)** — Engineering leadership, DORA metrics, blameless retrospectives, team health, flow metrics, career ladders

Skills work across monoliths, modular monoliths, and distributed/microservice architectures.

---

## Hooks (Claude Code only)

Hooks run shell scripts automatically at lifecycle events — before/after file writes, before shell commands, etc. They **enforce** behaviour rather than just guiding it.

```bash
# Install all hooks to your user-level Claude settings
mkdir -p ~/.claude/hooks
cp hooks/*.sh ~/.claude/hooks/ && chmod +x ~/.claude/hooks/*.sh
cp hooks/settings.json ~/.claude/settings.json
```

See [`hooks/README.md`](hooks/README.md) for per-hook documentation and project-level install instructions.

| Hook | Trigger | Effect |
|------|---------|--------|
| `secrets-scanner.sh` | Before Write/Edit | Blocks API keys, tokens, private keys |
| `lint-on-write.sh` | After Write/Edit | Runs ESLint / Ruff / shellcheck automatically |
| `test-reminder.sh` | After Write/Edit | Reminds agent to add tests for changed source files |
| `block-destructive.sh` | Before Bash | Blocks `rm -rf`, `git push --force`, `DROP TABLE` |
| `conventional-commit.sh` | Before Bash | Validates commit messages follow Conventional Commits |

---

## Templates

Drop-in instruction files that give agents immediate project context. Copy one to your project root before starting a session.

```bash
cp templates/CLAUDE.md.engineer ./CLAUDE.md   # Claude Code — engineer project
cp templates/CLAUDE.md.manager  ./CLAUDE.md   # Claude Code — manager workspace
cp templates/AGENTS.md          ./AGENTS.md   # Codex CLI
cp templates/copilot-instructions.md .github/ # GitHub Copilot CLI
```

See [`templates/README.md`](templates/README.md) for full usage guide.

---

## MCP Configurations

Pre-configured MCP server definitions for common engineering tools. MCPs extend what agents can *do* (live data access) rather than how they behave.

```bash
# See mcp/README.md for setup instructions per agent
cat mcp/jira.json        # Jira — query/create issues, manage sprints
cat mcp/confluence.json  # Confluence — search/write pages
cat mcp/github.json      # GitHub — PRs, issues, code search, CI
cat mcp/linear.json      # Linear — issues, cycles, projects
```

See [`mcp/README.md`](mcp/README.md) for setup per agent (Claude Code / Codex / Copilot CLI).

---

## Skill Index

### 🧪 QA / Quality Engineer Skills

| Skill | Path | When to Use |
|-------|------|-------------|
| **Test Strategy** | `skills/qa/test-strategy/` | Define what to test, at which layer, with risk-based prioritization |
| **Bug Reporting** | `skills/qa/bug-reporting/` | Write reproducible, high-quality bug reports with severity/priority rubric |
| **Acceptance Criteria** | `skills/qa/acceptance-criteria/` | Given/When/Then scenarios, Definition of Ready, Definition of Done |
| **Exploratory Testing** | `skills/qa/exploratory-testing/` | Test charters, SBTM, heuristics for finding what scripted tests miss |
| **Accessibility Testing** | `skills/qa/accessibility-testing/` | WCAG 2.1 AA checklist, keyboard/screen reader scripts, axe-core CI integration |

### 🧭 Start Here

| Skill | Path | When to Use |
|-------|------|-------------|
| **Skill Router** | `skills/cross-cutting/skill-router/` | Don't know where to start? Describe your problem and get a ranked skill list |

### 🧑‍💻 Engineer / IC Skills

| Skill | Path | When to Use |
|-------|------|-------------|
| **Refactoring** | `skills/engineer/refactoring/` | Improving code structure without changing behavior |
| **Test-Driven Development** | `skills/engineer/test-driven-development/` | Writing code using red-green-refactor |
| **Architecture Decision Record** | `skills/engineer/architecture-decision-record/` | Capturing or querying architectural decisions |
| **Code Review** | `skills/engineer/code-review/` | Reviewing PRs with high signal-to-noise |
| **Debugging** | `skills/engineer/debugging/` | Systematic fault isolation and diagnosis |
| **Continuous Delivery** | `skills/engineer/continuous-delivery/` | CI/CD pipeline health, branch strategy, deploy readiness |
| **API Design** | `skills/engineer/api-design/` | Designing REST or GraphQL APIs |
| **Feature Flags** | `skills/engineer/feature-flags/` | Introducing, gating, and retiring feature toggles |
| **Security Review** | `skills/engineer/security-review/` | OWASP-aligned threat modeling for features and PRs |
| **Database Migration** | `skills/engineer/database-migration/` | Zero-downtime schema changes with expand/contract pattern |
| **Pair Programming** | `skills/engineer/pair-programming/` | Structured driver/navigator pairing with AI agents or humans |
| **Documentation** | `skills/engineer/documentation/` | READMEs, runbooks, API docs using the Divio system |
| **Performance Optimization** | `skills/engineer/performance-optimization/` | Profile-first bottleneck analysis (CPU, memory, I/O, N+1) with runtime-specific tooling |
| **Contract Testing** | `skills/engineer/contract-testing/` | Consumer-driven contract testing with Pact to decouple service teams |
| **Database Optimization** | `skills/engineer/database-optimization/` | EXPLAIN ANALYZE, index strategy, N+1 fixes, keyset pagination, slow query analysis |
| **Chaos Engineering** | `skills/engineer/chaos-engineering/` | GameDay planning, steady-state hypothesis, blast-radius controlled fault injection |

### 🧑‍💼 Engineering Manager Skills

| Skill | Path | When to Use |
|-------|------|-------------|
| **Backlog Refinement** | `skills/manager/backlog-refinement/` | INVEST criteria, story writing, sizing, sprint readiness |
| **Incident Retrospective** | `skills/manager/incident-retrospective/` | Running blameless post-mortems |
| **Technical Debt Prioritization** | `skills/manager/technical-debt-prioritization/` | Tech debt scoring with business impact framing |
| **Engineering Metrics** | `skills/manager/engineering-metrics/` | DORA metrics analysis and team performance |
| **Flow Metrics Analysis** | `skills/manager/flow-metrics-analysis/` | Cycle time, WIP, flow efficiency, DORA correlation |
| **On-Call Handoff** | `skills/manager/on-call-handoff/` | Structured shift handoffs that eliminate context loss |
| **Hiring & Leveling** | `skills/manager/hiring-leveling/` | Rubric-based IC leveling for hiring and promotions |
| **Sprint Health Check** | `skills/manager/sprint-health-check/` | Mid-sprint signal reading for scope, progress, blockers, morale |
| **Roadmap Prioritization** | `skills/manager/roadmap-prioritization/` | RICE/ICE scoring + dependency mapping for quarterly planning |
| **Sprint Retrospective** | `skills/manager/sprint-retrospective/` | Facilitate retros, analyze themes with AI, create tracked action items |
| **Story Slicing** | `skills/manager/story-slicing/` | Slice epics into vertical slices; agent-native work breakdown, story enhancement, edge case generation, dependency detection, NL→JQL, and point estimation |
| **Technical Strategy** | `skills/manager/technical-strategy/` | Diagnosis → guiding policies → coherent actions; strategy doc and communication templates |
| **1:1 Coaching** | `skills/manager/one-on-one-coaching/` | GROW model coaching, SBI feedback, career conversations, question banks by scenario |
| **Engineer Onboarding** | `skills/manager/engineer-onboarding/` | 30/60/90 day plan, pre-day-1 checklist, time-to-first-PR metrics, ramp-up strategy |
| **OKR Alignment** | `skills/manager/okr-engineering-alignment/` | Outcome-based OKRs, DORA metrics as Key Results, output-vs-outcome conversion |
| **Vendor Evaluation** | `skills/manager/vendor-evaluation/` | Build vs. buy matrix, evaluation scorecard, TCO worksheet, contract red flags |

### 🔀 Cross-Cutting Skills

| Skill | Path | When to Use |
|-------|------|-------------|
| **Skill Router** | `skills/cross-cutting/skill-router/` | Routes problem → right skills in the right order |
| **Strangler Fig Migration** | `skills/cross-cutting/strangler-fig/` | Extracting functionality from a monolith incrementally |
| **Observability** | `skills/cross-cutting/observability/` | Structured logging, metrics, distributed tracing |
| **Team Topology** | `skills/cross-cutting/team-topology/` | Stream-aligned, platform, enabling, and complicated-subsystem teams |
| **Event-Driven Design** | `skills/cross-cutting/event-driven-design/` | Event storming, domain events, pub/sub, CQRS, event sourcing |
| **Monolith to Services** | `skills/cross-cutting/monolith-to-services/` | Decomposition heuristics, bounded contexts, service extraction order |
| **CI/CD Pipeline Analysis** | `skills/cross-cutting/ci-cd-pipeline-analysis/` | Diagnose slow/failing pipelines on GitHub Actions, Jenkins, TeamCity |
| **Agent Quality Patterns** | `skills/cross-cutting/agent-quality-patterns/` | Self-critique loops, evaluator-optimizer, LLM-as-judge, golden dataset evals |
| **MCP Safety Review** | `skills/cross-cutting/mcp-safety-review/` | Evaluate an MCP's outbound requests, blast radius, prompt injection risk, secrets handling, and sandbox validation |
| **Jira Intelligence** | `skills/cross-cutting/jira-intelligence/` | Agent-native Jira AI — work breakdown, story enhancement, comment summary, edge cases, dependency detection, point estimation, NL→JQL |
| **Context Engineering** | `skills/cross-cutting/context-engineering/` | Structure CLAUDE.md/AGENTS.md context files; optimize what agents know, when, and how |
| **Platform Engineering** | `skills/cross-cutting/platform-engineering/` | IDP maturity model, golden paths, platform-as-product, paved road charter, KPI dashboard |
| **SLO/SLA Management** | `skills/cross-cutting/slo-sla-management/` | SLI/SLO/SLA definitions, error budget calculation, burn rate alerts, ship-or-freeze guide |
| **Developer Experience** | `skills/cross-cutting/developer-experience/` | SPACE framework, inner/outer loop audit, DX backlog prioritization, toolchain scoring |

---

## Skill Format

Each skill (`SKILL.md`) follows the [agentskills.io](https://agentskills.io) open standard:
1. **Frontmatter** — `name`, `description` (required by spec)
2. **Context** — what this skill is and when it applies
3. **Instructions** — step-by-step agent behavior
4. **Principles** — the underlying theory/pattern being applied
5. **Output format** — what the agent should produce

---

## Contributing

1. Create a new directory under `skills/<category>/<skill-name>/`
2. Add a `SKILL.md` file following the existing format
3. Add the skill to relevant `profiles/*.yaml` files
4. Update `install.sh` — add the skill path to the appropriate array(s)
5. Update this README's skill index table

---

*Built for use with Claude Code, Codex CLI, and GitHub Copilot CLI.*

