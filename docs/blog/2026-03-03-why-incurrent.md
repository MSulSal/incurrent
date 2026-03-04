# Why I Built Incurrent Instead of Another CRUD App

Date: 2026-03-03  
Related issues: `INC-EPIC-001`, `INC-EPIC-002`  
Milestone: `MVP`

## The real objective

I wanted a focused reference implementation that proves a system can stay
correct and stable under pressure. Standard CRUD projects are useful, but they
rarely force decisions around retries, partitioning, idempotency, lag, and
recovery.

Incurrent is centered on one difficult but focused problem: high-rate distributed increments that must converge correctly even when infrastructure behaves imperfectly.

## Why counters?

Counters are deceptively simple. At low scale, a single process incrementing a number is trivial. At scale, counters surface core distributed systems challenges:

1. Duplicate requests from client retries.
2. Out-of-order or repeated consumption.
3. Hot keys that create bottlenecks.
4. Backpressure and overload behavior.
5. Rebuild/recovery guarantees when materialized state is lost.

That made counters the right domain for demonstrating practical engineering judgment.

## Design constraints

I added a hard rule: the whole project must be free to run. That constraint forces stronger engineering discipline:

1. No paid managed services to hide complexity.
2. Everything must be reproducible on local infrastructure.
3. Claims must be supported by transparent benchmarks and runbooks.

## What this project should prove

By the end, Incurrent should answer the core design-review questions:

1. How do you handle retries without over-counting?
2. What happens when a key becomes disproportionately hot?
3. How does the system degrade under sustained overload?
4. How do you recover after component failure or data loss?
5. How do you know your performance claims are valid?

## Footgun I want to avoid early

The biggest risk is building too much surface area (UI, auth, extra services)
before the core distributed behavior is validated. The roadmap intentionally
protects against that by forcing a narrow vertical slice first.

## Technical takeaway

I built Incurrent to demonstrate production-distributed fundamentals directly: correctness under retries, scalable partitioned processing, failure recovery, and measurable operational behavior.
