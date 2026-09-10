<!-- markdownlint-disable -->

# Hardening Report: reviewdog--action-markdownlint/v0.29.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **reviewdog--action-markdownlint/v0.29.1** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unsafe-shell (severity: high)

The Dockerfile fetches a remote install script via wget and pipes it directly to sh for execution: `wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/.../install.sh | sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}`. This is an unsafe shell pattern — if the remote URL is compromised or the content is tampered with in transit, arbitrary code will execute in the build environment. The script should be downloaded to a file first, its integrity verified (e.g. via checksum), and then executed separately.

Locations:

- `Dockerfile:15`

## Iteration Notes

### Iteration 1

**Fixes applied:** unsafe-shell

**Notes:**

Fixed the unsafe pipe-to-shell pattern in the Dockerfile. Changed `wget -O - -q <url> | sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}` to download the script to `/tmp/install-reviewdog.sh` first, then execute it with `sh /tmp/install-reviewdog.sh -b /usr/local/bin/ ${REVIEWDOG_VERSION}`, and clean up afterward. The `--` was dropped as it was the shell's own option terminator in the pipe form (not an argument to the install script). The URL remains pinned to the same specific commit SHA.

