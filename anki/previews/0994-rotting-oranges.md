# 994. Rotting Oranges

## Pattern

Multi-source BFS by levels, starting from every initially rotten orange.

## Invariant

After each minute, all oranges reachable in that many steps from any source are rotten, and the queue holds the next frontier.

## Code

q0 = enqueue all initially rotten cells
process one queue level at a time
increment time only if that level rotted at least one fresh orange

## Complexity

Time: O(mn). Space: O(mn).

## Pitfall(s)

Minute count is level-based, not pop-based. Return -1 if fresh oranges remain after the queue is empty.
