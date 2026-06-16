module Main where

import qualified Data.Set as S
import Solution (coinChange)
import TestUtil (Case(..), assertEqual, runCases)

main :: IO ()
main = runCases "0322-coin-change" (fixedCases ++ generatedCases)

fixedCases :: [Case]
fixedCases =
  [ check "example 1" [1, 2, 5] 11
  , check "example impossible" [2] 3
  , check "zero amount" [1] 0
  , check "non-greedy small" [1, 3, 4] 6
  , Case "large canonical currency" (assertEqual 5 (coinChange [1, 2, 5, 10, 20, 50, 100, 200] 1000))
  , Case "large unreachable-ish mix" (assertEqual 9 (coinChange [2, 5, 10, 20, 50, 100, 200, 500, 1000] 999))
  , Case "leetcode hard example" (assertEqual 20 (coinChange [186, 419, 83, 408] 6249))
  , check "empty coins zero amount" [] 0
  , check "empty coins positive amount" [] 7
  ]

generatedCases :: [Case]
generatedCases =
  [ check ("generated " ++ show coins ++ " amount " ++ show amount) coins amount
  | coins <- [[1], [2], [1, 2, 5], [2, 4], [3, 7, 11], [2, 5, 10]]
  , amount <- [0 .. 30]
  ]

check :: String -> [Int] -> Int -> Case
check name coins amount =
  Case name (assertEqual (slowCoinChange coins amount) (coinChange coins amount))

slowCoinChange :: [Int] -> Int -> Int
slowCoinChange coins amount
  | amount < 0 = -1
  | amount == 0 = 0
  | null positiveCoins = -1
  | otherwise = bfs 0 (S.singleton 0) (S.singleton 0)
  where
    positiveCoins = filter (> 0) coins

    bfs steps seen frontier
      | S.null frontier = -1
      | amount `S.member` frontier = steps
      | otherwise =
          let next =
                S.fromList
                  [ current + coin
                  | current <- S.toList frontier
                  , coin <- positiveCoins
                  , current + coin <= amount
                  ]
              unseen = next `S.difference` seen
          in bfs (steps + 1) (seen `S.union` unseen) unseen

