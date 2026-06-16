module Solution (searchRotated) where

import qualified Data.Array as A

-- Problem 33. Search in Rotated Sorted Array
searchRotated :: [Int] -> Int -> Int
searchRotated nums target = step l0 r0
    where step = \l r ->
            if l <= r
            then let
                    mid = (l+r) `div` 2
                    nums_mid = numsArr A.! mid
                    nums_l  = numsArr A.! l
                    nums_r  = numsArr A.! r
                in
                    if nums_mid == target
                    then mid
                    else if nums_l <= nums_mid
                            then if nums_l <= target && target < nums_mid
                                 then step l (mid-1)
                                 else step (mid+1) r
                            else if nums_mid < target && target <= nums_r
                                then step (mid+1) r
                                else step l (mid-1)
            else -1
          l0 = 0
          r0 = n-1
          numsArr = A.listArray (0,n-1) nums
          n = length nums
