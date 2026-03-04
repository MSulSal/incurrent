# Roadmap

## Milestone 0: Foundation Setup

Target: repo, workflow, and execution hygiene in place.

Deliverables:

1. GitHub labels, issue taxonomy, and seeded backlog.
2. Core docs: architecture, benchmark protocol, runbooks.
3. CI checks for docs/scripts.

Exit criteria:

1. Every next technical task maps to a tracked issue.
2. Context recovery process is documented and usable.

## Milestone 1: Minimal End-to-End Pipeline

Target: first working distributed path.

Deliverables:

1. Gateway accepts increment requests and publishes events.
2. Worker consumes and writes totals to Redis.
3. Read endpoint returns current value.
4. Basic metrics emitted from gateway and worker.

Exit criteria:

1. Functional increment/read loop validated.
2. No silent failures; basic health endpoints work.

## Milestone 2: Correctness Under Retry

Target: no double-apply for duplicate `op_id` within retention.

Deliverables:

1. Idempotency store and TTL policy.
2. Retry simulation in load generator.
3. Invariant check script/report.

Exit criteria:

1. Duplicate requests do not inflate totals in validation run.

## Milestone 3: Scale and Hot-Key Control

Target: credible high-throughput benchmark with skewed keys.

Deliverables:

1. Distributed load generation profile.
2. Hot-key detection and striping strategy.
3. Baseline vs striped benchmark report.

Exit criteria:

1. Throughput and tail latency improvements are quantified.

## Milestone 4: Operability and Failure Drills

Target: stable behavior under common failures.

Deliverables:

1. Dashboards: ingest, lag, latency, dedupe, shed rate.
2. Drill scripts: worker kill, rebalance, injected Redis latency.
3. Replay/rebuild workflow.

Exit criteria:

1. Failure drills pass with documented evidence.
2. Recovery runbook can be followed by a third party.

## Milestone 5: Technical Packaging

Target: publication-ready technical delivery.

Deliverables:

1. Technical summary inventory with measured metrics.
2. Case-study blog posts.
3. Architecture walkthrough notes with explicit tradeoffs.

Exit criteria:

1. Repo tells a clear story without live explanation.
