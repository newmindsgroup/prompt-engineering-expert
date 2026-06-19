#!/usr/bin/env bash
# Install prompt-engineering-expert across whatever AI IDEs/CLIs are present.
#
# The portable Agent Skill (skill/SKILL.md) is the unit of capability and is
# installed into every detected skills directory. Native on-demand adapters
# (Claude agent + command, Codex prompt) are installed where they apply.
#
# Usage:
#   ./install.sh                 # auto-detect + install user-global
#   ./install.sh --cursor PATH   # also install the Cursor rule into PATH/.cursor/rules
#   ./install.sh --dry-run       # show what would happen, change nothing
set -euo pipefail
cd "$(dirname "$0")"
ROOT="$(pwd)"
NAME="prompt-engineering-expert"

DRY=0; CURSOR_PROJ=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY=1; shift;;
    --cursor) CURSOR_PROJ="${2:-}"; shift 2;;
    *) echo "[err] unknown arg: $1" >&2; exit 1;;
  esac
done

say(){ printf '%s\n' "$*"; }
run(){ if [[ "$DRY" == 1 ]]; then say "  (dry-run) $*"; else eval "$*"; fi; }

install_skill_to(){ # $1 = skills dir
  local dir="$1"
  run "mkdir -p '$dir/$NAME/references'"
  run "cp '$ROOT/skill/SKILL.md' '$dir/$NAME/SKILL.md'"
  run "cp '$ROOT/skill/references/blueprint.md' '$dir/$NAME/references/blueprint.md'"
  run "cp '$ROOT/skill/references/model-guide.md' '$dir/$NAME/references/model-guide.md'"
  say "  ✓ skill → $dir/$NAME/"
}

say "Installing $NAME …"; [[ "$DRY" == 1 ]] && say "(dry-run: nothing will be written)"

# --- Claude Code ---
if command -v claude >/dev/null 2>&1 || [[ -d "$HOME/.claude" ]]; then
  say "• Claude Code detected"
  install_skill_to "$HOME/.claude/skills"
  run "mkdir -p '$HOME/.claude/agents' '$HOME/.claude/commands'"
  run "cp '$ROOT/claude-code/agents/$NAME.md' '$HOME/.claude/agents/$NAME.md'"
  run "cp '$ROOT/claude-code/commands/$NAME.md' '$HOME/.claude/commands/$NAME.md'"
  say "  ✓ agent → ~/.claude/agents/$NAME.md   ✓ command → ~/.claude/commands/$NAME.md"
fi

# --- Codex ---
if command -v codex >/dev/null 2>&1 || [[ -d "$HOME/.codex" ]]; then
  say "• Codex detected"
  install_skill_to "$HOME/.codex/skills"
  run "mkdir -p '$HOME/.codex/prompts'"
  run "cp '$ROOT/codex/prompts/$NAME.md' '$HOME/.codex/prompts/$NAME.md'"
  say "  ✓ prompt → ~/.codex/prompts/$NAME.md (use /$NAME)"
fi

# --- Cross-runtime skills dir (Gemini CLI, Antigravity, Copilot CLI) ---
if [[ -d "$HOME/.gemini" ]] || [[ -d "$HOME/.agents" ]] || command -v gemini >/dev/null 2>&1; then
  say "• Gemini/Antigravity (cross-runtime) detected"
  install_skill_to "$HOME/.agents/skills"
fi

# --- Cursor (project-level) ---
if [[ -n "$CURSOR_PROJ" ]]; then
  say "• Cursor: installing project rule into $CURSOR_PROJ/.cursor/rules"
  run "mkdir -p '$CURSOR_PROJ/.cursor/rules'"
  run "cp '$ROOT/cursor/$NAME.mdc' '$CURSOR_PROJ/.cursor/rules/$NAME.mdc'"
  say "  ✓ rule → $CURSOR_PROJ/.cursor/rules/$NAME.mdc"
else
  say "• Cursor: rules are per-project. To install into a project, run:"
  say "    ./install.sh --cursor /path/to/your/project"
  say "  (or copy cursor/$NAME.mdc into that project's .cursor/rules/)"
fi

say ""
say "Done. Restart your IDE/CLI session so it picks up the new skill."
