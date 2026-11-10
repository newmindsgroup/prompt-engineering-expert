# Template — Gauntlet loop (builder + blind critic until it beats a real bar)

Version-Timestamp: 2026-11-10

Adapted from RoboNuggets' gauntlet-loop skill (Jay E, CC BY 4.0, https://github.com/robonuggets/gauntlet-loop, commit 9b1975a); technique by Matt Shumer (https://github.com/mshumer/Claude-of-Duty). Changes: added the copy guard, hard gates, default cost ceiling and agent-neutral last lines; reworded throughout. See this repo's README credits.

Use when the user wants output that beats a real reference, not output that passes a self-written rubric: a page, deck, essay, tool or design. The prompt makes an agent split the work into small pieces, run a builder and a separate critic with fresh context on each, compare blind against a named bar and loop until ours wins.

## The bar decides everything

Ask for the bar before writing. If the user gives none, offer 2-3 candidate bars, one line each, and wait. A bar must be:

- **Named:** a specific thing ("Stripe's pricing page"), not a category ("award-winning SaaS sites").
- **Fetchable:** the critic can actually open, screenshot, read or run it. If it cannot, it will invent the comparison.
- **Comparable:** both can sit side by side and a judge can pick one.

Prefer the hardest bar the agent can reach. Add a measurable half when one exists (load time, word count, test pass rate, benchmark): taste plus a number beats taste alone.

| Goal | Bar that works |
| --- | --- |
| Website, app, UI | A specific best-in-class live page, screenshotted at the same viewports |
| Writing | A named published piece of the same length and format |
| Code, tooling | A named repo's implementation plus its tests or benchmark |
| Deck, doc | A real artifact from a firm known for it, same page count |
| Research | A named report or methods section, judged on rigour and coverage |

## Guardrails (always include)

- **Beat it, don't copy it.** The critic judges craft (hierarchy, clarity, polish, specificity), never resemblance. Work that could pass as the bar's brand loses: swap the names and if it still reads as theirs, it is a copy.
- **Hard gates come first.** Accessibility (WCAG 2.2 AA), the client's brand rules, licensing and factual accuracy are pass/fail checks run before any blind comparison. A pick never overrides a failed gate.
- **Cost ceiling.** Exit on a blind win or when the user stops the run, never on a round count. For client or paid work, include a spend or time ceiling; if the user names none, ask once, and default to stopping and reporting at the ceiling rather than looping silently.
- **Binary critic.** "Which is better, A or B, and the single biggest remaining gap." Scores out of 10 drift upward.

## Template

Keep it short (about 120-180 words), plain sentences, no headings or bullets inside. Fill the brackets; keep the guardrail sentences.

```
Build [GOAL].

The bar is [NAMED, FETCHABLE BAR] [plus MEASURABLE HALF if any]. Get the real thing first and compare against it directly, not against a description of it.

Break this into the smallest pieces that can be improved and judged on their own. For each piece, run a builder and a separate critic with fresh context. Before comparing, the critic checks the hard gates: [ACCESSIBILITY / BRAND RULES / LICENSING / ACCURACY]; a failed gate goes straight back to the builder. Then the critic inspects the actual output, puts it next to the bar blind with labels stripped, says which one is better on craft, and names the single biggest remaining gap. Resemblance to the bar counts against ours.

The critic is harsh. Praise is not useful. If ours does not win, it keeps going.

Loop on each piece until the critic picks ours blind or [CEILING] is reached, then report where each piece stands. Keep a live progress page updated so I can watch.

[AGENT LINE]
```

**Agent line.** Claude Code: "Run the builders and critics as parallel subagents; use /loop to keep going." Other agents: "Run the builders and critics as parallel subagents and keep looping until the critic picks ours." Add multi-agent orchestration keywords only when the user has opted into that scale; it can spawn many agents and cost a lot.

## Evaluation

Pass if: the bar is named, fetchable and comparable; hard gates and the copy guard are present; the critic is separate, fresh-context and binary; exit is win-or-ceiling, not a round count; the prompt is under about 180 words with no architecture or stack decisions the user did not ask for.
