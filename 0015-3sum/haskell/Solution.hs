module Solution (threeSum) where

import qualified Data.Array as A
import qualified Data.List as L

-- Problem 15. 3Sum
threeSum :: [Int] -> [[Int]]
threeSum nums = step i0 candidates0
    where
        step = \i candidates ->
            if (i >= len || (sortedArr A.! i) > 0)
            then candidates
            else if (i > 0 && (sortedArr A.! i == sortedArr A.! (i-1)))
                 then step (i+1) candidates
                 else let
                        l = i+1
                        r = len-1
                        localStep = \l' r' candidates' ->
                            if l' >= r'
                            then candidates'
                            else let
                                    sorted_i = sortedArr A.! i
                                    sorted_l = sortedArr A.! l'
                                    sorted_r = sortedArr A.! r'
                                    s = sorted_i + sorted_l + sorted_r
                                 in
                                    if s == 0
                                    then localStep (updateL r' (l'+1))
                                                   (updateR l' (r'-1))
                                                   ([sorted_i,sorted_l,sorted_r]:candidates')
                                    else if s < 0
                                        then localStep (l'+1) r' candidates'
                                        else localStep l' (r'-1) candidates'
                      in
                        step (i+1) (localStep l r candidates)
        updateL = \r l ->
            if l < r && (sortedArr A.! l) == (sortedArr A.! (l-1))
            then updateL r (l+1)
            else l
        updateR = \l r ->
            if l < r && (sortedArr A.! r) == (sortedArr A.! (r+1))
            then updateR l (r-1)
            else r
        sortedArr = A.listArray (0,len-1) numsSorted
        numsSorted = L.sort nums
        len = length nums
        candidates0 = []
        i0 = 0
