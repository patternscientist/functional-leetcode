# 3. Longest Substring Without Repeating Characters

## Pattern

Left fold over indexed characters with state `(start, best, seen)`.

## Invariant

After processing index i, `start` is the left edge of the current duplicate-free window, `seen` stores latest positions, and `best` is the best window length seen so far.

## Code

lengthOfLongestSubstring =
  snd3 . foldl' step (0, 0, IM.empty) . zip [0..] . map C.ord
  where
    step (start, best, seen) (i, k) =
      let start' = maybe start (max start . (+ 1)) (IM.lookup k seen)
          best' = max best (i - start' + 1)
          seen' = IM.insert k i seen
      in (start', best', seen')

## Complexity

Time: O(n log a) with IntMap over the character-code alphabet. Space: O(a).

## Pitfall(s)

`start` must never move backward when a repeated character was last seen before the current window.
