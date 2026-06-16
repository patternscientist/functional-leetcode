module Main where

import Solution (Tree(..), invertTree)
import TestUtil (Case(..), assertEqual, runCases)

main :: IO ()
main = runCases "0226-invert-binary-tree" (fixedCases ++ generatedCases)

fixedCases :: [Case]
fixedCases =
  [ Case "example full tree" (assertEqual inverted1 (invertTree original1))
  , Case "example three nodes" (assertEqual inverted2 (invertTree original2))
  , Case "empty" (assertEqual (Empty :: Tree Int) (invertTree Empty))
  ]

generatedCases :: [Case]
generatedCases =
  [ Case ("generated involution " ++ show n) (assertEqual tree (invertTree (invertTree tree)))
  | n <- [0 .. 40]
  , let tree = generatedTree n
  ]

original1 :: Tree Int
original1 =
  Node 4
    (Node 2 (Node 1 Empty Empty) (Node 3 Empty Empty))
    (Node 7 (Node 6 Empty Empty) (Node 9 Empty Empty))

inverted1 :: Tree Int
inverted1 =
  Node 4
    (Node 7 (Node 9 Empty Empty) (Node 6 Empty Empty))
    (Node 2 (Node 3 Empty Empty) (Node 1 Empty Empty))

original2 :: Tree Int
original2 = Node 2 (Node 1 Empty Empty) (Node 3 Empty Empty)

inverted2 :: Tree Int
inverted2 = Node 2 (Node 3 Empty Empty) (Node 1 Empty Empty)

generatedTree :: Int -> Tree Int
generatedTree n = build 0 n
  where
    build :: Int -> Int -> Tree Int
    build depth seed
      | depth > 4 = Empty
      | seed `mod` 5 == 0 = Empty
      | otherwise =
          Node seed
            (build (depth + 1) (seed * 2 + 1))
            (build (depth + 1) (seed * 3 + 2))
