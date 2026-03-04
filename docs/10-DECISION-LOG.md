# Decision Log (ADR Lite)

Record architecture decisions with enough detail to defend them in design reviews.

## Template

```text
ID:
Date:
Status: proposed | accepted | superseded
Context:
Decision:
Alternatives considered:
Consequences:
Follow-up actions:
```

---

## DEC-001

Date: 2026-03-03  
Status: accepted

Context:

Need a practical reference implementation that demonstrates distributed backend capability without paid services.

Decision:

Adopt a strict free-only stack policy (local containers/k8s + OSS data/metrics tooling + GitHub Free).

Alternatives considered:

1. Managed cloud services for faster setup.
2. Hybrid local + paid hosted observability.

Consequences:

1. Setup complexity is higher.
2. Project remains fully reproducible by any reviewer.
3. Engineering credibility is stronger because constraints mirror real tradeoffs.

Follow-up actions:

1. Track all future dependencies against free-stack policy.

## DEC-002

Date: 2026-03-03  
Status: accepted

Context:

Counter increments face retry duplication in distributed systems.

Decision:

Use `op_id`-based idempotency with bounded retention window and commit offsets only after successful state flush.

Alternatives considered:

1. Trust producer exactly-once semantics only.
2. Ignore duplicate risk for MVP.

Consequences:

1. Dedupe state introduces memory/storage overhead.
2. Correctness guarantees are explicitly bounded and testable.

Follow-up actions:

1. Define dedupe TTL and memory budget in implementation issue.

## DEC-003

Date: 2026-03-03  
Status: accepted

Context:

Hot keys create partition-level throughput bottlenecks and tail-latency spikes.

Decision:

Implement stripe-based sharding for hot logical keys and compare against baseline under Zipf load.

Alternatives considered:

1. Pure vertical scaling.
2. Manual special-casing per key.

Consequences:

1. Read-path complexity increases due to stripe aggregation.
2. Enables clear measurable scaling behavior under skew.

Follow-up actions:

1. Add benchmark scenario pair: unstriped vs striped.

## DEC-004

Date: 2026-03-04  
Status: accepted

Context:

Need to finalize implementation choices for Milestone 1 while preserving free-only execution and fast iteration.

Decision:

Use Java 21 + Spring Boot + Redpanda (Kafka API) + Redis + Docker Compose + Micrometer/Prometheus/Grafana as the baseline stack.

Alternatives considered:

1. Go baseline for first implementation.
2. Kafka OSS broker setup first instead of Redpanda.

Consequences:

1. Aligns with mainstream enterprise backend deployment patterns.
2. Strong compatibility path with Kafka ecosystem tooling.
3. Kubernetes and autoscaling are deferred until vertical slice stability.

Follow-up actions:

1. Define service/module layout and test-first package before implementation.
