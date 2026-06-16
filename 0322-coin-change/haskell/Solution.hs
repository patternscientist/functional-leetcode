module Solution (coinChange) where

import qualified Data.Array as A

-- LeetCode coins are positive. Zero or negative denominations are outside this
-- implementation's accepted input policy.
dp :: [Int] -> Int -> Int
dp coins amount = a A.! amount
  where
    inf = amount + 1
    a = tabulate f (0, amount)
    tabulate g bounds = A.array bounds [(x, g x) | x <- A.range bounds]
    f n =
      if n == 0
        then 0
        else
          let candidates =
                [ 1 + (a A.! (n - coin))
                | coin <- coins
                , n - coin >= 0
                ]
          in if null candidates then inf else minimum candidates

coinChange :: [Int] -> Int -> Int
coinChange coins amount =
  if possibleAns >= amount + 1 then -1 else possibleAns
  where
    possibleAns = dp coins amount

