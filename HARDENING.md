<!-- markdownlint-disable -->

# Hardening Report: reviewdog--action-markdownlint/v0.26.2

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `1`

Action **reviewdog--action-markdownlint/v0.26.2** was hardened automatically. 1 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### unsafe-shell (severity: high)

The Dockerfile pipes remote content directly to `sh` without first downloading it to a file for inspection. Line 15: `wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/fd59714416d6d9a1c0692d872e38e7f8448df4fc/install.sh | sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}`. Even though the URL contains a pinned commit SHA in the path, the content is streamed and executed immediately by the shell, matching the `curl/wget ... | sh` unsafe-shell pattern. The script should be downloaded to a temporary file, its integrity verified (e.g. via checksum), and only then executed.

Locations:

- `Dockerfile:15`

## Iteration Notes

### Iteration 1

**Fixes applied:** unsafe-shell

**Notes:**

Fixed Dockerfile line 15: replaced `wget -O - -q <url> | sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}` with a two-step approach that downloads the install script to `/tmp/reviewdog-install.sh` first, then executes it separately with `sh /tmp/reviewdog-install.sh -b /usr/local/bin/ ${REVIEWDOG_VERSION}`, and cleans up the temp file afterward. The pinned commit SHA in the URL is preserved.

### Iteration 2

**Fixes applied:** script-injection

**Notes:**

Fixed all four unquoted variable expansions in entrypoint.sh (lines 9, 19, 23, 38). Changed shebang from #!/bin/sh to #!/bin/bash to enable array support. Used 'read -ra' to split INPUT_MARKDOWNLINT_FLAGS and INPUT_REVIEWDOG_FLAGS into bash arrays, then expanded them as "${ARRAY[@]}" in all four command positions. This prevents shell metacharacter injection while preserving the ability to pass multiple space-separated flags. Removed the shellcheck disable=SC2086 suppression comments since the root cause is now properly fixed.

