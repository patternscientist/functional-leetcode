module Solution (maxProfit) where

import Data.List (foldl')

-- Problem 121. Best Time to Buy and Sell Stock
maxProfit :: [Int] -> Int
maxProfit = snd . foldl' step (maxBound,0)
    where step (bottom,best) x =
            let bottom' = min bottom x
                best'   = max best (x - bottom')
            in
                (bottom',best')
