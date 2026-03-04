# GitHub Bootstrap Scripts

## Purpose

Automate project-management setup for Incurrent:

1. Sync labels from `labels.json`.
2. Ensure milestone exists.
3. Seed issues from `issues.json`.
4. Create/find project board and add issues.

## Prerequisites

1. GitHub CLI installed (`gh --version`).
2. Python installed (`python --version`).
3. Authenticated session with scopes including `repo`, `project`.
4. Local checkout tied to target repository remote.

## Usage

Standard run:

```bash
bash scripts/github/bootstrap-project.sh
```

Dry run:

```bash
bash scripts/github/bootstrap-project.sh --dry-run
```

Skip project board creation:

```bash
bash scripts/github/bootstrap-project.sh --skip-project
```

Custom title/milestone:

```bash
bash scripts/github/bootstrap-project.sh \
  --project-title "Incurrent - Delivery Board" \
  --milestone "MVP"
```

## Notes

1. Script is idempotent for labels and issues (existing issue title = reused).
2. Issue lookup is title-based; keep titles stable to avoid duplicates.
3. If project item-add fails for an existing issue, script continues safely.
