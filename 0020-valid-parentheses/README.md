# 0020. Valid Parentheses

Status: accepted Haskell initial import.

The source file used `[String]` one-character tokens. This import normalizes the
API to the usual Haskell shape:

```haskell
isValid :: String -> Bool
```

Judge shape:

- fixed cases from `inputs/Lib.hs`, translated to strings;
- generated delimiter strings checked against an independent pair-reduction
  oracle.

Acceptance evidence: `python judge/judge.py test 0020 haskell` passes 89 / 89
fixed/generated cases.
