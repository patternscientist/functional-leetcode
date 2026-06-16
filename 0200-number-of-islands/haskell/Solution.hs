module Solution (numIslands) where

import qualified Data.Array as A
import Data.List (foldl')

toArray :: [[a]] -> A.Array (Int,Int) a
toArray xss = A.listArray ((0,0),(m-1,n-1)) $ concat xss
    where m = length xss
          n = length (xss !! 0)
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
-- Problem 200. Number of Islands
numIslands :: [[Char]] -> Int
numIslands grid = totalIslands
    where grid0  = toArray grid
          (lb,ub)  = A.bounds grid0
          q0       = ([],[])
          islands0 = 0
          dr       = [-1,0,1,0]
          dc       = [0,1,0,-1]
          offsets  = zip dr dc
          (_,_,totalIslands) = foldl' step (q0,grid0,islands0) (A.indices grid0)
          step     = \(q,gridArr,islands) (r,c) -> if gridArr A.! (r,c) /= '1'
                                                   then (q,gridArr,islands)
                                                   else let
                                                            qNow       = enqueue q (r,c)
                                                            gridArrNow = gridArr A.// [((r,c),'X')]
                                                            localStep = \(q',gridArr') ->
                                                                case q' of
                                                                    ([],[]) -> (q',gridArr')
                                                                    (_,_)   -> let
                                                                                ((r',c'),rest) = dequeue q'
                                                                                nbs = [(nr,nc)
                                                                                        | (dr_k,dc_k) <- offsets
                                                                                        , let nr = r'+dr_k;
                                                                                              nc = c'+dc_k
                                                                                        , (fst lb <= nr && nr <= fst ub &&
                                                                                            snd lb <= nc && nc <= snd ub &&
                                                                                            (gridArr' A.! (nr,nc)) == '1')]
                                                                                gridArr'' = gridArr' A.// (zip nbs (repeat 'X'))
                                                                                q''       = foldl' enqueue rest nbs
                                                                               in
                                                                                localStep (q'',gridArr'')
                                                            (qNew,gridArrNew) = localStep (qNow,gridArrNow)
                                                        in
                                                            (qNew,gridArrNew,islands+1)
