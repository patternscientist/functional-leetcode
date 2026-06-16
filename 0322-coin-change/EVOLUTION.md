# Evolution

## v1 - Recomputed lazy table attempt

- Parsed from `inputs/Lib.hs` as a historical stage.
- Rebuilds the table through recursive calls to `dp coins amount`.
- Not retained as a variant until it is run through this problem's judge.

## v2 - Shared lazy list

- Same recurrence, but ties the table once so cells can be shared.
- This is the meaningful representation step from "a recurrence that names a
  table" to an actually shared Haskell table.
- Not retained as a variant until it is run through this problem's judge.

## v3 - `Data.Array` table

- Accepted as the current canonical Haskell solution.
- Uses a finite array over amounts `0..amount`.
- Keeps the same recurrence, but makes indexing explicit and random-access.

