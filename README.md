# Functional LeetCode

Functional LeetCode is a curated laboratory for solving LeetCode-style problems
in Haskell and, later, Racket. It is separate from
`patternscientist/leetcode`, the LeetHub-managed imperative archive.

The current Haskell problem files are source-faithful standalone imports from
`inputs/Lib.hs`: module headers, minimal imports, and duplicated local helpers
were added only so each problem can be judged independently.

## Layout

```text
judge/                 Python orchestration layer
shared/haskell/        Haskell test helpers and reusable structures
shared/racket/         Racket test helpers
tools/                 Import and reporting helpers
0003-... through        Haskell imports from the current `inputs/Lib.hs`
0994-...
```

Each problem uses a zero-padded directory such as `0322-coin-change` with a
small `problem.json` and language-specific solution/test files. Commented-out
historical code from `inputs/Lib.hs` is kept only in clearly noncanonical
`attempts/` notes until it is replayed through the judge.

## Judge Commands

```powershell
python judge/judge.py test 0322 haskell
python judge/judge.py submit 0322 haskell --source .\0322-coin-change\haskell\Solution.hs
python judge/judge.py test-all
python judge/judge.py validate
```

`Accepted` means the candidate compiled and passed the repository's committed
target-language tests/oracles under the local timeout. This is evidence, not a
proof and not a LeetCode percentile claim.

During `submit`, frozen judge files are hashed before evaluation and checked
again afterward. Tests, oracles, generators, canonicalizers, seeds, expected
outputs, and timeouts must not change during a submission.

## Current Import Status

`0110-balanced-binary-tree` is pending because the active `Lib.hs` attempt fails
expanded balance edge cases. The rest of the active imported Haskell files are
intended to be accepted only after direct judge runs.

Final study-ready or polished canonical versions are intentionally deferred.

## Adding Problems

```powershell
python judge/judge.py add-problem 0322 coin-change --title "Coin Change" --language haskell
```

Before evaluating a real solution, add fixed tests, deterministic generated
tests, and an independent slow oracle where feasible. Pending problems are
skipped by `test-all`.

## Variants And Evolution

Accepted submissions are classified as:

- `duplicate`
- `minor-refactor`
- `meaningful-evolution`
- `distinct-approach`

Git history is enough for ordinary refinements. Create `EVOLUTION.md` only for
meaningful evolution or distinct approaches. Create `variants/` only when an old
implementation remains independently instructive and passes the judge.

Failed historical implementations are not variants and are never canonical.
Preserve them only in a clearly noncanonical path such as `attempts/`, with a
note showing the failing judge command or counterexample once known.

## CI

GitHub Actions installs GHC, runs judge self-tests, validates metadata, and runs
`test-all`. Racket setup is conditional on accepted Racket solutions.

Repository visibility is approved as public for now.
