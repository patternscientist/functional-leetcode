from __future__ import annotations

import argparse
import re
from pathlib import Path


PROBLEM_RE = re.compile(r"^-- Problem\s+([^\n]+)", re.MULTILINE)
SIGNATURE_RE = re.compile(r"^([a-zA-Z][A-Za-z0-9_']*)\s*::\s*([^\n]+)", re.MULTILINE)
BOOL_TEST_RE = re.compile(r"^(\w*(?:Test|Hard)\w*)\s*::\s*Bool", re.MULTILINE)
VERSION_RE = re.compile(r"--\s*([^-\n]*(?:first|second|third|solution|Assumes)[^-\n]*)", re.IGNORECASE)


KNOWN_IDS = {
    "01 Matrix.": (542, "01-matrix", "01 Matrix"),
    "050. Valid Parentheses": (20, "valid-parentheses", "Valid Parentheses"),
}


def normalize(raw: str) -> tuple[int, str, str]:
    raw = raw.strip()
    if raw in KNOWN_IDS:
        return KNOWN_IDS[raw]
    match = re.match(r"(\d+)\.\s*(.+)", raw)
    if not match:
        raise ValueError(f"cannot parse problem marker: {raw}")
    problem_id = int(match.group(1))
    title = match.group(2).strip()
    slug = (
        title.lower()
        .replace("&", "and")
        .replace(".", "")
        .replace("'", "")
    )
    slug = re.sub(r"[^a-z0-9]+", "-", slug).strip("-")
    return problem_id, slug, title


def sections(text: str) -> list[tuple[str, str]]:
    markers = list(PROBLEM_RE.finditer(text))
    result = []
    for index, marker in enumerate(markers):
        end = markers[index + 1].start() if index + 1 < len(markers) else len(text)
        result.append((marker.group(1).strip(), text[marker.start():end]))
    return result


def main() -> int:
    parser = argparse.ArgumentParser(description="Summarize inputs/Lib.hs problem sections")
    parser.add_argument("lib", nargs="?", default="inputs/Lib.hs")
    args = parser.parse_args()

    text = Path(args.lib).read_text(encoding="utf-8")
    for raw, body in sections(text):
        problem_id, slug, title = normalize(raw)
        tests = BOOL_TEST_RE.findall(body)
        signatures = SIGNATURE_RE.findall(body)
        versions = VERSION_RE.findall(body)
        print(f"## {problem_id:04d}-{slug}")
        print()
        print(f"- title: {title}")
        print(f"- tests: {', '.join(tests) if tests else 'none found'}")
        print(f"- signatures: {', '.join(name for name, _ in signatures)}")
        print(f"- version markers: {', '.join(v.strip() for v in versions) if versions else 'active version only'}")
        print()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

