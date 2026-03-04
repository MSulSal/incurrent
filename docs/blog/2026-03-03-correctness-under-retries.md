# Correctness Under Retries: At-Least-Once Without Double Counting

Date: 2026-03-03  
Related issues: `INC-006`, `BEN-004`  
Milestone: `MVP`

## Problem

In distributed systems, retries are normal. Clients retry on timeouts,
producers retry publish failures, and consumers can re-read messages after
rebalances. If each duplicate increment is blindly applied, totals drift upward
and trust in the system disappears.

## Naive approach and why it fails

A naive worker applies every consumed increment and commits offsets. This fails when:

1. Consumer restarts after state write but before offset commit.
2. Client retries with same logical operation.
3. Transient publish errors trigger upstream replay.

All three can produce duplicate effects.

## Approach

Each increment includes a unique `op_id`. Workers do:

1. Check whether `op_id` was already applied.
2. If not seen, apply delta and record `op_id`.
3. Commit offset only after state flush succeeds.

This keeps transport semantics at-least-once, while application effect becomes exactly-once within a defined retention period.

## Tradeoff that matters

Dedupe state is not free. A longer retention window reduces duplicate risk but
increases memory/storage pressure. The right TTL is a product decision tied to
expected client retry windows and memory budget.

## Footgun

It is easy to claim "exactly once" without defining boundaries. Incurrent explicitly documents the boundary: exactly-once effect per `op_id` only within dedupe retention.

## Evidence plan

The correctness benchmark will:

1. Inject duplicate retries deliberately.
2. Compare expected totals vs observed totals.
3. Track dedupe hit rate and mismatch count.

## Technical takeaway

Exactly-once is usually an application-level outcome built over at-least-once infrastructure, and the guarantee is only as strong as the dedupe boundary you define and operate.
