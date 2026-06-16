from __future__ import annotations

import json
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any


VALID_STATUSES = {"pending", "accepted"}
VALID_LANGUAGES = {"haskell", "racket"}


def zero_pad(problem_id: int) -> str:
    return f"{problem_id:04d}"


def directory_name(problem_id: int, slug: str) -> str:
    return f"{zero_pad(problem_id)}-{slug}"


@dataclass
class LanguageConfig:
    canonical: str | None = None
    approach: str | None = None

    @classmethod
    def from_json(cls, data: dict[str, Any]) -> "LanguageConfig":
        return cls(
            canonical=data.get("canonical"),
            approach=data.get("approach"),
        )

    def to_json(self) -> dict[str, Any]:
        data: dict[str, Any] = {}
        if self.canonical:
            data["canonical"] = self.canonical
        if self.approach:
            data["approach"] = self.approach
        return data


@dataclass
class Problem:
    id: int
    slug: str
    title: str
    status: str = "pending"
    languages: dict[str, LanguageConfig] = field(default_factory=dict)
    anki: dict[str, Any] = field(default_factory=dict)
    path: Path | None = None

    @property
    def directory(self) -> str:
        return directory_name(self.id, self.slug)

    @property
    def json_path(self) -> Path:
        if self.path is None:
            raise ValueError("problem path is not set")
        return self.path / "problem.json"

    @classmethod
    def from_json(cls, data: dict[str, Any], path: Path | None = None) -> "Problem":
        validate_problem_data(data)
        languages = {
            name: LanguageConfig.from_json(value)
            for name, value in data.get("languages", {}).items()
        }
        return cls(
            id=int(data["id"]),
            slug=str(data["slug"]),
            title=str(data["title"]),
            status=str(data.get("status", "pending")),
            languages=languages,
            anki=dict(data.get("anki", {})),
            path=path,
        )

    def to_json(self) -> dict[str, Any]:
        return {
            "id": self.id,
            "slug": self.slug,
            "title": self.title,
            "status": self.status,
            "languages": {
                name: config.to_json()
                for name, config in sorted(self.languages.items())
            },
            "anki": self.anki,
        }


def validate_problem_data(data: dict[str, Any]) -> None:
    required = ["id", "slug", "title"]
    missing = [key for key in required if key not in data]
    if missing:
        raise ValueError(f"problem.json missing required field(s): {', '.join(missing)}")

    try:
        problem_id = int(data["id"])
    except (TypeError, ValueError) as exc:
        raise ValueError("problem id must be an integer") from exc
    if problem_id <= 0:
        raise ValueError("problem id must be positive")

    status = data.get("status", "pending")
    if status not in VALID_STATUSES:
        raise ValueError(f"invalid status {status!r}; expected one of {sorted(VALID_STATUSES)}")

    languages = data.get("languages", {})
    if not isinstance(languages, dict):
        raise ValueError("languages must be an object")
    for name, config in languages.items():
        if name not in VALID_LANGUAGES:
            raise ValueError(f"invalid language {name!r}; expected one of {sorted(VALID_LANGUAGES)}")
        if not isinstance(config, dict):
            raise ValueError(f"language config for {name} must be an object")


def load_problem(problem_dir: Path) -> Problem:
    path = problem_dir / "problem.json"
    data = json.loads(path.read_text(encoding="utf-8"))
    return Problem.from_json(data, path=problem_dir)


def save_problem(problem: Problem) -> None:
    problem.json_path.write_text(
        json.dumps(problem.to_json(), indent=2, sort_keys=False) + "\n",
        encoding="utf-8",
    )


def iter_problem_dirs(root: Path) -> list[Path]:
    return sorted(
        path
        for path in root.iterdir()
        if path.is_dir() and (path / "problem.json").exists()
    )


def iter_problems(root: Path) -> list[Problem]:
    return [load_problem(path) for path in iter_problem_dirs(root)]


def find_problem(root: Path, token: str) -> Problem:
    normalized = token.strip().lower()
    if normalized.isdigit():
        normalized_id = int(normalized)
        normalized_pad = zero_pad(normalized_id)
    else:
        normalized_id = None
        normalized_pad = normalized[:4] if normalized[:4].isdigit() else None

    matches: list[Problem] = []
    for problem in iter_problems(root):
        names = {
            str(problem.id),
            zero_pad(problem.id),
            problem.slug.lower(),
            problem.directory.lower(),
        }
        if (
            normalized in names
            or (normalized_id is not None and problem.id == normalized_id)
            or (normalized_pad is not None and zero_pad(problem.id) == normalized_pad)
        ):
            matches.append(problem)

    if not matches:
        raise LookupError(f"problem {token!r} was not found")
    if len(matches) > 1:
        raise LookupError(f"problem {token!r} matched multiple directories")
    return matches[0]


def canonical_relative_path(language: str) -> str:
    if language == "haskell":
        return "haskell/Solution.hs"
    if language == "racket":
        return "racket/solution.rkt"
    raise ValueError(f"unsupported language: {language}")

