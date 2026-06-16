# Historical Attempts

Copied from commented sections in `inputs/Lib.hs`.

These are source-history notes, not accepted solutions or variants. Replay an
attempt through the problem judge before promoting it.

## v1 tuple fold

```haskell
first solution:
maxSubarray :: [Int] -> Int
maxSubarray []    = error "maxSubarray: empty input"
maxSubarray (x:xs) = snd . foldl' step (x,x) $ xs
    where step (bestEndingHere,best) x' =
            let bestEndingHere'  = max x' (bestEndingHere+x')
                best'            = max best bestEndingHere'
            in
                (bestEndingHere',best')
```
