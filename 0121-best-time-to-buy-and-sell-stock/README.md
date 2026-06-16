# 0121. Best Time to Buy and Sell Stock

Status: accepted Haskell initial import; accepted Racket submission.

Judge shape:

- fixed examples from `inputs/Lib.hs`;
- edge/boundary cases;
- deterministic generated arrays checked against a quadratic slow oracle.

Acceptance evidence:

```powershell
python judge/judge.py test 0121 haskell
python judge/judge.py test 0121 racket
```

Result: Haskell accepted 36 / 36 fixed/generated cases. Racket accepted 35 / 35
fixed/generated nonempty-list cases.

The latest Racket submission makes the LeetCode nonempty-list constraint
explicit with `cons/c`, uses `in-list` for list traversal, and seeds the fold
from `(first prices)`.
