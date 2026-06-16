# 0053. Maximum Subarray

Status: accepted Haskell initial import; LeetCode-accepted Racket submission
captured for later local judge acceptance.

Judge shape:

- fixed examples from `inputs/Lib.hs`;
- all-negative and singleton cases;
- deterministic generated nonempty arrays checked against an exhaustive slow
  oracle over all contiguous subarrays.

Acceptance evidence:

```powershell
python judge/judge.py test 0053 haskell
python judge/judge.py test 0053 racket
```

Result: Haskell accepted, 41 / 41 fixed/generated cases passed. Racket is not
listed in `problem.json` yet because this machine does not currently have
`racket` on PATH, so the local Racket judge has not been run.

The Racket submission follows the LeetCode nonempty-list constraint by using
`(first nums)` to seed the fold.
