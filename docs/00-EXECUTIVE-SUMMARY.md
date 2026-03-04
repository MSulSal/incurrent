# Incurrent Executive Summary

## One-Line Pitch

Incurrent is an event-driven distributed counter platform built to demonstrate real backend systems engineering: high-throughput ingestion, idempotent processing, hot-key scaling, deterministic overload behavior, and operational recovery.

## Engineering Value

This project demonstrates production-relevant engineering capabilities:

1. Stream processing design (partitioning, lag, checkpointing).
2. Correctness under retries and at-least-once delivery.
3. Performance engineering with reproducible benchmarks.
4. Reliability engineering through failure drills and runbooks.
5. Strong engineering communication through docs, ADRs, and postmortems.

## Product Capabilities (Target)

1. Counter increment API with `op_id` dedupe.
2. Low-latency reads and bounded bulk reads.
3. Hot-key striping and measurable tail-latency improvements.
4. Replay/rebuild from event log + snapshots.
5. Full observability (metrics dashboards + failure drill scripts).

## Scope Boundaries

In scope:

- Distributed systems concerns (throughput, correctness, operability).
- Reproducible performance and fault testing.
- Delivery-quality docs and GitHub execution hygiene.

Out of scope:

- Auth and account management.
- Billing and multi-tenant RBAC.
- Polished product UI beyond a minimal demo.

## Free-Only Constraint

All implementation, test, observability, and project management workflows must run on:

- Local machine + Docker/Kubernetes local clusters.
- GitHub Free tier.
- OSS tooling only.

No paid service is required to evaluate core engineering ability.

## Final Demo Narrative

1. Start stack locally (`docker compose up` target state).
2. Drive high write traffic with Zipf-distributed load.
3. Show baseline bottleneck on hot key.
4. Enable striping and re-run benchmark.
5. Induce worker kill/rebalance under load.
6. Verify correctness invariants remain true.
7. Wipe state and replay from log to recover.
8. Show dashboards and summarize tradeoffs.
