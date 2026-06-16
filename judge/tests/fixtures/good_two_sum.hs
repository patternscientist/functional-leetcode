module Solution (twoSum) where

import qualified Data.Map.Strict as M

twoSum :: [Int] -> Int -> (Int, Int)
twoSum nums target = go M.empty 0 nums
  where
    go _ _ [] = error "twoSum: expected exactly one solution"
    go seen i (x:xs) =
      case M.lookup (target - x) seen of
        Just j -> (j, i)
        Nothing -> go (M.insert x i seen) (i + 1) xs

