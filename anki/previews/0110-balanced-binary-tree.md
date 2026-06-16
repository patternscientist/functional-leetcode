# 110. Balanced Binary Tree

## Pattern

Bottom-up height fold with `Nothing` as early failure.

## Invariant

`Just h` means the subtree is balanced and has height h; `Nothing` means some descendant already violates the balance condition.

## Code

heightOrFail Empty = Just (-1)
heightOrFail (Node _ l r) = do
  lh <- heightOrFail l
  rh <- heightOrFail r
  if abs (lh - rh) > 1 then Nothing else Just (1 + max lh rh)

## Complexity

Time: O(n). Space: O(h) call stack.

## Pitfall(s)

Do not use `Nothing` for an empty child. Empty is a successful balanced subtree; `Nothing` is reserved for failure.
