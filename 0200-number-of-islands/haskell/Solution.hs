module Solution (numIslands) where

import qualified Data.Array as A
import Data.List (foldl')

toArray :: [[a]] -> A.Array (Int, Int) a
toArray xss = A.listArray ((0, 0), (m - 1, n - 1)) (concat xss)
  where
    m = length xss
    n = length (head xss)

type Queue a = ([a], [a])

pour :: Queue a -> Queue a
pour (front, back)
  | not (null front) = (front, back)
  | otherwise = (reverse back, [])

enqueue :: Queue a -> a -> Queue a
enqueue (front, back) x = (front, x : back)

dequeue :: Queue a -> (a, Queue a)
dequeue q =
  case front of
    [] -> error "dequeue: empty queue"
    x:xs -> (x, (xs, back))
  where
    (front, back) = pour q

-- LeetCode inputs are nonempty rectangular grids.
numIslands :: [[Char]] -> Int
numIslands grid = totalIslands
  where
    grid0 = toArray grid
    (lower, upper) = A.bounds grid0
    offsets = [(-1, 0), (0, 1), (1, 0), (0, -1)]
    (_, _, totalIslands) = foldl' step (([], []), grid0, 0) (A.indices grid0)

    step (q, gridArr, islands) (r, c)
      | gridArr A.! (r, c) /= '1' = (q, gridArr, islands)
      | otherwise =
          let qNow = enqueue q (r, c)
              gridArrNow = gridArr A.// [((r, c), 'X')]
              (qNew, gridArrNew) = localStep (qNow, gridArrNow)
          in (qNew, gridArrNew, islands + 1)

    localStep (q, gridArr) =
      case q of
        ([], []) -> (q, gridArr)
        _ ->
          let ((r, c), rest) = dequeue q
              nbs =
                [ (nr, nc)
                | (dr, dc) <- offsets
                , let nr = r + dr
                , let nc = c + dc
                , fst lower <= nr && nr <= fst upper
                , snd lower <= nc && nc <= snd upper
                , gridArr A.! (nr, nc) == '1'
                ]
              gridArr' = gridArr A.// zip nbs (repeat 'X')
              q' = foldl' enqueue rest nbs
          in localStep (q', gridArr')

