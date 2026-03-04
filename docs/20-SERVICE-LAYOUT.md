# Service Layout Specification

This document defines the initial repository layout for implementation.

## Target Structure

```text
services/
  gateway-service/
    pom.xml
    src/main/java/
    src/main/resources/
    src/test/java/
  worker-service/
    pom.xml
    src/main/java/
    src/main/resources/
    src/test/java/
  loadgen-service/                 (phase 2)
shared/
  contracts/
    pom.xml
    src/main/java/
  event-model/
    pom.xml
    src/main/java/
infra/
  compose/
  k8s/                             (phase 2)
tests/
  integration/
  system/
```

## Boundary Rules

1. `services/*` contains deployable Spring Boot applications only.
2. `shared/*` contains shared DTO/event types and common contracts.
3. Avoid business logic in shared modules to prevent tight coupling.
4. `tests/*` is separated by execution layer (integration/system).

## Java Package Convention

1. Root package: `io.incurrent`
2. Service package examples:
   - `io.incurrent.gateway`
   - `io.incurrent.worker`
3. Shared module package examples:
   - `io.incurrent.contracts`
   - `io.incurrent.events`

## Configuration Rules

1. No hardcoded hostnames/ports in code.
2. Environment-specific values live in `application-*.yml`.
3. Sensitive values are injected through env vars and not committed.
4. Default profile must run locally with compose without paid dependencies.

## Operational Requirements

1. Each service must expose:
   - `/actuator/health`
   - `/actuator/prometheus`
2. Logging format must be structured (JSON preferred).
3. Metrics names should be stable and documented.

## Dependency Rules

1. Prefer Spring Boot starter dependencies with explicit version management.
2. Keep direct dependencies minimal in early phases.
3. Add new infrastructure dependencies only with decision-log updates.
