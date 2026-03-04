# Engineering Growth Plan

This plan turns project work into deliberate engineering development rather than
just feature delivery.

## Growth Objectives

1. Service design depth in Java/Spring.
2. Distributed systems correctness reasoning.
3. Practical observability and operations discipline.
4. Strong testing and verification habits.
5. Better technical communication through decision logs and postmortems.

## Skill Tracks

## Track A: Java and Spring Service Engineering

Targets:

1. Build clean service boundaries with clear package/module structure.
2. Implement validation, error handling, and async API semantics.
3. Use Spring Kafka and Spring Data Redis effectively.

Evidence:

1. Clean PRs with bounded changes.
2. Integration test coverage for core request -> event path.
3. Documented tradeoffs in decision log.

## Track B: Distributed Systems Thinking

Targets:

1. Understand at-least-once delivery implications.
2. Implement and test `op_id` idempotency behavior.
3. Design and verify replay and hot-key mitigation paths.

Evidence:

1. Invariant checks from benchmark/drill runs.
2. Correctness-focused test cases and run artifacts.
3. Documented failure mode behavior with expected/observed comparison.

## Track C: Operability and Reliability

Targets:

1. Instrument meaningful service metrics early.
2. Run failure drills and explain system response.
3. Maintain runbooks with concrete actions and outcomes.

Evidence:

1. Dashboard snapshots tied to scenarios.
2. Drill logs with remediation actions.
3. Improved SLO metrics across iterations.

## Track D: Workflow and Engineering Discipline

Targets:

1. Follow docs -> tests -> implementation -> evidence loop.
2. Keep issues and PRs tightly linked and automatically closed.
3. Maintain high signal in commit messages and docs updates.

Evidence:

1. Consistent issue closure and traceable PR links.
2. Minimal untracked scope changes.
3. Quality gates consistently satisfied before merge.

## Reflection Cadence

At end of each significant milestone:

1. What skill improved the most?
2. What bottleneck repeated?
3. Which decision aged well or poorly?
4. What will change in the next sprint?

Record reflections in `docs/private/09-PROGRESS-LOG.md`.

## Success Criteria

1. You can explain system behavior and tradeoffs without vague claims.
2. You can demonstrate correctness and reliability with artifacts.
3. You can justify tool and language choices with clear boundaries.
