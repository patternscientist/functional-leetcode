# 200. Number of Islands

## Pattern

Scan the grid; each unseen land cell starts a BFS that marks one whole component.

## Invariant

All cells already scanned or reached by prior BFS runs are non-land in the working array; each new land root contributes exactly one island.

## Code

fold over array indices
  if current cell is '1': BFS mark its component and increment count
  otherwise continue

## Complexity

Time: O(mn). Space: O(mn).

## Pitfall(s)

Mark when enqueuing neighbors, not after repeated rediscovery, to avoid duplicate queue work.
