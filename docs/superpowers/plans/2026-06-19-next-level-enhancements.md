# prompt-engineering-expert Next-Level Enhancements — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a deterministic Gap-Detection Engine, a self-grading rubric, a template + anti-pattern library, and repo CI + an eval suite to `newmindsgroup/prompt-engineering-expert`.

**Architecture:** Behaviors (gap engine, rubric) go in the SKILL.md body so they propagate to every IDE render; rich content (gap detail, rubric criteria, templates, anti-patterns) goes in `references/` (no render cost); CI + evals are repo infra. Renders are regenerated from SKILL.md via `scripts/sync-renders.sh`.

**Tech Stack:** Markdown (Agent Skills spec), bash, python3 (stdlib only), GitHub Actions.

## Global Constraints

- **Repo:** work ONLY in `/Users/newmindsgroup/code/prompt-engineering-expert`.
- **Originality:** no `wizard`, `chatgpt`, `original gpt`, `gpt-5`, `\bo3\b` anywhere in shipped files.
- **Canon:** methodology behaviors live in `skills/prompt-engineering-expert/SKILL.md`; depth lives in `references/`. Edit canon, then run `scripts/sync-renders.sh`.
- **Body budget:** SKILL.md body additions ≤ ~2,500 chars; largest render ≤ ~8,500 chars (Antigravity limit ~12,000).
- **Renders committed in sync:** after editing SKILL.md, regenerate; renders must be drift-free.
- **Versioning:** bump `metadata.version` in SKILL.md, `.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json` to `1.1.0`. New reference files carry a `Version-Timestamp:` line.
- **Branch:** create `feat/next-level-enhancements` before first commit; the repo's default branch is `main`.
- **Attribution footer** on commits: `Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>` + `Agent-Attribution: computer=<hostname>; tool=claude-code; version=<ver>; timestamp=<YYYY-MM-DD HH:mm:ss TZ>`.

---

## File Structure

| File | Responsibility |
|------|----------------|
| `skills/prompt-engineering-expert/SKILL.md` | + Gap scan step, + self-grading step, + pointers to new references. Version bump. |
| `skills/prompt-engineering-expert/references/gap-checklist.md` | 8 dimensions, safe-default heuristics, 2 worked examples. |
| `skills/prompt-engineering-expert/references/quality-rubric.md` | 5 axes, 1/3/5 anchors. |
| `skills/prompt-engineering-expert/references/anti-patterns.md` | Prompt smells + one-line fixes. |
| `skills/prompt-engineering-expert/references/templates/README.md` + 7 archetypes | Ready-to-fill Blueprint templates. |
| `cursor/…`, `codex/…`, `antigravity/…` | Regenerated renders (do not hand-edit). |
| `.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json` | Version bump to 1.1.0. |
| `.github/workflows/validate.yml` | CI: frontmatter, JSON, paths, render-drift, originality. |
| `evals/README.md`, `evals/cases.md`, `evals/run-evals.sh` | Runnable eval suite. |

---

## Task 1: Branch + reference files (gap-checklist, quality-rubric, anti-patterns)

**Files:**
- Create: `skills/prompt-engineering-expert/references/gap-checklist.md`
- Create: `skills/prompt-engineering-expert/references/quality-rubric.md`
- Create: `skills/prompt-engineering-expert/references/anti-patterns.md`

**Interfaces:**
- Produces: reference files cited by name from SKILL.md in Task 3.

- [ ] **Step 1: Create the branch**

```bash
cd /Users/newmindsgroup/code/prompt-engineering-expert
git checkout main && git pull origin main
git checkout -b feat/next-level-enhancements
```

- [ ] **Step 2: Create `references/gap-checklist.md`**

````markdown
# Gap Checklist — what to infer, assume, or ask

Version-Timestamp: 2026-06-19

Run this during self-assessment, before drafting. Score the request against all
eight dimensions, then apply the decision rule.

## Dimensions

1. **Objective / definition of done** — what counts as success.
2. **Target model / platform / runtime** — Claude Code agent, Cursor rule, system
   prompt, end-user chat prompt, etc. (sets context window + cost).
3. **Audience & channel** — who reads/consumes the output, and where.
4. **Output shape / format** — prose, JSON, table, sectioned; exact schema if any.
5. **Constraints** — length, style, tone, banned patterns, must-dos/must-nots.
6. **Success criteria / evaluation** — how the output will be judged.
7. **Examples** — any gold/bad examples to anchor on.
8. **Stakes / risk** — low (draft/internal) vs high (client-facing, money, PII).

## Classification

- **✅ Known** — stated by the user, or confidently inferable from the project
  (files, AGENTS.md/CLAUDE.md, recent work).
- **🟡 Assumable** — unstated, but a safe, conventional default exists. Use it and
  state the assumption.
- **🔴 Blocking** — no safe default AND a wrong guess would materially change the
  output.

### Safe-default heuristics (🟡 vs 🔴)
- A dimension is 🟡 when the conventional default is low-regret (e.g. output format
  when the task implies one; tone when the channel is known).
- A dimension is 🔴 when guessing wrong wastes the work (e.g. unknown target model
  for a token-bound prompt; unknown audience for persuasive copy; unknown success
  criteria for an eval prompt; high stakes with ambiguous scope).

## Decision rule

- Any **🔴** → ask those as qualifying questions **before drafting**: batched,
  each with 2–4 concrete options **and a recommended default**, max ~3–4. Never
  open-ended. In Interactive mode, ask one at a time.
- Zero 🔴 → draft now; list 🟡 assumptions.
- User declines/stalls on a 🔴 → take the recommended default, mark it a flagged
  assumption, proceed.

## Worked examples

**Proceeds autonomously** — "Write a prompt to extract action items from meeting
transcripts." Objective ✅, output shape 🟡 (assume JSON list), audience 🟡 (assume
the meeting owner), model 🟡 (assume the current default), stakes ✅ low. Zero 🔴 →
draft + assumptions.

**Must ask** — "Write a prompt for our sales outreach." Objective 🔴 (book a call?
nurture? re-engage?), audience 🔴 (cold? existing?), stakes 🔴 (client-facing).
Three 🔴 → ask 3 batched multiple-choice questions with recommended defaults
before drafting.
````

- [ ] **Step 3: Create `references/quality-rubric.md`**

````markdown
# Quality Rubric — score the draft before presenting

Version-Timestamp: 2026-06-19

Score each axis 1–5. Auto-revise any axis ≤3 once, then present with a one-line
scorecard.

| Axis | 1 (poor) | 3 (ok) | 5 (strong) |
|------|----------|--------|------------|
| **Clarity** | ambiguous role/instructions | mostly clear | unambiguous; one reading only |
| **Specificity** | vague asks | some concrete detail | every instruction concrete + bounded |
| **Testability** | no way to judge output | loose criteria | explicit pass/fail + test inputs |
| **Token-efficiency** | bloated, repetitive | acceptable | tight; no wasted tokens |
| **Safety** | leaks PII / unsafe | minor gaps | masks PII, refuses-and-redirects, least data |

Scorecard format: `Quality: clarity 5 · specificity 4 · testability 5 · tokens 4 · safety 5`.
````

- [ ] **Step 4: Create `references/anti-patterns.md`**

````markdown
# Prompt Anti-Patterns ("smells") — scan and fix before finalizing

Version-Timestamp: 2026-06-19

| Smell | Fix |
|-------|-----|
| Vague role ("you are a helpful assistant") | Name the expertise + tone. |
| No output format | Specify shape (prose/JSON/table) + example. |
| Conflicting instructions | Remove or reconcile; state precedence. |
| Unbounded length | Set a hard limit (words/tokens/items). |
| Untestable success criteria | Add a pass/fail checklist + test inputs. |
| Buried key instruction | Move the critical rule to its own line near the top. |
| Over-stuffed context | Summarize or move to attachments/retrieval. |
| No examples when the task is nuanced | Add 1 gold (and 1 bad) example. |
| PII left inline | Mask to roles/placeholders. |
| "Don't" without "do" | Pair each prohibition with the desired behavior. |
````

- [ ] **Step 5: Verify all three exist with timestamps**

Run:
```bash
cd /Users/newmindsgroup/code/prompt-engineering-expert
for f in gap-checklist quality-rubric anti-patterns; do
  p="skills/prompt-engineering-expert/references/$f.md"
  test -s "$p" && grep -q "Version-Timestamp:" "$p" && echo "OK: $p" || echo "FAIL: $p"
done
```
Expected: three `OK:` lines.

- [ ] **Step 6: Commit**

```bash
git add skills/prompt-engineering-expert/references/gap-checklist.md skills/prompt-engineering-expert/references/quality-rubric.md skills/prompt-engineering-expert/references/anti-patterns.md
git commit -m "feat: add gap-checklist, quality-rubric, anti-patterns references"
```

---

## Task 2: Template library

**Files:**
- Create: `skills/prompt-engineering-expert/references/templates/README.md`
- Create: 7 archetype files in `skills/prompt-engineering-expert/references/templates/`

**Interfaces:**
- Produces: template set cited from SKILL.md in Task 3.

- [ ] **Step 1: Create the templates directory + index `README.md`**

````markdown
# Prompt Templates

Version-Timestamp: 2026-06-19

Ready-to-fill Prompt Blueprints. When a request matches an archetype, start here
instead of from blank, then tailor.

| Template | Use when |
|----------|----------|
| `extraction.md` | pull structured fields from unstructured text |
| `classification.md` | label/route an input into categories |
| `agent-system-prompt.md` | define an autonomous agent's persona + rules |
| `rag.md` | answer grounded in retrieved context |
| `code-generation.md` | generate or modify code to a spec |
| `evaluation-rubric.md` | judge another model's output |
| `multi-step-chain.md` | decompose a large task into a token-budgeted chain |
````

- [ ] **Step 2: Create `templates/extraction.md`**

````markdown
# Template — Extraction

```
# Role / Persona
You are a precise extraction engine.

# Objective / OKR
Extract <FIELDS> from the input. Success: every field present or explicitly null;
no invented values.

# Context
INPUT: <describe the source text>.

# Requirements
- Output valid JSON only, matching the schema below.
- If a field is absent, use null — never guess.
- Quote the source span for each extracted field where feasible.

# Desired Output (JSON)
{ "<field1>": "", "<field2>": "" }

# Evaluation
Pass if valid JSON, all fields present, no hallucinated values.
Test inputs: full record · partial record · empty/no-match.
```
````

- [ ] **Step 3: Create `templates/classification.md`**

````markdown
# Template — Classification

```
# Role / Persona
You are a careful classifier.

# Objective / OKR
Assign the input to exactly one of: <LABELS>. Success: correct label + calibrated
confidence.

# Context
Label definitions: <define each label + a boundary example>.

# Requirements
- Choose exactly one label. If none fit, use "other".
- Return a confidence 0–1 and a one-line justification.

# Desired Output (JSON)
{ "label": "", "confidence": 0.0, "why": "" }

# Evaluation
Pass if label ∈ allowed set, confidence present, justification references the input.
Test inputs: clear case · boundary case · none-fit case.
```
````

- [ ] **Step 4: Create `templates/agent-system-prompt.md`**

````markdown
# Template — Agent System Prompt

```
# Role / Persona
You are <AGENT NAME>, a <domain> specialist. Tone: <tone>.

# Objective / OKR
<the agent's mission and what "done" means>.

# Context
Operating environment: <tools, data, runtime>. Audience: <who it serves>.

# Requirements
- Use these tools only when needed: <tools>.
- Always: <musts>. Never: <must-nots>.
- Ask before <irreversible/outward-facing actions>.
- Degrade gracefully; surface uncertainty instead of guessing.

# Desired Output
<format of the agent's responses / artifacts>.

# Evaluation
Pass if it stays in scope, respects must-nots, and asks before risky actions.
Test inputs: happy path · ambiguous request · disallowed request.
```
````

- [ ] **Step 5: Create `templates/rag.md`**

````markdown
# Template — RAG (grounded answer)

```
# Role / Persona
You answer strictly from the provided context.

# Objective / OKR
Answer <question type> using ONLY the retrieved context. Success: accurate, cited,
no fabrication.

# Context
RETRIEVED:
<context chunks>

# Requirements
- Use only the context. If the answer isn't there, say "Not in the provided context."
- Cite the chunk id(s) for each claim.

# Desired Output
Answer + a "Sources:" list of chunk ids.

# Evaluation
Pass if every claim is grounded + cited, and missing info is admitted.
Test inputs: answerable · partially answerable · unanswerable.
```
````

- [ ] **Step 6: Create `templates/code-generation.md`**

````markdown
# Template — Code Generation

```
# Role / Persona
You are a senior <language> engineer who writes idiomatic, tested code.

# Objective / OKR
Implement <feature> to the spec. Success: compiles, matches the interface, has tests.

# Context
Codebase conventions: <style, libs>. Interface/spec: <signatures, behavior>.

# Requirements
- Match existing style. No new dependencies without calling them out.
- Handle errors on external calls. Include tests for the core paths.
- Return only the changed files/diff.

# Desired Output
The code (and tests), each in its own fenced block labeled with its path.

# Evaluation
Pass if it builds, satisfies the interface, and tests cover happy + failure paths.
Test inputs: nominal spec · edge spec · invalid input.
```
````

- [ ] **Step 7: Create `templates/evaluation-rubric.md`**

````markdown
# Template — Evaluation Rubric (LLM-as-judge)

```
# Role / Persona
You are an impartial evaluator.

# Objective / OKR
Score a candidate output against the criteria. Success: consistent, justified scores.

# Context
TASK the output was meant to do: <task>. CANDIDATE: <output>.

# Requirements
- Score each criterion 1–5 with a one-line reason: <criteria>.
- Be calibrated; reserve 5 for excellent. No ties-to-please.

# Desired Output (JSON)
{ "scores": { "<criterion>": 0 }, "overall": 0, "notes": "" }

# Evaluation
Pass if every criterion scored + justified and overall is consistent with parts.
Test inputs: strong output · weak output · mixed output.
```
````

- [ ] **Step 8: Create `templates/multi-step-chain.md`**

````markdown
# Template — Multi-Step Chain (token-budgeted)

```
# Role / Persona
You are an orchestrator that decomposes a large task into ordered steps.

# Objective / OKR
Produce <final synthesis> from <large/many inputs> without exceeding the context
window. Success: faithful synthesis, each step within budget.

# Context
Inputs: <sources + approximate sizes>. Window: <limit>.

# Requirements
Run this chain, with a rough token budget per step:
1. Map — summarize each source (~<n> tokens each).
2. Select — keep the top-relevant summaries.
3. Reduce — merge into a compact brief.
4. Synthesize — produce the final output from the brief.

# Desired Output
The final synthesis, plus a one-line note of what was dropped at Select.

# Evaluation
Pass if no step exceeds budget and the synthesis traces to the sources.
Test inputs: few large docs · many small docs · one oversized doc.
```
````

- [ ] **Step 9: Verify the template set**

Run:
```bash
cd /Users/newmindsgroup/code/prompt-engineering-expert
ls skills/prompt-engineering-expert/references/templates/ | sort
echo "count:" ; ls skills/prompt-engineering-expert/references/templates/*.md | wc -l
```
Expected: `README.md` + 7 archetypes = 8 files.

- [ ] **Step 10: Commit**

```bash
git add skills/prompt-engineering-expert/references/templates/
git commit -m "feat: add prompt template library (7 archetypes + index)"
```

---

## Task 3: Wire behaviors into SKILL.md + regenerate renders + version bump

**Files:**
- Modify: `skills/prompt-engineering-expert/SKILL.md`
- Modify (generated): `cursor/…`, `codex/…`, `antigravity/…`
- Modify: `.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json`

**Interfaces:**
- Consumes: the four reference paths from Tasks 1–2.
- Produces: the body behaviors that ship in every render.

- [ ] **Step 1: Add the Gap scan to the self-assessment section**

In `skills/prompt-engineering-expert/SKILL.md`, find the line:
```
Anything you can infer, do NOT ask. Only genuinely output-changing unknowns
become questions.
```
Immediately AFTER it, insert:
```markdown

### Gap scan (run before drafting)

Score the request against eight dimensions — objective, target model/platform,
audience/channel, output shape, constraints, success criteria, examples, stakes —
and classify each: ✅ Known · 🟡 Assumable (safe default exists — state it) ·
🔴 Blocking (no safe default; a wrong guess changes the output). Details and
safe-default heuristics: `references/gap-checklist.md`.

**Decision rule:** any 🔴 → ask those as qualifying questions BEFORE drafting,
batched, each with 2–4 concrete options and a recommended default (max ~3–4;
one at a time in Interactive mode). Zero 🔴 → draft now and list 🟡 assumptions.
If the user declines a 🔴, take the recommended default as a flagged assumption.
Show a compact one-line **Gap scan** above the draft (counts + assumptions made +
questions asked).
```

- [ ] **Step 2: Add the self-grading step to the Output pattern section**

In the same file, find the "## Output pattern" list ending with:
```
5. A token-budget note when the prompt is long, multi-document, or near a
   context limit.
```
Immediately AFTER that list item, insert:
```markdown
6. A one-line **quality scorecard** — score the draft 1–5 on clarity,
   specificity, testability, token-efficiency, safety; auto-revise any axis ≤3
   once before presenting. Criteria: `references/quality-rubric.md`. Example:
   `Quality: clarity 5 · specificity 4 · testability 5 · tokens 4 · safety 5`.
```

- [ ] **Step 3: Point to templates + anti-patterns in the Blueprint and Examples sections**

In the "## The Prompt Blueprint" section, find:
```
Full detail and worked examples:
`references/blueprint.md`.
```
Replace with:
```
Full detail and worked examples: `references/blueprint.md`. When a request matches
a common archetype (extraction, classification, agent system prompt, RAG,
code-gen, eval rubric, multi-step chain), start from `references/templates/`.
Before finalizing, scan the draft against `references/anti-patterns.md` and fix
any smells.
```

- [ ] **Step 4: Bump the skill version**

In the frontmatter, change `version: '1.0.0'` to `version: '1.1.0'`.

- [ ] **Step 5: Regenerate renders**

Run:
```bash
cd /Users/newmindsgroup/code/prompt-engineering-expert
./scripts/sync-renders.sh
```
Expected: three "Regenerated" lines.

- [ ] **Step 6: Verify body budget + render sizes**

Run:
```bash
for f in skills/prompt-engineering-expert/SKILL.md cursor/prompt-engineering-expert.mdc codex/prompts/prompt-engineering-expert.md antigravity/prompt-engineering-expert.md; do
  printf "%6d chars  %s\n" "$(wc -c < "$f")" "$f"
done
```
Expected: every render ≤ ~8,500 chars.

- [ ] **Step 7: Bump plugin + marketplace versions to 1.1.0**

In `.claude-plugin/plugin.json` change `"version": "1.0.0"` → `"version": "1.1.0"`.
In `.claude-plugin/marketplace.json` change the top-level `"version": "1.0.0"` →
`"version": "1.1.0"` AND the plugin entry's `"version": "1.0.0"` → `"version": "1.1.0"`.

- [ ] **Step 8: Validate JSON + originality + render drift**

Run:
```bash
cd /Users/newmindsgroup/code/prompt-engineering-expert
python3 -c "import json; json.load(open('.claude-plugin/plugin.json')); json.load(open('.claude-plugin/marketplace.json')); print('JSON ok')"
grep -rniE "wizard|chatgpt|original gpt|gpt-5|\bo3\b" skills cursor codex antigravity .claude-plugin && echo "FAIL originality" || echo "PASS originality"
./scripts/sync-renders.sh >/dev/null && git diff --quiet -- cursor codex antigravity && echo "PASS no drift" || echo "renders changed (stage them)"
```
Expected: `JSON ok`, `PASS originality`, `PASS no drift`.

- [ ] **Step 9: Commit**

```bash
git add skills/prompt-engineering-expert/SKILL.md cursor codex antigravity .claude-plugin
git commit -m "feat: gap-detection engine + self-grading rubric + library pointers (v1.1.0)"
```

---

## Task 4: Repo CI

**Files:**
- Create: `.github/workflows/validate.yml`

**Interfaces:**
- Consumes: the repo files + `scripts/sync-renders.sh`.
- Produces: a CI gate on push/PR.

- [ ] **Step 1: Create `.github/workflows/validate.yml`**

```yaml
name: Validate

on:
  push:
  pull_request:

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: SKILL.md frontmatter
        run: |
          F=skills/prompt-engineering-expert/SKILL.md
          head -1 "$F" | grep -q '^---$' || { echo "no frontmatter"; exit 1; }
          grep -q '^name: prompt-engineering-expert$' "$F" || { echo "bad name"; exit 1; }
          grep -qE '^description: ' "$F" || { echo "missing description"; exit 1; }
          echo "frontmatter ok"

      - name: JSON manifests valid
        run: |
          python3 -c "import json; json.load(open('.claude-plugin/plugin.json')); json.load(open('.claude-plugin/marketplace.json')); print('json ok')"

      - name: Plugin component paths resolve
        run: |
          python3 - <<'PY'
          import json, os, sys
          m = json.load(open('.claude-plugin/marketplace.json'))
          missing = []
          for p in m.get('plugins', []):
              for k in ('skills', 'agents', 'commands'):
                  v = p.get(k, [])
                  for path in ([v] if isinstance(v, str) else v):
                      rp = path.lstrip('./')
                      if not os.path.exists(rp):
                          missing.append(f"{k}: {path}")
          if missing:
              print("MISSING:", *missing, sep="\n"); sys.exit(1)
          print("all plugin paths resolve")
          PY

      - name: Renders not drifted
        run: |
          bash scripts/sync-renders.sh
          git diff --exit-code -- cursor codex antigravity \
            || { echo "Renders out of sync — run scripts/sync-renders.sh and commit."; exit 1; }

      - name: Originality sweep
        run: |
          if grep -rniE "wizard|chatgpt|original gpt|gpt-5|\bo3\b" \
               skills cursor codex antigravity .claude-plugin README.md; then
            echo "Origin/stale reference found"; exit 1
          fi
          echo "originality clean"
```

- [ ] **Step 2: Lint the workflow YAML locally**

Run:
```bash
cd /Users/newmindsgroup/code/prompt-engineering-expert
python3 -c "import yaml,sys; yaml.safe_load(open('.github/workflows/validate.yml')); print('yaml ok')" 2>/dev/null || echo "(pyyaml not present — will validate on push)"
```
Expected: `yaml ok` (or the fallback note; the real check is the CI run).

- [ ] **Step 3: Dry-run each CI step locally**

Run each `run:` block's commands locally from the repo root and confirm they print
their success lines (`frontmatter ok`, `json ok`, `all plugin paths resolve`,
no diff, `originality clean`).

- [ ] **Step 4: Commit**

```bash
git add .github/workflows/validate.yml
git commit -m "ci: validate frontmatter, manifests, plugin paths, render drift, originality"
```

---

## Task 5: Eval suite

**Files:**
- Create: `evals/README.md`
- Create: `evals/cases.md`
- Create: `evals/run-evals.sh`

**Interfaces:**
- Consumes: the installed/loaded skill.
- Produces: a runnable, dependency-free eval suite.

- [ ] **Step 1: Create `evals/README.md`**

````markdown
# Evals — prompt-engineering-expert

Version-Timestamp: 2026-06-19

A dependency-free, human-or-agent-runnable suite. No API keys. Each case is read,
executed against the skill (in a Claude Code / Codex / Cursor / Antigravity
session with the skill installed), and checked against its expectation.

## Run

```bash
./run-evals.sh        # prints each case + a blank PASS/FAIL line to fill in
```

Record results next to each case. CI does not run these (they need a live model);
they are a release checklist. Future automation hook: wire to
`anthropic-skills:skill-creator` evals.
````

- [ ] **Step 2: Create `evals/cases.md`**

````markdown
# Eval Cases

Version-Timestamp: 2026-06-19

## Bucket 1 — Trigger (should the skill activate?)

| # | Input | Expected |
|---|-------|----------|
| T1 | "help me write a prompt that summarizes tickets" | ACTIVATES |
| T2 | "improve this system prompt: <paste>" | ACTIVATES |
| T3 | "convert this Claude agent into a Cursor rule" | ACTIVATES |
| T4 | "what's the capital of France?" | does NOT activate |
| T5 | "refactor this Python function for speed" | does NOT activate |

## Bucket 2 — Gap detection (ask vs proceed)

| # | Input | Expected |
|---|-------|----------|
| G1 | "write a prompt to extract action items from a transcript" | proceeds; shows Gap scan with 🟡 assumptions; asks nothing |
| G2 | "write a prompt for our sales outreach" | asks 2–3 batched qualifying questions (objective, audience, stakes) with recommended defaults BEFORE drafting |
| G3 | "write a prompt to classify support tickets into Billing/Bug/Other, JSON out, for GPT-class model, internal use" | proceeds; near-zero assumptions (fully specified) |
| G4 | G2, then user says "just decide" | proceeds using recommended defaults, flagged as assumptions |

## Bucket 3 — Output quality

| # | Input | Expected |
|---|-------|----------|
| Q1 | "write a prompt to grade essays 1–5" | output uses the Blueprint, includes Desired Output + Evaluation, shows a quality scorecard, no anti-patterns (has output format + test inputs) |
| Q2 | "make this prompt cheaper: <long verbose prompt>" | reduces tokens, warns if near a window, scorecard shows improved token axis |
````

- [ ] **Step 3: Create `evals/run-evals.sh`**

```bash
#!/usr/bin/env bash
# Print each eval case with a blank result line for a human/agent to fill in.
# Dependency-free; does not call any model.
set -euo pipefail
cd "$(dirname "$0")"
echo "prompt-engineering-expert — eval run ($(cat cases.md | grep -c '^| [TGQ]'))" || true
echo "Read each case in cases.md, run it against the installed skill, record PASS/FAIL."
echo
grep -E '^\| (T|G|Q)[0-9]' cases.md | sed 's/|/ /g' | while read -r line; do
  echo "[ ] $line"
done
echo
echo "Done. Mark each [ ] as PASS/FAIL with a note."
```

- [ ] **Step 4: Make executable + smoke-run**

Run:
```bash
cd /Users/newmindsgroup/code/prompt-engineering-expert
chmod +x evals/run-evals.sh
./evals/run-evals.sh | head -20
```
Expected: prints the case lines, each prefixed `[ ]`.

- [ ] **Step 5: Commit**

```bash
git add evals/
git commit -m "test: add runnable eval suite (trigger, gap-detection, output quality)"
```

---

## Task 6: Final verification + push + PR

**Files:** none (verification + git)

- [ ] **Step 1: Fresh-clone-style integrity check**

Run:
```bash
cd /Users/newmindsgroup/code/prompt-engineering-expert
./scripts/sync-renders.sh >/dev/null && git diff --quiet -- cursor codex antigravity && echo "PASS: no drift"
./install.sh --dry-run >/dev/null 2>&1 && echo "PASS: installer runs"
python3 -c "import json,os; m=json.load(open('.claude-plugin/marketplace.json'));
print('PASS: paths' if all(os.path.exists(p.lstrip('./')) for pl in m['plugins'] for k in ('skills','agents','commands') for p in pl.get(k,[])) else 'FAIL')"
grep -rniE 'wizard|chatgpt|gpt-5|\bo3\b' skills cursor codex antigravity .claude-plugin README.md evals && echo FAIL || echo "PASS: originality"
```
Expected: all `PASS`.

- [ ] **Step 2: Live skill smoke test**

In a session with the skill installed, run G1 and G2 from `evals/cases.md`. Confirm
G1 proceeds (Gap scan + scorecard, no questions) and G2 asks batched qualifying
questions with recommended defaults before drafting.

- [ ] **Step 3: Push + open PR**

```bash
cd /Users/newmindsgroup/code/prompt-engineering-expert
git push -u origin feat/next-level-enhancements
gh pr create --base main --head feat/next-level-enhancements \
  --title "feat: gap-detection engine, self-grading, template library, CI + evals (v1.1.0)" \
  --body "Adds the Gap-Detection Engine (deterministic qualifying-questions), self-grading rubric, template + anti-pattern library, repo CI, and an eval suite. Renders regenerated; version 1.1.0. See docs/superpowers/specs/2026-06-19-next-level-enhancements-design.md."
```

- [ ] **Step 4: Wait for CI, then merge**

```bash
gh pr checks --watch
gh pr merge --merge --delete-branch
```

---

## Self-Review

**Spec coverage:** §2 architecture → Tasks 1–5 placement; §3 Gap engine → Task 1
(reference) + Task 3 Step 1 (body); §4 rubric → Task 1 + Task 3 Step 2; §5 library
→ Task 2 + Task 3 Step 3; §6.1 CI → Task 4; §6.2 evals → Task 5; §7 cross-cutting
(originality, renders, versioning, body budget, attribution) → Task 3 Steps 4–8 +
global constraints; §8 DoD → Task 6. All sections mapped.

**Placeholder scan:** Every file's full content is embedded; commands have expected
output. Template `<ANGLE>` tokens are intentional fill-in slots in the template
*content* (that is what a template is), not plan placeholders.

**Consistency:** `skills/prompt-engineering-expert/` path, reference filenames
(`gap-checklist.md`, `quality-rubric.md`, `anti-patterns.md`, `templates/`), the
scorecard string, and version `1.1.0` are used identically across tasks. CI grep
and Task 3 originality grep use the same pattern set.
