# MPI-BugBench notes (#24)

## What it is
MPI-BugBench (MBB) is a benchmark for MPI correctness tools (MUST, PARCOACH, ITAC, …). It doesn't ship fixed test files: **Python generators** write the C test programs, and `MBB.py` can build, run and score them with a tool.

- Generators: `scripts/errors/<P2P|COLL|RMA|…>/<ErrorClass>.py`, e.g. `LocalConcurrency.py`
- **Levels 1–5**: how many variants are generated. Level 1 = the smallest set.
- Each generated case says in its **header** how to run it and what is expected.

## Generating Level 1
Inside `make shell`:
```bash
python3 -m pip install tqdm pandas numpy typing-extensions   # again after every new container
cd /workspace/external/mpi-bugbench
python3 -B scripts/generate.py --level 1 --outpath /tmp/mbb-level1
```
(The official way is `python3 MBB.py -c generate --level 1`, which writes to `gencodes/`.)

Level 1 generates **130 cases** (37 generators). We use the ones with `| OK` or `| ERROR LocalConcurrency` in the header: **25 + 8 = 33 cases**, in `P2P/`, `COLL/` and `RMA/`.

## What a case says about itself
Every case starts with a header between `BEGIN_MBB_TESTS` and `END_MBB_TESTS`.

Buggy example, `P2P/LocalConcurrency-mpi_irecv-001.c`:
```text
  Description: Overlapping recv buffers
  Category: P2P
BEGIN_MBB_TESTS
  $ mpirun -np 2 ${EXE}
  | ERROR LocalConcurrency
  | LocalConcurrency-mpi_irecv
END_MBB_TESTS
```

Correct example, `P2P/Correct-mpi_send-001.c`:
```text
BEGIN_MBB_TESTS
  $ mpirun -np 2 ${EXE}
  | OK
  | Correct-mpi_send
END_MBB_TESTS
```

- `$ mpirun -np 2 ${EXE}`: how to run it → **number of ranks** (here 2)
- `| ERROR LocalConcurrency` or `| OK`: the **expected result** and the error class
- third line: name of the variant
- The bug itself is marked in the code with `/*MBBERROR_BEGIN*/ … /*MBBERROR_END*/` → these are the **error lines**

MBB's own parser `scripts/MBButils.parse_one_code(file)` reads all of this and returns:

| Field | Meaning | Example |
|---|---|---|
| `cmd` | how to run it | `mpirun -np 2 ${EXE}` → number of ranks |
| `expect` | `OK` or `ERROR` | |
| `detail` | the error class when `ERROR` | `LocalConcurrency` |
| `error_lines` | source lines between the `MBBERROR` markers | `39 40` |

**Select cases by header, not by file name:** 23 files are named `Correct-…`, but **25** have `| OK` in the header (also `P2P/CallOrdering-mpi_send-mpi_recv-001.c` and `P2P/InvalidParam-Buffer-mpi_sendrecv-007.c`).

- **LocalConcurrency** = "usage of buffer before operation is completed": a buffer used again while a non-blocking operation on it (`MPI_Isend`, `MPI_Irecv`, `MPI_Iallreduce`, `MPI_Rget`, …) is still running. Broader than our two tests: e.g. `LocalConcurrency-mpi_irecv-001` posts **two `MPI_Irecv` into the same buffer**, not a read before `MPI_Wait`.
- **Correct** = no bug; checks that a tool raises no false alarm.
- If started with too few ranks, a case prints `MBB ERROR: This test needs at least 2 processes to produce a bug!`.

## How MBB scores a tool
- Each tool has an adapter in `scripts/tools/` (e.g. `must.py`, `parcoach.py`, `itac.py`): build → run → **parse the tool's output** into a verdict.
- MBB compares that verdict with the header's expectation:

| Expected | Tool reports | Counts as |
|---|---|---|
| bug | the bug | true positive (hit) |
| bug | nothing | false negative (miss) |
| OK | nothing | true negative |
| OK | an error | false positive (false alarm) |
| – | build error / crash / timeout | separate counts |

- **There is no CoVer adapter**, neither in MBB nor in the CoVer repo. CoVer's own tests contain a few cases copied from MBB (e.g. `Tests/c/Correct-RankNull.c` = `Correct-Rank-001`), but nothing that maps CoVer's output.
- So CoVer's report has to be **mapped** to MBB's classes: CoVer prints `Contract violation detected` + a contract message like `Local Data Race`; MBB expects `LocalConcurrency`.

## Decision
**Our own Python runner** (`scripts/bugbench/run_cover.py`, #25) instead of an MBB adapter:
- it uses MBB only to generate the cases and, through `parse_one_code`, to read the expected result and the rank count;
- it selects the cases by their header (`OK` or `LocalConcurrency`);
- it builds with our `scripts/cover/cover_ir.sh` (full instrumentation) and runs with `mpiexec` in our container;
- mapping: runtime `Local Data Race` → `LocalConcurrency`; no violation → `OK`; other violations, build errors, crashes and timeouts are kept separate.

Reason: an MBB adapter would need CoVer inside MBB's own Docker setup. Our runner reuses the pipeline we already have. An adapter can come later if we want MBB's plots.