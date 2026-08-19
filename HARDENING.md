<!-- markdownlint-disable -->

# Hardening Report: reviewdog--action-markdownlint/v0.25.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **reviewdog--action-markdownlint/v0.25.0** was hardened automatically. 2 finding(s) were identified and resolved across 3 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

All uses: references in workflow files use mutable tags/version strings instead of full 40-character commit SHAs. Failing references: depup.yml — actions/checkout@v4, haya14busa/action-depup@v1, peter-evans/create-pull-request@v6; dockerimage.yml — actions/checkout@v4; release.yml — actions/checkout@v4, haya14busa/action-bumpr@v1, haya14busa/action-update-semver@v1, haya14busa/action-cond@v1; reviewdog.yml — actions/checkout@v4.

Locations:

- `.github/workflows/depup.yml:13`
- `.github/workflows/depup.yml:14`
- `.github/workflows/depup.yml:27`
- `.github/workflows/dockerimage.yml:10`
- `.github/workflows/release.yml:16`
- `.github/workflows/release.yml:21`
- `.github/workflows/release.yml:26`
- `.github/workflows/release.yml:31`
- `.github/workflows/reviewdog.yml:7`

### missing-permissions (severity: medium)

None of the workflow files define a top-level or job-level `permissions:` block. Without explicit permissions, workflows run with the default (potentially broad) token permissions. All four workflow files are affected: depup.yml, dockerimage.yml, release.yml, and reviewdog.yml.

Locations:

- `.github/workflows/depup.yml:1`
- `.github/workflows/dockerimage.yml:1`
- `.github/workflows/release.yml:1`
- `.github/workflows/reviewdog.yml:1`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses, missing-permissions

**Notes:**

Fixed all 9 unpinned action references across 4 workflow files by resolving each tag to its full 40-character commit SHA (preserving the original tag as a comment). Added top-level permissions blocks to all 4 workflow files with minimal required permissions: depup.yml (contents:write, pull-requests:write for PR creation), dockerimage.yml (contents:read for Docker build), release.yml (contents:write, pull-requests:write for releases and PR comments), reviewdog.yml (contents:read, checks:write, pull-requests:write for reviewdog reporters).

### Iteration 2

**Fixes applied:** unsafe-shell

**Notes:**

Fixed Dockerfile line 14: replaced the unsafe `wget ... | sh` pipe pattern with a download-then-execute approach. Changed the URL from the mutable `master` branch to the pinned `${REVIEWDOG_VERSION}` (v0.20.2) git tag, which is immutable. The script is now downloaded to /tmp/install-reviewdog.sh first, then executed separately with `sh`, and cleaned up afterward. This eliminates both the mutable URL risk and the pipe-to-shell execution pattern.

### Iteration 3

**Fixes applied:** script-injection

**Notes:**

Fixed script injection in entrypoint.sh by switching from #!/bin/sh to #!/bin/bash and using bash arrays. The INPUT_MARKDOWNLINT_FLAGS and INPUT_REVIEWDOG_FLAGS variables are now split into arrays with `IFS=' ' read -ra ARRAY <<< "$VAR"`, which splits only on whitespace without interpreting shell metacharacters (;, |, &, $(...), etc.). All three offending unquoted expansions (lines 8, 16, 30) are replaced with properly quoted array expansions `"${MARKDOWNLINT_FLAGS[@]}"` and `"${REVIEWDOG_FLAGS[@]}"`.

