# 0322. Coin Change

Status: accepted Haskell initial import.

Judge shape:

- fixed cases from `inputs/Lib.hs`, including large examples;
- deterministic generated small cases checked against a breadth-first slow
  oracle over reachable amounts.

Acceptance evidence:

```powershell
python judge/judge.py test 0322 haskell
```

Result: accepted, 195 / 195 fixed/generated cases passed.
