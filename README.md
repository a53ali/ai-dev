# ai-dev — Skills Library for Engineers & Engineering Managers

A curated set of **15 AI agent skills** for engineers and engineering managers. Works with **Claude Code**, **Codex CLI**, and **GitHub Copilot CLI**. Language-agnostic, grounded in industry-proven principles.

---

## Quick Start

### One-liner install (no clone required)

**Claude Code**
```bash
# Recommended starter set
curl -fsSL https://raw.githubusercontent.com/a53ali/ai-dev/main/install.sh | bash -s -- --profile=recommended --agent=claude

# Engineer skills
curl -fsSL https://raw.githubusercontent.com/a53ali/ai-dev/main/install.sh | bash -s -- --profile=engineer --agent=claude

# Manager skills
curl -fsSL https://raw.githubusercontent.com/a53ali/ai-dev/main/install.sh | bash -s -- --profile=manager --agent=claude
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

# Codex auto-discovers from .agents/skills/
codex

# Claude Code auto-discovers from .claude/skills/
claude
```

### Local install from clone

```bash
git clone https://github.com/a53ali/ai-dev.git
cd ai-dev
./install.sh --profile=all --agent=claude     # installs to ~/.claude/skills/
./install.sh --profile=all --agent=codex      # installs to ~/.agents/skills/
./install.sh --profile=all --agent=copilot    # installs to ~/.copilot/skills/
```

---

## Profiles

| Profile | Skills | Best for |
|---------|--------|----------|
| `recommended` | refactoring, code-review, debugging, tdd, backlog-refinement | Anyone — start here |
| `engineer` | All 8 engineer skills | ICs and senior engineers |
| `manager` | All 5 manager skills | EMs, tech leads, staff+ |
| `planning` | tdd, adr, backlog-refinement, flow-metrics | Sprint planning and delivery |
| `cross-cutting` | strangler-fig, observability | Monolith migration and production health |
| `all` | All 15 skills | Full library |

---

## Agent Compatibility

| Agent | Install path | Format | Auto-discovery |
|-------|-------------|--------|---------------|
| **Claude Code** | `~/.claude/skills/` | `skill-name/SKILL.md` | `.claude/skills/` in repo |
| **Codex CLI** | `~/.agents/skills/` | `skill-name/SKILL.md` | `.agents/skills/` in repo |
| **Copilot CLI** | `~/.copilot/skills/` | flat `skill-name.md` | `/skills` command |

Skills follow the [agentskills.io](https://agentskills.io) open standard — natively compatible with Claude Code and Codex CLI.

---

## How to use a skill

**Claude Code:** type `/skill-name` or Claude loads it automatically when relevant
**Codex CLI:** type `$skill-name` or Codex loads it automatically when relevant
**Copilot CLI:** run `/skills` to browse, or reference the skill name in your prompt

---

## Philosophy

These skills are built on two bodies of knowledge:
- **[martinfowler.com](https://martinfowler.com)** — Refactoring, architecture patterns, continuous delivery, tech debt, ADRs, strangler fig, feature toggles
- **[leaddev.com](https://leaddev.com)** — Engineering leadership, DORA metrics, blameless retrospectives, team health, flow metrics

Skills work across monoliths, modular monoliths, and distributed/microservice architectures.

---

## Skill Index

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

### 🧑‍💼 Engineering Manager Skills

| Skill | Path | When to Use |
|-------|------|-------------|
| **Backlog Refinement** | `skills/manager/backlog-refinement/` | INVEST criteria, story writing, sizing, sprint readiness |
| **Incident Retrospective** | `skills/manager/incident-retrospective/` | Running blameless post-mortems |
| **Technical Debt Prioritization** | `skills/manager/technical-debt-prioritization/` | Tech debt scoring with business impact framing |
| **Engineering Metrics** | `skills/manager/engineering-metrics/` | DORA metrics analysis and team performance |
| **Flow Metrics Analysis** | `skills/manager/flow-metrics-analysis/` | Cycle time, WIP, flow efficiency, DORA correlation |

### 🔀 Cross-Cutting Skills

| Skill | Path | When to Use |
|-------|------|-------------|
| **Strangler Fig Migration** | `skills/cross-cutting/strangler-fig/` | Extracting functionality from a monolith incrementally |
| **Observability** | `skills/cross-cutting/observability/` | Structured logging, metrics, distributed tracing |

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
3. Add a symlink in `.agents/skills/` and `.claude/skills/`
4. Add the skill to relevant profiles in `profiles/`
5. Update this README's skill index table

---

*Built for use with Claude Code, Codex CLI, and GitHub Copilot CLI.*

