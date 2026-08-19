<!-- markdownlint-disable -->

# Hardening Report: reviewdog--action-markdownlint/v0.26.2

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **reviewdog--action-markdownlint/v0.26.2** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### missing-permissions (severity: medium)

Workflow file has no top-level `permissions:` key and no job-level `permissions:` keys on any job. Without explicit permissions, the GITHUB_TOKEN is granted default (potentially broad) permissions. All jobs in this workflow are affected.

Locations:

- `.github/workflows/depup.yml:1`
- `.github/workflows/dockerimage.yml:1`
- `.github/workflows/release.yml:1`
- `.github/workflows/reviewdog.yml:1`

## Iteration Notes

### Iteration 1

**Fixes applied:** missing-permissions

**Notes:**

Added top-level `permissions:` blocks to all four workflow files with minimal required permissions:
- depup.yml: `contents: write, pull-requests: write` (creates PRs via peter-evans/create-pull-request)
- dockerimage.yml: `contents: read` (only checks out code and builds a Docker image)
- release.yml: `contents: write, pull-requests: write` (creates releases, updates semver tags, posts PR comments via action-bumpr)
- reviewdog.yml: `contents: read, checks: write, pull-requests: write` (checks out code, posts GitHub Checks annotations, and posts PR review comments)

