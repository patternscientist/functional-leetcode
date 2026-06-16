# 0003. Longest Substring Without Repeating Characters

Status: accepted Haskell initial import.

Judge shape:

- fixed examples from `inputs/Lib.hs`;
- boundary and repeated-character cases;
- deterministic generated strings checked against an O(n^2) slow oracle.

Acceptance evidence:

```powershell
python judge/judge.py test 0003 haskell
```

Result: accepted, 68 / 68 fixed/generated cases passed.
