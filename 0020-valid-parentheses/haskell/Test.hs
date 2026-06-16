module Main where

import Solution (isValid)
import TestUtil (Case(..), assertEqual, runCases)

main :: IO ()
main = runCases "0020-valid-parentheses" (fixedCases ++ generatedCases)

fixedCases :: [Case]
fixedCases =
  [ check "unit pair" "()"
  , check "three pairs" "()[]{}"
  , check "wrong close" "(]"
  , check "nested" "([])"
  , check "crossed" "([)]"
  , check "empty" ""
  , check "early close" ")("
  , check "leftover opens" "((("
  ]

generatedCases :: [Case]
generatedCases =
  [ check ("generated " ++ show n) (generatedString n)
  | n <- [0 .. 80]
  ]

generatedString :: Int -> String
generatedString n =
  take (n `mod` 10)
    [ alphabet !! ((i * 5 + i * i + n) `mod` length alphabet)
    | i <- [0 ..]
    ]
  where
    alphabet = "()[]{}"

check :: String -> String -> Case
check name s = Case name (assertEqual (slowValid s) (isValid s))

slowValid :: String -> Bool
slowValid s =
  case reducePairs s of
    "" -> True
    s'
      | s' == s -> False
      | otherwise -> slowValid s'

reducePairs :: String -> String
reducePairs ('(':')':xs) = reducePairs xs
reducePairs ('[':']':xs) = reducePairs xs
reducePairs ('{':'}':xs) = reducePairs xs
reducePairs (x:xs) = x : reducePairs xs
reducePairs [] = []

