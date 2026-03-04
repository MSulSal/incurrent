# Tooling Justifications

This document explains why each core tool is used, what alternatives were
considered, and where each tool should or should not be used.

## Selection Principles

1. Free-only and locally reproducible.
2. Common enough to map to real team environments.
3. Strong operational visibility and debuggability.
4. Fast iteration for a single engineer.

## Language and Runtime

### Java 21 + Spring Boot

Why selected:

1. Strong local market alignment for backend roles.
2. Mature ecosystem for REST, Kafka, Redis, and observability.
3. Standard enterprise conventions for service architecture.

Alternatives considered:

1. Go for faster low-level service iteration.
2. C#/.NET for ecosystem familiarity in mixed backend environments.

Why not selected as primary:

1. Go demand is lower in the current target market.
2. C# is viable but Java/Spring appears more dominant locally.

Usage boundary:

1. Primary language for all core services (`gateway`, `worker`, `loadgen`).

## Streaming Layer

### Redpanda (Kafka API)

Why selected:

1. Kafka-compatible API with easier local setup.
2. Supports partitioned consumer-group behavior required by architecture.
3. Keeps migration path to Kafka tooling straightforward.

Alternatives considered:

1. Apache Kafka OSS directly.
2. Cloud-managed stream offerings (rejected by free-only policy).

Usage boundary:

1. Event transport and replay source of truth.
2. Not a general query store.

## State Store

### Redis OSS

Why selected:

1. Very low-latency read/write path for materialized counters.
2. Good support for pipelining and atomic operations.
3. Strong operational maturity and broad adoption.

Alternatives considered:

1. Postgres for full durability (kept optional for snapshots/history).
2. RocksDB-style embedded state (adds complexity early).

Usage boundary:

1. Materialized state and dedupe-adjacent runtime state.
2. Not the primary immutable event history.

## Observability

### Micrometer + Prometheus + Grafana

Why selected:

1. Standard metrics path for Spring services.
2. Strong visualization and drill support without paid services.
3. Enables SLO-style dashboarding from early milestones.

Alternatives considered:

1. OpenTelemetry-only metrics path.
2. Managed observability SaaS (rejected by policy).

Usage boundary:

1. Metrics-first observability baseline.
2. Tracing may be added once cross-service flows justify it.

## Local Platform

### Docker Compose first, Kubernetes later

Why selected:

1. Compose enables quick local loops for milestone 1.
2. Kubernetes adds deployment realism after behavior is stable.
3. Prevents infrastructure overhead from blocking core correctness work.

Alternatives considered:

1. Kubernetes-first setup.
2. Bare local processes without containers.

Usage boundary:

1. Compose for development and initial benchmarking.
2. K8s for scale drills and autoscaling scenarios later.

## Repository Automation

### GitHub Actions + Dependabot + PR automation

Why selected:

1. Native to GitHub and free-tier friendly.
2. Supports quality gates, labeling, and issue lifecycle automation.
3. Keeps process quality consistent during rapid iteration.

Usage boundary:

1. CI quality checks and workflow automation.
2. Not a substitute for local reproducibility or clear docs.

## Bash and Supporting Scripting

### Bash for automation scripts

Why selected:

1. Cross-platform scripting standard in CI and developer environments.
2. Easier portability than PowerShell for Linux-hosted CI.
3. Matches current project preference.

### Python for JSON parsing inside scripts

Why selected:

1. Available by default in many dev environments.
2. Avoids hard dependency on `jq` in Windows Git Bash setups.

Usage boundary:

1. Bash remains the orchestration layer.
2. Python is used narrowly for structured parsing/helpers.
