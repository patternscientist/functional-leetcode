module Solution (isPalindrome) where

import qualified Data.Array as A
import qualified Data.Char as C

-- Problem 125. Valid Palindrome
isPalindrome :: String -> Bool
isPalindrome s = step l0 r0 flag0
    where step = \l r flag ->
            if l >= r || not flag
            then flag
            else  let
                    l'  = updateL r l
                    r'  = updateR l r
                    cl' = C.toLower $ sArr A.! l'
                    cr' = C.toLower $ sArr A.! r'
                    flag' = if C.isAlphaNum cl'
                                && C.isAlphaNum cr' -- l,r could still point to something
                                                    -- non-alphanumeric after being updated,
                                                    -- e.g. if we've reached the end of
                                                    -- of the string
                            then cl' == cr'
                            else flag
                  in
                    step (l'+1) (r'-1) flag'
          updateL = \r l ->
            if l < r && (not $ C.isAlphaNum (sArr A.! l))
            then updateL r (l+1)
            else l
          updateR = \l r ->
            if l < r && (not $ C.isAlphaNum (sArr A.! r))
            then updateR l (r-1)
            else r
          sArr  = A.listArray (0,n-1) s
          flag0 = True
          l0 = 0
          r0 = n-1
          n  = length s
