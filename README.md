# Functional LeetCode

Functional LeetCode is a curated laboratory for solving LeetCode-style problems
in Haskell and, later, Racket. It is separate from
`patternscientist/leetcode`, the LeetHub-managed imperative archive. This repo
keeps deterministic tests, accepted functional solutions, meaningful evolution
notes, variants when justified, and version-controlled Anki note sources.

## Layout

```text
judge/                 Python orchestration layer
shared/haskell/        Haskell test helpers and reusable structures
shared/racket/         Racket test helpers
anki/                  Functional deck model, templates, previews
tools/                 Import and reporting helpers
0001-two-sum/          Accepted Haskell sample problem
0003-... through        Accepted Haskell imports from the current `inputs/Lib.hs`
0994-...
```

Each problem uses a zero-padded directory such as `0322-coin-change` with a
small `problem.json`, language-specific solution/test files, and optional Anki
source under `anki/note.json`.

## Judge Commands

```powershell
python judge/judge.py test 0001 haskell
python judge/judge.py submit 0001 haskell --source .\0001-two-sum\haskell\Solution.hs
python judge/judge.py test-all
python judge/judge.py validate
python judge/judge.py preview-anki 0001
```

`Accepted` means the candidate compiled and passed the repository's committed
target-language tests/oracles under the local timeout. This is evidence, not a
proof and not a LeetCode percentile claim.

During `submit`, frozen judge files are hashed before evaluation and checked
again afterward. Tests, oracles, generators, canonicalizers, seeds, expected
outputs, and timeouts must not change during a submission.

## Adding Problems

```powershell
python judge/judge.py add-problem 0322 coin-change --title "Coin Change" --language haskell
```

Before evaluating a real solution, add fixed tests, deterministic generated
tests, and an independent slow oracle where feasible. Pending problems are
skipped by `test-all`.

For the initial import, the tests already present in `inputs/Lib.hs` are useful
seed tests, not the whole acceptance surface. Each uncommented function should
be run through the expanded per-problem judge before it is submitted as
canonical.

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
Usually describe them in `EVOLUTION.md` as attempts if they explain a useful
transition. Preserve failing code only in a clearly noncanonical path such as
`attempts/`, with a note showing the failing judge command or counterexample.

## Anki

Anki source is stored as JSON under each problem's `anki/` directory. Haskell is
the canonical card language. Racket is an alternate practice language and gets a
comparison field/card only when it changes the lesson materially.

```powershell
python tools/generate_anki_tsv.py --output anki/previews/functional_leetcode.tsv
```

The repository stores reproducible note source/templates, not live scheduling
state. Synchronizing with Anki requires a future explicit approval step.

## CI

GitHub Actions installs GHC, runs judge self-tests, validates metadata, and runs
`test-all`. Racket setup is conditional on accepted Racket solutions.

Repository visibility is approved as public for now. Do not push until initial
push approval is explicit.
