# 704. Binary Search

## Pattern

Closed-interval binary search.

## Invariant

If the target exists, it is inside the current inclusive interval `[l, r]`; outside the interval has been ruled out.

## Code

step l r
  | l <= r = compare target with nums[mid] and keep the half that can still contain it
  | otherwise = -1

## Complexity

Time: O(log n). Space: O(n) here for array conversion, O(1) with native random-access input.

## Pitfall(s)

Move past `mid` on recursive calls. Empty input starts with `l = 0, r = -1` and returns -1 without indexing.
