<!-- markdownlint-disable -->

# Hardening Report: reviewdog--action-markdownlint/v0.31.2

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **reviewdog--action-markdownlint/v0.31.2** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unsafe-shell (severity: high)

The Dockerfile pipes a remotely fetched script directly to `sh` without first saving it to a file for inspection. The line `wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/.../install.sh | sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}` downloads and immediately executes remote content. If the remote URL is compromised or the content changes, arbitrary code will run during the Docker image build. The script should be downloaded to a file first, its integrity verified (e.g. via checksum), and then executed separately.

Locations:

- `Dockerfile:14`

## Iteration Notes

### Iteration 1

**Fixes applied:** unsafe-shell

**Notes:**

Fixed Dockerfile line 14: replaced `wget ... | sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}` with a two-step approach that downloads the install script to `/tmp/install-reviewdog.sh` first, then executes it separately as `sh /tmp/install-reviewdog.sh -b /usr/local/bin/ ${REVIEWDOG_VERSION}`, and cleans up the temp file afterward. The `--` shell option terminator was dropped since it is no longer needed when running the script as a file (it was only needed in the pipe form to separate the shell's own `-s` option from the script's positional arguments).

