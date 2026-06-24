# Design Spec — `prompt-engineering-expert` next-level enhancements

Version-Timestamp: 2026-06-19
Author: New Minds Group (Daniel Gonell)
Repo: newmindsgroup/prompt-engineering-expert (this repo ONLY)
Status: Approved design → ready for implementation plan

---

## 1. Purpose

Take the `prompt-engineering-expert` capability from "good autonomous drafter" to
"reliable autonomous drafter that knows what it doesn't know." Four enhancements:

1. **Gap-Detection Engine** — deterministic gap-finding + qualifying-questions
   protocol so the skill always asks when (and only when) a real gap would change
   the output.
2. **Self-grading rubric** — the skill scores and self-revises its own draft.
3. **Template + anti-pattern library** — proven archetypes to start from and
   "prompt smells" to avoid.
4. **Repo CI + eval suite** — automated guards so the repo can't silently break,
   plus runnable evals for trigger + output quality.

Scope is limited to this repo. The skills-library copy is out of scope here.

## 2. Architecture — where each piece lives

The Cursor/Codex/Antigravity renders are generated from the **SKILL.md body only**
(not `references/`). Antigravity caps a rule at ~12,000 chars; the body is ~5,500
chars today and renders ~6,000. Therefore:

| Piece | Location | Rationale |
|-------|----------|-----------|
| Gap-Detection Engine (protocol) | `skills/prompt-engineering-expert/SKILL.md` body | Behavior must ship in every IDE render |
| Self-grading rubric (protocol) | SKILL.md body | Behavior must ship in every render |
| Gap-checklist detail + examples | `references/gap-checklist.md` | Rich content; on-demand; no render cost |
| Rubric scoring criteria | `references/quality-rubric.md` | Rich content; on-demand |
| Template library | `references/templates/*.md` | Rich content; pointed to from body |
| Anti-patterns | `references/anti-patterns.md` | Rich content; pointed to from body |
| CI | `.github/workflows/validate.yml` | Repo infra; no body cost |
| Evals | `evals/` | Repo infra; no body cost |

**Body budget:** keep total SKILL.md body additions ≤ ~2,500 chars so the largest
render stays ≤ ~8,500 chars (well under Antigravity's 12k). Depth goes to
`references/`, which the body cites by name.

After any SKILL.md edit, `scripts/sync-renders.sh` regenerates all renders.

## 3. Enhancement B — Gap-Detection Engine

### 3.1 Body additions (concise)
Add a **Gap scan** sub-step to the self-assessment protocol. Score the request
against eight fixed dimensions:

1. Objective / definition of done
2. Target model / platform / runtime
3. Audience & channel
4. Output shape / format
5. Constraints (length, style, banned patterns)
6. Success criteria / evaluation
7. Examples (gold / bad)
8. Stakes / risk level

Each dimension is classified:
- **✅ Known** — stated, or confidently inferable from the project.
- **🟡 Assumable** — no statement, but a safe default exists; state the assumption.
- **🔴 Blocking** — no safe default, and a wrong guess would materially change the
  output.

**Decision rule (deterministic):**
- Any **🔴** → ask those as **qualifying questions before drafting**. Batched,
  each with 2–4 concrete options **and a recommended default**, max ~3–4 questions.
  Never open-ended walls. In **Interactive mode**, ask one at a time.
- Zero 🔴 → draft immediately and list 🟡 assumptions.
- If the user declines/stalls on a 🔴, pick the recommended default, mark it a
  flagged assumption, and proceed.

**Output:** above the draft, show a compact **Gap scan** line — counts + the
specific assumptions made and questions asked (e.g.
`Gap scan: 6 ✅ · 1 🟡 (assumed audience = end-users) · 1 🔴 → asked below`).

### 3.2 `references/gap-checklist.md`
Full definition of each of the 8 dimensions, the safe-default heuristic for each
(what makes something 🟡 vs 🔴), and 2 worked examples (one that proceeds
autonomously, one that must ask). Carries a `Version-Timestamp`.

## 4. Enhancement C — Self-grading rubric

### 4.1 Body additions (concise)
After producing a draft, score it 1–5 on five axes: **clarity, specificity,
testability, token-efficiency, safety**. Auto-revise any axis scoring ≤3 once,
then present. Show a one-line **scorecard** with the draft (default on), e.g.
`Quality: clarity 5 · specificity 4 · testability 5 · tokens 4 · safety 5`.

### 4.2 `references/quality-rubric.md`
What each axis means and what 1 vs 3 vs 5 looks like, so scoring is consistent.
`Version-Timestamp` included.

## 5. Enhancement D — Template + anti-pattern library

### 5.1 `references/templates/`
One file per archetype, each a ready-to-fill Prompt Blueprint:
`extraction.md`, `classification.md`, `agent-system-prompt.md`, `rag.md`,
`code-generation.md`, `evaluation-rubric.md`, `multi-step-chain.md`. Plus
`references/templates/README.md` indexing them.

Body instruction: when a request matches an archetype, start from that template
rather than blank.

### 5.2 `references/anti-patterns.md`
The "prompt smells" the skill checks against and fixes: vague role, no output
format, conflicting instructions, unbounded length, untestable success criteria,
buried instruction, over-stuffed context, no examples when needed, PII left inline.
Each with a one-line fix. `Version-Timestamp` included.

Body instruction: before finalizing, scan the draft against anti-patterns.

## 6. Enhancement E — Repo CI + eval suite

### 6.1 `.github/workflows/validate.yml`
Runs on push + PR. Pure bash + python3 (preinstalled on GitHub runners); no
external package installs. Steps:

1. **Frontmatter** — `skills/prompt-engineering-expert/SKILL.md` has valid YAML
   frontmatter with `name: prompt-engineering-expert` and a non-empty
   `description`.
2. **JSON manifests** — `.claude-plugin/plugin.json` and `marketplace.json` parse
   as valid JSON.
3. **Plugin paths resolve** — every `skills`/`agents`/`commands` path in
   `marketplace.json` exists on disk.
4. **Renders not drifted** — run `scripts/sync-renders.sh`; fail if
   `git diff --exit-code` shows changes (renders must be committed in sync).
5. **Originality sweep** — grep fails the build on `wizard`, `chatgpt`,
   `original gpt`, `gpt-5`, or `\bo3\b` in shipped files.

### 6.2 `evals/`
A documented, runnable suite — no API keys required:
- `evals/README.md` — how to run (a human or an agent reads each case, executes
  it against the skill, checks the expectation).
- `evals/cases.md` — cases across three buckets:
  - **Trigger** — prompts that SHOULD activate the skill and decoys that should NOT.
  - **Gap-detection** — requests engineered to contain 🔴 gaps (must ask) vs.
    fully-specified requests (must NOT ask).
  - **Output quality** — a request whose ideal output is checkable against the
    rubric + anti-patterns.
- `evals/run-evals.sh` — a thin harness that prints each case for an agent/human
  to execute and records pass/fail notes (no model calls baked in). Hook noted for
  future `skill-creator` automation.

## 7. Cross-cutting requirements

- **Originality preserved** — no "wizard"/origin framing anywhere.
- **Renders regenerated** from SKILL.md after body edits; committed in sync.
- **Versioning** — bump `metadata.version` in SKILL.md, `plugin.json`, and
  `marketplace.json` to `1.1.0`. New reference files carry `Version-Timestamp`.
- **Body budget** — verify largest render ≤ ~8,500 chars after edits.
- **Attribution** — commits carry the `Agent-Attribution` footer.

## 8. Validation (definition of done)

- New CI workflow passes locally (run each step by hand) and on the PR.
- `sync-renders.sh` idempotent; renders committed and drift-free.
- Largest render char count printed and ≤ ~8,500.
- Fresh-clone smoke: clone, `./install.sh --dry-run` clean, all plugin paths
  resolve, references present.
- A live skill run shows the Gap scan + scorecard and asks qualifying questions
  on a deliberately-underspecified request; asks nothing on a fully-specified one.

## 9. Out of scope (YAGNI)

- Porting these into the skills-library copy (separate effort if desired later).
- A fully automated, model-calling eval harness with API keys.
- Token estimation tooling (deferred; the rubric's token axis covers the 80%).
- Per-platform conversion checklists (candidate for a future pass).

## 10. Open items

- None blocking. Template set in §5.1 is the initial cut; more archetypes can be
  added later without design change.
