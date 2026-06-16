# 322. Coin Change

## Pattern

Bottom-up DP table over amounts, with `amount + 1` as the unreachable sentinel.

## Invariant

After filling amount n, table[n] is the fewest coins needed for n using the available positive denominations, or the sentinel if unreachable.

## Code

dp coins amount = a A.! amount
  where
    inf = amount + 1
    a = A.array (0, amount) [(x, f x) | x <- [0..amount]]
    f 0 = 0
    f n = minimumOrInf [1 + a A.! (n - coin) | coin <- coins, n - coin >= 0]

## Complexity

Time: O(amount * number of coins). Space: O(amount).

## Pitfall(s)

A recurrence that names `dp` is not necessarily shared. Tie the table once or use an array; otherwise repeated indexing/reconstruction can dominate.
