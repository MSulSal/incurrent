# Architecture

## System Goal

Handle very high increment write rates across many counters while preserving correctness under retries and failures.

## Components

1. Gateway API
   - Accepts `POST /counters/{id}/inc` with `{delta, op_id}`.
   - Applies ingress limits, batching, and partition-aware publish.
   - Emits events to `inc_events`.
2. Event Log (Redpanda/Kafka)
   - `inc_events` topic for write stream.
   - `snapshots` topic (optional compacted snapshots/checkpoints).
   - `audit_ops` topic (optional correctness verification).
3. Aggregator Workers
   - Consumer group reads partitions.
   - Dedupes by `op_id` within retention window.
   - Aggregates deltas and flushes state to Redis.
   - Commits offsets only after successful flush.
4. Redis
   - Stores materialized counter values.
   - Stores dedupe keys or dedupe metadata.
5. Metrics and dashboards
   - Prometheus scrapes gateway/workers/redis exporters.
   - Grafana panels for latency, lag, error, and throughput.

## Data Model

Event shape:

```json
{
  "counter_id": "counter:123",
  "delta": 1,
  "op_id": "uuid-v7",
  "timestamp_ms": 1760000000000
}
```

State shape (logical):

```json
{
  "counter_id": "counter:123",
  "value": 42001,
  "updated_at_ms": 1760000002500
}
```

## API Contract (Planned)

1. `POST /counters/{id}/inc`
   - Request: `{ "delta": 1, "op_id": "..." }`
   - Response: `202 Accepted` for async flow.
2. `GET /counters/{id}`
   - Response: `{ "value": 42001, "last_updated_ms": 176..., "freshness_ms": 8 }`
3. `POST /counters/bulk_get`
   - Request: `{ "ids": ["counter:1","counter:2"] }`
   - Response: list of resolved values.
4. `GET /health`, `GET /metrics`
5. `POST /admin/replay`, `GET /admin/hotkeys`

## Correctness Semantics

1. Delivery model: at-least-once from producer/consumer perspective.
2. Application model: exactly-once effect per `op_id` within retention window.
3. Offset commit policy: commit only after state flush succeeds.
4. Replay behavior: rebuilding state from log should converge to same totals.

## Hot-Key Mitigation

Problem: one key can bottleneck a partition/worker path.

Approach:

1. Detect hot logical key (`counter:123`).
2. Convert to striped physical keys (`counter:123#0..#N`).
3. Route write to stripe using stable hash of `op_id`.
4. Read path sums stripes (cached if needed).

Expected outcome:

1. Increased parallel write throughput for hot counters.
2. Lower p95/p99 under skewed key distributions.

## Backpressure Strategy

1. Bounded ingress queues.
2. Adaptive batching up to configured ceiling.
3. Shed load with `429` when downstream remains saturated.
4. Emit explicit signals:
   - `ingress_queue_depth`
   - `shed_requests_total`
   - `publish_latency_ms`

## Failure and Recovery

1. Worker crash: re-assignment/rebalance resumes partition processing.
2. Redis latency spike: backpressure engages before collapse.
3. State wipe: replay from event log/snapshot recovers materialized view.

## Non-Goals

1. Authentication and user management.
2. Multi-tenant security boundaries.
3. Rich front-end product features beyond demo visibility.
