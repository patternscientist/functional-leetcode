module Solution (maxProfit) where

import Data.List (foldl')

-- LeetCode uses a nonempty list, but this implementation returns 0 for [].
maxProfit :: [Int] -> Int
maxProfit = snd . foldl' step (maxBound, 0)
  where
    step (bottom, best) x =
      let bottom' = min bottom x
          best' = max best (x - bottom')
      in (bottom', best')

