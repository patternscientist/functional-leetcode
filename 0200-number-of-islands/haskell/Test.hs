module Main where

import qualified Data.Set as S
import Solution (numIslands)
import TestUtil (Case(..), assertEqual, runCases)

main :: IO ()
main = runCases "0200-number-of-islands" (fixedCases ++ generatedCases)

fixedCases :: [Case]
fixedCases =
  [ Case "example one island" (assertEqual 1 (numIslands numIslandsTest1Grid))
  , Case "example three islands" (assertEqual 3 (numIslands numIslandsTest2Grid))
  , Case "hard grid" (assertEqual 10 (numIslands numIslandsHardInput))
  , Case "all water" (assertEqual 0 (numIslands ["000", "000"]))
  , Case "all land" (assertEqual 1 (numIslands ["111", "111"]))
  ]

generatedCases :: [Case]
generatedCases =
  [ Case ("generated " ++ show rows ++ "x" ++ show cols ++ " seed " ++ show seed)
      (assertEqual (slowNumIslands grid) (numIslands grid))
  | rows <- [1 .. 6]
  , cols <- [1 .. 6]
  , seed <- [0 .. 4]
  , let grid = generatedGrid rows cols seed
  ]

generatedGrid :: Int -> Int -> Int -> [[Char]]
generatedGrid rows cols seed =
  [ [ if (r * 3 + c * 5 + seed) `mod` 4 == 0 then '1' else '0'
    | c <- [0 .. cols - 1]
    ]
  | r <- [0 .. rows - 1]
  ]

slowNumIslands :: [[Char]] -> Int
slowNumIslands grid = go S.empty allCells 0
  where
    rows = length grid
    cols = length (head grid)
    allCells = [(r, c) | r <- [0 .. rows - 1], c <- [0 .. cols - 1]]

    go _ [] count = count
    go seen (p:rest) count
      | p `S.member` seen = go seen rest count
      | cell p /= '1' = go (S.insert p seen) rest count
      | otherwise =
          let component = dfs S.empty [p]
          in go (seen `S.union` component) rest (count + 1)

    dfs seen [] = seen
    dfs seen (p:rest)
      | p `S.member` seen = dfs seen rest
      | cell p /= '1' = dfs (S.insert p seen) rest
      | otherwise = dfs (S.insert p seen) (neighbors p ++ rest)

    cell (r, c) = grid !! r !! c

    neighbors (r, c) =
      [ (nr, nc)
      | (dr, dc) <- [(-1, 0), (0, 1), (1, 0), (0, -1)]
      , let nr = r + dr
      , let nc = c + dc
      , nr >= 0 && nr < rows && nc >= 0 && nc < cols
      ]

numIslandsTest1Grid :: [[Char]]
numIslandsTest1Grid =
  [ "11110"
  , "11010"
  , "11000"
  , "00000"
  ]

numIslandsTest2Grid :: [[Char]]
numIslandsTest2Grid =
  [ "11000"
  , "11000"
  , "00100"
  , "00011"
  ]

numIslandsHardInput :: [[Char]]
numIslandsHardInput =
  [ "11000100111000010011"
  , "11010100101011010001"
  , "00010100101001011101"
  , "11110000001101000101"
  , "00100111100101011101"
  , "00100000100100000100"
  , "11101110111101110111"
  , "10001000100001000101"
  , "10111011101111011101"
  , "10000010000000010001"
  , "11111010111111011111"
  , "00001010000001000000"
  ]

