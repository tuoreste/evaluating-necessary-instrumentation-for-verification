#!/usr/bin/env python3

import argparse
import os
from pathlib import Path
import subprocess

import shlex
import sys

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

def read_case(source: Path) -> tuple[str, int]:
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
    return expected, ranks

def run_case(source: Path, out: Path, ranks: int, expected: str) -> int:
    out.mkdir(parents=True, exist_ok=True)

    build_log = out / "build.log"
    with build_log.open("w") as log:
        build = subprocess.run(
            [ROOT / "scripts/cover/cover_ir.sh", source, out, "full"],
            stdout=log,
            stderr=subprocess.STDOUT,
        )

    if build.returncode != 0:
        print(f"Build failed. See {build_log}")
        return build.returncode

    program = out / "full.exe"
    print(f"Built {program}")

    print(f"Static violation reported: {reports_violation(out / 'static.log')}")

    command = ["mpiexec"]
    if os.geteuid() == 0:
        command.append("--allow-run-as-root")
    command.extend(["-n", str(ranks), str(program)])

    runtime_log = out / "runtime.log"
    try:
        with runtime_log.open("w") as log:
            result = subprocess.run(
                command, cwd=out, stdout=log,
                stderr=subprocess.STDOUT, timeout=30,
            )
        print(f"MPI exit status: {result.returncode}")

        actual = classify_runtime(runtime_log, result.returncode)
        print(f"CoVer runtime result: {actual}")
        if actual == "runtime_error":
            print("Matches BugBench: not scored")
        else:
            print(f"Matches BugBench: {actual == expected}")

        return result.returncode
    except subprocess.TimeoutExpired:
        print("MPI run timed out after 30 seconds.")
        return 124
    finally:
        print(f"Runtime log: {runtime_log}")
        print(runtime_log.read_text(errors="replace"))


def main() -> int:
    parser = argparse.ArgumentParser(description="Run one MPI-BugBench case with CoVer.")
    parser.add_argument("source", type=Path)
    parser.add_argument("out_dir", type=Path)
    args = parser.parse_args()

    source = args.source.resolve()
    if not source.is_file():
        parser.error(f"Test source does not exist: {source}")

    try:
        expected, ranks = read_case(source)
    except ValueError as error:
        parser.error(str(error))

    print(f"BugBench expects: {expected}")
    print(f"MPI ranks from header: {ranks}")
    return run_case(source, args.out_dir.resolve(), ranks, expected)


if __name__ == "__main__":
    raise SystemExit(main())