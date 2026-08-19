#!/bin/bash

cd "${GITHUB_WORKSPACE}" || exit 1
git config --global --add safe.directory "${GITHUB_WORKSPACE}" || exit 1

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

# Split flag strings into arrays to avoid unquoted expansion / shell injection.
# IFS=' ' read -ra splits on whitespace only — no metacharacter interpretation.
IFS=' ' read -ra MARKDOWNLINT_FLAGS <<< "${INPUT_MARKDOWNLINT_FLAGS:-.}"
IFS=' ' read -ra REVIEWDOG_FLAGS    <<< "${INPUT_REVIEWDOG_FLAGS}"

markdownlint "${MARKDOWNLINT_FLAGS[@]}" 2>&1 \
  | reviewdog \
      -efm="%f:%l:%c %m" \
      -efm="%f:%l %m" \
      -name="markdownlint" \
      -reporter="${INPUT_REPORTER:-github-pr-check}" \
      -filter-mode="${INPUT_FILTER_MODE}" \
      -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
      -level="${INPUT_LEVEL}" \
      "${REVIEWDOG_FLAGS[@]}" || EXIT_CODE=$?

# github-pr-review only diff adding
if [ "${INPUT_REPORTER}" = "github-pr-review" ]; then
  # fix
  markdownlint --fix "${MARKDOWNLINT_FLAGS[@]}" 2>&1 || true

  TMPFILE=$(mktemp)
  git diff > "${TMPFILE}"

  git stash -u

  reviewdog                        \
    -f=diff                        \
    -f.diff.strip=1                \
    -name="markdownlint-fix"       \
    -reporter="github-pr-review"   \
    -filter-mode="diff_context"    \
    -level="${INPUT_LEVEL}"        \
    "${REVIEWDOG_FLAGS[@]}" < "${TMPFILE}"

  git stash drop || true
fi

exit "${EXIT_CODE:-0}"
