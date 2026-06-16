# 150. Evaluate Reverse Polish Notation

## Pattern

Stack machine over tokens: push literals, pop two operands for each operator.

## Invariant

After each prefix of the token stream, the stack holds the values of complete subexpressions from that prefix, topmost first.

## Code

evalRPN tokens = case foldl' step [] tokens of
  [] -> 0
  t:_ -> t

step stack token = case readMaybe token of
  Just n -> n : stack
  Nothing -> pop two operands and apply token

## Complexity

Time: O(n). Space: O(n) for the stack.

## Pitfall(s)

Operand order matters: for stack `s1:s0:rest`, subtraction and division are `s0 - s1` and `s0 quot s1`.
