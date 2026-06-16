# Anki Source

This repository stores source files and previews for a future functional
LeetCode deck. It does not store live Anki scheduling state, intervals, or
review history.

The reference APKG uses one LeetCode model whose durable back fields are:

- `Pattern`
- `Invariant`
- `Code`
- `Complexity`
- `Pitfall(s)`

The functional deck keeps the same card grammar and uses Haskell as the
canonical language. Racket belongs in repository solutions and can appear in a
comparison field when it changes the representation lesson.

Current source format:

```text
0001-two-sum/anki/note.json
```

Generate an importable TSV:

```powershell
python tools/generate_anki_tsv.py --output anki/previews/functional_leetcode.tsv
```

Render one Markdown preview:

```powershell
python judge/judge.py preview-anki 0001
```

Synchronization with a live Anki collection is intentionally out of scope for
the first checkpoint.

