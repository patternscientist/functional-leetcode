# 543. Diameter of Binary Tree

## Pattern

Tree fold returning a pair: height and best diameter seen below.

## Invariant

For each node, height is the longest downward edge count, while best is the maximum of left best, right best, and the path through this node.

## Code

heightAndBest Empty = (-1, -1)
heightAndBest (Node _ l r) =
  let (lh, lb) = heightAndBest l
      (rh, rb) = heightAndBest r
  in (1 + max lh rh, maximum [lb, rb, lh + rh + 2])

## Complexity

Time: O(n). Space: O(h) call stack.

## Pitfall(s)

Use edge counts consistently: empty height -1 makes a leaf height 0 and leaf diameter 0.
