# GitHub Bootstrap Scripts

## Purpose

Automate project-management setup for Incurrent:

1. Sync labels from `labels.json`.
2. Ensure milestone exists.
3. Seed issues from `issues.json`.
4. Create/find project board and add issues.

## Prerequisites

1. GitHub CLI installed (`gh --version`).
2. Authenticated session with scopes including `repo`, `project`.
3. Local checkout tied to target repository remote.

## Usage

Standard run:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/github/bootstrap-project.ps1
```

Dry run:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/github/bootstrap-project.ps1 -DryRun
```

Skip project board creation:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/github/bootstrap-project.ps1 -SkipProject
```

Custom title/milestone:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/github/bootstrap-project.ps1 `
  -ProjectTitle "Incurrent - Delivery Board" `
  -Milestone "MVP"
```

## Notes

1. Script is idempotent for labels and issues (existing issue title = reused).
2. Issue lookup is title-based; keep titles stable to avoid duplicates.
3. If project item-add fails for an existing issue, script continues safely.
