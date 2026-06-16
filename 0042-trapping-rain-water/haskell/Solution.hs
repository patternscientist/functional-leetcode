module Solution (trap) where

import qualified Data.Array as A

trap :: [Int] -> Int
trap height = step left0 right0 leftMax0 rightMax0 0
  where
    step l r leftMax rightMax amount
      | l >= r = amount
      | leftMax' <= rightMax' =
          step (l + 1) r leftMax' rightMax' (amount + leftMax' - heightArr A.! l)
      | otherwise =
          step l (r - 1) leftMax' rightMax' (amount + rightMax' - heightArr A.! r)
      where
        leftMax' = max leftMax (heightArr A.! l)
        rightMax' = max rightMax (heightArr A.! r)

    heightArr = A.listArray (0, n - 1) height
    n = length height
    left0 = 0
    right0 = n - 1
    leftMax0 = 0
    rightMax0 = 0

