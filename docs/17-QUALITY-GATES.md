# Quality Gates

Use these gates before merging any feature branch.

## Gate 1: Scope and Contract

1. Linked issue has acceptance criteria.
2. Relevant API/behavior contract is documented.
3. Out-of-scope items are explicit.

## Gate 2: Test Readiness

1. New or changed behavior has corresponding tests.
2. Tests were authored before or alongside implementation.
3. Validation commands are reproducible from repo docs.

## Gate 3: Operational Readiness

1. Metrics impact is known (new/changed signals).
2. Failure mode implications are documented.
3. Rollback strategy is clear for high-risk changes.

## Gate 4: Evidence

1. Test output summarized in issue/PR.
2. Benchmark/drill evidence attached when claims involve scale/reliability.
3. Decision log updated for architectural tradeoffs.

## Gate 5: Documentation Integrity

1. Runbooks reflect new operational behavior.
2. Tracking artifacts are updated.
3. Context recovery docs are still accurate.

## Merge Rule

If any gate is not satisfied, do not merge. Open follow-up tasks only for non-critical polish, not for core correctness or reliability gaps.
