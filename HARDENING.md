<!-- markdownlint-disable -->

# Hardening Report: reviewdog--action-markdownlint/v0.28.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **reviewdog--action-markdownlint/v0.28.1** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### missing-permissions (severity: medium)

The workflow file has no top-level `permissions:` key and no job-level `permissions:` key on any job. Without explicit permissions, the GITHUB_TOKEN is granted its default (often broad) permissions. All jobs in this file should have minimal explicit permissions.

Locations:

- `.github/workflows/depup.yml:1`
- `.github/workflows/dockerimage.yml:1`
- `.github/workflows/release.yml:1`
- `.github/workflows/reviewdog.yml:1`

## Iteration Notes

### Iteration 1

**Fixes applied:** missing-permissions

**Notes:**

Added explicit `permissions:` blocks to all four workflow files:

1. **depup.yml**: Top-level `permissions: {}` + job-level `contents: write, pull-requests: write` for both `markdownlint-cli` and `reviewdog` jobs (they create PRs via peter-evans/create-pull-request).

2. **dockerimage.yml**: Top-level `permissions: {}` + job-level `contents: read` for the `build` job (only builds a Docker image).

3. **release.yml**: Top-level `permissions: {}` + job-level `contents: write, pull-requests: read` for the `release` job (creates releases and tags) + `contents: read, pull-requests: write` for the `release-check` job (posts PR status comments).

4. **reviewdog.yml**: Top-level `permissions: {}` + job-level `contents: read, checks: write, pull-requests: write` for the `markdownlint` job (uses github-check and github-pr-review reporters).

