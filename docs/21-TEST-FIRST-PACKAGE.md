# Test-First Package for Milestone 1

This document defines the first test package to be authored before implementation.

## Scope

Initial focus:

1. Increment API contract (`POST /counters/{id}/inc`)
2. Read API contract (`GET /counters/{id}`)
3. Event publish behavior and validation boundaries

## Test Tooling Baseline

1. JUnit 5
2. Spring Boot Test
3. MockMvc (or WebTestClient if reactive stack is chosen)
4. Testcontainers (Redpanda/Kafka-compatible + Redis for integration tests)
5. AssertJ + JSON assertion helpers

## Test Groups

## Unit tests

1. Request validation:
   - missing `op_id`
   - invalid `delta` type/range
   - invalid counter id shape
2. Serialization:
   - event payload fields and timestamp presence
3. Partition keying:
   - stable mapping for same logical counter id

## Integration tests

1. Increment request accepted and published to stream.
2. Invalid request returns expected error code and body.
3. Read endpoint returns defined schema and freshness metadata.
4. Worker consumes event and persists expected value to Redis.

## System checks (initial smoke)

1. Compose stack boots and health endpoints pass.
2. Single increment path converges to readable state.
3. Basic metrics endpoint is reachable for gateway and worker.

## Required Artifacts Per Test PR

1. Test command list.
2. Pass/fail summary.
3. Any failing red tests linked to upcoming implementation issue.
4. Contract changes reflected in architecture or API docs.

## First Acceptance Gate

Before first implementation merge:

1. Unit/integration test skeletons are committed.
2. At least one deliberate red-path test exists for increment validation.
3. Test execution entrypoint is documented in repo docs.
4. Integration test profile uses Testcontainers and runs in CI.
