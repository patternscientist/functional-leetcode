module Main where

import Solution (Tree(..), isBalanced)
import TestUtil (Case(..), assertEqual, runCases)

main :: IO ()
main = runCases "0110-balanced-binary-tree" (fixedCases ++ generatedCases)

fixedCases :: [Case]
fixedCases =
  [ Case "balanced example" (assertEqual True (isBalanced balancedExample))
  , Case "unbalanced example" (assertEqual False (isBalanced unbalancedExample))
  , Case "empty" (assertEqual True (isBalanced Empty))
  , Case "single child leaf" (assertEqual True (isBalanced (Node 1 (Node 2 Empty Empty) Empty)))
  , Case "left chain three" (assertEqual False (isBalanced (Node 1 (Node 2 (Node 3 Empty Empty) Empty) Empty)))
  ]

generatedCases :: [Case]
generatedCases =
  [ Case ("generated " ++ show n) (assertEqual (slowBalanced tree) (isBalanced tree))
  | n <- [0 .. 35]
  , let tree = generatedTree n
  ]

balancedExample :: Tree Int
balancedExample =
  Node 3
    (Node 9 Empty Empty)
    (Node 20 (Node 15 Empty Empty) (Node 7 Empty Empty))

unbalancedExample :: Tree Int
unbalancedExample =
  Node 1
    (Node 2 (Node 3 (Node 4 Empty Empty) (Node 4 Empty Empty)) (Node 3 Empty Empty))
    (Node 2 Empty Empty)

slowBalanced :: Tree a -> Bool
slowBalanced Empty = True
slowBalanced (Node _ l r) =
  abs (height l - height r) <= 1 && slowBalanced l && slowBalanced r

height :: Tree a -> Int
height Empty = -1
height (Node _ l r) = 1 + max (height l) (height r)

generatedTree :: Int -> Tree Int
generatedTree n = build 0 n
  where
    build :: Int -> Int -> Tree Int
    build depth seed
      | depth > 5 = Empty
      | seed `mod` 7 == 0 = Empty
      | otherwise =
          Node seed
            (build (depth + 1) (seed * 2 + 1))
            (build (depth + 1) (seed * 3 + 2))
