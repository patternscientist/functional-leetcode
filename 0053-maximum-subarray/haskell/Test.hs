module Main where

import Solution (maxSubarray)
import TestUtil (Case(..), assertEqual, runCases)

main :: IO ()
main = runCases "0053-maximum-subarray" (fixedCases ++ generatedCases)

fixedCases :: [Case]
fixedCases =
  [ check "mixed example" [-2, 1, -3, 4, -1, 2, 1, -5, 4]
  , check "singleton positive" [1]
  , check "all positive with dip" [5, 4, -1, 7, 8]
  , check "singleton negative" [-1]
  , check "all negative pair" [-2, -1]
  , check "zero included" [-3, 0, -2]
  ]

generatedCases :: [Case]
generatedCases =
  [ check ("generated length " ++ show n) (generatedNums n)
  | n <- [1 .. 35]
  ]

generatedNums :: Int -> [Int]
generatedNums n =
  [ ((i * 11 + n * 5) `mod` 19) - 9
  | i <- [0 .. n - 1]
  ]

check :: String -> [Int] -> Case
check name nums =
  Case name (assertEqual (slowMaxSubarray nums) (maxSubarray nums))

slowMaxSubarray :: [Int] -> Int
slowMaxSubarray nums =
  maximum
    [ sum (take len (drop start nums))
    | start <- [0 .. length nums - 1]
    , len <- [1 .. length nums - start]
    ]

