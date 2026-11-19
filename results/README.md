# results
Output of the scripts: one folder per test and `summary.csv`. Compiled programs (`*.exe`) are not committed.

Folder names are the test file name without `.c`, e.g. `irecv-read-before-wait.buggy/` for `tests/data-race-read/irecv-read-before-wait.buggy.c`.

| File | Written by | Content |
|---|---|---|
| `full.ll` | `scripts/cover/cover_ir.sh` | instrumented IR (all callbacks) |
| `static.log` | `scripts/cover/cover_ir.sh` | CoVer's static analysis output |
| `minimal.ll` | `scripts/minimize.py` | IR with only the needed memory callbacks |
| `minimize.log` | `scripts/minimize.py` | one line per memory callback: kind, source line, static flag, needed or not |
| `summary.csv` | `scripts/minimize.py` | one row per test |

## summary.csv

| Column | Meaning |
|---|---|
| `test` | result folder name |
| `violation_with_full` | does the fully instrumented program report an error? |
| `mem_callbacks_total` | memory callbacks in `full.ll` |
| `mem_callbacks_needed` | memory callbacks left after minimization |
| `needed_source_lines` | source lines of the needed callbacks |
| `needed_all_flagged_by_static` | were all needed callbacks flagged by CoVer's static analysis? |

## Current results (baseline, #10)

| Test | Memory callbacks | Needed | Source line |
|---|---|---|---|
| `irecv-read-before-wait.buggy` | 7 | 1 | 18 (read in `printf`) |
| `isend-write-before-wait.buggy` | 8 | 1 | 16 (`buf = 7`) |
| `*.correct` | 7 / 8 | – (no violation) | – |
