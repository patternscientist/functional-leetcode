# AGENTS

## Build And Test

- Use `python judge/judge.py test 0322 haskell` for one accepted Haskell import.
- Use `python judge/judge.py test-all` before reporting the repo as healthy.
- Use `python -m unittest discover -s judge/tests` for judge self-tests.
- Use `python judge/judge.py validate` after editing `problem.json`.
- Local Haskell tests compile with `ghc -O2 -Wall -Wextra` and plain assertions
  unless the repo deliberately adds test dependencies.
- When importing from `inputs/Lib.hs`, treat the user's included tests as seed
  evidence. Build/review the problem judge first, then run every uncommented
  candidate through that judge before accepting it.
- Keep standalone solution imports minimal. Include shared helper definitions in
  each problem file that needs them instead of relying on the monolithic source.

## Judge Rules

- The deterministic judge is the acceptance authority. Codex operates it; Codex
  is not the oracle.
- Direct Haskell tests are primary for Haskell. Direct Racket tests are primary
  for Racket. Python may orchestrate and report.
- During `submit`, do not edit tests, oracles, generators, seeds,
  canonicalizers, expected outputs, or timeouts. Frozen judge files are
  hash-checked.
- A failed submission is never canonical. A successful submission may update the
  accepted solution only after acceptance and classification.
- A commented historical implementation must also pass the problem judge before
  it can be called a solution or stored in `variants/`.
- Testing is evidence, not proof. Do not claim theorem-level certainty or
  LeetCode runtime percentiles.

## Classification

Use exactly:

- `duplicate`
- `minor-refactor`
- `meaningful-evolution`
- `distinct-approach`

Default to less artifact proliferation when ambiguous and ask the user only for
real ambiguity. Git history preserves ordinary refinements. `variants/` is for
genuinely distinct algorithms or representations. `EVOLUTION.md` records
meaningful milestones, not every commit.

Failed historical attempts may be described in `EVOLUTION.md` when they explain
a useful transition. Preserve failing code only when it has clear educational
value, put it under a plainly noncanonical path such as `attempts/`, and include
the failing judge command/counterexample near the code. Do not create empty
`attempts/`, `variants/`, or `EVOLUTION.md` files.

## Git

- Commit only relevant infrastructure/problem files.
- Do not push unless required tests pass, except documented pending problems
  skipped by `test-all`.
- Ask before creating a remote if visibility is unspecified.
- Repository visibility has been approved as public for now.
- Never print, store, or commit credentials or tokens.
