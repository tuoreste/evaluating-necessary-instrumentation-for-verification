#!/usr/bin/env python3

"""
argparse reads cmd-line arguments
"""
import argparse
from pathlib import Path

def main() -> None:
    parser = argparse.ArgumentParser(
        description="Turn CoVer-instrumented LLVM IR into an executable."
    )
    parser.add_argument("ir_file", type=Path, help="Input .ll file")
    parser.add_argument("program", type=Path, help="Output executable")

    args = parser.parse_args()

    print(f"IR file: {args.ir_file}")
    print(f"Program: {args.program}")


if __name__ == "__main__":
    main()