#!/usr/bin/env python3

import argparse
from pathlib import Path

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

    print(f"Test: {test}")
    print(f"Output directory: {out_dir}")
    print(f"Mode: {args.mode}")
    print(f"Compiler: {compiler}")


if __name__ == "__main__":
    main()
