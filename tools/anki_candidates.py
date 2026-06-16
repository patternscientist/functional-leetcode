from __future__ import annotations

import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))

from judge.models import iter_problems  # noqa: E402


def main() -> int:
    for problem in iter_problems(ROOT):
        anki = problem.anki or {}
        if anki.get("candidate"):
            reasons = ", ".join(anki.get("reasons", []))
            print(f"{problem.directory}\t{problem.title}\t{reasons}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

