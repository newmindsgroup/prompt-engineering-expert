# Prompt Engineering Expert

An original, portable prompt-engineering capability that works the same way across
every AI IDE — **Claude Code, Codex, Cursor, and Google Antigravity / Gemini CLI**.
It turns vague goals into precise, safe, token-efficient prompts and agent
instructions.

It runs **autonomously by default** — reads your project, infers intent, and
delivers a finished prompt with stated assumptions in one pass — and switches to a
guided **one-question-at-a-time interactive mode** whenever you ask for it.

---

## How it works — one brain, many adapters

The entire methodology lives in **one** file:
[`skills/prompt-engineering-expert/SKILL.md`](skills/prompt-engineering-expert/SKILL.md)
(plus [`references/`](skills/prompt-engineering-expert/references)). That file is an
[Agent Skill](https://agentskills.io), the portable unit every modern AI IDE can
load directly.

Each IDE additionally gets a **thin native adapter** for on-demand triggering. The
adapters are **generated** from the canon by
[`scripts/sync-renders.sh`](scripts/sync-renders.sh) — so the methodology is
single-source and never drifts.

```
skills/prompt-engineering-expert/SKILL.md   ← the canon (edit here only)
├── claude-code/  agent + slash commands (/prompt-engineering-expert, /pe)
├── codex/        ~/.codex/prompts slash command
├── cursor/       .cursor/rules/*.mdc  (generated)
├── antigravity/  instruction file     (generated)
└── .claude-plugin/  plugin + marketplace manifests (native /plugin install)
```

> Edit `skills/prompt-engineering-expert/SKILL.md`, then run
> `./scripts/sync-renders.sh` to regenerate the Cursor / Codex / Antigravity
> renders. Never hand-edit the generated files.

---

## Install

### Claude Code plugin (one command, no clone)

```
/plugin marketplace add newmindsgroup/prompt-engineering-expert
/plugin install prompt-engineering-expert@prompt-engineering-expert
```

This installs the skill, the sub-agent, and the `/prompt-engineering-expert` + `/pe`
commands in Claude Code. Restart the session afterward.

### Cross-IDE installer (Claude Code, Codex, Cursor, Antigravity)

Clone this repo, then run the installer — it auto-detects your installed IDEs and
installs to the right places.

**macOS / Linux:**

```bash
git clone https://github.com/newmindsgroup/prompt-engineering-expert.git
cd prompt-engineering-expert
./install.sh                     # Claude Code, Codex, Gemini/Antigravity (user-global)
./install.sh --cursor /path/to/project   # also drop the Cursor rule into a project
./install.sh --dry-run           # preview, change nothing
```

**Windows (PowerShell):**

```powershell
git clone https://github.com/newmindsgroup/prompt-engineering-expert.git
cd prompt-engineering-expert
./install.ps1                    # Claude Code, Codex, Gemini/Antigravity (user-global)
./install.ps1 -Cursor C:\path\to\project   # also drop the Cursor rule into a project
./install.ps1 -DryRun            # preview, change nothing
```

What it installs:

| IDE | Skill (auto-trigger) | On-demand adapter |
|-----|----------------------|-------------------|
| **Claude Code** | `~/.claude/skills/prompt-engineering-expert/` | agent + `/prompt-engineering-expert` |
| **Codex** | `~/.codex/skills/…` | `~/.codex/prompts/prompt-engineering-expert.md` → `/prompt-engineering-expert` |
| **Antigravity / Gemini CLI** | `~/.agents/skills/…` (cross-runtime) | reads the skill at session start |
| **Cursor** | — | `.cursor/rules/prompt-engineering-expert.mdc` (per-project) |

Restart the IDE/CLI session afterward so it picks up the new skill.

---

## Use it

- **Automatically** — it triggers whenever you're writing or improving a prompt,
  system prompt, agent instructions, `AGENTS.md`/`CLAUDE.md`, or an IDE rule.
- **On demand** — `/prompt-engineering-expert <your goal>` or the short `/pe <your goal>` (Claude Code, Codex).
- **Interactive** — say *"take me through it step by step"* for the guided loop.
- **In Cursor** — the rule is agent-attached; Cursor applies it when your request
  matches the rule description, or `@`-mention it.

---

## What it does

- **Prompt Blueprint** — every prompt is structured against six sections:
  Role/Persona · Objective/OKR · Context · Requirements · Desired Output · Evaluation.
- **Self-assessment** before drafting — infers target platform, model, audience,
  and stakes from your project so it asks the fewest questions possible.
- **Output pattern** — tightened draft in a code block, short rationale, a
  `▸revisions` line, a model recommendation, and token-budget warnings.
- **Token awareness + chaining** for long / multi-document prompts.
- **Conversion** between Claude / Cursor / Codex / custom-GPT / plain system-prompt
  formats, preserving intent.
- **Current, cross-vendor model guide** — see
  [`skills/prompt-engineering-expert/references/model-guide.md`](skills/prompt-engineering-expert/references/model-guide.md).
- **Safety + privacy** — masks secrets, refuses-and-redirects unsafe requests.

---

## Repository

| Path | What |
|------|------|
| `skills/prompt-engineering-expert/` | The canonical Agent Skill — the single source of truth. |
| `claude-code/` | Claude Code sub-agent + slash commands (`/prompt-engineering-expert`, `/pe`). |
| `codex/` | Codex on-demand prompt. |
| `cursor/` | Generated `.cursor/rules` rule. |
| `antigravity/` | Generated instruction file for Antigravity / Gemini CLI. |
| `.claude-plugin/` | Plugin + marketplace manifests for native `/plugin install`. |
| `scripts/sync-renders.sh` | Regenerates all renders from the canon. |
| `install.sh` / `install.ps1` | Cross-IDE installer (macOS/Linux / Windows). |

## License

MIT © New Minds Group. See [LICENSE](LICENSE).
