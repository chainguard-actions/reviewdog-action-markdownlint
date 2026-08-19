<!-- markdownlint-disable -->

# Hardening Report: reviewdog--action-markdownlint/v0.26.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **reviewdog--action-markdownlint/v0.26.0** was hardened automatically. 3 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unsafe-shell (severity: high)

The Dockerfile pipes remote content directly to a shell interpreter. The command `wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh | sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}` fetches a script from a remote URL (on the `master` branch, which is mutable) and executes it immediately via `sh`. This is unsafe because the remote content is not verified before execution, allowing a supply-chain compromise of the remote script to execute arbitrary code in the build environment.

Locations:

- `Dockerfile:16`

### unpinned-uses (severity: high)

All workflow files use mutable tag-based or branch-based `uses:` references instead of full 40-character SHA commit digests. Mutable tags can be silently moved to point to different (potentially malicious) commits. Affected references:
- depup.yml: `actions/checkout@v4`, `haya14busa/action-depup@v1`, `peter-evans/create-pull-request@v6` (used twice each)
- dockerimage.yml: `actions/checkout@v4`
- release.yml: `actions/checkout@v4`, `haya14busa/action-bumpr@v1` (×2), `haya14busa/action-update-semver@v1`, `haya14busa/action-cond@v1`
- reviewdog.yml: `actions/checkout@v4`

Locations:

- `.github/workflows/depup.yml:13`
- `.github/workflows/depup.yml:14`
- `.github/workflows/depup.yml:20`
- `.github/workflows/dockerimage.yml:11`
- `.github/workflows/release.yml:16`
- `.github/workflows/release.yml:22`
- `.github/workflows/release.yml:27`
- `.github/workflows/release.yml:32`
- `.github/workflows/release.yml:51`
- `.github/workflows/reviewdog.yml:8`

### missing-permissions (severity: medium)

None of the four workflow files define a `permissions:` block at either the top level or the job level. Without explicit permissions, workflows run with the default repository permissions (which may be `write` for the GITHUB_TOKEN), violating the principle of least privilege. All four files are affected: depup.yml, dockerimage.yml, release.yml, and reviewdog.yml.

Locations:

- `.github/workflows/depup.yml:1`
- `.github/workflows/dockerimage.yml:1`
- `.github/workflows/release.yml:1`
- `.github/workflows/reviewdog.yml:1`

## Iteration Notes

### Iteration 1

**Fixes applied:** unsafe-shell, unpinned-uses, missing-permissions

**Notes:**

1. Dockerfile: Fixed pipe-to-shell by downloading install.sh to /tmp/install-reviewdog.sh first, executing separately, then removing it. Changed URL from mutable 'master' branch to use the pinned ${REVIEWDOG_VERSION} tag. 2. All workflow files: Pinned all 'uses:' references to full 40-char SHA digests with original tag in comment (actions/checkout→11d5960a, haya14busa/action-depup→99f7aecf, peter-evans/create-pull-request→c5a7806, haya14busa/action-bumpr→faf6f47, haya14busa/action-update-semver→7d2c558, haya14busa/action-cond→94f77f7). 3. Added least-privilege 'permissions:' blocks to all four workflow files: depup.yml (contents:write, pull-requests:write), dockerimage.yml (contents:read), release.yml (contents:write, pull-requests:write), reviewdog.yml (contents:read, checks:write, pull-requests:write).

