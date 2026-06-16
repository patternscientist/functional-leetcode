# 1. Two Sum

## Pattern

Hash map of previously seen values, queried by complement before inserting the current value.

## Invariant

Before index i, the map contains exactly the values from indices 0..i-1, so a successful complement lookup always uses an earlier, different element.

## Code

twoSum nums target = go M.empty 0 nums
  where
    go seen i (x:xs) =
      case M.lookup (target - x) seen of
        Just j -> (j, i)
        Nothing -> go (M.insert x i seen) (i + 1) xs

## Complexity

Time: O(n log n) with Data.Map.Strict. Space: O(n). A hash-map implementation would target average O(n).

## Pitfall(s)

Check the complement before inserting the current value; otherwise target = 2*x can match the same element with itself.
