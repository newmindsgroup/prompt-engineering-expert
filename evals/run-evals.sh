#!/usr/bin/env bash
# Print each eval case with a blank result line for a human/agent to fill in.
# Dependency-free; does not call any model.
set -euo pipefail
cd "$(dirname "$0")"
echo "prompt-engineering-expert — eval run ($(grep -cE '^\| (T|G|Q)[0-9]' cases.md) cases)"
echo "Read each case in cases.md, run it against the installed skill, record PASS/FAIL."
echo
grep -E '^\| (T|G|Q)[0-9]' cases.md | sed 's/|/ /g' | while read -r line; do
  echo "[ ] $line"
done
echo
echo "Done. Mark each [ ] as PASS/FAIL with a note."
