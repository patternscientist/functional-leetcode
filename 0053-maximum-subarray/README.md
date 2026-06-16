# 0053. Maximum Subarray

Status: accepted Haskell initial import.

Judge shape:

- fixed examples from `inputs/Lib.hs`;
- all-negative and singleton cases;
- deterministic generated nonempty arrays checked against an exhaustive slow
  oracle over all contiguous subarrays.

Acceptance evidence:

```powershell
python judge/judge.py test 0053 haskell
```

Result: accepted, 41 / 41 fixed/generated cases passed.
