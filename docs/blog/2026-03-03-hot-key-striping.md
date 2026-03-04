# Hot-Key Meltdown and the Striping Fix

Date: 2026-03-03  
Related issues: `INC-008`, `BEN-002`, `BEN-003`  
Milestone: `MVP`

## Problem

A single hot counter can dominate write traffic and saturate one partition path. This creates a hard throughput ceiling and inflates tail latency even when other partitions are mostly idle.

## Baseline behavior

With normal key partitioning, all increments for `counter:123` route to the same key/partition path. Under a Zipf distribution this creates:

1. Lag concentration on one partition.
2. Queue growth at a single worker.
3. p99 latency spikes.

## Striping strategy

When a key crosses a heat threshold, map one logical key to many physical stripes:

1. Logical key: `counter:123`
2. Physical keys: `counter:123#0..#63`
3. Stripe selection: hash of `op_id`
4. Read path: aggregate stripe totals

This spreads writes while preserving deterministic assignment.

## Tradeoffs

Benefits:

1. Better parallel write throughput.
2. Lower tail latency under skew.

Costs:

1. Read amplification for striped keys.
2. More complex cache/aggregation logic.

## Footgun

Choosing stripe count without measurement can backfire. Too few stripes do not relieve pressure; too many add unnecessary read overhead. Incurrent treats stripe count as tunable and benchmark-driven.

## Evidence plan

Run the same Zipf scenario twice:

1. Without striping.
2. With striping enabled.

Compare:

1. Throughput.
2. p95/p99 latency.
3. Hottest partition lag.

## Technical takeaway

Hot-key mitigation is a classic distributed bottleneck problem. Striping is effective, but only when paired with measurement and clear read-path tradeoff handling.
