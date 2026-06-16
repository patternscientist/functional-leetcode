# 42. Trapping Rain Water

## Pattern

Two-pointer refinement of the prefix/suffix maxima specification.

## Invariant

The side with the smaller current max has its trapped water determined; the opposite side already supplies a high enough boundary.

## Code

step l r leftMax rightMax amount
  | leftMax' <= rightMax' = consume left
  | otherwise = consume right

## Complexity

Time: O(n). Space: O(n) here for array indexing; O(1) extra with direct indexing in an imperative setting.

## Pitfall(s)

The scan specification is simpler for testing. The two-pointer solution depends on consuming the side with the lower boundary.
