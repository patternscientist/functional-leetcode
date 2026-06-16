module Main where

import Solution (productExceptSelf)
import TestUtil (Case(..), assertEqual, runCases)

main :: IO ()
main = runCases "0238-product-of-array-except-self" (fixedCases ++ generatedCases)

fixedCases :: [Case]
fixedCases =
  [ check "example positive" [1, 2, 3, 4]
  , check "example with zero" [-1, 1, 0, -3, 3]
  , check "singleton" [5]
  , check "two zeros" [0, 0]
  , check "one middle zero" [2, 3, 0, 4]
  , check "empty local policy" []
  ]

generatedCases :: [Case]
generatedCases =
  [ check ("generated length " ++ show n) (generatedNums n)
  | n <- [0 .. 30]
  ]

generatedNums :: Int -> [Int]
generatedNums n =
  [ ((i * 7 + n) `mod` 5) - 2
  | i <- [0 .. n - 1]
  ]

check :: String -> [Int] -> Case
check name nums =
  Case name (assertEqual (slowProductExceptSelf nums) (productExceptSelf nums))

slowProductExceptSelf :: [Int] -> [Int]
slowProductExceptSelf nums =
  [ product [x | (j, x) <- zip [0 :: Int ..] nums, j /= i]
  | i <- [0 .. length nums - 1]
  ]

