# Historical Attempts

Copied from commented sections in `inputs/Lib.hs`.

These are source-history notes, not accepted solutions or variants. Replay an
attempt through the problem judge before promoting it.

## v1 repeated table

```haskell
-- first solution:
dp :: [Int] -> Int -> [Int]
dp coins amount = 0 : (map (giveMinOrInf . getCandidates)  [1..])
    where inf            = amount+1
          getCandidates  = \n  -> [min inf (1+((dp coins amount) !! (n-coin))) | coin <- coins, n-coin >= 0]
          giveMinOrInf   = \xs -> if null xs then inf else minimum xs

coinChange :: [Int] -> Int -> Int
coinChange coins amount = if possibleAns == amount+1 then -1 else possibleAns
    where possibleAns = (dp coins amount) !! amount
```

## v2 shared lazy table

```haskell
-- second solution:
dp :: [Int] -> Int -> [Int]
dp coins amount = table
    where inf   = amount+1
          table = 0 : map best [1..]
          best n =
            let candidates = [min inf (1+(table !! (n-coin)))
                             | coin <- coins
                             , n-coin >= 0
                             ]
            in if null candidates then inf else minimum candidates
coinChange :: [Int] -> Int -> Int
coinChange coins amount = if possibleAns == amount+1 then -1 else possibleAns
    where possibleAns = (dp coins amount) !! amount
```
