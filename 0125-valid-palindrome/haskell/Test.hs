module Main where

import qualified Data.Char as C
import Solution (isPalindrome)
import TestUtil (Case(..), assertEqual, runCases)

main :: IO ()
main = runCases "0125-valid-palindrome" (fixedCases ++ generatedCases)

fixedCases :: [Case]
fixedCases =
  [ check "example true" "A man, a plan, a canal: Panama"
  , check "example false" "race a car"
  , check "nixon" "No 'x' in Nixon"
  , check "car cat" "Was it a car or a cat I saw?"
  , check "madam adam" "Madam, I'm Adam."
  , check "underscore skipped" "ab_a"
  , check "digits and case" "1a2@2A1"
  , check "digit mismatch" "1a2@3A1"
  , check "0P" "0P"
  , check "no alphanumeric" ".,;:!? _-"
  , check "empty" ""
  ]

generatedCases :: [Case]
generatedCases =
  [ check ("generated " ++ show n) (generatedString n)
  | n <- [0 .. 80]
  ]

generatedString :: Int -> String
generatedString n =
  take (n `mod` 24)
    [ alphabet !! ((i * i + 7 * i + n) `mod` length alphabet)
    | i <- [0 ..]
    ]
  where
    alphabet = "aAbB019!? _-"

check :: String -> String -> Case
check name s = Case name (assertEqual (slowPalindrome s) (isPalindrome s))

slowPalindrome :: String -> Bool
slowPalindrome s = normalized == reverse normalized
  where
    normalized = map C.toLower (filter C.isAlphaNum s)

