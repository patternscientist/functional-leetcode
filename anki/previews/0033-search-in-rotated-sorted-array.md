# 33. Search in Rotated Sorted Array

## Pattern

Binary search with sorted-side detection.

## Invariant

At each step, at least one side of the interval is sorted; use that side's bounds to decide whether the target can live there.

## Code

if nums[l] <= nums[mid]
  then left side is sorted
  else right side is sorted

Discard the sorted side only when target is outside its bounds.

## Complexity

Time: O(log n). Space: O(n) here for array conversion, O(1) with native random-access input.

## Pitfall(s)

Use strict/exclusive bounds around `mid` correctly. Generated tests over all rotations are excellent at catching off-by-one errors.
