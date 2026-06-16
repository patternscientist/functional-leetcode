# Initial Import Status

Source inspected: `inputs/Lib.hs`.

This file tracks the first standalone import pass. It intentionally does not
choose final study-ready or polished canonical forms; those can be discussed
later. The goal here is source faithfulness plus direct judge evidence.

Policy:

- `haskell/Solution.hs` should be based on the active uncommented definition in
  `inputs/Lib.hs`, with only module headers, minimal imports, and duplicated
  helper definitions needed for standalone compilation.
- The user's included tests are seed tests, not the full acceptance surface.
- Commented historical implementations are not solutions until they pass the
  problem judge. Preserve them only under `attempts/` unless they are later
  accepted as variants.
- `0001-two-sum` is only a judge scaffold because it does not appear in
  `inputs/Lib.hs`.
- `0110-balanced-binary-tree` is pending because the active source attempt treats
  `Empty` as failure; a corrected version should not be substituted silently.

## Problem Status

| Problem | Status |
| --- | --- |
| `0001-two-sum` | pending; judge scaffold only, not in `inputs/Lib.hs` |
| `0003-longest-substring-without-repeating-characters` | accepted active `Lib.hs` import after direct judge run |
| `0015-3sum` | accepted active `Lib.hs` import after direct judge run |
| `0020-valid-parentheses` | accepted active `Lib.hs` import after direct judge run |
| `0033-search-in-rotated-sorted-array` | accepted active `Lib.hs` import after direct judge run |
| `0042-trapping-rain-water` | accepted active `Lib.hs` import after direct judge run |
| `0053-maximum-subarray` | accepted active `Lib.hs` import after direct judge run |
| `0110-balanced-binary-tree` | pending; active `Lib.hs` attempt fails expanded edge cases |
| `0121-best-time-to-buy-and-sell-stock` | accepted active `Lib.hs` import after direct judge run |
| `0125-valid-palindrome` | accepted active `Lib.hs` import after direct judge run |
| `0150-evaluate-reverse-polish-notation` | accepted active `Lib.hs` import after direct judge run |
| `0200-number-of-islands` | accepted active `Lib.hs` import after direct judge run |
| `0226-invert-binary-tree` | accepted active `Lib.hs` import after direct judge run |
| `0238-product-of-array-except-self` | accepted active `Lib.hs` import after direct judge run |
| `0322-coin-change` | accepted active `Lib.hs` import after direct judge run |
| `0542-01-matrix` | accepted active `Lib.hs` import after direct judge run |
| `0543-diameter-of-binary-tree` | accepted active `Lib.hs` import after direct judge run |
| `0704-binary-search` | accepted active `Lib.hs` import after direct judge run |
| `0733-flood-fill` | accepted active `Lib.hs` import after direct judge run |
| `0994-rotting-oranges` | accepted active `Lib.hs` import after direct judge run |

## Historical Attempts Preserved

- `0003-longest-substring-without-repeating-characters/attempts/README.md`
- `0053-maximum-subarray/attempts/README.md`
- `0238-product-of-array-except-self/attempts/README.md`
- `0322-coin-change/attempts/README.md`
- `0733-flood-fill/attempts/README.md`
