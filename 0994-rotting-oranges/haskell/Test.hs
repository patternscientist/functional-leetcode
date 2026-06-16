module Main where

import Solution (orangesRotting)
import TestUtil (Case(..), assertEqual, runCases)

main :: IO ()
main = runCases "0994-rotting-oranges" (fixedCases ++ generatedCases)

fixedCases :: [Case]
fixedCases =
  [ Case "example 1" (assertEqual 4 (orangesRotting [[2,1,1],[1,1,0],[0,1,1]]))
  , Case "example impossible" (assertEqual (-1) (orangesRotting [[2,1,1],[0,1,1],[1,0,1]]))
  , Case "no fresh" (assertEqual 0 (orangesRotting [[0,2]]))
  , Case "hard grid" (assertEqual 24 (orangesRotting rottingOrangesHardInput))
  ]

generatedCases :: [Case]
generatedCases =
  [ Case ("generated " ++ show rows ++ "x" ++ show cols ++ " seed " ++ show seed)
      (assertEqual (slowRotting grid) (orangesRotting grid))
  | rows <- [1 .. 5]
  , cols <- [1 .. 5]
  , seed <- [0 .. 5]
  , let grid = generatedGrid rows cols seed
  ]

generatedGrid :: Int -> Int -> Int -> [[Int]]
generatedGrid rows cols seed =
  [ [ (r * 2 + c * 3 + seed) `mod` 3
    | c <- [0 .. cols - 1]
    ]
  | r <- [0 .. rows - 1]
  ]

slowRotting :: [[Int]] -> Int
slowRotting grid = go 0 grid
  where
    rows = length grid
    cols = length (head grid)

    go minutes current
      | noFresh current = minutes
      | null newlyRotten = -1
      | otherwise = go (minutes + 1) (apply current newlyRotten)
      where
        newlyRotten =
          [ (r, c)
          | r <- [0 .. rows - 1]
          , c <- [0 .. cols - 1]
          , current !! r !! c == 1
          , any (\(nr, nc) -> current !! nr !! nc == 2) (neighbors r c)
          ]

    noFresh = all (all (/= 1))

    apply current rotten =
      [ [ if (r, c) `elem` rotten then 2 else current !! r !! c
        | c <- [0 .. cols - 1]
        ]
      | r <- [0 .. rows - 1]
      ]

    neighbors r c =
      [ (nr, nc)
      | (dr, dc) <- [(-1, 0), (0, 1), (1, 0), (0, -1)]
      , let nr = r + dr
      , let nc = c + dc
      , nr >= 0 && nr < rows && nc >= 0 && nc < cols
      ]

rottingOrangesHardInput :: [[Int]]
rottingOrangesHardInput =
  [ [2,1,1,0,1,1,1,1,0,1,1,2]
  , [0,0,1,0,1,0,0,1,0,1,0,1]
  , [1,1,1,1,1,1,0,1,1,1,0,1]
  , [1,0,0,0,0,1,0,0,0,1,0,1]
  , [1,1,1,1,0,1,1,1,1,1,1,1]
  , [0,0,0,1,0,0,0,0,0,0,1,0]
  , [1,1,1,1,1,1,1,1,1,0,1,1]
  , [1,0,0,0,0,0,0,0,1,0,0,1]
  , [1,1,1,1,1,1,1,0,1,1,1,1]
  ]

