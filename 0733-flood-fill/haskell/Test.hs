module Main where

import qualified Data.Set as S
import Solution (floodFill)
import TestUtil (Case(..), assertEqual, runCases)

main :: IO ()
main = runCases "0733-flood-fill" (fixedCases ++ generatedCases)

fixedCases :: [Case]
fixedCases =
  [ Case "example 1" (assertEqual [[2,2,2],[2,2,0],[2,0,1]] (floodFill [[1,1,1],[1,1,0],[1,0,1]] 1 1 2))
  , Case "same color" (assertEqual [[0,0,0],[0,0,0]] (floodFill [[0,0,0],[0,0,0]] 0 0 0))
  , Case "hard component" (assertEqual floodFillHardExpected (floodFill floodFillHardInput 0 0 9))
  , Case "diagonal trap" (assertEqual [[1,0,1],[0,9,0],[1,0,1]] (floodFill [[1,0,1],[0,1,0],[1,0,1]] 1 1 9))
  , Case "large wall efficiency" (assertEqual bigFloodExpected (floodFill bigFloodInput 0 0 9))
  ]

generatedCases :: [Case]
generatedCases =
  [ Case ("generated " ++ show rows ++ "x" ++ show cols ++ " seed " ++ show seed)
      (assertEqual (slowFloodFill image sr sc color) (floodFill image sr sc color))
  | rows <- [1 .. 5]
  , cols <- [1 .. 5]
  , seed <- [0 .. 4]
  , let image = generatedGrid rows cols seed
  , let sr = seed `mod` rows
  , let sc = (seed * 2 + rows) `mod` cols
  , let color = (seed + 3) `mod` 4
  ]

generatedGrid :: Int -> Int -> Int -> [[Int]]
generatedGrid rows cols seed =
  [ [ (r * 3 + c * 5 + seed) `mod` 3
    | c <- [0 .. cols - 1]
    ]
  | r <- [0 .. rows - 1]
  ]

slowFloodFill :: [[Int]] -> Int -> Int -> Int -> [[Int]]
slowFloodFill image sr sc color
  | original == color = image
  | otherwise =
      [ [ if (r, c) `S.member` component then color else image !! r !! c
        | c <- [0 .. cols - 1]
        ]
      | r <- [0 .. rows - 1]
      ]
  where
    rows = length image
    cols = length (head image)
    original = image !! sr !! sc
    component = dfs S.empty [(sr, sc)]

    dfs seen [] = seen
    dfs seen (p@(r, c):rest)
      | p `S.member` seen = dfs seen rest
      | image !! r !! c /= original = dfs seen rest
      | otherwise = dfs (S.insert p seen) (neighbors r c ++ rest)

    neighbors r c =
      [ (nr, nc)
      | (dr, dc) <- [(-1, 0), (0, 1), (1, 0), (0, -1)]
      , let nr = r + dr
      , let nc = c + dc
      , nr >= 0 && nr < rows && nc >= 0 && nc < cols
      ]

floodFillHardInput :: [[Int]]
floodFillHardInput =
  [ [1,1,1,2,2,2,1]
  , [1,2,1,2,1,2,1]
  , [1,1,1,2,1,1,1]
  , [2,2,1,2,2,2,1]
  , [1,1,1,1,1,2,1]
  , [1,2,2,2,1,1,1]
  ]

floodFillHardExpected :: [[Int]]
floodFillHardExpected =
  [ [9,9,9,2,2,2,9]
  , [9,2,9,2,9,2,9]
  , [9,9,9,2,9,9,9]
  , [2,2,9,2,2,2,9]
  , [9,9,9,9,9,2,9]
  , [9,2,2,2,9,9,9]
  ]

bigRows, bigCols, wallCol :: Int
bigRows = 300
bigCols = 301
wallCol = 150

bigFloodInput :: [[Int]]
bigFloodInput =
  [ [ if c == wallCol then 2 else 1
    | c <- [0 .. bigCols - 1]
    ]
  | _ <- [0 .. bigRows - 1]
  ]

bigFloodExpected :: [[Int]]
bigFloodExpected =
  [ [ expectedCell c
    | c <- [0 .. bigCols - 1]
    ]
  | _ <- [0 .. bigRows - 1]
  ]
  where
    expectedCell c
      | c < wallCol = 9
      | c == wallCol = 2
      | otherwise = 1

