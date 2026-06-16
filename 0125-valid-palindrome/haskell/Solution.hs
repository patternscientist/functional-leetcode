module Solution (isPalindrome) where

import qualified Data.Array as A
import qualified Data.Char as C

isPalindrome :: String -> Bool
isPalindrome s = step left0 right0 True
  where
    step l r valid
      | l >= r || not valid = valid
      | otherwise =
          let l' = updateLeft r l
              r' = updateRight l r
              cl = C.toLower (sArr A.! l')
              cr = C.toLower (sArr A.! r')
              valid' =
                if C.isAlphaNum cl && C.isAlphaNum cr
                  then cl == cr
                  else valid
          in step (l' + 1) (r' - 1) valid'

    updateLeft r l
      | l < r && not (C.isAlphaNum (sArr A.! l)) = updateLeft r (l + 1)
      | otherwise = l

    updateRight l r
      | l < r && not (C.isAlphaNum (sArr A.! r)) = updateRight l (r - 1)
      | otherwise = r

    sArr = A.listArray (0, n - 1) s
    left0 = 0
    right0 = n - 1
    n = length s

