#!/usr/bin/env python3

"""
argparse reads cmd-line arguments
"""
import argparse
from pathlib import Path

"""
shell lexical analysis(shlex):Python standard library module \
used to parse and split strings using Unix shell-like syntax
"""
import shlex
import subprocess #python std lib to run external programs or shell commands

import tempfile

import os

def run(command: list[object]) -> None:
    """Print and execute an external command."""
    command = [str(part) for part in command]
    print("+", shlex.join(command))
    subprocess.run(command, check=True)

def main() -> None:
    parser = argparse.ArgumentParser(
        description="Turn CoVer-instrumented LLVM IR into an executable."
    )
    parser.add_argument("ir_file", type=Path, help="Input .ll file")
    parser.add_argument("program", type=Path, help="Output executable")

    parser.add_argument(
        "--linker",
        choices=("mpicc", "mpicxx"),
        default="mpicc",
        help="MPI linker to use (default: mpicc)",
    )

    args = parser.parse_args()

    # print(f"IR file: {args.ir_file}")
    # print(f"Program: {args.program}")

    """
    resolve(): converts messy or relative paths into clean, \
    canonical absolute paths by interacting directly with \
    the operating system's file system
    """
    ir_file = args.ir_file.resolve()
    program = args.program.resolve()

    if not ir_file.is_file(): #we do not want to call llvm with missing input
        parser.error(f"IR file does not exist: {ir_file}")

    if ir_file.suffix != ".ll": #has to be specifically text llvm ir
        parser.error(f"Expected a .ll file: {ir_file}")

    print(f"IR file: {ir_file}")

    program.parent.mkdir(parents=True, exist_ok=True)
    # object_file = Path(f"{program}.o")
    with tempfile.TemporaryDirectory(prefix="cover-link-") as temp_directory:
        object_file = Path(temp_directory) / "program.o"

        run(
            [
                "llc",                      #llvm ir compiler
                "-filetype=obj",            #obj file not assembly
                "--relocation-model=pic",   #gen pos indep machine code, allows to later avoid linking problem since we are copiling native lang like c
                ir_file,
                "-o",
                object_file,                #generated obj file
            ]
        )

        # cover_prefix = Path("/opt/cover")
        cover_prefix = Path(os.environ.get("COVER_PREFIX", "/opt/cover"))

        run(
            [
                args.linker,                     # MPI-aware linker
                "-fPIC",
                "-g",
                object_file,
                "-lm",
                "-ldl",
                "-lffi",
                "-lpthread",
                "-Wl,--whole-archive",
                cover_prefix / "lib/libCoVerDynamicAnalyzer.a",
                "-Wl,--no-whole-archive",
                "-lstdc++",
                cover_prefix / "lib/libCoVerIntrinsics.a",
                "-o",
                program,                     # Generated exe
            ]
        )

    print(f"Program: {program}")

if __name__ == "__main__":
    main()



