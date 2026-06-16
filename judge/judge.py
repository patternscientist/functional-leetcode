from __future__ import annotations

import argparse
import hashlib
import os
import shutil
import subprocess
import sys
import time
from dataclasses import dataclass
from pathlib import Path
from typing import Callable

if __package__ in (None, ""):
    sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
    from judge.models import (  # type: ignore
        LanguageConfig,
        Problem,
        canonical_relative_path,
        directory_name,
        find_problem,
        iter_problems,
        save_problem,
        validate_problem_data,
        zero_pad,
    )
    from judge.reporting import ProcessReport  # type: ignore
else:
    from .models import (
        LanguageConfig,
        Problem,
        canonical_relative_path,
        directory_name,
        find_problem,
        iter_problems,
        save_problem,
        validate_problem_data,
        zero_pad,
    )
    from .reporting import ProcessReport


BUILD_ROOT = ".judge_build"
WORK_ROOT = ".judge_work"
CLASSIFICATIONS = {"duplicate", "minor-refactor", "meaningful-evolution", "distinct-approach"}


@dataclass
class JudgeResult:
    ok: bool
    return_code: int
    output: str


@dataclass
class SubmitOptions:
    timeout: int = 30
    classification: str | None = None
    commit: bool = False
    message: str | None = None
    tamper_after_test: Callable[[list[Path]], None] | None = None


def repo_root_from_cwd() -> Path:
    return Path.cwd().resolve()


def ensure_inside(root: Path, path: Path) -> None:
    resolved_root = root.resolve()
    resolved_path = path.resolve()
    if resolved_root != resolved_path and resolved_root not in resolved_path.parents:
        raise ValueError(f"refusing to operate outside repository root: {resolved_path}")


def recreate_dir(root: Path, path: Path) -> None:
    ensure_inside(root, path)
    if path.exists():
        shutil.rmtree(path)
    path.mkdir(parents=True, exist_ok=True)


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for block in iter(lambda: f.read(1024 * 1024), b""):
            h.update(block)
    return h.hexdigest()


def frozen_files(root: Path, problem: Problem, language: str) -> list[Path]:
    if problem.path is None:
        raise ValueError("problem path is not set")

    files: list[Path] = [problem.json_path]
    if language == "haskell":
        haskell_dir = problem.path / "haskell"
        files.extend(path for path in haskell_dir.glob("*.hs") if path.name != "Solution.hs")
        shared_dir = root / "shared" / "haskell"
        files.extend(sorted(shared_dir.glob("*.hs")))
    elif language == "racket":
        racket_dir = problem.path / "racket"
        files.extend(path for path in racket_dir.glob("*.rkt") if path.name != "solution.rkt")
        shared_dir = root / "shared" / "racket"
        files.extend(sorted(shared_dir.glob("*.rkt")))
    else:
        raise ValueError(f"unsupported language: {language}")

    return sorted(path for path in files if path.exists())


def snapshot(paths: list[Path]) -> dict[Path, str]:
    return {path: sha256(path) for path in paths}


def changed_hashes(before: dict[Path, str]) -> list[Path]:
    changed: list[Path] = []
    for path, digest in before.items():
        if not path.exists() or sha256(path) != digest:
            changed.append(path)
    return changed


def run_process(command: list[str], cwd: Path, timeout: int) -> ProcessReport:
    proc = subprocess.run(
        command,
        cwd=str(cwd),
        text=True,
        encoding="utf-8",
        errors="replace",
        capture_output=True,
        timeout=timeout,
    )
    return ProcessReport.from_completed(command, proc)


def render_unavailable(tool: str, language: str) -> JudgeResult:
    return JudgeResult(
        ok=False,
        return_code=127,
        output=f"Unavailable\n{language} tests require `{tool}`, but it is not on PATH.",
    )


def prepare_haskell_source_root(root: Path, problem: Problem, source_override: Path | None) -> Path:
    assert problem.path is not None
    source_root = problem.path / "haskell"
    if source_override is None:
        return source_root

    work = root / WORK_ROOT / f"{problem.directory}-haskell-candidate"
    recreate_dir(root, work)
    for path in source_root.glob("*.hs"):
        if path.name == "Solution.hs":
            continue
        shutil.copy2(path, work / path.name)
    shutil.copy2(source_override, work / "Solution.hs")
    return work


def prepare_racket_source_root(root: Path, problem: Problem, source_override: Path | None) -> Path:
    assert problem.path is not None
    source_root = problem.path / "racket"
    if source_override is None:
        return source_root

    work = root / WORK_ROOT / f"{problem.directory}-racket-candidate"
    recreate_dir(root, work)
    for path in source_root.glob("*.rkt"):
        if path.name == "solution.rkt":
            continue
        shutil.copy2(path, work / path.name)
    shutil.copy2(source_override, work / "solution.rkt")
    return work


def run_haskell_tests(
    root: Path,
    problem: Problem,
    source_override: Path | None = None,
    timeout: int = 30,
) -> JudgeResult:
    if problem.path is None:
        raise ValueError("problem path is not set")

    source_root = prepare_haskell_source_root(root, problem, source_override)
    test_file = source_root / "Test.hs"
    if not test_file.exists():
        return JudgeResult(False, 2, f"Refused\nmissing Haskell test harness: {test_file}")

    build = root / BUILD_ROOT / f"{problem.directory}-haskell"
    recreate_dir(root, build)
    obj_dir = build / "obj"
    hi_dir = build / "hi"
    obj_dir.mkdir(parents=True, exist_ok=True)
    hi_dir.mkdir(parents=True, exist_ok=True)
    exe = build / ("test.exe" if os.name == "nt" else "test")
    shared = root / "shared" / "haskell"

    compile_cmd = [
        "ghc",
        "-O2",
        "-Wall",
        "-Wextra",
        f"-i{source_root}",
        f"-i{shared}",
        str(test_file),
        "-odir",
        str(obj_dir),
        "-hidir",
        str(hi_dir),
        "-o",
        str(exe),
    ]

    try:
        compile_report = run_process(compile_cmd, root, timeout)
    except FileNotFoundError:
        return render_unavailable("ghc", "Haskell")
    except subprocess.TimeoutExpired:
        return JudgeResult(False, 124, f"Compile Timeout\nHaskell compile exceeded {timeout}s")

    if compile_report.returncode != 0:
        return JudgeResult(False, compile_report.returncode, "Compile Error\n" + compile_report.render("Compiler"))

    try:
        run_report = run_process([str(exe)], root, timeout)
    except subprocess.TimeoutExpired:
        return JudgeResult(False, 124, f"Time Limit Exceeded\nHaskell test run exceeded {timeout}s")

    sections: list[str] = []
    if compile_report.stderr.strip():
        sections.append("Compiler warnings\n" + compile_report.stderr.rstrip())
    if run_report.stdout.strip():
        sections.append(run_report.stdout.rstrip())
    if run_report.stderr.strip():
        sections.append("Runtime stderr\n" + run_report.stderr.rstrip())

    if run_report.returncode == 0:
        return JudgeResult(True, 0, "\n\n".join(["Accepted", *sections]).rstrip())
    return JudgeResult(False, run_report.returncode, "\n\n".join(["Wrong Answer", *sections]).rstrip())


def run_racket_tests(
    root: Path,
    problem: Problem,
    source_override: Path | None = None,
    timeout: int = 30,
) -> JudgeResult:
    if problem.path is None:
        raise ValueError("problem path is not set")
    source_root = prepare_racket_source_root(root, problem, source_override)
    test_file = source_root / "test.rkt"
    if not test_file.exists():
        return JudgeResult(False, 2, f"Refused\nmissing Racket test harness: {test_file}")
    try:
        report = run_process(["racket", str(test_file)], root, timeout)
    except FileNotFoundError:
        return render_unavailable("racket", "Racket")
    except subprocess.TimeoutExpired:
        return JudgeResult(False, 124, f"Time Limit Exceeded\nRacket test run exceeded {timeout}s")
    if report.returncode == 0:
        return JudgeResult(True, 0, "Accepted\n" + report.stdout.rstrip())
    return JudgeResult(False, report.returncode, "Wrong Answer\n" + report.render("Racket"))


def run_problem_tests(root: Path, problem_token: str, language: str, timeout: int = 30) -> JudgeResult:
    problem = find_problem(root, problem_token)
    if language == "haskell":
        return run_haskell_tests(root, problem, timeout=timeout)
    if language == "racket":
        return run_racket_tests(root, problem, timeout=timeout)
    raise ValueError(f"unsupported language: {language}")


def classify_submission(canonical: Path, source: Path, requested: str | None) -> str:
    if requested:
        return requested
    if canonical.exists() and sha256(canonical) == sha256(source):
        return "duplicate"
    if canonical.exists():
        return "minor-refactor"
    return "meaningful-evolution"


def submit_problem(
    root: Path,
    problem_token: str,
    language: str,
    source: Path,
    options: SubmitOptions,
) -> JudgeResult:
    if options.classification and options.classification not in CLASSIFICATIONS:
        raise ValueError(f"invalid classification: {options.classification}")
    source = source.resolve()
    if not source.exists():
        return JudgeResult(False, 2, f"Refused\nsource file does not exist: {source}")

    problem = find_problem(root, problem_token)
    if problem.path is None:
        raise ValueError("problem path is not set")
    if language not in {"haskell", "racket"}:
        raise ValueError(f"unsupported language: {language}")

    frozen = frozen_files(root, problem, language)
    if not frozen:
        return JudgeResult(False, 2, "Refused\nno frozen judge files were found")

    before = snapshot(frozen)
    started = time.perf_counter()
    if language == "haskell":
        test_result = run_haskell_tests(root, problem, source_override=source, timeout=options.timeout)
    else:
        test_result = run_racket_tests(root, problem, source_override=source, timeout=options.timeout)

    if options.tamper_after_test is not None:
        options.tamper_after_test(frozen)

    tampered = changed_hashes(before)
    if tampered:
        rels = [str(path.relative_to(root)) for path in tampered]
        return JudgeResult(
            False,
            3,
            "Judge Tampering Detected\nFrozen judge files changed during submit:\n"
            + "\n".join(f"- {rel}" for rel in rels),
        )

    if not test_result.ok:
        return JudgeResult(
            False,
            test_result.return_code,
            test_result.output + "\n\nCanonical solution restored: unchanged",
        )

    lang_config = problem.languages.get(language, LanguageConfig())
    canonical_rel = lang_config.canonical or canonical_relative_path(language)
    canonical = problem.path / canonical_rel
    classification = classify_submission(canonical, source, options.classification)

    if classification != "duplicate" or not canonical.exists():
        canonical.parent.mkdir(parents=True, exist_ok=True)
        if source.resolve() != canonical.resolve():
            shutil.copy2(source, canonical)

    if language not in problem.languages:
        problem.languages[language] = LanguageConfig(canonical=canonical_rel)
    elif not problem.languages[language].canonical:
        problem.languages[language].canonical = canonical_rel
    problem.status = "accepted"
    save_problem(problem)

    elapsed = time.perf_counter() - started
    lines = [
        test_result.output,
        "",
        "Classification",
        classification,
        "",
        "Canonical solution",
        "unchanged" if classification == "duplicate" else str(canonical.relative_to(root)),
        "",
        "Runtime",
        f"{elapsed:.3f}s local wall-clock, machine-specific",
        "",
        "Commit",
        "not created" if not options.commit else "requested",
        "",
        "Push",
        "awaiting explicit approval",
    ]

    if options.commit:
        message = options.message or f"Accept {problem.directory} {language}"
        commit_report = commit_success(root, [canonical, problem.json_path], message)
        lines.extend(["", commit_report.output])
        return_code = 0 if commit_report.ok else commit_report.return_code
        return JudgeResult(commit_report.ok, return_code, "\n".join(lines))

    return JudgeResult(True, 0, "\n".join(lines))


def commit_success(root: Path, paths: list[Path], message: str) -> JudgeResult:
    rels = [str(path.relative_to(root)) for path in paths]
    add = run_process(["git", "add", *rels], root, 10)
    if add.returncode != 0:
        return JudgeResult(False, add.returncode, add.render("git add failed"))
    commit = run_process(["git", "commit", "-m", message], root, 30)
    if commit.returncode != 0:
        return JudgeResult(False, commit.returncode, commit.render("git commit failed"))
    return JudgeResult(True, 0, "Commit\n" + commit.stdout.rstrip())


def add_problem(root: Path, args: argparse.Namespace) -> JudgeResult:
    problem_id = int(args.id)
    problem_dir = root / directory_name(problem_id, args.slug)
    if problem_dir.exists():
        return JudgeResult(False, 2, f"Refused\nproblem directory already exists: {problem_dir}")

    (problem_dir / "haskell").mkdir(parents=True, exist_ok=True)
    if args.language == "racket":
        (problem_dir / "racket").mkdir(parents=True, exist_ok=True)

    problem = Problem(
        id=problem_id,
        slug=args.slug,
        title=args.title,
        status="pending",
        languages={args.language: LanguageConfig(canonical=canonical_relative_path(args.language))},
        path=problem_dir,
    )
    save_problem(problem)
    (problem_dir / "README.md").write_text(
        f"# {zero_pad(problem_id)}. {args.title}\n\nStatus: pending.\n",
        encoding="utf-8",
    )

    if args.language == "haskell":
        (problem_dir / "haskell" / "Test.hs").write_text(
            "module Main where\n\n"
            "main :: IO ()\n"
            "main = error \"add fixed tests, generated tests, and an oracle before submit\"\n",
            encoding="utf-8",
        )
    else:
        (problem_dir / "racket" / "test.rkt").write_text(
            "#lang racket\n"
            "(error \"add RackUnit tests and an oracle before submit\")\n",
            encoding="utf-8",
        )

    return JudgeResult(True, 0, f"Created pending problem {problem.directory}")


def test_all(root: Path, timeout: int) -> JudgeResult:
    lines: list[str] = []
    ok = True
    for problem in iter_problems(root):
        if problem.status == "pending":
            lines.append(f"SKIP {problem.directory} pending")
            continue
        if not problem.languages:
            lines.append(f"SKIP {problem.directory} no accepted languages")
            continue
        for language in sorted(problem.languages):
            result = run_problem_tests(root, problem.directory, language, timeout=timeout)
            status = "PASS" if result.ok else "FAIL"
            lines.append(f"{status} {problem.directory} {language}")
            lines.append(result.output)
            ok = ok and result.ok
    return JudgeResult(ok, 0 if ok else 1, "\n\n".join(lines))


def validate_all(root: Path) -> JudgeResult:
    lines: list[str] = []
    ok = True
    for problem in iter_problems(root):
        try:
            validate_problem_data(problem.to_json())
            lines.append(f"OK {problem.directory}")
        except ValueError as exc:
            ok = False
            lines.append(f"FAIL {problem.directory}: {exc}")
    if not lines:
        lines.append("No problem.json files found")
    return JudgeResult(ok, 0 if ok else 1, "\n".join(lines))


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Functional LeetCode deterministic judge")
    parser.add_argument("--timeout", type=int, default=30, help="compile/run timeout in seconds")
    sub = parser.add_subparsers(dest="command", required=True)

    add = sub.add_parser("add-problem", help="create a pending problem scaffold")
    add.add_argument("id")
    add.add_argument("slug")
    add.add_argument("--title", required=True)
    add.add_argument("--language", choices=["haskell", "racket"], default="haskell")

    test = sub.add_parser("test", help="run tests for one problem/language")
    test.add_argument("problem")
    test.add_argument("language", choices=["haskell", "racket"])

    submit = sub.add_parser("submit", help="run frozen tests against a candidate source")
    submit.add_argument("problem")
    submit.add_argument("language", choices=["haskell", "racket"])
    submit.add_argument("--source", required=True)
    submit.add_argument("--classification", choices=sorted(CLASSIFICATIONS))
    submit.add_argument("--commit", action="store_true")
    submit.add_argument("--message")

    sub.add_parser("test-all", help="run all accepted solutions")
    sub.add_parser("validate", help="validate problem metadata")
    return parser


def main(argv: list[str] | None = None) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)
    root = repo_root_from_cwd()
    try:
        if args.command == "add-problem":
            result = add_problem(root, args)
        elif args.command == "test":
            result = run_problem_tests(root, args.problem, args.language, timeout=args.timeout)
        elif args.command == "submit":
            result = submit_problem(
                root,
                args.problem,
                args.language,
                Path(args.source),
                SubmitOptions(
                    timeout=args.timeout,
                    classification=args.classification,
                    commit=args.commit,
                    message=args.message,
                ),
            )
        elif args.command == "test-all":
            result = test_all(root, timeout=args.timeout)
        elif args.command == "validate":
            result = validate_all(root)
        else:
            parser.error(f"unhandled command: {args.command}")
    except (LookupError, ValueError) as exc:
        print(f"Error: {exc}")
        return 2

    print(result.output)
    return result.return_code


if __name__ == "__main__":
    raise SystemExit(main())
