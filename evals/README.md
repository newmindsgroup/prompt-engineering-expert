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
they are a release checklist.

## Automated scored runs via skill-creator

The eval cases are also provided in `anthropic-skills:skill-creator`'s native
formats so they can be run as scored benchmarks:

- **`evals.json`** — output-quality cases with prompts, `expected_output`, and
  `assertions` (each `{text, passed, evidence}`). Run with skill-creator's eval
  loop: it spawns with-skill vs. baseline runs, grades the assertions, and opens a
  benchmark viewer. Point it at this skill: `skills/prompt-engineering-expert`.
- **`trigger-eval-set.json`** — `{query, should_trigger}` pairs for description
  optimization. Run skill-creator's description optimizer:
  ```bash
  python -m scripts.run_loop \
    --eval-set evals/trigger-eval-set.json \
    --skill-path skills/prompt-engineering-expert \
    --model <session-model-id> --max-iterations 5 --verbose
  ```
  It reports a `best_description` selected on a held-out split (guards against
  overfitting). Apply it to `SKILL.md` only if it beats the current description.

`cases.md` remains the human-readable checklist; `evals.json` is its machine form.
