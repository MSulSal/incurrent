# Implementation Stack

This document locks the baseline implementation stack for Milestone 1.

## Primary Stack

1. Language: Java 21
2. Framework: Spring Boot 3.x
3. Build: Maven Wrapper
4. Stream: Redpanda (Kafka API compatible) with Spring for Apache Kafka
5. State store: Redis OSS with Spring Data Redis (Lettuce)
6. Local orchestration: Docker Compose
7. Metrics: Micrometer + Prometheus + Grafana
8. Repository automation: GitHub Actions + Dependabot + label automation

## Delivery Order

1. Compose-first delivery for local reproducibility.
2. Kubernetes manifests after vertical slice is stable.
3. Lag-based autoscaling (KEDA) after baseline benchmarks exist.

## Why This Stack

1. Matches common enterprise backend service patterns.
2. Keeps local setup low-friction and free-only.
3. Supports stream-processing semantics and scale experiments.
4. Gives clear production-style observability with standard Java tooling.

## Service Responsibilities

1. `gateway-service`
   - Validate increment requests.
   - Publish events to stream.
   - Expose read endpoints and operational endpoints.
2. `worker-service`
   - Consume events by partition.
   - Dedupe and aggregate deltas.
   - Flush state to Redis and commit offsets after successful flush.
3. `loadgen-service` (next phase)
   - Generate uniform/Zipf/retry/burst profiles.

## Runtime Baselines

1. Services run in containers locally.
2. Configuration is environment-variable driven.
3. Health endpoints and metrics are mandatory for each service.
4. JVM container memory limits are explicitly configured.

## Out-of-Scope for Milestone 1

1. Internal gRPC mesh.
2. Multi-region or cross-cluster replication.
3. Managed cloud services.
