#!/usr/bin/env bash
# Regenerate every per-IDE render from the canonical skills/prompt-engineering-expert/SKILL.md.
# The methodology lives in ONE place (skills/prompt-engineering-expert/SKILL.md); the Cursor, Codex, and
# Antigravity files below are generated artifacts — never hand-edit them.
set -euo pipefail
cd "$(dirname "$0")/.."

SKILL="skills/prompt-engineering-expert/SKILL.md"
[[ -f "$SKILL" ]] || { echo "[err] $SKILL not found" >&2; exit 1; }

# Body = everything after the YAML frontmatter block.
BODY="$(awk 'NR==1 && /^---[[:space:]]*$/{f=1; next} f && /^---[[:space:]]*$/{f=0; next} !f{print}' "$SKILL")"

DESC="Designs, improves, converts, debugs, and operationalizes prompts, system prompts, agent instructions, and reusable AI-agent behavior. Use when writing or refining any prompt, system prompt, agent instruction, AGENTS.md, or IDE rule; converting a prompt between platforms; debugging poor prompt output; or reducing tokens."

# --- Cursor: .cursor/rules/*.mdc (agent-attached via description; alwaysApply false) ---
{
  printf -- '---\n'
  printf 'description: %s\n' "$DESC"
  printf 'globs:\n'
  printf 'alwaysApply: false\n'
  printf -- '---\n\n'
  printf '<!-- GENERATED from skills/prompt-engineering-expert/SKILL.md by scripts/sync-renders.sh — do not edit by hand. -->\n\n'
  printf '%s\n' "$BODY"
} > cursor/prompt-engineering-expert.mdc

# --- Codex: ~/.codex/prompts/<name>.md (on-demand slash command) ---
{
  printf '<!-- GENERATED from skills/prompt-engineering-expert/SKILL.md by scripts/sync-renders.sh — do not edit by hand. -->\n\n'
  printf '%s\n' "$BODY"
  printf '\n---\n\nApply the methodology above to the user request below.\n'
  printf 'Default to Autonomous mode; use Interactive mode only if asked.\n\n'
  printf '$ARGUMENTS\n'
} > codex/prompts/prompt-engineering-expert.md

# --- Antigravity / Gemini CLI: plain instruction file the agent reads ---
{
  printf '<!-- GENERATED from skills/prompt-engineering-expert/SKILL.md by scripts/sync-renders.sh — do not edit by hand. -->\n\n'
  printf '%s\n' "$BODY"
} > antigravity/prompt-engineering-expert.md

echo "[ ok ] Regenerated: cursor/prompt-engineering-expert.mdc"
echo "[ ok ] Regenerated: codex/prompts/prompt-engineering-expert.md"
echo "[ ok ] Regenerated: antigravity/prompt-engineering-expert.md"
echo "       Canon: skills/prompt-engineering-expert/SKILL.md (edit there, then re-run this script)."
