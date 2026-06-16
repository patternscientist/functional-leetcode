# 733. Flood Fill

## Pattern

BFS over the connected component of cells matching the source color, followed by one final update.

## Invariant

The queue contains same-color cells whose neighbors still need scanning; the visited map marks exactly same-color cells already reached from the start.

## Code

floodFill image sr sc color
  | originalColor == color = image
  | otherwise = recolor visitedComponent

step (q, visited) = dequeue one cell, enqueue unseen same-color neighbors

## Complexity

Time: O(mn log mn) with Map. Space: O(mn).

## Pitfall(s)

Do not cross diagonals, and do not mutate/rewrite the array repeatedly when a final component update will do.
