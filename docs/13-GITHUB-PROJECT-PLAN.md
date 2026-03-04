# GitHub Project and Issue Plan

## Objective

Use GitHub project management as evidence of delivery discipline, not just code output.

## Board Structure

Recommended project fields:

1. `Status`: Backlog, Ready, In Progress, In Review, Blocked, Done.
2. `Track`: Foundation, Correctness, Scale, Observability, Publication.
3. `Priority`: P0, P1, P2.
4. `Milestone`: M0, M1, M2, M3, M4.

## Label Taxonomy

1. Type labels:
   - `type:epic`
   - `type:feature`
   - `type:benchmark`
   - `type:drill`
   - `type:docs`
   - `type:bug`
2. Priority labels:
   - `priority:p0`
   - `priority:p1`
   - `priority:p2`
3. Track labels:
   - `track:foundation`
   - `track:correctness`
   - `track:scale`
   - `track:observability`
   - `track:publication`

## Issue Rules

1. Every issue has acceptance criteria.
2. Performance claims require benchmark issue linkage.
3. Failure resilience claims require drill issue linkage.
4. Architecture changes require decision-log update.

## Bootstrap Commands

Run:

```bash
bash scripts/github/bootstrap-project.sh
```

The script will:

1. Create or update labels.
2. Create milestone `MVP`.
3. Create seed issues from `scripts/github/issues.json`.
4. Create/find a project board and add issues to it.

## Manual Verification

After bootstrap:

1. Confirm issue count and labels.
2. Confirm milestone assignment.
3. Confirm project board item creation.
4. Re-rank priorities and assign first sprint.
