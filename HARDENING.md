<!-- markdownlint-disable -->

# Hardening Report: reviewdog--action-markdownlint/v0.28.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **reviewdog--action-markdownlint/v0.28.0** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### missing-permissions (severity: medium)

None of the workflow files define a top-level `permissions:` key, and no individual job within them defines a `permissions:` key either. Without explicit permissions, workflows inherit the repository's default token permissions (often write-all), violating the principle of least privilege.

Locations:

- `.github/workflows/depup.yml:1`
- `.github/workflows/dockerimage.yml:1`
- `.github/workflows/release.yml:1`
- `.github/workflows/reviewdog.yml:1`

## Iteration Notes

### Iteration 1

**Fixes applied:** missing-permissions

**Notes:**

Added top-level `permissions:` blocks to all four workflow files with least-privilege scopes: depup.yml (contents:write, pull-requests:write for PR creation), dockerimage.yml (contents:read only for Docker build), release.yml (contents:write for release creation and tag updates), reviewdog.yml (contents:read, checks:write, pull-requests:write for posting check annotations and PR review comments).

