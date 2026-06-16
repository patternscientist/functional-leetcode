module Solution (maxSubarray) where

-- Problem 53. Maximum Subarray
maxSubarray :: [Int] -> Int
maxSubarray = maximum . scanl1 step
    where step bestEndingHere x = max x (bestEndingHere+x)
