# scripts
Automation in Python and shell: building and running tests, minimization and the driver.
Run everything inside the container (`make shell`, in `/workspace`).

| Script | What it does |
|---|---|
| `cover/cover_ir.sh` | Instruments a test with CoVer and keeps the IR (`full.ll`, `static.log`, `full.exe`). See `cover/README.md`. |
| `cover/link_ir.sh` | Builds a program from a (possibly edited) `.ll` file. See `cover/README.md`. |
| `minimize.py` | Baseline (#10): removes the memory callbacks one by one and keeps only the ones needed to still detect the error. |

## minimize.py

```bash
python3 scripts/minimize.py results/<test>/full.ll [--ranks 2]
```

For each `PPDCV_MemRCallback` / `PPDCV_MemWCallback` line, the script deletes it, rebuilds with `cover/link_ir.sh` and runs the program with `mpiexec`. If "Contract violation detected" is still printed (stdout or stderr), the callback stays removed; otherwise it is put back.

Writes `results/<test>/minimal.ll`, `results/<test>/minimize.log` and a row in `results/summary.csv` (see `results/README.md`). A test that reports no violation even with full instrumentation (a `.correct` version) only gets a row with `violation_with_full=False`.