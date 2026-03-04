# Failure Drill Suite

Use these drills to prove resilience and correctness under realistic failure modes.

## Drill 1: Kill Worker During Peak Load

Purpose:

1. Validate consumer group failover behavior.
2. Verify no correctness drift after rebalance.

Expected signals:

1. Temporary lag increase.
2. Worker restart/rebalance logs.
3. Recovery to steady state without invariant violations.

## Drill 2: Scale Workers Mid-Run (Forced Rebalance)

Purpose:

1. Validate partition reassignment handling.
2. Ensure offset commits and flush ordering remain correct.

Expected signals:

1. Rebalance events visible.
2. No prolonged duplicate processing.
3. End totals match expected values.

## Drill 3: Inject Redis Latency

Purpose:

1. Validate bounded queues and graceful degradation.
2. Confirm controlled load shedding (`429`) under pressure.

Expected signals:

1. Rising write latency and queue depth.
2. Increased shed rate after configured threshold.
3. System remains responsive instead of collapsing.

## Drill 4: Restart Messaging Broker

Purpose:

1. Validate producer/consumer recovery paths.
2. Confirm replay from committed offsets resumes correctly.

Expected signals:

1. Temporary publish/consume disruption.
2. Recovery without dropped correctness guarantees.
3. Eventual lag catch-up.

## Drill 5: Wipe Redis, Rebuild From Log

Purpose:

1. Demonstrate event-sourced recovery.
2. Measure replay time and post-replay consistency.

Expected signals:

1. State returns to pre-wipe totals.
2. Replay completion timestamp captured.
3. Correctness audit passes.

## Drill Logging Requirements

Record every drill in `docs/private/09-PROGRESS-LOG.md`:

1. Drill name and date/time.
2. Hypothesis.
3. Commands and config.
4. Observed metrics and logs.
5. Outcome and follow-up issues.
