module Main where

import Solution (maxProfit)
import TestUtil (Case(..), assertEqual, runCases)

main :: IO ()
main = runCases "0121-best-time-to-buy-and-sell-stock" (fixedCases ++ generatedCases)

fixedCases :: [Case]
fixedCases =
  [ check "example profit" [7, 1, 5, 3, 6, 4]
  , check "example no profit" [7, 6, 4, 3, 1]
  , check "single day" [5]
  , check "empty local policy" []
  , check "buy first sell last" [1, 2]
  , check "late low price" [2, 4, 1]
  ]

generatedCases :: [Case]
generatedCases =
  [ check ("generated length " ++ show n) (generatedPrices n)
  | n <- [1 .. 30]
  ]

generatedPrices :: Int -> [Int]
generatedPrices n =
  [ ((i * i + 7 * i + 3 * n) `mod` 23) + 1
  | i <- [0 .. n - 1]
  ]

check :: String -> [Int] -> Case
check name prices =
  Case name (assertEqual (slowMaxProfit prices) (maxProfit prices))

slowMaxProfit :: [Int] -> Int
slowMaxProfit prices =
  maximum $
    0 :
    [ prices !! sell - prices !! buy
    | buy <- [0 .. length prices - 1]
    , sell <- [buy + 1 .. length prices - 1]
    ]

