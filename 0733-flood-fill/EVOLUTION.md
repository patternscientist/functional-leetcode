# Evolution

## v1 - Repeated array updates

- Parsed from `inputs/Lib.hs` as a historical stage.
- Performs BFS and updates the immutable array as reachable cells are found.
- Not retained as a variant until it is run through this problem's judge.

## v2 - Reachability first, one final update

- Accepted as the current canonical Haskell solution.
- Separates component discovery from recoloring.
- Uses a map over source-color cells to track reachability, then applies one
  final array update for the reached component.

