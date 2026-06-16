# Judge

The judge is a Python orchestration layer. It runs direct target-language tests;
it is not the semantic oracle itself.

Implemented commands:

```powershell
python judge/judge.py add-problem 0322 coin-change --title "Coin Change" --language haskell
python judge/judge.py test 0001 haskell
python judge/judge.py submit 0001 haskell --source .\0001-two-sum\haskell\Solution.hs
python judge/judge.py test-all
python judge/judge.py validate
python judge/judge.py preview-anki 0001
```

During `submit`, problem metadata, target-language tests, shared test helpers,
and local oracle/generator files are hashed before evaluation and checked again
afterward. If any frozen judge file changes, the submission is rejected even if
the candidate passed.

The first version keeps Haskell harnesses dependency-light because the local GHC
package database does not include QuickCheck, HUnit, Hspec, or Tasty. Plain
assertions and deterministic generated cases are preferred until dependencies
are deliberately added.
