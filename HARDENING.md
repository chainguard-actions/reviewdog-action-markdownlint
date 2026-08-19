<!-- markdownlint-disable -->

# Hardening Report: reviewdog--action-markdownlint/v0.27.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **reviewdog--action-markdownlint/v0.27.0** was hardened automatically. 1 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### missing-permissions (severity: medium)

None of the workflow files define a top-level `permissions:` block, and no job within any of these files defines its own `permissions:` block. Without explicit permissions, workflows run with the default (often write) token permissions, violating the principle of least privilege. All four workflow files are affected: depup.yml, dockerimage.yml, release.yml, and reviewdog.yml.

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
- depup.yml: `contents: write` + `pull-requests: write` (needed to create PRs via peter-evans/create-pull-request)
- dockerimage.yml: `contents: read` (only checks out code and builds a Docker image)
- release.yml: `contents: write` + `pull-requests: write` (creates GitHub releases/tags and reads PR label events)
- reviewdog.yml: `contents: read` + `checks: write` + `pull-requests: write` (posts GitHub Check annotations and PR review comments via reviewdog)

### Iteration 2

**Fixes applied:** unsafe-shell, script-injection

**Notes:**

1. Dockerfile (unsafe-shell): Replaced `wget ... | sh -s -- ...` pipe pattern with a two-step approach: download the install script to /tmp/install-reviewdog.sh, execute it with `sh`, then remove it. The URL remains pinned to the same commit SHA. 2. entrypoint.sh (script-injection): Double-quoted all four unquoted INPUT_* variable expansions — `${INPUT_MARKDOWNLINT_FLAGS:-.}` on lines 9 and 23 became `"${INPUT_MARKDOWNLINT_FLAGS:-.}"`, and `${INPUT_REVIEWDOG_FLAGS}` on lines 20 and 37 became `"${INPUT_REVIEWDOG_FLAGS}"`. Removed the `# shellcheck disable=SC2086` comments that were suppressing the warnings.

