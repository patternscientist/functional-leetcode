module Grid
  ( Point
  , inBounds
  , neighbors4
  ) where

type Point = (Int, Int)

inBounds :: Int -> Int -> Point -> Bool
inBounds rows cols (r, c) =
  r >= 0 && r < rows && c >= 0 && c < cols

neighbors4 :: Int -> Int -> Point -> [Point]
neighbors4 rows cols (r, c) =
  filter (inBounds rows cols)
    [ (r - 1, c)
    , (r + 1, c)
    , (r, c - 1)
    , (r, c + 1)
    ]

