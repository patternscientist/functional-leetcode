module Solution (updateMatrix) where

import qualified Data.Array as A
import Data.List (foldl')

toArray :: [[a]] -> A.Array (Int, Int) a
toArray xss = A.listArray ((0, 0), (m - 1, n - 1)) (concat xss)
  where
    m = length xss
    n = length (head xss)

fromArray :: A.Array (Int, Int) b -> [[b]]
fromArray xss =
  [ [xss A.! (r, c) | c <- [snd lower .. snd upper]]
  | r <- [fst lower .. fst upper]
  ]
  where
    (lower, upper) = A.bounds xss

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

-- LeetCode inputs are nonempty rectangular matrices with at least one zero.
updateMatrix :: [[Int]] -> [[Int]]
updateMatrix mat = fromArray . snd $ step (q0, dist0)
  where
    matArray = toArray mat
    (lower, upper) = A.bounds matArray
    zeroesPos = map fst . filter ((== 0) . snd) . A.assocs $ matArray
    dist0 = A.listArray (A.bounds matArray) (repeat (-1)) A.// zip zeroesPos (repeat 0)
    q0 = foldl' enqueue ([], []) zeroesPos
    offsets = [(-1, 0), (0, 1), (1, 0), (0, -1)]

    step (q, dist) =
      case q of
        ([], []) -> (q, dist)
        _ ->
          let ((r, c), rest) = dequeue q
              nbs =
                [ (nr, nc)
                | (dr, dc) <- offsets
                , let nr = r + dr
                , let nc = c + dc
                , fst lower <= nr && nr <= fst upper
                , snd lower <= nc && nc <= snd upper
                , dist A.! (nr, nc) == -1
                ]
              dist' = dist A.// zip nbs (repeat (1 + dist A.! (r, c)))
              q' = foldl' enqueue rest nbs
          in step (q', dist')

