#!/usr/bin/env bash
set -u

model="$1"
output="$2"
mkdir -p "$(dirname "$output")"

set +e
printf '%s' "$REVIEW_PROMPT" | timeout --foreground 55 "$HOME/.opencode/bin/opencode" run \
  --format json \
  --model "$model" \
  --agent code-reviewer \
  --title "Automated pull request review" > "$output" 2>&1
status=$?
set -e

printf 'model=%s\n' "$model" >> "$GITHUB_OUTPUT"
printf 'status=%s\n' "$status" >> "$GITHUB_OUTPUT"
