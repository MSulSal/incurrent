# Test Strategy

This document defines testing layers and minimum expectations before a feature is considered done.

## Test Layers

1. Unit tests
   - Validation, serialization, routing/hash logic, pure aggregation logic.
2. Integration tests
   - Gateway -> stream publish contract.
   - Worker consume -> Redis flush correctness.
3. System tests
   - End-to-end increment/read behavior in local composed stack.
4. Reliability tests
   - Retry/idempotency correctness.
   - Failure drills and replay recovery checks.

## Minimum Required by Feature Type

1. API contract change
   - Unit tests for request validation.
   - Integration test for expected status/body behavior.
2. Worker/data-path change
   - Unit tests for aggregation/dedupe logic.
   - Integration test for offset commit and Redis write semantics.
3. Backpressure/reliability change
   - System test for overload behavior.
   - Drill artifact or synthetic failure scenario evidence.

## Red-Green-Refactor Policy

1. Add failing or pending test first.
2. Implement until test turns green.
3. Refactor while preserving test coverage.
4. Record validation command output in issue/PR notes.

## Baseline Correctness Invariants

1. Duplicate `op_id` must not apply twice within dedupe window.
2. Post-restart totals must converge to expected values.
3. Replay after state wipe must restore totals consistently.
4. Tail latency and shed behavior must remain within declared thresholds for tested scenario.

## Evidence Requirements

Every test-sensitive PR should include:

1. Commands executed.
2. Pass/fail summary.
3. Relevant logs/metrics for non-trivial behavior.
4. Updated docs if behavior or operational expectations changed.
