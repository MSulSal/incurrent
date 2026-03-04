# Benchmark Protocol

This document defines how to run and report reproducible performance tests.

## Goals

1. Measure steady-state throughput.
2. Track latency distribution (p50/p95/p99).
3. Validate correctness under retries and failures.
4. Compare baseline vs optimization changes.

## Standard Scenarios

1. Uniform keys:
   - Even distribution over large keyspace.
2. Zipf skew:
   - Hot-key pressure to expose partition bottlenecks.
3. Retry-heavy:
   - Simulated client retries with duplicated `op_id`.
4. Burst mode:
   - Sudden 10x traffic spikes to test backpressure.

## Required Inputs Per Run

1. Code/version reference (commit SHA).
2. Environment profile (hardware, container limits, replicas).
3. Scenario config (clients, RPS/events-s, duration, key distribution).
4. Failure injection plan (if applicable).

## Mandatory Metrics

1. Ingest rate (`events/s`).
2. End-to-end latency p50/p95/p99.
3. Error rate and shed rate (`429`).
4. Consumer lag per partition.
5. Dedupe hit rate.
6. Redis command latency.

## Correctness Checks

For each run, include invariant verification:

1. Expected total increments vs materialized totals.
2. Duplicate `op_id` count vs dedupe prevented count.
3. Post-failure convergence time.

## Report Template

Each benchmark issue/report must include:

1. Scenario summary.
2. Commands and config used.
3. Metric screenshots or exported data.
4. Invariant check results.
5. Conclusion and recommended next action.

## Comparison Rules

When claiming improvement:

1. Keep workload and environment constant.
2. Run baseline and candidate back-to-back.
3. Include at least three runs if variance is high.
4. Report median and worst observed run.
