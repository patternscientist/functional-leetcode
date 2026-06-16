# Initial Import Plan

Source inspected: `inputs/Lib.hs`.

Current verification status on this machine: `ghc -fforce-recomp -Wall -Wextra
-fno-code inputs\Lib.hs` fails before any tests run because local GHC `9.4.8`
with `base-4.17.2.1` does not expose `foldl'` from Prelude, while the file
imports `Data.List` qualified as `L` and uses `foldl'` unqualified in several
sections. This is version-sensitive: newer GHC/base combinations may warn that
`Data.List (foldl')` is redundant because Prelude exports it. Treat the
algorithms below as parsed and reviewed from source, not accepted by the new
judge.

Do not replay historical commits until this plan is approved. For each replayed
stage, freeze tests first, compile the stage directly with GHC, and commit only
correct accepted stages.

Import policy update: the user's included tests are seed tests, not the full
judge. Before any current uncommented function or commented historical stage is
submitted as canonical or retained as a variant, build/review that problem's
fixed tests, generated tests, and slow oracle, then run the stage through the
judge. If a commented historical stage fails the judge, do not call it a
solution and do not place it under `variants/`. Usually describe the failed
idea in `EVOLUTION.md`; preserve the code only when it has durable educational
value, under a clearly noncanonical `attempts/` path with the failing judge
command or counterexample documented nearby.

## 0121-best-time-to-buy-and-sell-stock

- Import status: accepted Haskell canonical solution.
- Judge evidence: `python judge/judge.py test 0121 haskell` passes 36 / 36
  fixed/generated cases, including a quadratic slow oracle.
- Current tests found: `maxProfitTest1`, `maxProfitTest2`.
- Missing tests/oracles: generated small arrays compared with a quadratic slow
  oracle; explicit single-day and monotone cases.
- Chronological versions found: active single-pass fold only.
- Version status: active version accepted after standalone import with local
  `Data.List (foldl')` import for GHC `9.4.8`.
- Proposed canonical version: single pass carrying minimum price and best profit.
- Transition classification: history only / minor-refactor.
- History alone sufficient: yes.
- Retained variant justified: no.
- `EVOLUTION.md` justified: no.
- Proposed Anki status: candidate; fields should emphasize the minimum-prefix
  invariant and "sell after buy" ordering.
- Ambiguity: none.

## 0053-maximum-subarray

- Import status: accepted Haskell canonical solution.
- Judge evidence: `python judge/judge.py test 0053 haskell` passes 41 / 41
  fixed/generated cases, including an exhaustive slow oracle.
- Current tests found: `maxSubarrayTest1` through `maxSubarrayTest5`.
- Missing tests/oracles: generated non-empty arrays compared with all subarray
  sums; all-negative and long mixed arrays.
- Chronological versions found: commented tuple fold, active `scanl1` form.
- Version status: tuple fold is superseded; active scan version accepted as the
  initial canonical solution.
- Proposed canonical version: active scan version, possibly named for card
  readability.
- Transition classification: minor-refactor / history only.
- History alone sufficient: yes.
- Retained variant justified: no.
- `EVOLUTION.md` justified: no.
- Proposed Anki status: candidate; pattern is Kadane as a prefix scan over best
  suffix ending here.
- Ambiguity: none.

## 0238-product-of-array-except-self

- Import status: accepted Haskell canonical solution.
- Judge evidence: `python judge/judge.py test 0238 haskell` passes 37 / 37
  fixed/generated cases, including a division-free slow oracle.
- Current tests found: five fixed tests including zeros and singleton.
- Missing tests/oracles: generated arrays compared with a division-free slow
  oracle; multiple-zero cases.
- Chronological versions found: explicit left/right folds, named prefix/suffix
  scans, scan composition, active point-free applicative composition.
- Version status: earlier forms are superseded; active point-free form accepted.
  It may still be rewritten later for card readability if the behavior is
  preserved and judged.
- Proposed canonical version: scan composition, preferably with readable names
  for prefixes and suffixes.
- Transition classification: minor-refactor / history only.
- History alone sufficient: yes.
- Retained variant justified: no.
- `EVOLUTION.md` justified: no.
- Proposed Anki status: candidate; fields should focus on prefix product before
  index and suffix product after index.
- Ambiguity: whether the polished canonical code should keep the point-free
  expression or use named bindings.

## 0003-longest-substring-without-repeating-characters

- Import status: accepted Haskell canonical solution.
- Judge evidence: `python judge/judge.py test 0003 haskell` passes 68 / 68
  fixed/generated cases, including an O(n^2) slow oracle.
- Current tests found: `lengthOfLongestSubstringTest1` through `Test3`.
- Missing tests/oracles: deterministic generated strings compared with an
  O(n^2) unique-substring oracle; empty string; repeated boundaries.
- Chronological versions found: commented prefilled IntMap version, active
  sparse IntMap sliding-window version.
- Version status: first version is superseded; active sparse IntMap version
  accepted as the initial canonical solution.
- Proposed canonical version: active sliding window with last-seen indices.
- Transition classification: minor-refactor / history only.
- History alone sufficient: yes.
- Retained variant justified: no.
- `EVOLUTION.md` justified: no.
- Proposed Anki status: candidate; fields should emphasize `start` never moves
  backward.
- Ambiguity: character-domain policy for Haskell should be documented if moving
  beyond ASCII/LeetCode examples.

## 0322-coin-change

- Import status: accepted Haskell canonical solution.
- Judge evidence: `python judge/judge.py test 0322 haskell` passes 195 / 195
  fixed/generated cases, including a breadth-first slow oracle for small cases.
- Current tests found: seven fixed tests, including unreachable and large cases.
- Missing tests/oracles: generated small amounts compared with exhaustive
  breadth-first or recursive slow oracle; explicit duplicate coin policy.
- Chronological versions found: first repeated table reconstruction, second
  shared lazy list, active `Data.Array` table.
- Version status: first version is superseded and inefficient; second is a
  meaningful sharing improvement; active array version accepted as the initial
  canonical solution.
- Proposed canonical version: `Data.Array` DP table.
- Transition classification: meaningful-evolution.
- History alone sufficient: no.
- Retained variant justified: yes, at least lazy-list versus array if both pass
  frozen tests.
- `EVOLUTION.md` justified: yes; created with earlier stages described as
  historical stages pending separate judge runs.
- Proposed Anki status: high-value candidate; card should preserve recurrence,
  sentinel value, and representation/performance transition.
- Ambiguity: whether to retain the repeated-table version as code if it passes
  the judge. If it fails, describe the idea or preserve it only as a
  noncanonical attempt with failure evidence.

## 0150-evaluate-reverse-polish-notation

- Import status: accepted Haskell canonical solution.
- Judge evidence: `python judge/judge.py test 0150 haskell` passes 48 / 48
  fixed/generated cases, including generated AST-to-RPN cases.
- Current tests found: three examples plus four division semantics tests.
- Missing tests/oracles: generated valid expression trees evaluated by a direct
  AST oracle; negative truncating division cases.
- Chronological versions found: active stack fold only.
- Version status: active stack-machine version accepted.
- Proposed canonical version: stack machine with explicit operand order for
  noncommutative operators.
- Transition classification: history only.
- History alone sufficient: yes.
- Retained variant justified: no.
- `EVOLUTION.md` justified: no.
- Proposed Anki status: candidate; fields should emphasize stack invariant and
  division order.
- Ambiguity: none.

## 0020-valid-parentheses

- Import status: accepted Haskell canonical solution.
- Judge evidence: `python judge/judge.py test 0020 haskell` passes 89 / 89
  fixed/generated cases, using a pair-reduction oracle.
- Current tests found: `isValidTest1` through `isValidTest5`.
- Missing tests/oracles: generated balanced/unbalanced bracket strings compared
  with a simple grammar/parser oracle.
- Chronological versions found: active stack fold only.
- Version status: accepted after normalizing the source's `[String]` token API
  to the usual `String -> Bool` Haskell shape.
- Proposed canonical version: stack parser over `String`/`Char`; accepted.
- Transition classification: minor-refactor if representation is normalized.
- History alone sufficient: yes.
- Retained variant justified: no.
- `EVOLUTION.md` justified: no.
- Proposed Anki status: candidate; fields should emphasize unmatched opener
  stack order.
- Ambiguity: resolved by normalizing to `String -> Bool`.

## 0226-invert-binary-tree

- Import status: accepted Haskell canonical solution.
- Judge evidence: `python judge/judge.py test 0226 haskell` passes 44 / 44
  fixed/generated cases, including involution checks.
- Current tests found: two fixed tree tests.
- Missing tests/oracles: generated small trees checking `invert . invert == id`
  and mirror-shape preservation.
- Chronological versions found: active recursive tree transform only.
- Version status: active version accepted with a local `Tree` type.
- Proposed canonical version: direct structural recursion.
- Transition classification: history only.
- History alone sufficient: yes.
- Retained variant justified: no.
- `EVOLUTION.md` justified: no.
- Proposed Anki status: optional candidate; useful for basic algebraic data
  type recursion.
- Ambiguity: tree type should become shared test/model support or stay local per
  tree problem.

## 0543-diameter-of-binary-tree

- Import status: accepted Haskell canonical solution.
- Judge evidence: `python judge/judge.py test 0543 haskell` passes 40 / 40
  fixed/generated cases, including a slow every-node diameter oracle.
- Current tests found: three fixed tree tests.
- Missing tests/oracles: generated trees compared with a slow all-pairs/height
  oracle.
- Chronological versions found: active `heightAndBest` fold only.
- Version status: active `heightAndBest` version accepted.
- Proposed canonical version: one traversal returning `(height, bestDiameter)`.
- Transition classification: history only.
- History alone sufficient: yes.
- Retained variant justified: no.
- `EVOLUTION.md` justified: no.
- Proposed Anki status: candidate; pattern is returning the local summary needed
  by the parent.
- Ambiguity: same shared tree-type decision as `0226`.

## 0110-balanced-binary-tree

- Import status: accepted Haskell canonical solution with a correctness fix.
- Judge evidence: `python judge/judge.py test 0110 haskell` passes 41 / 41
  fixed/generated cases, including empty and single-child trees.
- Current tests found: two fixed tree tests.
- Missing tests/oracles: generated trees compared with a direct height plus
  balance oracle; degenerate tall trees.
- Chronological versions found: active `Maybe` height/fail fold only.
- Version status: source's intended `Maybe` height/fail fold accepted after
  fixing the empty-subtree policy. `Empty` now returns `Just (-1)`; `Nothing`
  is reserved for a real balance failure.
- Proposed canonical version: bottom-up `Maybe Int` height computation.
- Transition classification: history only.
- History alone sufficient: yes.
- Retained variant justified: no.
- `EVOLUTION.md` justified: no.
- Proposed Anki status: candidate; fields should emphasize early failure as
  `Nothing`.
- Ambiguity: same shared tree-type decision as `0226`.

## 0733-flood-fill

- Import status: accepted Haskell canonical solution.
- Judge evidence: `python judge/judge.py test 0733 haskell` passes 130 / 130
  fixed/generated cases, including generated DFS-oracle grids and the large
  wall case.
- Current tests found: two examples, hard component test, diagonal trap, and a
  large efficiency test.
- Missing tests/oracles: generated small grids compared with an independent DFS
  component oracle; empty-grid policy if outside LeetCode constraints.
- Chronological versions found: commented BFS with repeated array updates,
  active reachable-set/map pass followed by one array update.
- Version status: first version is superseded; active reachable-set/final-update
  version accepted.
- Proposed canonical version: active reachability map/set plus one final update.
- Transition classification: meaningful-evolution.
- History alone sufficient: no.
- Retained variant justified: likely yes if the old implementation passes and
  remains instructive as a performance contrast.
- `EVOLUTION.md` justified: yes; created with the old repeated-array-update
  stage described as pending separate judge run.
- Proposed Anki status: high-value candidate; fields should capture component
  reachability and "do not recolor through diagonals".
- Ambiguity: retain old implementation as code if it passes the judge, or only
  describe it. If it fails, preserve it only as a noncanonical attempt with
  failure evidence.

## 0994-rotting-oranges

- Import status: accepted Haskell canonical solution.
- Judge evidence: `python judge/judge.py test 0994 haskell` passes 154 / 154
  fixed/generated cases, including a minute-by-minute simulator oracle.
- Current tests found: three examples plus one hard test.
- Missing tests/oracles: generated small grids compared with a minute-by-minute
  slow simulator; no-fresh and impossible edge cases.
- Chronological versions found: active multi-source BFS only.
- Version status: active multi-source BFS version accepted.
- Proposed canonical version: queue-based multi-source BFS over rotten frontier.
- Transition classification: history only.
- History alone sufficient: yes.
- Retained variant justified: no.
- `EVOLUTION.md` justified: no.
- Proposed Anki status: candidate; pattern is frontier expansion with minutes as
  layers.
- Ambiguity: none.

## 0542-01-matrix

- Import status: accepted Haskell canonical solution.
- Judge evidence: `python judge/judge.py test 0542 haskell` passes 183 / 183
  fixed/generated cases, including generated nearest-zero distance checks.
- Current tests found: two examples plus one hard test.
- Missing tests/oracles: generated binary matrices compared with per-cell slow
  BFS to nearest zero.
- Chronological versions found: active multi-source BFS only.
- Version status: active multi-source BFS version accepted.
- Proposed canonical version: multi-source BFS initialized from all zero cells.
- Transition classification: history only.
- History alone sufficient: yes.
- Retained variant justified: no.
- `EVOLUTION.md` justified: no.
- Proposed Anki status: candidate; compare with rotting oranges to highlight
  multi-source distance propagation.
- Ambiguity: none.

## 0200-number-of-islands

- Import status: accepted Haskell canonical solution.
- Judge evidence: `python judge/judge.py test 0200 haskell` passes 185 / 185
  fixed/generated cases, including generated DFS component-count checks.
- Current tests found: two examples plus one hard test.
- Missing tests/oracles: generated small grids compared with independent DFS or
  union-find oracle.
- Chronological versions found: active grid traversal with queue/visited state.
- Version status: active grid traversal version accepted.
- Proposed canonical version: BFS/DFS flood over unvisited land.
- Transition classification: history only.
- History alone sufficient: yes.
- Retained variant justified: no.
- `EVOLUTION.md` justified: no.
- Proposed Anki status: candidate; fields should emphasize quotienting cells
  into connected components.
- Ambiguity: none.

## 0125-valid-palindrome

- Import status: accepted Haskell canonical solution.
- Judge evidence: `python judge/judge.py test 0125 haskell` passes 92 / 92
  fixed/generated cases, including normalize-then-reverse specification checks.
- Current tests found: two examples plus eight hard normalization tests.
- Missing tests/oracles: generated strings compared with a simple
  normalize-then-reverse specification.
- Chronological versions found: active two-pointer array implementation only.
- Version status: active two-pointer array version accepted.
- Proposed canonical version: two-pointer refinement, with a clear specification
  helper in tests.
- Transition classification: distinct-approach only if a normalized
  specification implementation is retained beside it.
- History alone sufficient: yes for current source.
- Retained variant justified: maybe, if normalized-spec code is added for
  teaching.
- `EVOLUTION.md` justified: only if spec versus two-pointer variants are both
  retained.
- Proposed Anki status: candidate; fields should separate normalization policy
  from pointer invariant.
- Ambiguity: whether to keep a spec-level normalized implementation as an
  educational variant.

## 0015-3sum

- Import status: accepted Haskell canonical solution.
- Judge evidence: `python judge/judge.py test 0015 haskell` passes 71 / 71
  fixed/generated cases, including an O(n^3) canonical triplet oracle.
- Current tests found: three examples plus five hard duplicate/canonicalization
  tests.
- Missing tests/oracles: generated small arrays compared with O(n^3) canonical
  triplet oracle.
- Chronological versions found: active sort plus outer index plus two pointers.
- Version status: active sort/two-pointer version accepted.
- Proposed canonical version: sorted two-pointer sweep with duplicate skipping.
- Transition classification: history only.
- History alone sufficient: yes.
- Retained variant justified: no.
- `EVOLUTION.md` justified: no.
- Proposed Anki status: candidate; fields should emphasize duplicate skipping
  and canonical triplet comparison.
- Ambiguity: none.

## 0042-trapping-rain-water

- Import status: accepted Haskell canonical solution.
- Judge evidence: `python judge/judge.py test 0042 haskell` passes 88 / 88
  fixed/generated cases, including prefix/suffix-max specification checks.
- Current tests found: two examples.
- Missing tests/oracles: generated arrays compared with prefix/suffix maxima
  specification; monotone, plateau, and single-valley cases.
- Chronological versions found: active two-pointer implementation only.
- Version status: active two-pointer version accepted.
- Proposed canonical version: two-pointer solution after adding a scan-based
  oracle/spec.
- Transition classification: distinct-approach if prefix/suffix scan solution is
  retained beside two pointers.
- History alone sufficient: yes for current source, no if adding scan spec as a
  retained approach.
- Retained variant justified: likely yes if scan and two-pointer solutions are
  both polished.
- `EVOLUTION.md` justified: likely later, because scan, two-pointer, and stack
  approaches are genuinely distinct.
- Proposed Anki status: candidate; high value once scan spec and optimized
  invariant are both documented.
- Ambiguity: which approach should become canonical for the first functional
  card.

## 0704-binary-search

- Import status: accepted Haskell canonical solution.
- Judge evidence: `python judge/judge.py test 0704 haskell` passes 331 / 331
  fixed/generated cases, including linear-search checks.
- Current tests found: two examples plus eight hard/big boundary tests.
- Missing tests/oracles: generated sorted arrays and targets compared with
  `elemIndex`/linear search.
- Chronological versions found: active binary search only.
- Version status: active binary search version accepted.
- Proposed canonical version: half-open or closed interval search, whichever is
  clearest after split.
- Transition classification: history only.
- History alone sufficient: yes.
- Retained variant justified: no.
- `EVOLUTION.md` justified: no.
- Proposed Anki status: candidate; fields should state the interval invariant
  and termination measure.
- Ambiguity: choose and document closed versus half-open interval policy.

## 0033-search-in-rotated-sorted-array

- Import status: accepted Haskell canonical solution.
- Judge evidence: `python judge/judge.py test 0033 haskell` passes 2593 / 2593
  fixed/generated cases, including all rotations for generated unique arrays.
- Current tests found: two examples plus five hard boundary tests.
- Missing tests/oracles: exhaustive generated rotations of sorted unique arrays,
  compared with linear search.
- Chronological versions found: active rotated binary search only.
- Version status: active rotated binary search version accepted; this is the
  last problem in the current source's `tests` list.
- Proposed canonical version: interval refinement that detects which side is
  sorted before discarding half.
- Transition classification: history only.
- History alone sufficient: yes.
- Retained variant justified: no.
- `EVOLUTION.md` justified: no.
- Proposed Anki status: candidate; fields should emphasize sorted-side
  detection and boundary equality cases.
- Ambiguity: none after exhaustive rotation tests are added.
