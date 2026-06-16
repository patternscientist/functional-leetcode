module Main where

import Solution (twoSum)
import TestUtil (Case(..), assertBool, runCases)

main :: IO ()
main = runCases "0001-two-sum" (fixedCases ++ generatedCases)

fixedCases :: [Case]
fixedCases =
  [ check "example 1" [2, 7, 11, 15] 9
  , check "middle pair" [3, 2, 4] 6
  , check "duplicate values" [3, 3] 6
  , check "negative complement" [-10, 4, 7, 11] 1
  ]

generatedCases :: [Case]
generatedCases =
  [ check ("generated n=" ++ show n) (generatedInput n) (targetFor n)
  | n <- [2 :: Int .. 40]
  ]

generatedInput :: Int -> [Int]
generatedInput n =
  [ if i == n - 2 then 1000 + n
    else if i == n - 1 then 2000 - n
    else 10 * n + i
  | i <- [0 .. n - 1]
  ]

targetFor :: Int -> Int
targetFor n = (1000 + n) + (2000 - n)

check :: String -> [Int] -> Int -> Case
check name nums target =
  Case name $
    assertBool message (validPair nums target got && got == expected)
  where
    got = twoSum nums target
    expected = slowTwoSum nums target
    message =
      "Input\nnums = " ++ show nums ++ "\n" ++
      "target = " ++ show target ++ "\n\n" ++
      "Output\n" ++ show got ++ "\n\n" ++
      "Expected\n" ++ show expected

validPair :: [Int] -> Int -> (Int, Int) -> Bool
validPair nums target (i, j) =
  i >= 0 &&
  j >= 0 &&
  i < length nums &&
  j < length nums &&
  i /= j &&
  nums !! i + nums !! j == target

slowTwoSum :: [Int] -> Int -> (Int, Int)
slowTwoSum nums target =
  case [ (i, j)
       | i <- [0 .. length nums - 1]
       , j <- [i + 1 .. length nums - 1]
       , nums !! i + nums !! j == target
       ] of
    pair:_ -> pair
    [] -> error "slowTwoSum: expected exactly one solution"
