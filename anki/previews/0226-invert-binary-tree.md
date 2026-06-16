# 226. Invert Binary Tree

## Pattern

Structural recursion over a binary tree.

## Invariant

The inverted tree preserves every node value and recursively swaps the left and right subtrees at every node.

## Code

invertTree Empty = Empty
invertTree (Node x l r) = Node x (invertTree r) (invertTree l)

## Complexity

Time: O(n). Space: O(h) call stack.

## Pitfall(s)

The useful property check is involution: inverting twice returns the original tree.
