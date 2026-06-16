module Main where

import Solution (Tree(..), diameterOfBinaryTree)
import TestUtil (Case(..), assertEqual, runCases)

main :: IO ()
main = runCases "0543-diameter-of-binary-tree" (fixedCases ++ generatedCases)

fixedCases :: [Case]
fixedCases =
  [ Case "example 1" (assertEqual 3 (diameterOfBinaryTree tree1))
  , Case "example 2" (assertEqual 1 (diameterOfBinaryTree tree2))
  , Case "hard tree" (assertEqual 8 (diameterOfBinaryTree tree3))
  , Case "empty local policy" (assertEqual (-1) (diameterOfBinaryTree (Empty :: Tree Int)))
  ]

generatedCases :: [Case]
generatedCases =
  [ Case ("generated " ++ show n) (assertEqual (slowDiameter tree) (diameterOfBinaryTree tree))
  | n <- [0 .. 35]
  , let tree = generatedTree n
  ]

tree1 :: Tree Int
tree1 = Node 1 (Node 2 (Node 4 Empty Empty) (Node 5 Empty Empty)) (Node 3 Empty Empty)

tree2 :: Tree Int
tree2 = Node 1 (Node 2 Empty Empty) Empty

tree3 :: Tree Int
tree3 =
  Node 1
    (Node 2
      (Node 4 (Node 6 (Node 8 (Node 10 Empty Empty) Empty) Empty) Empty)
      (Node 5 Empty (Node 7 Empty (Node 9 Empty (Node 11 Empty Empty)))))
    (Node 3 Empty Empty)

height :: Tree a -> Int
height Empty = -1
height (Node _ l r) = 1 + max (height l) (height r)

slowDiameter :: Tree a -> Int
slowDiameter Empty = -1
slowDiameter (Node _ l r) =
  maximum [height l + height r + 2, slowDiameter l, slowDiameter r]

generatedTree :: Int -> Tree Int
generatedTree n = build 0 n
  where
    build :: Int -> Int -> Tree Int
    build depth seed
      | depth > 5 = Empty
      | seed `mod` 6 == 0 = Empty
      | otherwise =
          Node seed
            (build (depth + 1) (seed * 2 + 1))
            (build (depth + 1) (seed * 3 + 2))
