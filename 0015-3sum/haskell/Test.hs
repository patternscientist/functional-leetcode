module Main where

import qualified Data.List as L
import Solution (threeSum)
import TestUtil (Case(..), assertEqual, runCases)

main :: IO ()
main = runCases "0015-3sum" (fixedCases ++ generatedCases)

fixedCases :: [Case]
fixedCases =
  [ check "example 1" [-1, 0, 1, 2, -1, -4]
  , check "example none" [0, 1, 1]
  , check "example zero triple" [0, 0, 0]
  , Case "hard duplicates 1" (assertEqual (canonicalTriples threeSumHardExpected1) (canonicalTriples (threeSum threeSumHardInput1)))
  , Case "hard range" (assertEqual (canonicalTriples threeSumHardExpected2) (canonicalTriples (threeSum threeSumHardInput2)))
  , check "all zero many" [0, 0, 0, 0, 0]
  , check "duplicate pair" [-2, 0, 0, 2, 2]
  , check "all positive" [1, 2, 3, 4, 5]
  , check "empty" []
  , check "too short" [0, 0]
  ]

generatedCases :: [Case]
generatedCases =
  [ check ("generated " ++ show n) (generatedNums n)
  | n <- [0 .. 60]
  ]

generatedNums :: Int -> [Int]
generatedNums n =
  take (n `mod` 10)
    [ ((i * i + 3 * i + n) `mod` 13) - 6
    | i <- [0 ..]
    ]

check :: String -> [Int] -> Case
check name nums =
  Case name (assertEqual (slowThreeSum nums) (canonicalTriples (threeSum nums)))

slowThreeSum :: [Int] -> [[Int]]
slowThreeSum nums =
  canonicalTriples
    [ L.sort [nums !! i, nums !! j, nums !! k]
    | i <- [0 .. length nums - 1]
    , j <- [i + 1 .. length nums - 1]
    , k <- [j + 1 .. length nums - 1]
    , nums !! i + nums !! j + nums !! k == 0
    ]

canonicalTriples :: [[Int]] -> [[Int]]
canonicalTriples = L.sort . L.nub . map L.sort

threeSumHardInput1 :: [Int]
threeSumHardInput1 =
  [-4,-2,-2,-2,0,1,2,2,2,3,3,4,4,6,6]

threeSumHardExpected1 :: [[Int]]
threeSumHardExpected1 =
  [ [-4,-2,6]
  , [-4,0,4]
  , [-4,1,3]
  , [-4,2,2]
  , [-2,-2,4]
  , [-2,0,2]
  ]

threeSumHardInput2 :: [Int]
threeSumHardInput2 =
  [-5,-4,-3,-2,-1,0,1,2,3,4,5]

threeSumHardExpected2 :: [[Int]]
threeSumHardExpected2 =
  [ [-5,0,5]
  , [-5,1,4]
  , [-5,2,3]
  , [-4,-1,5]
  , [-4,0,4]
  , [-4,1,3]
  , [-3,-2,5]
  , [-3,-1,4]
  , [-3,0,3]
  , [-3,1,2]
  , [-2,-1,3]
  , [-2,0,2]
  , [-1,0,1]
  ]

