# 121. Best Time to Buy and Sell Stock

## Pattern

Left fold with product state: minimum price seen so far and best profit so far.

## Invariant

After a prefix, bottom is the minimum price in that prefix and best is the best buy-before-sell profit inside the prefix, floored at 0.

## Code

maxProfit = snd . foldl' step (maxBound, 0)
  where
    step (bottom, best) x =
      let bottom' = min bottom x
          best' = max best (x - bottom')
      in (bottom', best')

## Complexity

Time: O(n). Space: O(1).

## Pitfall(s)

Update the minimum before computing x - bottom'; that still respects buy-before-sell because same-day profit is 0.
