<!-- markdownlint-disable -->

# Hardening Report: reviewdog--action-markdownlint/v0.31.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **reviewdog--action-markdownlint/v0.31.0** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unsafe-shell (severity: high)

The Dockerfile downloads a remote shell script and pipes it directly to `sh` without first saving it to a file for inspection. The line `wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/.../install.sh | sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}` is a classic curl/wget-pipe-to-shell pattern that executes remotely fetched content without any integrity verification beyond the pinned commit SHA in the URL.

Locations:

- `Dockerfile:14`

## Iteration Notes

### Iteration 1

**Fixes applied:** unsafe-shell

**Notes:**

Fixed the wget-pipe-to-shell pattern in Dockerfile line 14. Changed from `wget -O - -q ... | sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}` to: download the script to `/tmp/install-reviewdog.sh`, execute it with `sh /tmp/install-reviewdog.sh -b /usr/local/bin/ ${REVIEWDOG_VERSION}`, then remove the temp file. Dropped `-s` and `--` from the shell invocation as required when switching from stdin pipe to file execution — the script now receives `-b` as `$1` instead of `--`.

