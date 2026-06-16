module Solution (maxSubarray) where

maxSubarray :: [Int] -> Int
maxSubarray = maximum . scanl1 step
    where step bestEndingHere x = max x (bestEndingHere+x)
