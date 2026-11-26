# Which memory callbacks are needed and why (#26)

Tests: `tests/data-race-read/irecv-read-before-wait.buggy.c` and `tests/data-race-write/isend-write-before-wait.buggy.c`, CoVer full instrumentation (`results/<test>.buggy/full.ll`). IDs from the pass's list mode (`-list-out`), "needed" from `scripts/minimize.py` (`minimize.log`).

## Result
In both tests exactly **one** memory callback is needed: the access to the MPI buffer **while the non-blocking operation is still running**. It is also the only callback CoVer's static analysis flagged (`i1 true`).

## Reason categories

| Category | What it is | Needed? | Why |
|---|---|---|---|
| **A. Not the MPI buffer** | accesses to other variables: the copies of `argc`/`argv` at the start of `main`, reads of `rank` in the `if` | no | CoVer's Local Data Race contract only watches the buffer passed to `MPI_Isend`/`MPI_Irecv`. Accesses to other memory can never violate it. |
| **B. MPI buffer, no operation running** | accesses to `buf` before the non-blocking call starts, or on a rank that only uses blocking calls | no | The contract is only "open" between the non-blocking call and its `MPI_Wait`. Before it starts (or with no request at all) the access is allowed, so the runtime doesn't need to see it. |
| **C. MPI buffer, operation running** | the read/write of `buf` between `MPI_Irecv`/`MPI_Isend` and `MPI_Wait` | **yes** | This is the conflicting access itself. The runtime only knows it happened through this callback; without it, nothing violates the contract and the race is missed. |

A fourth case, "MPI buffer after `MPI_Wait`", would also be category "not needed" (operation finished), but it doesn't occur in our two tests.

## Read race (`irecv-read-before-wait.buggy.c`, 7 callbacks)

| ID | Kind | Line | Variable | Static flag | Needed? | Category | Reason |
|---|---|---|---|---|---|---|---|
| 0 | W | – | `argc` (copy at function start) | 0 | no | A | not the buffer |
| 1 | W | – | `argv` (copy at function start) | 0 | no | A | not the buffer |
| 2 | W | 9 | `buf = 0` | 0 | no | B | before `MPI_Irecv` |
| 3 | R | 12 | `rank` in `if (rank == 0)` | 0 | no | A | not the buffer |
| 4 | W | 13 | `buf = 42` (rank 0) | 0 | no | B | rank 0 only uses blocking `MPI_Send` |
| 5 | R | 15 | `rank` in `else if (rank == 1)` | 0 | no | A | not the buffer |
| 6 | R | 18 | `buf` in `printf` (rank 1) | **1** | **yes** | C | read between `MPI_Irecv` (17) and `MPI_Wait` (19) |

## Write race (`isend-write-before-wait.buggy.c`, 8 callbacks)

| ID | Kind | Line | Variable | Static flag | Needed? | Category | Reason |
|---|---|---|---|---|---|---|---|
| 0 | W | – | `argc` (copy at function start) | 0 | no | A | not the buffer |
| 1 | W | – | `argv` (copy at function start) | 0 | no | A | not the buffer |
| 2 | W | 9 | `buf = 0` | 0 | no | B | before `MPI_Isend` |
| 3 | R | 12 | `rank` in `if (rank == 0)` | 0 | no | A | not the buffer |
| 4 | W | 14 | `buf = 42` (rank 0) | 0 | no | B | before `MPI_Isend` (15) |
| 5 | W | 16 | `buf = 7` (rank 0) | **1** | **yes** | C | write between `MPI_Isend` (15) and `MPI_Wait` (17) |
| 6 | R | 18 | `rank` in `else if (rank == 1)` | 0 | no | A | not the buffer |
| 7 | R | 20 | `buf` in `printf` (rank 1) | 0 | no | B | after the blocking `MPI_Recv` (19); no request on rank 1 |

Line "–": the two callbacks for `argc`/`argv` are inserted by the compiler's function prologue and have no source line (`0` in the list, `?` in `minimize.log`).

## How to check a row
`minimize.log` shows the IR pointer of every callback. In both tests:

| Pointer | Variable |
|---|---|
| `%3` | `argc` |
| `%4` | `argv` |
| `%5` | `rank` |
| `%6` | `buf` (the MPI buffer) |

To see it yourself in `full.ll`: search for `PPDCV_Mem`. The line right after a callback is the `load` (read) or `store` (write) it reports. Its pointer leads to the variable: `#dbg_declare(ptr %6, !137, …)` → `!137 = !DILocalVariable(name: "buf", …)`. The callback's `!dbg` leads to the source line.

## Removal experiment vs. static flag

| Test | Callbacks | Needed (removal) | Flagged (static) | Same? |
|---|---|---|---|---|
| Read race | 7 | ID 6 | ID 6 | yes |
| Write race | 8 | ID 5 | ID 5 | yes |

Confirmed with the pass (#13): keeping only the needed callback still reports the race; removing only that one misses it.

For these two simple races, CoVer's static analysis already finds exactly the needed callback, so `filtered` mode would be enough. The BugBench cases (#25) are where to look for cases where this does **not** hold: e.g. `COLL/LocalConcurrency-mpi_iallreduce-001` and `P2P/LocalConcurrency-receive-mpi_irecv-001` were flagged statically but missed at runtime.