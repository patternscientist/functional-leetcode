module Main where

import Solution (trap)
import TestUtil (Case(..), assertEqual, runCases)

main :: IO ()
main = runCases "0042-trapping-rain-water" (fixedCases ++ generatedCases)

fixedCases :: [Case]
fixedCases =
  [ check "example 1" [0,1,0,2,1,0,1,3,2,1,2,1]
  , check "example 2" [4,2,0,3,2,5]
  , check "empty" []
  , check "single" [4]
  , check "monotone up" [0,1,2,3,4]
  , check "monotone down" [4,3,2,1,0]
  , check "plateau basin" [3,0,0,3]
  ]

generatedCases :: [Case]
generatedCases =
  [ check ("generated " ++ show n) (generatedHeights n)
  | n <- [0 .. 80]
  ]

generatedHeights :: Int -> [Int]
generatedHeights n =
  take (n `mod` 25)
    [ (i * i + 5 * i + n) `mod` 9
    | i <- [0 ..]
    ]

check :: String -> [Int] -> Case
check name heights = Case name (assertEqual (slowTrap heights) (trap heights))

slowTrap :: [Int] -> Int
slowTrap heights =
  sum
    [ max 0 (min (maximum (take (i + 1) heights)) (maximum (drop i heights)) - heights !! i)
    | i <- [0 .. length heights - 1]
    ]

