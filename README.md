# Incurrent

Incurrent is a zero-cost distributed systems reference implementation focused on high-write counters, correctness under retries, hot-key mitigation, backpressure handling, and operability under failure.

## Why This Exists

Many demos stop at CRUD behavior. Incurrent is intentionally different:

- Event-driven pipeline, not table CRUD.
- At-least-once delivery with idempotent outcomes.
- Observable behavior under stress and chaos drills.
- Reproducible benchmark methodology.
- Documentation designed for clear design and operations reviews.

## Target Deliverable

At completion, this repo demonstrates:

- `POST /counters/{id}/inc` with `op_id` idempotency.
- `GET /counters/{id}` low-latency reads.
- Hot-key striping (`key#0..#N`) with measured tail-latency gains.
- Replay/rebuild from event log and snapshots.
- Dashboarded SLOs (p95/p99 latency, lag, shed rate, dedupe rate).
- Failure drills (kill workers, induce lag, recover and verify invariants).

## Free-Only Stack Policy

Everything in this project must be runnable without paid services:

- Runtime: Docker, Docker Compose, Kubernetes (local `kind`/`k3d`), Helm/Kustomize.
- Streaming: Redpanda community image or Apache Kafka OSS.
- State/cache: Redis OSS.
- Observability: Prometheus + Grafana OSS.
- Tooling: GitHub Free, GitHub Actions free tier, `gh` CLI.

No paid cloud dependencies are required to prove the architecture.

## Documentation Map

- Project summary: `docs/00-EXECUTIVE-SUMMARY.md`
- Scope options: `docs/01-SCOPE-VARIANTS.md`
- Architecture: `docs/03-ARCHITECTURE.md`
- Roadmap: `docs/04-ROADMAP.md`
- Benchmark protocol: `docs/05-BENCHMARK-PROTOCOL.md`
- Operations/runbook: `docs/06-OPS-RUNBOOK.md`
- Failure drills: `docs/07-FAILURE-DRILLS.md`
- Context recovery: `docs/08-CONTEXT-RECOVERY.md`
- Decision log: `docs/10-DECISION-LOG.md`
- GitHub project/issue plan: `docs/13-GITHUB-PROJECT-PLAN.md`
- Blog journey: `docs/14-BLOG-SERIES.md`
- Engineering workflow: `docs/15-WORKFLOW.md`
- Test strategy: `docs/16-TEST-STRATEGY.md`
- Quality gates: `docs/17-QUALITY-GATES.md`
- Automation baseline: `docs/18-AUTOMATION.md`
- Implementation stack: `docs/19-IMPLEMENTATION-STACK.md`
- Service layout spec: `docs/20-SERVICE-LAYOUT.md`
- Test-first package: `docs/21-TEST-FIRST-PACKAGE.md`
- Private-docs convention: `docs/PRIVATE-DOCS.md`

## Private Local Docs

Personal working notes belong in `docs/private/` and are gitignored by default.

## GitHub Bootstrap

This repo includes scripts to create labels, milestone, GitHub project, and seeded issues:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/github/bootstrap-project.ps1
```

Script docs: `scripts/github/README.md`

## Current Status

Repository is in structured planning mode. Core scaffolding, issue system, and execution docs are being prepared first so implementation work is tracked professionally from day one.
