module Solution (updateMatrix) where

import qualified Data.Array as A
import Data.List (foldl')

toArray :: [[a]] -> A.Array (Int,Int) a
toArray xss = A.listArray ((0,0),(m-1,n-1)) $ concat xss
    where m = length xss
          n = length (xss !! 0)
fromArray :: (A.Ix a, Enum a) => A.Array (a,a) b -> [[b]]
fromArray xss = [[xss A.! (r,c) | c <- [(snd lower)..(snd upper)]] | r <- [(fst lower)..(fst upper)]]
    where (lower,upper) = A.bounds xss
type Queue a = ([a],[a])

pour :: Queue a -> Queue a
pour (front,back) = if not $ null front
                    then (front,back)
                    else pourAux (front,back)
    where pourAux = \(f,b) -> case b of
                                []   -> (f,b)
                                x:xs -> pourAux (x:f,xs)

enqueue :: Queue a -> a -> Queue a
enqueue (front,back) x = (front,x:back)

dequeue :: Queue a -> (a, Queue a)
dequeue q = case front of
    []   -> error "can't dequeue from an empty queue"
    x:xs -> (x,(xs,back))
    where (front,back) = pour q
-- Problem 01 Matrix.
updateMatrix :: [[Int]] -> [[Int]]
updateMatrix mat = fromArray . snd $ step (q0,dist0)
    where matArray  = toArray mat
          (lb,ub) = A.bounds matArray
          zeroesPos = map fst . filter ((==0) . snd) . A.assocs $ matArray
          dist0     = (A.listArray (A.bounds matArray) (repeat (-1))) A.// (zip zeroesPos (repeat 0))
          q0        = foldl' enqueue ([],[]) zeroesPos
          dr        = [-1,0,1,0]
          dc        = [0,1,0,-1]
          offsets   = zip dr dc
          step      = \(q,dist) -> case q of
            ([],[]) -> (q,dist)
            (_,_)   -> let
                        ((r,c),rest) = dequeue q
                        nbs = [(nr,nc)
                              | (dr_k,dc_k) <- offsets
                              , let nr = r+dr_k;
                                    nc = c+dc_k
                              , (fst lb <= nr && nr <= fst ub &&
                                 snd lb <= nc && nc <= snd ub &&
                                 (dist A.! (nr,nc)) == -1)
                              ]
                        dist' = dist A.// (zip nbs (repeat $ 1 + dist A.! (r,c)))
                        q'    = foldl' enqueue rest nbs
                      in
                        step (q',dist')
