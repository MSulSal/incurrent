# Seed Issue Map

These keys map to entries in `scripts/github/issues.json`.

## Foundation

1. `INC-EPIC-001` - [Epic] Foundation: free-only distributed counter platform scaffold
2. `INC-001` - Scaffold Java 21 + Spring Boot service layout
3. `INC-002` - Implement increment API contract and validation
4. `INC-003` - Publish increment events to partitioned topic
5. `INC-004` - Implement worker consume -> aggregate -> Redis flush path
6. `INC-005` - Implement read and bulk read endpoints

## Correctness

1. `INC-EPIC-002` - [Epic] Correctness: idempotency and retry safety
2. `INC-006` - Implement `op_id` dedupe store with TTL policy
3. `BEN-004` - Run retry-heavy correctness benchmark and invariant audit

## Scale and Hot Keys

1. `INC-EPIC-003` - [Epic] Scale: skewed load and hot-key mitigation
2. `INC-007` - Build load generator profiles (uniform, Zipf, burst, retry)
3. `BEN-001` - Baseline benchmark: uniform key distribution
4. `BEN-002` - Benchmark: Zipf skew without striping
5. `INC-008` - Implement hot-key striping for write/read paths
6. `BEN-003` - Benchmark: Zipf skew with striping

## Operability

1. `INC-EPIC-004` - [Epic] Operability: backpressure, drills, and replay
2. `INC-009` - Implement bounded ingress queue and `429` shedding
3. `INC-010` - Implement replay/rebuild admin flow
4. `INC-011` - Add metrics instrumentation + Grafana dashboard set
5. `DRILL-001` - Drill: kill worker during load
6. `DRILL-002` - Drill: scale workers to force rebalance
7. `DRILL-003` - Drill: inject Redis latency
8. `DRILL-004` - Drill: restart broker under load
9. `DRILL-005` - Drill: wipe Redis and replay state

## Technical Publication

1. `INC-EPIC-005` - [Epic] Technical publication and walkthrough readiness
2. `DOC-001` - Publish technical case-study article with metrics
3. `DOC-002` - Finalize technical outcome summary with validated numbers
4. `DOC-003` - Prepare architecture walkthrough script from project decisions
5. `INC-012` - Optional k8s autoscaling by consumer lag
