module Solution (lengthOfLongestSubstring) where

import qualified Data.Char as C
import Data.List (foldl')
import qualified Data.IntMap.Strict as IM

lengthOfLongestSubstring :: String -> Int
lengthOfLongestSubstring =
  snd3 . foldl' step (0, 0, IM.empty) . zip [0 :: Int ..] . map C.ord
  where
    step (start, best, seen) (i, k) =
      let start' =
            case IM.lookup k seen of
              Nothing -> start
              Just j -> max start (j + 1)
          best' = max best (i - start' + 1)
          seen' = IM.insert k i seen
      in (start', best', seen')

snd3 :: (a, b, c) -> b
snd3 (_, y, _) = y

