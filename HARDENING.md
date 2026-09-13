<!-- markdownlint-disable -->

# Hardening Report: reviewdog--action-markdownlint/v0.30.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **reviewdog--action-markdownlint/v0.30.0** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unsafe-shell (severity: high)

The Dockerfile pipes a remotely fetched shell script directly to `sh` without first saving it to a file for inspection. The line `wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/fd59714416d6d9a1c0692d872e38e7f8448df4fc/install.sh | sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}` downloads and immediately executes the remote script. Although the URL is pinned to a specific commit SHA, this pattern is still considered unsafe because it bypasses any opportunity to verify the script's contents before execution. The script should be downloaded to a file, its integrity verified (e.g. via checksum), and then executed separately.

Locations:

- `Dockerfile:14`

## Iteration Notes

### Iteration 1

**Fixes applied:** unsafe-shell

**Notes:**

Fixed the unsafe pipe-to-shell pattern in Dockerfile line 14. Changed `wget -O - -q ... | sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}` to download the install script to `/tmp/install-reviewdog.sh` first, then execute it separately as `sh /tmp/install-reviewdog.sh -b /usr/local/bin/ ${REVIEWDOG_VERSION}`, and finally remove the temporary file. The `--` shell option terminator was dropped (as required) since it was part of the pipe form's `sh -s --` syntax and not an argument to the install script itself.

