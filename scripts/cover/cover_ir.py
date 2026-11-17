#!/usr/bin/env python3

import argparse
from pathlib import Path

import os
import shlex
import subprocess
import tempfile

def run(command: list[object]) -> None:
    """Print and execute an external command."""
    command = [str(part) for part in command]
    print("+", shlex.join(command))
    subprocess.run(command, check=True)

def main() -> None:
    parser = argparse.ArgumentParser(
        description="Compile a test with CoVer while preserving its LLVM IR."
    )
    parser.add_argument("test", type=Path, help="C or C++ test program")
    parser.add_argument("out_dir", type=Path, help="Output directory")
    parser.add_argument(
        "mode",
        nargs="?",
        choices=("full", "funconly", "filtered"),
        default="full",
        help="CoVer instrumentation mode (default: full)",
    )
    args = parser.parse_args()

    test = args.test.resolve()
    out_dir = args.out_dir.resolve()

    if not test.is_file():
        parser.error(f"Test file does not exist: {test}")

    if test.suffix == ".c":
        compiler = "mpicc"
    elif test.suffix == ".cpp":
        compiler = "mpicxx"
    else:
        parser.error(f"Expected a .c or .cpp file: {test}")

    out_dir.mkdir(parents=True, exist_ok=True)

    cover_prefix = Path(os.environ.get("COVER_PREFIX", "/opt/cover"))

    with tempfile.TemporaryDirectory(prefix="cover-ir-") as temp_directory:
        bitcode = Path(temp_directory) / "input.bc"

        run(
            [
                compiler,                           # mpicc or mpicxx
                "-fPIC",                            # Position-independent code
                "-g",                               # Preserve source debug information
                "-emit-llvm",                       # Generate LLVM bitcode
                "-Xclang",
                "-disable-O0-optnone",              # Allow LLVM passes at -O0
                "-c",                               # Compile without linking
                "-I",
                cover_prefix / "include",           # CoVer headers
                "-include",
                cover_prefix / "include/mpi_contracts.h",
                test,                               # Input C or C++ source
                "-o",
                bitcode,                            # Temporary bitcode output
            ]
        )

        print(f"Temporary bitcode created: {bitcode}")

    print(f"Test: {test}")
    print(f"Output directory: {out_dir}")
    print(f"Mode: {args.mode}")
    print(f"Compiler: {compiler}")


if __name__ == "__main__":
    main()
