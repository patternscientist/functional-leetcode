from __future__ import annotations

import subprocess
from dataclasses import dataclass


@dataclass
class ProcessReport:
    command: list[str]
    returncode: int
    stdout: str
    stderr: str

    @classmethod
    def from_completed(cls, command: list[str], proc: subprocess.CompletedProcess[str]) -> "ProcessReport":
        return cls(
            command=command,
            returncode=proc.returncode,
            stdout=proc.stdout or "",
            stderr=proc.stderr or "",
        )

    def render(self, title: str) -> str:
        lines = [title, f"Command: {' '.join(self.command)}", f"Exit code: {self.returncode}"]
        if self.stdout.strip():
            lines.extend(["", "Stdout", self.stdout.rstrip()])
        if self.stderr.strip():
            lines.extend(["", "Stderr", self.stderr.rstrip()])
        return "\n".join(lines)


def section(title: str, body: str | list[str]) -> str:
    if isinstance(body, list):
        body_text = "\n".join(body)
    else:
        body_text = body
    return f"{title}\n{body_text.rstrip()}"

