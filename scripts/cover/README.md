# scripts/cover
CoVer helper scripts. Run them inside the container (`make shell`, in `/workspace`).

```bash
# Instrument a test with CoVer and keep the IR
scripts/cover/cover_ir.sh <test.c|test.cpp> <out_dir> [full|funconly|filtered]

# Build an executable from a (possibly edited) .ll file
scripts/cover/link_ir.sh <file.ll> <program> [--linker mpicc|mpicxx]
```

`cover_ir.sh` writes to `<out_dir>`:

| File | Content |
|---|---|
| `full.ll` | the instrumented LLVM IR |
| `static.log` | CoVer's static analysis output |
| `full.exe` | the instrumented program (not committed) |

The names stay the same in every mode; the default mode is `full`. It uses `mpicc` for `.c` and `mpicxx` for `.cpp` files and prints how many callbacks the IR contains.

`link_ir.sh` runs `llc` on the `.ll` file and links the object file with CoVer's runtime libraries.

Example:

```bash
scripts/cover/cover_ir.sh tests/data-race-read/irecv-read-before-wait.buggy.c results/irecv-read-before-wait.buggy full
mpiexec --allow-run-as-root -n 2 results/irecv-read-before-wait.buggy/full.exe
```

`COVER_PREFIX` can point to another CoVer installation (default: `/opt/cover`, where the container has it). Outside the container, set `OMPI_CC=clang` (and `OMPI_CXX=clang++`); with gcc, linking fails with `undefined reference to symbol 'ceil'`.