module Main where

import qualified Data.List as L
import Solution (binarySearch)
import TestUtil (Case(..), assertEqual, runCases)

main :: IO ()
main = runCases "0704-binary-search" (fixedCases ++ generatedCases)

fixedCases :: [Case]
fixedCases =
  [ check "example found" [-1,0,3,5,9,12] 9
  , check "example missing" [-1,0,3,5,9,12] 2
  , check "first" hardInput (-100)
  , check "last" hardInput 144
  , check "middle" hardInput 9
  , check "missing between" hardInput 8
  , check "missing below" hardInput (-101)
  , check "missing above" hardInput 145
  , check "empty" [] 1
  , check "single found" [3] 3
  , check "single missing" [3] 2
  , Case "big found" (assertEqual 999999 (binarySearch [0,2 .. 2000000] 1999998))
  , Case "big missing" (assertEqual (-1) (binarySearch [0,2 .. 2000000] 1999999))
  ]

generatedCases :: [Case]
generatedCases =
  [ check ("generated size " ++ show n ++ " target " ++ show target) nums target
  | n <- [0 .. 40]
  , let nums = generatedNums n
  , target <- [minimumDefault 0 nums - 1, 0, n, maximumDefault 0 nums + 1] ++ take 4 nums
  ]

generatedNums :: Int -> [Int]
generatedNums n = L.nub (L.sort [((i * 7 + n * 3) `mod` 97) - 40 | i <- [0 .. n - 1]])

check :: String -> [Int] -> Int -> Case
check name nums target =
  Case name (assertEqual (linearSearch nums target) (binarySearch nums target))

linearSearch :: [Int] -> Int -> Int
linearSearch nums target =
  case [i | (i, x) <- zip [0 :: Int ..] nums, x == target] of
    i:_ -> i
    [] -> -1

minimumDefault :: Int -> [Int] -> Int
minimumDefault d [] = d
minimumDefault _ xs = minimum xs

maximumDefault :: Int -> [Int] -> Int
maximumDefault d [] = d
maximumDefault _ xs = maximum xs

hardInput :: [Int]
hardInput = [-100,-50,-10,-3,0,4,9,15,21,34,55,89,144]

