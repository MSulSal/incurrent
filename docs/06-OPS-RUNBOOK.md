# Operations Runbook

## Purpose

Provide a fast, repeatable guide for operating Incurrent during development, load tests, and drills.

## Core Operational SLOs (Initial Targets)

1. Gateway availability: `>= 99.0%` during test windows.
2. End-to-end increment latency p99: `< 400ms` in Medium scope.
3. Data correctness: `0` duplicate `op_id` double-applies within dedupe retention.
4. Recovery time objective (state replay): `< 15 minutes` for demo dataset.

## Standard Checks

Run before every benchmark or drill:

1. `GET /health` for gateway and workers.
2. Prometheus target scrape status.
3. Kafka/Redpanda topic health and consumer lag baseline.
4. Redis connectivity and latency baseline.

## Incident Severity

1. Sev-1: correctness violation (mismatched totals, duplicate apply).
2. Sev-2: sustained error/shed rate above threshold.
3. Sev-3: degraded performance without correctness impact.

## Incident Response Loop

1. Detect via dashboard or test failure.
2. Stabilize by reducing load or pausing drill.
3. Capture evidence (metrics, logs, run ID, timestamps).
4. Identify root cause and patch.
5. Re-run scenario to verify fix.
6. Record lessons in `docs/private/09-PROGRESS-LOG.md`.

## Rollback Guidelines

1. Keep feature flags/config toggles for high-risk behavior (striping, batch size).
2. Roll back one change at a time.
3. Preserve benchmark inputs when comparing before/after results.

## Required Ops Artifacts

For each significant run:

1. Run ID and scenario definition.
2. Dashboard screenshots or exports.
3. Error log excerpts with timestamps.
4. Invariant check output.
5. Short conclusion and next step.
