#!/usr/bin/env python3

import argparse
from pathlib import Path

import os
import shlex
import subprocess
import tempfile
import sys

def run(command: list[object], log_file: Path | None = None,) -> None:
    """Print and execute an external command."""
    command = [str(part) for part in command]
    print("+", shlex.join(command))

    if log_file is None:
        subprocess.run(command, check=True)
    else:
        with log_file.open("w") as log:
            subprocess.run(
                command,
                check=True,
                stdout=log,
                stderr=subprocess.STDOUT,
            )

def count_callbacks(ir_file: Path) -> dict[str, int]:
    """Count CoVer callback calls in textual LLVM IR."""
    lines = ir_file.read_text().splitlines()

    return {
        "function": sum(
            "call " in line and "@PPDCV_FunctionCallback" in line
            for line in lines
        ),
        "memory_read": sum(
            "call " in line and "@PPDCV_MemRCallback" in line
            for line in lines
        ),
        "memory_write": sum(
            "call " in line and "@PPDCV_MemWCallback" in line
            for line in lines
        ),
    }

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

    full_ir = out_dir / "full.ll"
    static_log = out_dir / "static.log"
    full_exe = out_dir / "full.exe"
    link_ir = Path(__file__).resolve().with_name("link_ir.py")

    with tempfile.TemporaryDirectory(prefix="cover-ir-") as temp_directory:
        bitcode = Path(temp_directory) / "input.bc"

        run(
            [
                compiler,                           # mpicc or mpicxx
                "-fPIC",                            # OIC
                "-g",
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

        run(
            [
                "opt",
                f"--load-pass-plugin={cover_prefix / 'lib/DSA.so'}",
                f"--load-pass-plugin={cover_prefix / 'lib/CoVerPlugin.so'}",
                "-passes=function(sroa),instrumentIntrinsics,"
                "contractVerifierPreCall,contractVerifierPostCall,"
                "contractVerifierRelease,contractVerifierParam,"
                "contractVerifierAlloc,contractPostProcess,"
                "instrumentContracts",
                f"-cover-instrument-type={args.mode}",
                bitcode,
                "-S",                   # Produce readable textual IR
                "-o",
                full_ir,                # Persistent instrumented IR
            ],
            log_file=static_log,
        )

        print(f"Temporary bitcode created: {bitcode}")

    run(
        [
            sys.executable,      # Use the current Python interpreter
            link_ir,
            "--linker",
            compiler,
            full_ir,
            full_exe,
        ]
    )

    callbacks = count_callbacks(full_ir)
    memory_total = callbacks["memory_read"] + callbacks["memory_write"]
    
    print(f"Instrumented IR: {full_ir}")
    print(f"Static report: {static_log}")
    print(f"Program: {full_exe}")

    print(f"Test: {test}")
    print(f"Output directory: {out_dir}")
    print(f"Mode: {args.mode}")
    print(f"Compiler: {compiler}")

    print(f"Function callbacks: {callbacks['function']}")
    print(f"Memory-read callbacks: {callbacks['memory_read']}")
    print(f"Memory-write callbacks: {callbacks['memory_write']}")
    print(f"Total memory callbacks: {memory_total}")


if __name__ == "__main__":
    main()
