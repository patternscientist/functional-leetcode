module Solution (binarySearch) where

import qualified Data.Array as A

-- Problem 704. Binary Search
binarySearch :: [Int] -> Int -> Int
binarySearch nums target = step l0 r0
    where step = \l r ->
            if l <= r
            then let
                    mid = (l+r) `div` 2
                    num = numsArr A.! mid
                 in
                    if num == target
                    then mid
                    else if num < target
                         then step (mid+1) r
                         else step l (mid-1)
            else -1
          l0 = 0
          r0 = n-1
          numsArr = A.listArray (0,n-1) nums
          n = length nums
