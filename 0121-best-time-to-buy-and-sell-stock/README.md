# 0121. Best Time to Buy and Sell Stock

Status: accepted Haskell initial import; LeetCode-accepted Racket submission
captured for later local judge acceptance.

Judge shape:

- fixed examples from `inputs/Lib.hs`;
- edge/boundary cases;
- deterministic generated arrays checked against a quadratic slow oracle.

Acceptance evidence:

```powershell
python judge/judge.py test 0121 haskell
python judge/judge.py test 0121 racket
```

Result: Haskell accepted 36 / 36 fixed/generated cases. Racket is not listed in
`problem.json` yet because this machine does not currently have `racket` on
PATH, so the local Racket judge has not been run.

The latest Racket submission makes the LeetCode nonempty-list constraint
explicit with `cons/c`, uses `in-list` for list traversal, and seeds the fold
from `(first prices)`.
