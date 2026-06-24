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
