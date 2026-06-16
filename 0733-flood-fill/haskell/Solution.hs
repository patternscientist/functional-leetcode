module Solution (floodFill) where

import qualified Data.Array as A
import qualified Data.Map as M
import Data.List (foldl')

-- Problem 733. Flood Fill
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
floodFill :: [[Int]] -> Int -> Int -> Int -> [[Int]]
floodFill image sr sc color = if ogColor == color
                              then image
                              else fromArray . (imageArr A.//) . M.assocs . M.map (\_ -> color) . M.filter id . snd $ step (q0,mp0)
    where ogColor = (image !! sr) !! sc
          imageArr = toArray image
          (lb,ub)  = A.bounds imageArr
          ogColorSubset = filter ((==ogColor) . snd) $ A.assocs imageArr
          q0 = enqueue ([],[]) (sr,sc)
          mp0        = M.fromList . map (\(i,_) -> if i == (sr,sc)
                                                   then (i,True)
                                                   else (i,False)) $ ogColorSubset
          dr = [-1,0,1,0]
          dc = [0,1,0,-1]
          offsets = zip dr dc
          step = \(q,mp) -> case q of
            ([],[]) -> (q,mp)
            (_,_)   -> let
                        ((r,c),rest) = dequeue q
                        nbs = [(nr,nc)
                              | (dr_k,dc_k) <- offsets
                              , let nr = r+dr_k;
                                    nc = c+dc_k
                              , ((fst lb) <= nr && nr <= (fst ub) &&
                                 (snd lb) <= nc && nc <= (snd ub) &&
                                 (not $ M.findWithDefault True (nr,nc) mp))
                              ]
                        q'  = foldl' enqueue rest nbs
                        mp' = foldr (M.adjust not) mp nbs
                      in
                        step (q',mp')
