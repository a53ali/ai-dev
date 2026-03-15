# ai-dev — Copilot CLI Skills Library

A curated set of **Copilot CLI skill files** for engineers and engineering managers. Designed for day-to-day use with AI coding agents (GitHub Copilot CLI, Codex, Claude). Language-agnostic, grounded in industry-proven principles.

## Philosophy

These skills are built on two bodies of knowledge:
- **[martinfowler.com](https://martinfowler.com)** — Refactoring, architecture patterns, continuous delivery, tech debt, ADRs, strangler fig, feature toggles
- **[leaddev.com](https://leaddev.com)** — Engineering leadership, DORA metrics, blameless retrospectives, team health, LLM/AI impact on teams

Skills work across monoliths, modular monoliths, and distributed/microservice architectures.

---

## Usage

### Install a skill
Place any skill file in your Copilot CLI skills directory:
```bash
# User-level (applies everywhere)
cp skills/<category>/<skill>.md ~/.copilot/skills/

# Or use the /skills command inside Copilot CLI
/skills
```

### Use a skill
Inside a Copilot CLI session, invoke via the `/skills` command or reference by name in your prompt:
```
/skills refactoring
```

---

## Skill Index

### 🧑‍💻 Engineer / IC Skills

| Skill | File | When to Use |
|-------|------|-------------|
| **Refactoring** | `skills/engineer/refactoring.md` | Improving code structure without changing behavior |
| **Test-Driven Development** | `skills/engineer/test-driven-development.md` | Writing code using red-green-refactor |
| **Architecture Decision Record** | `skills/engineer/architecture-decision-record.md` | Capturing or querying architectural decisions |
| **Code Review** | `skills/engineer/code-review.md` | Reviewing PRs with high signal-to-noise |
| **Debugging** | `skills/engineer/debugging.md` | Systematic fault isolation and diagnosis |
| **Continuous Delivery** | `skills/engineer/continuous-delivery.md` | CI/CD pipeline health, branch strategy, deploy readiness |
| **API Design** | `skills/engineer/api-design.md` | Designing REST or GraphQL APIs |
| **Feature Flags** | `skills/engineer/feature-flags.md` | Introducing, gating, and retiring feature toggles |

### 🧑‍💼 Engineering Manager Skills

| Skill | File | When to Use |
|-------|------|-------------|
| **Incident Retrospective** | `skills/manager/incident-retrospective.md` | Running blameless post-mortems |
| **Technical Debt Prioritization** | `skills/manager/technical-debt-prioritization.md` | Identifying and queuing tech debt with business framing |
| **Engineering Metrics** | `skills/manager/engineering-metrics.md` | Analyzing DORA metrics and team performance signals |
| **Backlog Refinement** | `skills/manager/backlog-refinement.md` | Running effective refinement sessions, INVEST criteria, sizing, splitting |
| **Flow Metrics Analysis** | `skills/manager/flow-metrics-analysis.md` | Analyze story cycle time in-progress→done, WIP, flow efficiency, DORA correlation |

### 🔀 Cross-Cutting Skills

| Skill | File | When to Use |
|-------|------|-------------|
| **Strangler Fig Migration** | `skills/cross-cutting/strangler-fig.md` | Extracting functionality from a monolith incrementally |
| **Observability** | `skills/cross-cutting/observability.md` | Adding structured logging, metrics, and tracing |

---

## Skill File Format

Each skill is a markdown file with:
1. **Frontmatter** — `name`, `description`, `triggers` (keywords that invoke it)
2. **Context** — what this skill is and when it applies
3. **Instructions** — step-by-step agent behavior
4. **Principles** — the underlying theory/pattern being applied
5. **Output format** — what the agent should produce

---

## Contributing

1. Add new skill files under the appropriate category directory
2. Follow the existing skill file format
3. Reference a credible principle source in the Principles section
4. Update this README's skill index table

---

*Built for use with GitHub Copilot CLI, Codex, and Claude-based agents.*
