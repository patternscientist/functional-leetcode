# 0238. Product of Array Except Self

Status: accepted Haskell initial import; accepted Racket submission import.

Judge shape:

- fixed cases from `inputs/Lib.hs`, including zeros and singleton;
- deterministic generated arrays with multiple zeros;
- division-free slow oracle.
- Racket cases cover the nonempty LeetCode contract used by the submitted
  function.

Acceptance evidence:

```powershell
python judge/judge.py test 0238 haskell
python judge/judge.py test 0238 racket
```

Results:

- Haskell: accepted, 37 / 37 fixed/generated cases passed.
- Racket: accepted, 35 / 35 fixed/generated cases passed.
