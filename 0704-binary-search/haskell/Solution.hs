module Solution (binarySearch) where

import qualified Data.Array as A

binarySearch :: [Int] -> Int -> Int
binarySearch nums target = step 0 (n - 1)
  where
    step l r
      | l <= r =
          let mid = (l + r) `div` 2
              num = numsArr A.! mid
          in if num == target
               then mid
               else if num < target then step (mid + 1) r else step l (mid - 1)
      | otherwise = -1

    numsArr = A.listArray (0, n - 1) nums
    n = length nums

