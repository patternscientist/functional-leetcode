# Historical Attempts

Copied from commented sections in `inputs/Lib.hs`.

These are source-history notes, not accepted solutions or variants. Replay an
attempt through the problem judge before promoting it.

## v1 direct array update BFS

```haskell
-- first solution.
floodFill :: [[Int]] -> Int -> Int -> Int -> [[Int]]
floodFill image sr sc color = if srcColor == color
                              then image
                              else fromArray . snd $ step (q0,img0)
        where srcColor = (image !! sr) !! sc
              m        = length image
              n        = length (image !! 0)
              imageArr = toArray image
              dr       = [-1,0,1,0]
              dc       = [0,1,0,-1]
              neighborOffsets = zip dr dc
              q0       = enqueue ([],[]) (sr,sc)
              img0     = imageArr A.// [((sr,sc),color)]
              step     = \(q,img) -> case q of
                                        ([],[]) -> (q,img)
                                        (_,_)   -> let
                                                    ((r,c),rest) = dequeue q
                                                    srcColorNeighbors = [(nr,nc)
                                                                        | (dr_k,dc_k) <- neighborOffsets
                                                                        , let nr = r+dr_k;
                                                                              nc = c+dc_k
                                                                        , (nr >= 0 && nr < m &&
                                                                           nc >= 0 && nc < n &&
                                                                           (img A.! (nr,nc)) == srcColor)
                                                                        ]
                                                    q'    = foldl' enqueue rest srcColorNeighbors
                                                    img'  = img A.// (zip srcColorNeighbors (repeat color))
                                                   in
                                                    step (q',img')
```
