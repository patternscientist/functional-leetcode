module Solution (threeSum) where

import qualified Data.Array as A
import qualified Data.List as L

threeSum :: [Int] -> [[Int]]
threeSum nums = step 0 []
  where
    step i candidates
      | i >= len || sortedArr A.! i > 0 = candidates
      | i > 0 && sortedArr A.! i == sortedArr A.! (i - 1) = step (i + 1) candidates
      | otherwise =
          let l = i + 1
              r = len - 1
          in step (i + 1) (localStep l r candidates)
      where
        localStep l r candidates'
          | l >= r = candidates'
          | total == 0 =
              localStep
                (updateLeft r (l + 1))
                (updateRight l (r - 1))
                ([sortedI, sortedL, sortedR] : candidates')
          | total < 0 = localStep (l + 1) r candidates'
          | otherwise = localStep l (r - 1) candidates'
          where
            sortedI = sortedArr A.! i
            sortedL = sortedArr A.! l
            sortedR = sortedArr A.! r
            total = sortedI + sortedL + sortedR

    updateLeft r l
      | l < r && sortedArr A.! l == sortedArr A.! (l - 1) = updateLeft r (l + 1)
      | otherwise = l

    updateRight l r
      | l < r && sortedArr A.! r == sortedArr A.! (r + 1) = updateRight l (r - 1)
      | otherwise = r

    sortedArr = A.listArray (0, len - 1) numsSorted
    numsSorted = L.sort nums
    len = length nums

