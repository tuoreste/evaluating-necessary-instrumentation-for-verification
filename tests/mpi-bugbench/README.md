# MPI-BugBench Level 1

We evaluate the cases whose headers expect `OK` or `ERROR LocalConcurrency`.
This selects 25 correct cases and 8 local-concurrency cases.

Inside `make shell`, generate the cases and run CoVer:

```bash
python3 -m pip install tqdm pandas numpy typing-extensions
cd /workspace/external/mpi-bugbench
bench=$(mktemp -d /tmp/mpi-bugbench-level1.XXXXXX)
python3 -B scripts/generate.py --level 1 --outpath "$bench"
cd /workspace

python3 -B scripts/bugbench/run_cover.py \
  "$bench" "$(mktemp -d /tmp/cover-a2.XXXXXX)" \
  --batch --summary results/bugbench/summary.csv
```

The runner uses the MPI rank count from each case header and runs CoVer with
full instrumentation. It maps a runtime `Local Data Race` violation to
`LocalConcurrency`. A completed run without a violation is recorded as `OK`.
Other violations, build failures, MPI failures, and timeouts remain visible
in the results.

Static detection and runtime source-line matches are recorded separately.
The build logs, runtime logs, IR, and executables stay in the temporary
output directory.