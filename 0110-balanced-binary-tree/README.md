# 0110. Balanced Binary Tree

Status: pending Haskell import from `inputs/Lib.hs`.

`haskell/Solution.hs` preserves the active `Lib.hs` attempt. The expanded judge
currently rejects it because `heightOrFail Empty = Nothing` makes `Empty` and
otherwise balanced single-child trees report as unbalanced. A corrected canonical
solution should be discussed separately before this problem is marked accepted.

Judge command to replay the failure:

```powershell
python judge/judge.py test 0110 haskell
```
