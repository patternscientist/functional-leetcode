module Solution (orangesRotting) where

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
-- Problem 994. Rotting Oranges
queueSize :: Queue a -> Int
queueSize (front,back) = (length front) + (length back)

orangesRotting :: [[Int]] -> Int
orangesRotting grid = if freshFinal /= 0
                      then -1
                      else elapsedTime
    where gridArr       = toArray grid
          (lower,upper) = A.bounds gridArr
          freshCount    = length  . filter ((==1) . snd) . A.assocs $ gridArr
          initRottedPos = map fst . filter ((==2) . snd) . A.assocs $ gridArr
          q0            = foldl' enqueue ([],[]) initRottedPos
          dr            = [-1,0,1,0]
          dc            = [0,1,0,-1]
          offsets       = zip dr dc
          globalStep    = \(q,arr,fresh,time) -> case q of
            ([],[]) -> (q,arr,fresh,time)
            (_,_)   -> let
                        levelSize = queueSize q
                        localStep = \n (q',arr',fresh',timeFlag) ->
                            if n == 0
                            then (q',arr',fresh',timeFlag)
                            else let
                                    ((r,c),rest) = dequeue q'
                                    nbs = [(nr,nc)
                                        | (dr_k,dc_k) <- offsets
                                        , let nr = r+dr_k;
                                              nc = c+dc_k
                                        , (fst lower <= nr && nr <= fst upper &&
                                            snd lower <= nc && nc <= snd upper &&
                                            (arr' A.! (nr,nc)) == 1)
                                        ]
                                    arr''     = arr' A.// (zip nbs (repeat 2))
                                    q''       = foldl' enqueue rest nbs
                                    fresh''   = fresh' - length nbs
                                    timeFlag' = timeFlag || fresh'' /= fresh'
                                in
                                    localStep (n-1) (q'',arr'',fresh'',timeFlag')
                        (qNew,arrNew,freshNew,flag) = localStep levelSize ((q,arr,fresh,False))
                        timeNew = if flag then time+1 else time
                       in
                        globalStep (qNew,arrNew,freshNew,timeNew)
          (_,_,freshFinal,elapsedTime) = globalStep (q0,gridArr,freshCount,0)
