from __future__ import annotations

import argparse
import csv
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
FIELDS = [
    "Slug",
    "Id",
    "Title",
    "Difficulty",
    "Topic",
    "Pattern",
    "Invariant",
    "Code",
    "Complexity",
    "Pitfall(s)",
    "Racket Comparison",
    "Source",
]


def iter_notes() -> list[dict[str, str]]:
    notes: list[dict[str, str]] = []
    for note_path in sorted(ROOT.glob("[0-9][0-9][0-9][0-9]-*/anki/note.json")):
        data = json.loads(note_path.read_text(encoding="utf-8"))
        fields = data.get("fields", {})
        missing = [field for field in FIELDS if field not in fields]
        if missing:
            raise ValueError(f"{note_path} missing fields: {', '.join(missing)}")
        notes.append({field: str(fields.get(field, "")) for field in FIELDS})
    return notes


def main() -> int:
    parser = argparse.ArgumentParser(description="Generate Functional LeetCode Anki TSV")
    parser.add_argument("--output", required=True)
    args = parser.parse_args()

    output = (ROOT / args.output).resolve()
    output.parent.mkdir(parents=True, exist_ok=True)
    notes = iter_notes()
    with output.open("w", encoding="utf-8", newline="") as f:
        writer = csv.writer(f, delimiter="\t", lineterminator="\n")
        writer.writerow(FIELDS)
        for note in notes:
            writer.writerow([note[field] for field in FIELDS])
    print(f"Wrote {output.relative_to(ROOT)} ({len(notes)} note(s))")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

