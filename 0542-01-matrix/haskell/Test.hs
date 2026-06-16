module Main where

import Solution (updateMatrix)
import TestUtil (Case(..), assertEqual, runCases)

main :: IO ()
main = runCases "0542-01-matrix" (fixedCases ++ generatedCases)

fixedCases :: [Case]
fixedCases =
  [ Case "example 1" (assertEqual [[0,0,0],[0,1,0],[0,0,0]] (updateMatrix [[0,0,0],[0,1,0],[0,0,0]]))
  , Case "example 2" (assertEqual [[0,0,0],[0,1,0],[1,2,1]] (updateMatrix [[0,0,0],[0,1,0],[1,1,1]]))
  , Case "hard matrix" (assertEqual matrix01HardExpected (updateMatrix matrix01HardInput))
  ]

generatedCases :: [Case]
generatedCases =
  [ Case ("generated " ++ show rows ++ "x" ++ show cols ++ " seed " ++ show seed)
      (assertEqual (slowUpdateMatrix mat) (updateMatrix mat))
  | rows <- [1 .. 6]
  , cols <- [1 .. 6]
  , seed <- [0 .. 4]
  , let mat = ensureZero (generatedMatrix rows cols seed)
  ]

generatedMatrix :: Int -> Int -> Int -> [[Int]]
generatedMatrix rows cols seed =
  [ [ if (r * 3 + c * 5 + seed) `mod` 4 == 0 then 0 else 1
    | c <- [0 .. cols - 1]
    ]
  | r <- [0 .. rows - 1]
  ]

ensureZero :: [[Int]] -> [[Int]]
ensureZero mat
  | any (any (== 0)) mat = mat
  | otherwise =
      case mat of
        [] -> []
        row:rows -> (0 : drop 1 row) : rows

slowUpdateMatrix :: [[Int]] -> [[Int]]
slowUpdateMatrix mat =
  [ [ if mat !! r !! c == 0 then 0 else nearestZero r c
    | c <- [0 .. cols - 1]
    ]
  | r <- [0 .. rows - 1]
  ]
  where
    rows = length mat
    cols = length (head mat)
    zeroes =
      [ (r, c)
      | r <- [0 .. rows - 1]
      , c <- [0 .. cols - 1]
      , mat !! r !! c == 0
      ]
    nearestZero r c =
      minimum [abs (r - zr) + abs (c - zc) | (zr, zc) <- zeroes]

matrix01HardInput :: [[Int]]
matrix01HardInput =
  [ [0,1,1,1,1,1,1,1,1,1,1,1,1,0]
  , [1,1,1,1,1,1,1,1,1,1,1,1,1,1]
  , [1,1,1,1,1,0,1,1,1,1,1,1,1,1]
  , [1,1,1,1,1,1,1,1,1,1,1,1,1,1]
  , [1,1,1,1,1,1,1,1,1,1,0,1,1,1]
  , [1,1,1,1,1,1,1,1,1,1,1,1,1,1]
  , [1,1,0,1,1,1,1,1,1,1,1,1,1,1]
  , [1,1,1,1,1,1,1,1,1,1,1,1,1,1]
  , [1,1,1,1,1,1,1,1,0,1,1,1,1,1]
  , [1,1,1,1,1,1,1,1,1,1,1,1,1,0]
  ]

matrix01HardExpected :: [[Int]]
matrix01HardExpected =
  [ [0,1,2,3,3,2,3,4,5,4,3,2,1,0]
  , [1,2,3,3,2,1,2,3,4,4,3,3,2,1]
  , [2,3,3,2,1,0,1,2,3,3,2,3,3,2]
  , [3,4,3,3,2,1,2,3,3,2,1,2,3,3]
  , [4,3,2,3,3,2,3,3,2,1,0,1,2,3]
  , [3,2,1,2,3,3,4,4,3,2,1,2,3,4]
  , [2,1,0,1,2,3,4,3,2,3,2,3,4,3]
  , [3,2,1,2,3,4,3,2,1,2,3,4,3,2]
  , [4,3,2,3,4,3,2,1,0,1,2,3,2,1]
  , [5,4,3,4,5,4,3,2,1,2,3,2,1,0]
  ]

