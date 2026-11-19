# RemoveCallbacks LLVM pass

This LLVM module pass works on CoVer's memory-read and memory-write callbacks (`PPDCV_MemRCallback` / `PPDCV_MemWCallback`) in an instrumented `full.ll`.

- **List mode** (`-list-out`): writes every callback with its ID to a CSV file. Does not change the IR.
- **Remove mode** (`-remove-ids`): deletes the callbacks whose IDs are in a file and writes the reduced IR.

Function callbacks (`PPDCV_FunctionCallback`) are never touched.

## Build

Run from the host:

```bash
make pass
```

This builds the plugin inside the `cover-lab` container:

```text
pass/build/RemoveCallbacks.so
```

`pass/build/` is generated and is not committed.

## Run in list mode

Enter the container:

```bash
make shell
```

Then run:

```bash
opt \
  -load-pass-plugin=pass/build/RemoveCallbacks.so \
  -passes=removecallbacks \
  -list-out=/tmp/list.csv \
  -disable-output \
  results/<test>/full.ll
```

`-disable-output` prevents `opt` from writing another LLVM IR file. The callback list is written to the path passed through `-list-out`.

## Run in remove mode

Write the IDs to remove into a file (one per line), then let `opt` write the reduced IR with `-S -o`:

```bash
printf '0\n1\n2\n3\n4\n5\n' > /tmp/remove.txt

opt \
  -load-pass-plugin=pass/build/RemoveCallbacks.so \
  -passes=removecallbacks \
  -remove-ids=/tmp/remove.txt \
  -S results/irecv-read-before-wait.buggy/full.ll \
  -o /tmp/reduced.ll

scripts/cover/link_ir.sh /tmp/reduced.ll /tmp/reduced.exe
mpiexec --allow-run-as-root -n 2 /tmp/reduced.exe
```

- IDs that don't exist in this IR are skipped with a warning.
- Duplicate IDs and empty lines are ignored.
- A line that is not a number, or a file that can't be opened, stops `opt` with `LLVM ERROR` and exit code 1. The same happens if the `-list-out` file can't be written. This way a script calling the pass always notices a problem.
- `-list-out` and `-remove-ids` can be used together; the list always describes the IR *before* removal.
- The callbacks are only erased after all of them have been collected, because deleting an instruction while looping over its block breaks the loop.

### Check (issue #13)

The needed callback from the baseline (#10) is ID 6 for the read race and ID 5 for the write race.

| Test | IDs removed | Callbacks left | Race reported? |
|---|---|---|---|
| read race, keep only the needed one | 0–5 | 1 | yes |
| read race, remove only the needed one | 6 | 6 | no |
| write race, keep only the needed one | 0–4, 6, 7 | 1 | yes |
| write race, remove only the needed one | 5 | 7 | no |

## Callback list format

The list file is CSV with one row per memory callback:

```csv
id,kind,function,line,static_flag
6,R,main,18,1
```

Fields:

- `id`: zero-based callback ID in LLVM module order.
- `kind`: `R` for `PPDCV_MemRCallback` or `W` for `PPDCV_MemWCallback`.
- `function`: function containing the callback.
- `line`: original source line from LLVM debug information; `0` means unavailable.
- `static_flag`: first callback argument; `1` means CoVer's static analysis marked it relevant, otherwise `0`.

Callback IDs are valid only for the exact `full.ll` from which the list was generated. Regenerating or changing the IR may change the IDs.

## Remove-file format

Remove mode reads a text file containing one callback ID per line:

```text
1
4
6
```

The file has no header. Each ID refers to the callback list generated from the same `full.ll`.

## Removed-file format

Future random-removal mode (#14) will write the IDs it removed, one per line:

```text
0
3
5
```

This makes a random experiment reproducible with the same `full.ll`.