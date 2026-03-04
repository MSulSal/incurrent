# Free Stack and Cost Guardrails

## Principle

If a feature depends on paid infrastructure, redesign it until it does not.

## Approved Tooling

## Core runtime

1. Docker Desktop (or alternatives), Docker Compose.
2. Local Kubernetes (`kind` or `k3d`).
3. Helm or Kustomize for deployment manifests.

## Data and messaging

1. Redpanda OSS container or Apache Kafka OSS.
2. Redis OSS.

## Observability

1. Prometheus OSS.
2. Grafana OSS.
3. Optional Loki OSS for logs.

## Load and test

1. k6 OSS or custom Go/Rust load tool.
2. Native unit/integration tooling in chosen language.

## Delivery and management

1. GitHub Free repositories/issues/projects.
2. GitHub Actions free minutes.
3. `gh` CLI.

## Explicitly Avoid

1. Managed Kafka/Redis offerings that require payment.
2. Paid observability SaaS tiers as required dependencies.
3. Proprietary load testing platforms.

## Cost Validation Checklist

Before introducing a new component, confirm:

1. It has an OSS variant with no trial lockout.
2. Local execution path exists in docs.
3. Benchmark/failure workflows can run fully local.
4. Public technical claims remain defensible without paid tooling.

## Documentation Requirement

Any component choice must be logged in `docs/10-DECISION-LOG.md` with:

1. Why chosen.
2. Free alternative considered.
3. Exit strategy if replaced.
