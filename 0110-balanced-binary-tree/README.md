# 0110. Balanced Binary Tree

Status: accepted Haskell initial import.

The accepted version uses the LeetCode policy that an empty subtree is balanced
with height `-1`. This fixes the monolithic source's `heightOrFail Empty =
Nothing` behavior, which rejects otherwise balanced single-child trees.

Judge shape:

- fixed tests from `inputs/Lib.hs`;
- explicit empty and single-child cases;
- generated trees checked against a direct height/balance oracle.

Acceptance evidence: `python judge/judge.py test 0110 haskell` passes 41 / 41
fixed/generated cases.
