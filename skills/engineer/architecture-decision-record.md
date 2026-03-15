---
name: architecture-decision-record
description: Write, update, and query Architecture Decision Records (ADRs) in any codebase
triggers: [adr, architecture decision, decision record, document decision, why did we choose]
audience: engineer
---

# Architecture Decision Records (ADRs)

## Context
An ADR is a short document that captures an important architectural decision made in a project — including the context, the decision, and the consequences. ADRs create a searchable log of *why* your system is the way it is, which is invaluable when onboarding, refactoring, or dealing with monolith evolution.

Use this skill when:
- Making a significant technical decision (library choice, pattern choice, storage model, API contract)
- Questioning a past decision ("why do we do it this way?")
- Onboarding someone who needs to understand architectural history

## Instructions

### Creating a New ADR

1. **Number sequentially.** Store in `docs/adr/` or `adr/`. Filename: `NNNN-short-title.md` (e.g., `0012-use-postgres-for-event-store.md`).

2. **Use this template:**

```markdown
# NNNN — [Short Title]

**Date:** YYYY-MM-DD  
**Status:** Proposed | Accepted | Deprecated | Superseded by [NNNN]

## Context
What is the problem or situation that led to this decision? What constraints exist?
Include: team size, system state (monolith/distributed), performance needs, timeline.

## Decision
What did we decide to do? Be specific and direct.
> "We will use X because Y."

## Consequences
**Positive:**
- ...

**Negative / Trade-offs:**
- ...

**Risks:**
- ...

## Alternatives Considered
List other options evaluated and why they were not chosen.

## References
- Link to relevant discussions, tickets, or documentation
```

3. **Keep ADRs immutable.** Never edit an accepted ADR to change the decision. If the decision changes, create a new ADR with status "Superseded by [old ADR number]" and update the old ADR's status to "Superseded by [new ADR number]".

4. **Commit the ADR with the code change it describes.** The ADR and the implementation should land in the same PR where possible.

### Querying Existing ADRs
When asked "why do we do X?", search `docs/adr/` for relevant records. Summarize the decision and consequences from the most relevant ADR.

### Updating ADR Status
- `Proposed` → someone has written it, awaiting team review
- `Accepted` → team has agreed and implementation is underway
- `Deprecated` → no longer relevant but not superseded
- `Superseded by NNNN` → a newer decision replaces this

## Principles
- Source: [Documenting Architecture Decisions — Michael Nygard](https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions)
- Source: [ADRs — Martin Fowler](https://martinfowler.com/articles/architecture-decision-records.html)
- Key idea: *"The most important thing to capture is the rationale — the context and the trade-offs considered. Without that, future maintainers have no way to know whether to keep or change the decision."*

## Output Format
When applying this skill, the agent should:
- Generate the filled-in ADR template for new decisions
- Suggest the next sequential number based on existing ADRs
- For queries, quote the relevant decision and consequences from the matching ADR
