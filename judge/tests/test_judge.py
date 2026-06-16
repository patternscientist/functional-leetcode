from __future__ import annotations

import shutil
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

from judge.judge import SubmitOptions, submit_problem


REPO = Path(__file__).resolve().parents[2]


def copy_scaffold(tmp_path: Path) -> Path:
    root = tmp_path / "repo"
    root.mkdir()
    for name in ["judge", "shared", "0053-maximum-subarray"]:
        shutil.copytree(REPO / name, root / name, ignore=shutil.ignore_patterns("__pycache__"))
    return root


def run_cli(root: Path, *args: str) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        [sys.executable, "judge/judge.py", *args],
        cwd=root,
        text=True,
        encoding="utf-8",
        errors="replace",
        capture_output=True,
        timeout=60,
    )


class JudgeTests(unittest.TestCase):
    def setUp(self) -> None:
        self.tmp = tempfile.TemporaryDirectory()
        self.root = copy_scaffold(Path(self.tmp.name))

    def tearDown(self) -> None:
        self.tmp.cleanup()

    @unittest.skipIf(shutil.which("ghc") is None, "GHC is not available")
    def test_bad_submission_is_rejected_and_canonical_is_unchanged(self) -> None:
        canonical = self.root / "0053-maximum-subarray" / "haskell" / "Solution.hs"
        before = canonical.read_text(encoding="utf-8")
        bad = self.root / "judge" / "tests" / "fixtures" / "bad_max_subarray.hs"

        proc = run_cli(self.root, "submit", "0053", "haskell", "--source", str(bad))

        self.assertNotEqual(proc.returncode, 0)
        self.assertIn("Wrong Answer", proc.stdout)
        self.assertIn("Canonical solution restored: unchanged", proc.stdout)
        self.assertEqual(canonical.read_text(encoding="utf-8"), before)

    @unittest.skipIf(shutil.which("ghc") is None, "GHC is not available")
    def test_good_submission_is_accepted(self) -> None:
        good = self.root / "judge" / "tests" / "fixtures" / "good_max_subarray.hs"

        proc = run_cli(self.root, "submit", "0053", "haskell", "--source", str(good))

        self.assertEqual(proc.returncode, 0, proc.stdout + proc.stderr)
        self.assertIn("Accepted", proc.stdout)
        self.assertIn("Classification", proc.stdout)
        self.assertIn("Push\nawaiting explicit approval", proc.stdout)
        self.assertTrue((self.root / "0053-maximum-subarray" / "haskell" / "Solution.hs").exists())

    @unittest.skipIf(shutil.which("ghc") is None, "GHC is not available")
    def test_tampering_with_frozen_tests_is_detected(self) -> None:
        good = self.root / "judge" / "tests" / "fixtures" / "good_max_subarray.hs"
        test_file = self.root / "0053-maximum-subarray" / "haskell" / "Test.hs"

        def tamper(_: list[Path]) -> None:
            test_file.write_text(test_file.read_text(encoding="utf-8") + "\n-- tampered\n", encoding="utf-8")

        result = submit_problem(
            self.root,
            "0053",
            "haskell",
            good,
            SubmitOptions(timeout=60, tamper_after_test=tamper),
        )

        self.assertFalse(result.ok)
        self.assertEqual(result.return_code, 3)
        self.assertIn("Judge Tampering Detected", result.output)
        self.assertIn("0053-maximum-subarray", result.output)

    def test_problem_json_validates(self) -> None:
        proc = run_cli(self.root, "validate")
        self.assertEqual(proc.returncode, 0, proc.stdout + proc.stderr)
        self.assertIn("OK 0053-maximum-subarray", proc.stdout)


if __name__ == "__main__":
    unittest.main()
