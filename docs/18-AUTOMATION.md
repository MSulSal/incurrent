# Automation Baseline

This document describes current CI/automation and when to extend it.

## Current Workflows

1. `CI` (`.github/workflows/ci.yml`)
   - Markdown lint
   - JSON validation
   - YAML lint for `.github/`
   - GitHub workflow lint (`actionlint`)
   - Bash script syntax validation
   - Offline markdown link checks
2. `PR Labeler` (`.github/workflows/pr-labeler.yml`)
   - Applies labels based on changed file paths using `.github/labeler.yml`
3. `PR Issue Link Check` (`.github/workflows/pr-issue-link.yml`)
   - Requires PR body to include a closing issue reference (`Closes #123`)
4. `Issue Auto Close` (`.github/workflows/issue-autoclose.yml`)
   - Closes referenced issues when PR is merged (safety net)

## Dependency Automation

`Dependabot` (`.github/dependabot.yml`) currently updates:

1. GitHub Actions versions (weekly)

Add additional ecosystems only when manifest files exist (for example `gomod`, `npm`, `docker`).

## Ownership and Review

`CODEOWNERS` (`.github/CODEOWNERS`) sets repository ownership for:

1. Global default
2. GitHub automation files
3. Documentation

## Operating Guidance

1. Keep CI strict on syntax and structure from day one.
2. Add service test jobs only after implementation manifests exist.
3. Add deployment workflows only after local compose/k8s paths are stable.
4. Avoid flaky external checks in blocking CI paths.

## Next Automation Milestones

1. Add language-specific test jobs once stack manifests are committed.
2. Add container build and image scan workflow once Dockerfiles are added.
3. Add optional preview deployment workflow for local-k8s smoke test.
