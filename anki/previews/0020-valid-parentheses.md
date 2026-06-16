# 20. Valid Parentheses

## Pattern

Stack of unmatched opening delimiters.

## Invariant

After a prefix, the stack is exactly the unmatched openers in the order they must be closed, with the nearest opener on top.

## Code

isValid = finish . foldl step ([], True)

step (stack, valid) ch
  | isOpen ch = (ch : stack, valid)
  | otherwise = match ch against the stack top

## Complexity

Time: O(n). Space: O(n) in the all-openers case.

## Pitfall(s)

Handle early closing brackets and leftover openers. The imported version normalizes the source's token list to `String -> Bool`.
