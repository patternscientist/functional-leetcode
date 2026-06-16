module Main where

import Solution (searchRotated)
import TestUtil (Case(..), assertEqual, runCases)

main :: IO ()
main = runCases "0033-search-in-rotated-sorted-array" (fixedCases ++ generatedCases)

fixedCases :: [Case]
fixedCases =
  [ check "example found" [4,5,6,7,0,1,2] 0
  , check "example missing" [4,5,6,7,0,1,2] 3
  , check "hard first" hardInput 40
  , check "hard last" hardInput 30
  , check "hard pivot" hardInput 5
  , check "hard left middle" hardInput 80
  , check "hard missing" hardInput 55
  , check "empty" [] 1
  , check "single found" [1] 1
  , check "single missing" [1] 0
  ]

generatedCases :: [Case]
generatedCases =
  [ check ("generated n=" ++ show n ++ " k=" ++ show k ++ " target=" ++ show target) rotated target
  | n <- [0 .. 25]
  , let base = [i * 3 - 20 | i <- [0 .. n - 1]]
  , k <- if n == 0 then [0] else [0 .. n - 1]
  , let rotated = rotate k base
  , target <- take 5 base ++ [-100, 100, 1]
  ]

rotate :: Int -> [a] -> [a]
rotate _ [] = []
rotate k xs = drop k xs ++ take k xs

check :: String -> [Int] -> Int -> Case
check name nums target =
  Case name (assertEqual (linearSearch nums target) (searchRotated nums target))

linearSearch :: [Int] -> Int -> Int
linearSearch nums target =
  case [i | (i, x) <- zip [0 :: Int ..] nums, x == target] of
    i:_ -> i
    [] -> -1

hardInput :: [Int]
hardInput = [40,50,60,70,80,90,5,10,20,30]

