<!-- markdownlint-disable -->

# Hardening Report: reviewdog--action-markdownlint/v0.29.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **reviewdog--action-markdownlint/v0.29.0** was hardened automatically. 3 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### missing-permissions (severity: medium)

The workflow file 'depup.yml' has no top-level 'permissions:' key and neither of its jobs ('markdownlint-cli', 'reviewdog') defines a job-level 'permissions:' block. This means the workflow runs with the default (potentially broad) token permissions.

Locations:

- `.github/workflows/depup.yml:1`

### missing-permissions (severity: medium)

The workflow file 'dockerimage.yml' has no top-level 'permissions:' key and its only job ('build') has no job-level 'permissions:' block. This means the workflow runs with the default (potentially broad) token permissions.

Locations:

- `.github/workflows/dockerimage.yml:1`

### missing-permissions (severity: medium)

The workflow file 'reviewdog.yml' has no top-level 'permissions:' key and its only job ('markdownlint') has no job-level 'permissions:' block. This means the workflow runs with the default (potentially broad) token permissions.

Locations:

- `.github/workflows/reviewdog.yml:1`

## Iteration Notes

### Iteration 1

**Fixes applied:** missing-permissions

**Notes:**

Added top-level 'permissions:' blocks to all three workflow files with least-privilege settings:
- depup.yml: 'contents: write' and 'pull-requests: write' (required to create pull requests via peter-evans/create-pull-request)
- dockerimage.yml: 'contents: read' (only checks out code and builds a Docker image locally)
- reviewdog.yml: 'contents: read', 'checks: write', and 'pull-requests: write' (required for reviewdog's github-check and github-pr-review reporters)

