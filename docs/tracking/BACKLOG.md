# Prioritized Backlog

This is the execution queue. Keep it ordered and actionable.

## P0 (Do Next)

1. Bootstrap GitHub project artifacts (labels, milestone, seed issues).
2. Scaffold Java 21 + Spring Boot multi-module service layout.
3. Implement vertical slice:
   - `POST /counters/{id}/inc` -> topic publish
   - worker consume -> Redis write
   - `GET /counters/{id}` read path
4. Add baseline metrics from gateway + worker.
5. Implement `op_id` dedupe with retention policy.

## P1 (After Vertical Slice)

1. Add load generator with uniform + Zipf + retry profiles.
2. Run first benchmark report with invariants.
3. Add hot-key striping path and compare results.
4. Implement bounded queue + shedding behavior.
5. Add failure drill scripts (worker kill, rebalance, Redis latency, broker restart).
6. Implement replay/rebuild workflow and validate.

## P2 (Packaging and Publication)

1. Add k8s deployment manifests and optional lag-based autoscaling.
2. Expand dashboards and alerts.
3. Publish blog series with benchmark evidence.
4. Finalize technical summary metrics and architecture walkthrough notes.

## Scope Discipline Rules

1. No UI expansion before P0/P1 system proof points are complete.
2. No new component without decision-log entry.
3. Every benchmark or drill must create/update a GitHub issue.
