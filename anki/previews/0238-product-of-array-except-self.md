# 238. Product of Array Except Self

## Pattern

Prefix and suffix scans over multiplication, then pointwise combine.

## Invariant

At index i, the answer is product(elements before i) times product(elements after i). No division is needed, so zeros are handled naturally.

## Code

productExceptSelf =
  zipWith (*) <$> (init . scanl (*) 1) <*> (drop 1 . scanr (*) 1)

## Complexity

Time: O(n). Space: O(n) for prefix/suffix scan lists.

## Pitfall(s)

Use `drop 1` on the suffix scan rather than dividing by nums[i]; division fails on zeros and is outside the intended pattern.
