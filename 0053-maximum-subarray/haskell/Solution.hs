module Solution (maxSubarray) where

-- LeetCode uses a nonempty list; [] is intentionally outside this function's
-- accepted input policy.
maxSubarray :: [Int] -> Int
maxSubarray = maximum . scanl1 step
  where
    step bestEndingHere x = max x (bestEndingHere + x)

