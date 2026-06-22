<!-- markdownlint-disable -->

# Hardening Report: reviewdog--action-markdownlint/v0.27.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `1`

Action **reviewdog--action-markdownlint/v0.27.0** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unsafe-shell (severity: high)

The Dockerfile pipes a remotely fetched script directly to a shell interpreter without first saving it to a file for inspection. The pattern `wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/.../install.sh | sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}` downloads and executes the install script in a single pipeline. Even though the URL is pinned to a specific commit SHA in the path, the content is still executed without any integrity verification step, making this an unsafe-shell pattern.

Locations:

- `Dockerfile:16`

## Iteration Notes

### Iteration 1

**Fixes applied:** unsafe-shell

**Notes:**

Fixed the unsafe pipe-to-shell pattern in Dockerfile line 16. Changed `wget -O - -q <url> | sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}` to first download the script to /tmp/install-reviewdog.sh, then execute it separately with `sh /tmp/install-reviewdog.sh -b /usr/local/bin/ ${REVIEWDOG_VERSION}`, and finally clean up the temp file. The URL remains pinned to the specific commit SHA (fd59714416d6d9a1c0692d872e38e7f8448df4fc).

