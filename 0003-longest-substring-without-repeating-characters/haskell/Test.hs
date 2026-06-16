module Main where

import Data.List (nub)
import Solution (lengthOfLongestSubstring)
import TestUtil (Case(..), assertEqual, runCases)

main :: IO ()
main = runCases "0003-longest-substring-without-repeating-characters" (fixedCases ++ generatedCases)

fixedCases :: [Case]
fixedCases =
  [ check "example abcabcbb" "abcabcbb"
  , check "example bbbbb" "bbbbb"
  , check "example pwwkew" "pwwkew"
  , check "empty" ""
  , check "abba boundary" "abba"
  , check "dvdf repeat before window" "dvdf"
  , check "symbols count as chars" "a!a"
  ]

generatedCases :: [Case]
generatedCases =
  [ check ("generated " ++ show n) (generatedString n)
  | n <- [0 .. 60]
  ]

generatedString :: Int -> String
generatedString n =
  take (n `mod` 18)
    [ alphabet !! ((i * i + 3 * i + n) `mod` length alphabet)
    | i <- [0 ..]
    ]
  where
    alphabet = "abcXYZ!?"

check :: String -> String -> Case
check name input =
  Case name (assertEqual (slowLongest input) (lengthOfLongestSubstring input))

slowLongest :: String -> Int
slowLongest input =
  maximum $
    0 :
    [ length candidate
    | start <- [0 .. length input - 1]
    , len <- [1 .. length input - start]
    , let candidate = take len (drop start input)
    , allUnique candidate
    ]

allUnique :: String -> Bool
allUnique xs = length xs == length (nub xs)

