<!-- markdownlint-disable -->

# Hardening Report: reviewdog--action-markdownlint/v0.26.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `1`

Action **reviewdog--action-markdownlint/v0.26.0** was hardened automatically. 2 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unsafe-shell (severity: high)

The Dockerfile downloads a remote shell script from GitHub and pipes it directly to `sh` without first saving it to a file for inspection. This allows a compromised or tampered remote script to execute arbitrary code during the Docker image build. Offending line: `wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh | sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}`

Locations:

- `Dockerfile:14`

### script-injection (severity: high)

Sub-rule (b): In entrypoint.sh, the shell variables `${INPUT_MARKDOWNLINT_FLAGS:-.}` and `${INPUT_REVIEWDOG_FLAGS}` are expanded **unquoted** in shell command lines. These variables hold values sourced directly from action inputs, which are workflow-controllable. Without double-quoting, an attacker can inject shell metacharacters (`;`, `|`, `&`, `$(...)`, etc.) to achieve arbitrary command execution. Offending lines: `markdownlint ${INPUT_MARKDOWNLINT_FLAGS:-.} 2>&1` (line 8), `${INPUT_REVIEWDOG_FLAGS}` (line 17), `markdownlint --fix ${INPUT_MARKDOWNLINT_FLAGS:-.} 2>&1` (line 22), and `${INPUT_REVIEWDOG_FLAGS}` (line 32).

Locations:

- `entrypoint.sh:8`
- `entrypoint.sh:17`
- `entrypoint.sh:22`
- `entrypoint.sh:32`

## Iteration Notes

### Iteration 1

**Fixes applied:** unsafe-shell, script-injection

**Notes:**

Dockerfile: Replaced `wget ... | sh` pipe with a two-step download-then-execute pattern (wget to /tmp/install-reviewdog.sh, then sh /tmp/install-reviewdog.sh, then rm). entrypoint.sh: Quoted all four unquoted variable expansions — ${INPUT_MARKDOWNLINT_FLAGS:-.} is now double-quoted in both markdownlint invocations (lines 8 and 22); ${INPUT_REVIEWDOG_FLAGS} is now guarded with the ${VAR:+"$VAR"} pattern in both reviewdog invocations (lines 17 and 32) so empty values produce no argument while non-empty values are properly quoted. Removed the now-unnecessary shellcheck disable comments.

