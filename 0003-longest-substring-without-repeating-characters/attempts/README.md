# Historical Attempts

Copied from commented sections in `inputs/Lib.hs`.

These are source-history notes, not accepted solutions or variants. Replay an
attempt through the problem judge before promoting it.

## v1 prefilled IntMap

```haskell
--first solution:
lengthOfLongestSubstring :: String -> Int
lengthOfLongestSubstring  = snd3 . foldl' step (0,0,(IM.fromList $ zip [0..255] [-1,-1..])) . zip [0..] . map C.ord
    where step (start,best,seen) (i,k) =
            let v      = (seen IM.! k)::Int
                start' = if v /= -(1::Int) then max start (v+1) else start
                best'  = max best (i-start'+1)
                seen'  = IM.insert k i seen
            in
                (start',best',seen')
```
