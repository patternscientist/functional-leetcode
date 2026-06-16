# 0053. Maximum Subarray

Status: accepted Haskell initial import; accepted Racket submission.

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

Result: Haskell accepted, 41 / 41 fixed/generated cases passed. Racket accepted,
41 / 41 fixed/generated nonempty-list cases passed.

The Racket submission follows the LeetCode nonempty-list constraint by using
`(first nums)` to seed the fold.
