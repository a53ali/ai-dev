---
name: skill-router
description: Given a problem description, identify and sequence the most relevant skills from this library. Acts as the meta-orchestrator — routes any engineering or management challenge to the right skill(s) in the right order.
triggers:
  - "where do I start"
  - "which skill should I use"
  - "help me figure out approach"
  - "what's the right process for"
audience:
  - engineer
  - manager
---

# Skill Router

Given a problem, map it to the right skills and sequence them for maximum leverage.

## How to Use

Describe your problem in plain language. The router will:
1. Classify the domain (delivery, architecture, quality, people, metrics)
2. Return a ranked list of applicable skills
3. Suggest a sequencing order with rationale
4. Highlight skill dependencies or synergies

---

## Domain → Skill Map

### Delivery & Flow
| Trigger | Skills |
|---|---|
| Code is slow to ship | `continuous-delivery` → `feature-flags` → `flow-metrics-analysis` |
| PRs take too long | `code-review` → `pair-programming` → `flow-metrics-analysis` |
| Deployment is risky | `continuous-delivery` → `feature-flags` → `observability` |
| Work piles up mid-sprint | `sprint-health-check` → `flow-metrics-analysis` → `backlog-refinement` |
| End of sprint reflection | `sprint-retrospective` → `flow-metrics-analysis` |

### Architecture & Design
| Trigger | Skills |
|---|---|
| Migrating off a monolith | `strangler-fig` → `monolith-to-services` → `event-driven-design` → `architecture-decision-record` |
| System is hard to change | `refactoring` → `technical-debt-prioritization` → `architecture-decision-record` |
| Building a new API | `api-design` → `documentation` → `security-review` |
| Shipping an AI agent | `agent-quality-patterns` → `ci-cd-pipeline-analysis` → `observability` |
| Database changes are scary | `database-migration` → `observability` → `feature-flags` |
| Need to record a key decision | `architecture-decision-record` |

### Quality & Safety
| Trigger | Skills |
|---|---|
| No tests / hard to test | `test-driven-development` → `refactoring` → `continuous-delivery` |
| Security concerns on a feature | `security-review` → `code-review` → `observability` |
| Production incident | `incident-retrospective` → `observability` → `on-call-handoff` |
| Hard to debug | `debugging` → `observability` |

### QA / Quality Engineering
| Trigger | Skills |
|---|---|
| Writing a test strategy for a feature or release | `test-strategy` → `acceptance-criteria` → `test-driven-development` |
| Bug found — need a high-quality report | `bug-reporting` → `acceptance-criteria` |
| Exploring edge cases / finding what scripted tests miss | `exploratory-testing` → `bug-reporting` |
| Deciding what acceptance criteria to put on a story | `acceptance-criteria` → `backlog-refinement` |
| Setting up or reviewing the test pipeline | `ci-cd-pipeline-analysis` → `test-strategy` |
| AI/LLM test automation quality | `agent-quality-patterns` → `test-strategy` |

### People & Teams
| Trigger | Skills |
|---|---|
| Team struggling to deliver | `team-topology` → `flow-metrics-analysis` → `sprint-health-check` |
| Planning next quarter | `roadmap-prioritization` → `backlog-refinement` → `technical-debt-prioritization` |
| Growing the team | `hiring-leveling` → `team-topology` |
| On-call handoff | `on-call-handoff` → `incident-retrospective` |
| Tech debt is blocking features | `technical-debt-prioritization` → `refactoring` → `engineering-metrics` |

---

## Routing Template

When asked "where do I start?", respond with:

```
Problem: [restate the problem]
Domain: [delivery / architecture / quality / people / metrics]

Recommended skill sequence:
1. [skill-name] — [why first]
2. [skill-name] — [depends on output from step 1]
3. [skill-name] — [optional, if complexity warrants]

Key synergy: [note any skills that reinforce each other]
Skip if: [condition under which a skill can be omitted]
```

---

## Skill Synergy Notes

- **`strangler-fig` + `monolith-to-services`**: Always pair these. Strangler-fig is the migration pattern; monolith-to-services provides the decomposition strategy.
- **`flow-metrics-analysis` + `engineering-metrics`**: Flow metrics are the *what* (cycle time, throughput); engineering metrics are the *why* (DORA, team health). Use both for quarterly reviews.
- **`refactoring` + `test-driven-development`**: Refactoring without tests is risky. TDD first, then refactor safely.
- **`architecture-decision-record` + any arch skill**: Any major decision from `api-design`, `event-driven-design`, or `monolith-to-services` should produce an ADR.
- **`observability` + `continuous-delivery`**: You can't safely ship fast without knowing what's happening in production.
- **`security-review` + `code-review`**: Security review surfaces threats; code review enforces them. Run in the same PR flow.

---

## References
- Martin Fowler: [Patterns of Enterprise Application Architecture](https://martinfowler.com/eaaCatalog/)
- Team Topologies: Matthew Skelton & Manuel Pais
- DORA: [State of DevOps Report](https://dora.dev)
