# Scope Variants

Choose a scope level and lock it before implementation starts. Finish the selected scope completely before expanding.

## Small (Core Signal)

Goal: prove correctness and core throughput with minimum surface area.

Required:

1. Increment endpoint + read endpoint.
2. Kafka/Redpanda event ingestion.
3. Worker aggregation + Redis state writes.
4. `op_id` idempotency (retention window documented).
5. Prometheus metrics + at least one Grafana dashboard.
6. One benchmark report + one failure drill report.

Done criteria:

1. Sustained workload documented with p95/p99 and error rate.
2. Duplicate retries do not overcount in validation checks.
3. Worker restart during load does not violate invariants.

## Medium (Recommended)

Goal: strong production-style artifact for distributed backend architecture.

Required:

1. Everything in Small.
2. Bulk get endpoint.
3. Hot-key striping with before/after benchmark.
4. Backpressure behavior with bounded queue and `429` shedding.
5. Replay endpoint to rebuild Redis state from log/snapshots.
6. Failure drill suite (at least 4 drills).
7. Architecture notes + blog journey docs updated from real runs.

Done criteria:

1. Demonstrated hot-key improvement with concrete benchmark deltas.
2. Recovery drill passes after state wipe and replay.
3. Docs are complete enough for a third-party technical walkthrough without extra prep.

## Large (Capstone)

Goal: near production-grade simulation.

Required:

1. Everything in Medium.
2. Kubernetes deployment with autoscaling based on lag.
3. Distributed load generator pods.
4. Multi-environment config (dev/load/chaos profiles).
5. Automated invariant checks in CI or nightly workflow.

Done criteria:

1. End-to-end benchmark matrix across profiles is published.
2. Chaos drills are scriptable and repeatable.
3. Case-study article and technical summary include hard numbers.

## Recommendation

Start at Medium and enforce strict scope control. A completed Medium project with clean evidence is stronger than an unfinished Large plan.
