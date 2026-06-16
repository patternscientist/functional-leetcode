module Solution (floodFill) where

import qualified Data.Array as A
import Data.List (foldl')
import qualified Data.Map.Strict as M

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

-- LeetCode inputs are nonempty rectangular images with in-bounds start cells.
floodFill :: [[Int]] -> Int -> Int -> Int -> [[Int]]
floodFill image sr sc color
  | originalColor == color = image
  | otherwise =
      fromArray .
      (imageArr A.//) .
      M.assocs .
      M.map (const color) .
      M.filter id .
      snd $
        step (q0, visited0)
  where
    originalColor = image !! sr !! sc
    imageArr = toArray image
    (lower, upper) = A.bounds imageArr
    originalColorCells = filter ((== originalColor) . snd) (A.assocs imageArr)
    q0 = enqueue ([], []) (sr, sc)
    visited0 =
      M.fromList
        [ (index, index == (sr, sc))
        | (index, _) <- originalColorCells
        ]
    offsets = [(-1, 0), (0, 1), (1, 0), (0, -1)]

    step (q, visited) =
      case q of
        ([], []) -> (q, visited)
        _ ->
          let ((r, c), rest) = dequeue q
              nbs =
                [ (nr, nc)
                | (dr, dc) <- offsets
                , let nr = r + dr
                , let nc = c + dc
                , fst lower <= nr && nr <= fst upper
                , snd lower <= nc && nc <= snd upper
                , not (M.findWithDefault True (nr, nc) visited)
                ]
              q' = foldl' enqueue rest nbs
              visited' = foldr (M.adjust (const True)) visited nbs
          in step (q', visited')

