# 0150. Evaluate Reverse Polish Notation

Status: accepted Haskell initial import.

Judge shape:

- fixed examples and division semantics from `inputs/Lib.hs`;
- generated expression trees serialized to RPN and checked against direct AST
  evaluation.

Acceptance evidence: `python judge/judge.py test 0150 haskell` passes 48 / 48
fixed/generated cases.
