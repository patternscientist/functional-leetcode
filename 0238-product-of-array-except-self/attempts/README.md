# Historical Attempts

Copied from commented sections in `inputs/Lib.hs`.

These are source-history notes, not accepted solutions or variants. Replay an
attempt through the problem judge before promoting it.

## commented first/second/third attempts

```haskell
--first solution:
productExceptSelf xs = zipWith (*) (reverse . snd . foldl' step (1,[]) $ xs) (snd . foldr step' (1,[]) $ xs)
    where step (prefix,xs') x =
            let prefix' = prefix * x
                xs'' = prefix : xs'
            in
                (prefix',xs'')

          step' x (suffix,xs') =
            let suffix' = suffix * x
                xs'' = suffix : xs'
            in
                (suffix',xs'')

--second solution:
productExceptSelf xs = zipWith (*) prefixes suffixes
    where prefixes = reverse . snd . foldl' leftStep (1,[]) $ xs
          suffixes = snd . foldr rightStep (1,[]) $ xs

          leftstep (prefix,xs) x =
                let prefix' = prefix * x
                    xs'     = prefix : xs
                in
                    (prefix',xs')
          rightStep x (suffix,xs) =
                let suffix' = x * suffix
                    xs'     = suffix : xs
--third solution:
productExceptSelf xs = zipWith (*) (init $ scanl (*) 1 xs) (drop 1 $ scanr (*) 1 xs) -- `drop 1` does the same as `tail` w/o throwing error on an empty list
```
