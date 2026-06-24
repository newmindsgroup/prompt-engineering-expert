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
