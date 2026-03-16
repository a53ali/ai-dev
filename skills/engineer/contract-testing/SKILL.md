---
name: contract-testing
description: Implement consumer-driven contract testing with Pact to decouple microservice teams, detect breaking changes in CI, and replace brittle integration test suites with fast, reliable contract verification
triggers:
  - "contract testing"
  - "pact"
  - "consumer-driven contracts"
  - "microservice testing"
  - "breaking change detection"
  - "provider verification"
  - "contract broker"
  - "integration test brittle"
  - "service contract"
audience: engineer, qa
---

# Contract Testing

## Context
In a microservices architecture, integration tests that spin up multiple real services are expensive, slow, flaky, and create tight coupling between teams. When Service A calls Service B, who owns the test that proves compatibility? Integration tests answer this too late — often only when you deploy.

Consumer-driven contract testing solves this by capturing the *exact expectations* the consumer has of a provider, turning them into a verifiable contract that the provider team can run independently, in their own CI pipeline, without the consumer being deployed.

**The core idea (Martin Fowler):** *"Consumer-driven contracts shift the focus from testing the implementation to testing the agreement."* A provider only needs to satisfy what its consumers actually use — not every field it could theoretically return.

Use this skill when:
- Multiple teams own services that communicate via HTTP or messaging
- You want to catch breaking API changes before deployment, not after
- Integration test environments are slow, fragile, or expensive to maintain
- You're introducing a new service-to-service dependency
- A provider team wants to know if a proposed change is safe to ship

**This skill does not replace:**
- Unit tests (test internal logic in isolation)
- End-to-end tests (test critical user journeys only, with minimal coverage)
- Load/performance tests

---

## Instructions / Steps

### Step 1: Understand the Roles

| Role | Responsibility | Who writes the test? |
|------|----------------|----------------------|
| **Consumer** | The service making the call (HTTP client, message subscriber) | Consumer team writes the contract |
| **Provider** | The service receiving the call (HTTP server, message publisher) | Provider team runs verification against the contract |
| **Pact Broker** | Stores and shares contracts between teams | Platform/shared infrastructure |

The consumer owns the contract. The provider proves it satisfies the contract. This is the key inversion compared to traditional integration tests.

### Step 2: Consumer — Write the Contract

In your consumer's test suite, use Pact to define the interaction: the request your consumer sends and the minimum response it needs.

**JavaScript/TypeScript example (Jest + Pact):**

```typescript
// order-service.pact.spec.ts (consumer: order-service, provider: inventory-service)
import { Pact, Matchers } from '@pact-foundation/pact';
import path from 'path';
import { InventoryClient } from '../src/clients/inventory-client';

const { like, eachLike, term } = Matchers;

const provider = new Pact({
  consumer: 'order-service',
  provider: 'inventory-service',
  port: 4000,
  dir: path.resolve(__dirname, '../pacts'),  // where the .json contract file is written
  logLevel: 'warn',
});

describe('InventoryClient contract', () => {
  beforeAll(() => provider.setup());
  afterAll(() => provider.finalize());
  afterEach(() => provider.verify());

  describe('GET /products/:id/stock', () => {
    beforeEach(() =>
      provider.addInteraction({
        state: 'product 42 exists with stock > 0',  // provider state
        uponReceiving: 'a request for stock level of product 42',
        withRequest: {
          method: 'GET',
          path: '/products/42/stock',
          headers: { Accept: 'application/json' },
        },
        willRespondWith: {
          status: 200,
          headers: { 'Content-Type': term({ generate: 'application/json', matcher: 'application/json.*' }) },
          body: {
            productId: like(42),          // any number, not exactly 42
            stockLevel: like(100),         // any number > 0
            warehouseId: like('WH-001'),   // any string
          },
        },
      })
    );

    it('returns stock level', async () => {
      const client = new InventoryClient('http://localhost:4000');
      const result = await client.getStockLevel(42);
      expect(result.stockLevel).toBeGreaterThan(0);
    });
  });
});
```

**Key rules when writing consumer contracts:**
- Use `like()` (type matching) not literal values — you want the contract to survive normal data changes
- Use `eachLike()` for arrays — you only care about the structure of elements, not the count
- Use `term()` (regex) for format-sensitive fields (dates, UUIDs, content-type headers)
- Only assert on fields your consumer actually reads — do not encode the full response shape
- Write a `state` string that is meaningful to the provider team (they'll set up fixtures for it)

### Step 3: Publish the Contract to the Pact Broker

After the consumer test passes, the `.json` pact file is written to `./pacts/`. Publish it:

```bash
# Using the Pact CLI (install via npm or standalone binary)
pact-broker publish ./pacts \
  --broker-base-url https://your-pact-broker.example.com \
  --broker-token $PACT_BROKER_TOKEN \
  --consumer-app-version $(git rev-parse HEAD) \
  --branch $(git rev-parse --abbrev-ref HEAD) \
  --tag $(git rev-parse --abbrev-ref HEAD)
```

Or using the npm wrapper:

```bash
npx pact-broker publish ./pacts \
  --broker-base-url $PACT_BROKER_URL \
  --broker-token $PACT_BROKER_TOKEN \
  --consumer-app-version $GIT_SHA
```

**Self-hosted Pact Broker (Docker):**
```yaml
# docker-compose.yml
services:
  postgres:
    image: postgres:15
    environment:
      POSTGRES_USER: pact
      POSTGRES_PASSWORD: pact
      POSTGRES_DB: pact

  pact-broker:
    image: pactfoundation/pact-broker:latest
    ports:
      - "9292:9292"
    environment:
      PACT_BROKER_DATABASE_URL: postgres://pact:pact@postgres/pact
      PACT_BROKER_BASIC_AUTH_USERNAME: admin
      PACT_BROKER_BASIC_AUTH_PASSWORD: secret
    depends_on:
      - postgres
```

Alternatively, use **PactFlow** (SaaS, managed broker with bi-directional contract support).

### Step 4: Provider — Verify the Contract

In the provider's test suite, pull contracts from the broker and run verification:

```typescript
// inventory-service.pact.provider.spec.ts (provider-side)
import { Verifier } from '@pact-foundation/pact';

describe('Pact verification: inventory-service', () => {
  it('satisfies all consumer contracts', () => {
    return new Verifier({
      provider: 'inventory-service',
      providerBaseUrl: 'http://localhost:3001',  // your running provider

      // Fetch contracts from broker
      pactBrokerUrl: process.env.PACT_BROKER_URL,
      pactBrokerToken: process.env.PACT_BROKER_TOKEN,
      publishVerificationResult: true,
      providerVersion: process.env.GIT_SHA,
      providerVersionBranch: process.env.GIT_BRANCH,

      // Set up provider states (fixture setup per interaction)
      stateHandlers: {
        'product 42 exists with stock > 0': async () => {
          await db.products.upsert({ id: 42, stockLevel: 100, warehouseId: 'WH-001' });
        },
        'product 99 does not exist': async () => {
          await db.products.delete({ where: { id: 99 } });
        },
      },
    }).verifyProvider();
  });
});
```

**State handlers are the provider's responsibility.** They set up test fixtures so the provider's real code runs in a known state for each interaction.

### Step 5: CI Pipeline Integration

**Consumer CI pipeline:**
```yaml
# .github/workflows/consumer-ci.yml (excerpt)
- name: Run contract tests
  run: npm test -- --testPathPattern=pact

- name: Publish pacts to broker
  run: |
    npx pact-broker publish ./pacts \
      --broker-base-url ${{ secrets.PACT_BROKER_URL }} \
      --broker-token ${{ secrets.PACT_BROKER_TOKEN }} \
      --consumer-app-version ${{ github.sha }} \
      --branch ${{ github.ref_name }}

- name: Can I deploy? (consumer)
  run: |
    npx pact-broker can-i-deploy \
      --pacticipant order-service \
      --version ${{ github.sha }} \
      --to-environment production \
      --broker-base-url ${{ secrets.PACT_BROKER_URL }} \
      --broker-token ${{ secrets.PACT_BROKER_TOKEN }}
```

**Provider CI pipeline:**
```yaml
# .github/workflows/provider-ci.yml (excerpt)
- name: Start provider service
  run: npm start &
  env:
    PORT: 3001

- name: Verify contracts
  run: npm test -- --testPathPattern=pact.provider
  env:
    PACT_BROKER_URL: ${{ secrets.PACT_BROKER_URL }}
    PACT_BROKER_TOKEN: ${{ secrets.PACT_BROKER_TOKEN }}
    GIT_SHA: ${{ github.sha }}
    GIT_BRANCH: ${{ github.ref_name }}

- name: Can I deploy? (provider)
  run: |
    npx pact-broker can-i-deploy \
      --pacticipant inventory-service \
      --version ${{ github.sha }} \
      --to-environment production \
      --broker-base-url ${{ secrets.PACT_BROKER_URL }} \
      --broker-token ${{ secrets.PACT_BROKER_TOKEN }}
```

The `can-i-deploy` command is the **safety gate**: it checks that every consumer of this provider has a verified contract against this version, and every provider of this consumer has verified against the consumer's contract. Block deployment if it fails.

### Step 6: Breaking Change Detection

The Pact Broker tracks which versions are verified against which. When a provider wants to remove or change a field:

1. Make the change in provider code
2. Run `can-i-deploy` — if any consumer relies on the changed field, it will **fail with a clear message** naming the consumer and the failing interaction
3. Coordinate with the consumer team to update their contract first
4. Redeploy consumer → provider publishes new verification → `can-i-deploy` passes

This gives you **safe, coordinated API evolution** without integration test environments.

---

## Contract vs Integration Test Comparison

| Dimension | Contract Test | Integration Test |
|---|---|---|
| Speed | Milliseconds (mock server) | Seconds to minutes (real services) |
| Flakiness | Near-zero (deterministic mock) | High (network, data, timing) |
| Blast radius of failure | Points to exact interaction | Points to environment/deployment |
| Team coupling | Decoupled — each team runs independently | Coupled — both services must be deployed |
| Environment needed | None (Pact spins up mock) | Shared staging/test environment |
| Feedback loop | Instant in PR | After deployment to test env |
| What it tests | The contract (request/response shape) | Full end-to-end behaviour |
| Who maintains it | Consumer team owns consumer test | Shared — both teams implicated |

**Use both, but differently:** contract tests run in every PR for fast feedback; end-to-end tests cover critical journeys once per deployment.

---

## Pact CLI Reference

```bash
# Install CLI
npm install -g @pact-foundation/pact-cli

# List all pacts for a provider
pact-broker list-latest-pact-versions --broker-base-url $URL --broker-token $TOKEN

# Check deployment safety
pact-broker can-i-deploy \
  --pacticipant <service-name> \
  --version <git-sha> \
  --to-environment <production|staging>

# Create an environment record (required for can-i-deploy)
pact-broker create-environment --name production --production

# Record a deployment
pact-broker record-deployment \
  --pacticipant <service> \
  --version <git-sha> \
  --environment production

# Describe a pacticipant version
pact-broker describe-version --pacticipant <service> --version <sha>
```

---

## Common Mistakes

| Mistake | Why it breaks contracts | Fix |
|---|---|---|
| Asserting on exact response values | Contract breaks when data changes | Use `like()` / `eachLike()` instead |
| Encoding the full response schema | Every new field the provider adds breaks verification | Only assert on fields the consumer uses |
| Skipping provider states | Provider doesn't know how to set up fixtures | Write meaningful state strings; provider implements `stateHandlers` |
| Publishing contracts from every branch without tagging | Broker becomes noisy; `can-i-deploy` is unreliable | Always pass `--branch` and `--tag` when publishing |
| Treating contract tests as integration tests | You'll try to assert business logic through them | Contract tests check shape/protocol, not business behaviour |

---

## Output Format
When applying this skill, the agent should:
- Identify which service is the consumer and which is the provider
- Scaffold the consumer Pact test with correct use of `like()`, `eachLike()`, `term()`
- Scaffold the provider verification test with `stateHandlers` for each provider state
- Provide the `pact-broker publish` and `can-i-deploy` commands for the project's CI
- Flag any fields being matched exactly that should use flexible matchers
- Explain the breaking change implications if a provider wants to remove/rename a field

---

## References
- [Consumer-Driven Contracts — Martin Fowler](https://martinfowler.com/articles/consumerDrivenContracts.html)
- [Pact Documentation — pact.io](https://docs.pact.io/)
- [PactFlow — managed Pact Broker with bi-directional contracts](https://pactflow.io/)
- [Testing Microservices — LeadDev](https://leaddev.com/technical-direction-strategy/testing-microservices)
- [Pact JS — GitHub](https://github.com/pact-foundation/pact-js)
- [Contract Testing vs Integration Testing — Pact.io](https://docs.pact.io/consumer/contract_tests_not_functional_tests)
