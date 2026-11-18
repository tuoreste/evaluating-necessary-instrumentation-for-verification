# RemoveCallbacks LLVM pass

This LLVM module pass finds CoVer's memory-read and memory-write callbacks in an instrumented `full.ll`.

The current version only lists callbacks. It does not modify the LLVM IR.

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

Future removal mode will read a text file containing one callback ID per line:

```text
1
4
6
```

The file has no header. Each ID refers to the callback list generated from the same `full.ll`.

## Removed-file format

Future random-removal mode will write the IDs it removed, one per line:

```text
0
3
5
```

This makes a random experiment reproducible with the same `full.ll`.