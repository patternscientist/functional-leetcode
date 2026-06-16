module Solution (searchRotated) where

import qualified Data.Array as A

searchRotated :: [Int] -> Int -> Int
searchRotated nums target = step 0 (n - 1)
  where
    step l r
      | l <= r =
          let mid = (l + r) `div` 2
              numsMid = numsArr A.! mid
              numsL = numsArr A.! l
              numsR = numsArr A.! r
          in if numsMid == target
               then mid
               else
                 if numsL <= numsMid
                   then
                     if numsL <= target && target < numsMid
                       then step l (mid - 1)
                       else step (mid + 1) r
                   else
                     if numsMid < target && target <= numsR
                       then step (mid + 1) r
                       else step l (mid - 1)
      | otherwise = -1

    numsArr = A.listArray (0, n - 1) nums
    n = length nums

