#!/usr/bin/env python3

import argparse
import os
from pathlib import Path
import subprocess

import shlex
import sys

import csv
import re
from collections import Counter

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "external" / "mpi-bugbench"))

from scripts.MBButils import parse_one_code

def reports_violation(log_path: Path) -> bool:
    return "Contract violation detected" in log_path.read_text(errors="replace")

def classify_runtime(log_path: Path, exit_code: int) -> str:
    if exit_code != 0:
        return "runtime_error"

    output = log_path.read_text(errors="replace")
    if "## Contract violation detected! ##" not in output:
        return "OK"

    if "for Formula (message or contract string): Local Data Race" in output:
        return "LocalConcurrency"

    return "other_violation"

def read_case(source: Path) -> tuple[str, int, list[int]]:
    case, = parse_one_code(str(source))
    command = shlex.split(case["cmd"])

    if (
        len(command) != 4
        or command[0] not in {"mpirun", "mpiexec"}
        or command[1] not in {"-np", "-n"}
        or command[3] != "${EXE}"
    ):
        raise ValueError(f"Unexpected BugBench command: {case['cmd']}")

    ranks = int(command[2])
    if ranks < 1:
        raise ValueError("MPI rank count must be positive")

    expected = "OK" if case["expect"] == "OK" else case["detail"]
    return expected, ranks, case["error_lines"]

def run_logged(command, log_path, *, cwd, timeout=None):
    """Run a command, save its output, and return its exit code."""
    with log_path.open("w") as log:
        try:
            return subprocess.run(
                command,
                cwd=cwd,
                stdout=log,
                stderr=subprocess.STDOUT,
                timeout=timeout,
            ).returncode
        except subprocess.TimeoutExpired:
            print(f"Timed out after {timeout} seconds.", file=log)
            return None
        except OSError as error:
            print(error, file=log)
            return 127


def score(expected, actual):
    """Return whether the class matched and how to count the case."""
    if actual in {"build_error", "runtime_error", "timeout"}:
        return "", actual
    if actual == expected:
        return True, "clean" if expected == "OK" else "hit"
    return False, "false_alarm" if expected == "OK" else "miss"


def run_case(source, out, name, expected, ranks, expected_lines):
    out.mkdir(parents=True, exist_ok=True)

    exit_code = run_logged(
        [ROOT / "scripts/cover/cover_ir.sh", source, out, "full"],
        out / "build.log",
        cwd=ROOT,
    )

    actual = "build_error"
    static_violation = ""
    reported_lines = set()
    line_match = ""

    if exit_code == 0:
        static_violation = reports_violation(out / "static.log")
        command = ["mpiexec"]
        if os.geteuid() == 0:
            command.append("--allow-run-as-root")
        command.extend(["-n", str(ranks), str(out / "full.exe")])

        runtime_log = out / "runtime.log"
        exit_code = run_logged(command, runtime_log, cwd=out, timeout=30)
        if exit_code is None:
            actual, exit_code = "timeout", 124
        else:
            actual = classify_runtime(runtime_log, exit_code)
            if actual in {"LocalConcurrency", "other_violation"}:
                output = runtime_log.read_text(errors="replace")
                reference = rf"Reference:[ \t]+{re.escape(str(source))}:(\d+)\b"
                reported_lines = {int(line) for line in re.findall(reference, output)}
                if expected_lines:
                    line_match = bool(reported_lines.intersection(expected_lines))

    match, outcome = score(expected, actual)
    return {
        "test": name,
        "ranks": ranks,
        "expected": expected,
        "actual": actual,
        "match": match,
        "outcome": outcome,
        "static_violation": static_violation,
        "expected_lines": " ".join(map(str, sorted(set(expected_lines)))),
        "reported_lines": " ".join(map(str, sorted(reported_lines))),
        "line_match": line_match,
        "exit_code": exit_code,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description="Run MPI-BugBench cases with CoVer.")
    parser.add_argument("source", type=Path, help="A test file, or a case directory with --batch")
    parser.add_argument("out_dir", type=Path, help="Directory for build and runtime logs")
    parser.add_argument("--batch", action="store_true", help="Run all OK and LocalConcurrency cases")
    parser.add_argument("--summary", type=Path, help="Path for the summary CSV")
    args = parser.parse_args()

    source = args.source.resolve()
    out = args.out_dir.resolve()
    if args.batch:
        if not source.is_dir() or args.summary is None:
            parser.error("--batch requires a case directory and --summary")
        paths = sorted(source.rglob("*.c"))
    else:
        if not source.is_file():
            parser.error(f"Test source does not exist: {source}")
        paths = [source]

    cases = []
    for path in paths:
        try:
            expected, ranks, expected_lines = read_case(path)
        except ValueError as error:
            parser.error(f"{path}: {error}")

        if args.batch and expected not in {"OK", "LocalConcurrency"}:
            continue
        name = path.relative_to(source) if args.batch else Path(path.name)
        case_out = out / name.with_suffix("") if args.batch else out
        cases.append((path, case_out, name.as_posix(), expected, ranks, expected_lines))

    if not cases:
        parser.error("No matching BugBench cases found")

    rows = []
    for case in cases:
        row = run_case(*case)
        rows.append(row)
        if args.batch:
            print(
                f"{row['test']} | expected {row['expected']} | "
                f"reported {row['actual']} | {row['outcome']}",
                flush=True,
            )
        else:
            print(f"BugBench expects: {row['expected']}")
            print(f"MPI ranks from header: {row['ranks']}")
            print(f"Static violation reported: {row['static_violation']}")
            print(f"CoVer runtime result: {row['actual']}")
            match = row["match"] if row["match"] != "" else "not scored"
            print(f"Matches BugBench: {match}")
            print(f"Logs: {out}")

    if args.summary is not None:
        args.summary.parent.mkdir(parents=True, exist_ok=True)
        with args.summary.open("w", newline="") as handle:
            writer = csv.DictWriter(handle, fieldnames=list(rows[0]))
            writer.writeheader()
            writer.writerows(rows)
        print(f"Wrote {len(rows)} results to {args.summary}")

    if args.batch:
        counts = Counter(row["outcome"] for row in rows)
        for outcome in ("clean", "hit", "miss", "false_alarm", "build_error", "runtime_error", "timeout"):
            print(f"{outcome}: {counts[outcome]}")
        return 0

    return rows[0]["exit_code"]

if __name__ == "__main__":
    raise SystemExit(main())