# Engineering Workflow

This project uses a strict feature loop:

1. `spec/docs` first
2. `tests` second (red/failing or not-yet-implemented)
3. `implementation` third
4. `evidence + docs update` last

## Per-Issue Commit Sequence

For each feature issue, prefer this sequence:

1. `docs:` clarify contract, invariants, acceptance criteria
2. `test:` add or update tests that fail before implementation
3. `feat|fix:` implement behavior to satisfy tests
4. `docs|test:` attach results, update runbook/progress/decision notes

## Why This Sequence

1. Prevents implementation drift from undefined behavior.
2. Produces auditable intent before code.
3. Makes regressions visible early.
4. Keeps each commit reviewable with clear purpose.

## Rules

1. No implementation commit without linked acceptance criteria.
2. No "green tests" claim without executable commands in PR notes.
3. Performance/correctness claims require benchmark or drill evidence.
4. Architecture behavior changes require a decision-log entry.
5. PR body must include a closing issue reference (for example `Closes #123`).

## Commit Message Pattern

1. `docs: define counter increment contract and invariants`
2. `test: add failing idempotency retry case`
3. `feat: implement op_id dedupe in worker path`
4. `docs: publish benchmark and drill outcomes`
