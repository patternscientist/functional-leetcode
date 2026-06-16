module Solution (trap) where

import qualified Data.Array as A

-- Problem 42. Trapping Rain Water
trap :: [Int] -> Int
trap height = step l0 r0 leftMax0 rightMax0 0
    where step = \l r lm rm amt ->
            if l >= r
            then amt
            else let
                    lm' = max lm (heightArr A.! l)
                    rm' = max rm (heightArr A.! r)
                 in
                    if lm' <= rm'
                    then step (l+1) r lm' rm' (amt + lm' - (heightArr A.! l))
                    else step l (r-1) lm' rm' (amt + rm' - (heightArr A.! r))
          heightArr = A.listArray (0,n-1) height
          n  = length height
          l0 = 0
          r0 = n-1
          leftMax0  = 0
          rightMax0 = 0
