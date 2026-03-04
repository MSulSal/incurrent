# Context Recovery Playbook

Use this when returning after a gap or when previous AI/chat context is gone.

## Single Source of Truth

Always trust these files first:

1. `docs/private/PROJECT_STATUS.md` (current state snapshot).
2. `docs/tracking/BACKLOG.md` (ranked work queue).
3. `docs/private/09-PROGRESS-LOG.md` (chronological execution history).
4. `docs/10-DECISION-LOG.md` (architectural commitments and tradeoffs).

## 10-Minute Recovery Procedure

1. Read `docs/private/PROJECT_STATUS.md`.
2. Read the newest entries in `docs/private/09-PROGRESS-LOG.md`.
3. Confirm open issues in GitHub and match them against `docs/tracking/ISSUE_MAP.md`.
4. Select one highest-priority actionable task.
5. Add a new progress-log entry before starting implementation.

## Session Start Checklist

1. What milestone are we in?
2. What is the next measurable deliverable?
3. What unknowns can block today's work?
4. What evidence will prove this task is done?

## Session End Checklist

1. Update `docs/private/PROJECT_STATUS.md`.
2. Add entry to `docs/private/09-PROGRESS-LOG.md`.
3. Log any architecture changes in `docs/10-DECISION-LOG.md`.
4. Create or update GitHub issue with next step and owner.
5. Fill `docs/private/SESSION_HANDOFF_TEMPLATE.md` and paste into issue/PR comment.

## Recovery Anti-Patterns

1. Starting coding before updating status docs.
2. Making architecture changes without decision-log entries.
3. Claiming benchmark results without saved run config/artifacts.
