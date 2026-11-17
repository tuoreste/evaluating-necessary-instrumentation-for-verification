#!/usr/bin/env python3
"""
Empirical minimization of CoVer's memory instrumentation.

Idea (one-by-one removal):
    for each memory callback in the instrumented IR:
        remove it, rebuild the program, run it with MPI
        error still reported?  yes -> callback NOT needed, leave it out
                               no  -> callback NEEDED, put it back
The result is a minimal set of memory callbacks that still detects the error.

Only memory callbacks (PPDCV_MemRCallback / PPDCV_MemWCallback) are removed:
each one is a single standalone line, so deleting it always gives valid IR.
Function callbacks (PPDCV_FunctionCallback) replace the MPI call itself and
are left untouched for now.

Usage (inside `make shell`, from the repo root):
    python3 scripts/minimize.py results/<test-name>/full.ll [--ranks 2]

A test whose full instrumentation reports no violation (e.g. a .correct
version) is only recorded in summary.csv with violation_with_full=False.

Writes:
    results/<test-name>/minimal.ll    IR with only the needed memory callbacks
    results/<test-name>/minimize.log  one line per callback: needed or not
    results/summary.csv               one row per test (appended / updated)
"""
import argparse
import csv
import os
import re
import subprocess

HERE = os.path.dirname(os.path.abspath(__file__))
LINK = os.path.join(HERE, "cover", "link_ir.sh")
MEM_CB = re.compile(r"^\s*call void @PPDCV_Mem([RW])Callback\(i1 (true|false), ptr ([^)]+)\)(?:, !dbg !(\d+))?")
DBG_LINE = re.compile(r"^!(\d+) = !DILocation\(line: (\d+)")
VIOLATION = "Contract violation detected"


def source_lines(lines):
    """Map debug-metadata ids (!140) to source line numbers."""
    m = {}
    for l in lines:
        d = DBG_LINE.match(l)
        if d:
            m[d.group(1)] = int(d.group(2))
    return m


def detects(lines, removed, workdir, ranks):
    """Rebuild the IR without the `removed` line indices, run it, return True if CoVer reports a violation."""
    ll = os.path.join(workdir, "try.ll")
    exe = os.path.join(workdir, "try.exe")
    with open(ll, "w") as f:
        f.write("\n".join(l for i, l in enumerate(lines) if i not in removed))
    subprocess.run([LINK, ll, exe], check=True, stdout=subprocess.DEVNULL)
    cmd = ["mpiexec", "--oversubscribe", "-n", str(ranks), exe]
    if os.geteuid() == 0:  # inside the Docker container we are root
        cmd.insert(1, "--allow-run-as-root")
    run = subprocess.run(cmd,
                         stdout=subprocess.PIPE, stderr=subprocess.STDOUT,   # CoVer reports on stderr
                         text=True, timeout=120)
    return VIOLATION in run.stdout


def cleanup(workdir):
    """Remove the temporary files of the last try."""
    for tmp in ("try.ll", "try.exe"):
        if os.path.exists(os.path.join(workdir, tmp)):
            os.remove(os.path.join(workdir, tmp))


def update_summary(path, row):
    """Write/replace this test's row in results/summary.csv."""
    rows = []
    if os.path.exists(path):
        with open(path, newline="") as f:
            rows = [r for r in csv.DictReader(f) if r["test"] != row["test"]]
    rows.append(row)
    with open(path, "w", newline="") as f:
        w = csv.DictWriter(f, fieldnames=list(row.keys()))
        w.writeheader()
        w.writerows(rows)


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("ll", help="instrumented IR, e.g. results/<test>/full.ll")
    ap.add_argument("--ranks", type=int, default=2, help="number of MPI processes (default 2)")
    args = ap.parse_args()

    workdir = os.path.dirname(os.path.abspath(args.ll))
    test = os.path.basename(workdir)
    lines = open(args.ll).read().split("\n")
    dbg = source_lines(lines)
    candidates = [i for i, l in enumerate(lines) if MEM_CB.match(l)]

    summary = os.path.join(os.path.dirname(workdir), "summary.csv")
    print(f"{test}: {len(candidates)} memory callbacks")
    if not detects(lines, set(), workdir, args.ranks):
        cleanup(workdir)
        update_summary(summary, {
            "test": test,
            "violation_with_full": False,
            "mem_callbacks_total": len(candidates),
            "mem_callbacks_needed": "",
            "needed_source_lines": "",
            "needed_all_flagged_by_static": "",
        })
        print("The fully instrumented program reports no violation - nothing to minimize.")
        print(f"Wrote {summary}")
        return

    removed, log = set(), []
    for i in candidates:
        kind, flagged, ptr, dbg_id = MEM_CB.match(lines[i]).groups()
        needed = not detects(lines, removed | {i}, workdir, args.ranks)
        if not needed:
            removed.add(i)
        src = dbg.get(dbg_id, "?")
        entry = (f"IR line {i + 1:4}  {'read ' if kind == 'R' else 'write'}  {ptr:5}  "
                 f"source line {src!s:>3}  static flag={flagged:5}  -> {'NEEDED' if needed else 'not needed'}")
        log.append(entry)
        print(entry)

    with open(os.path.join(workdir, "minimal.ll"), "w") as f:
        f.write("\n".join(l for i, l in enumerate(lines) if i not in removed))
    with open(os.path.join(workdir, "minimize.log"), "w") as f:
        f.write("\n".join(log) + "\n")
    cleanup(workdir)

    needed = [e for e in log if e.endswith("NEEDED")]
    update_summary(summary, {
        "test": test,
        "violation_with_full": True,
        "mem_callbacks_total": len(candidates),
        "mem_callbacks_needed": len(needed),
        "needed_source_lines": " ".join(e.split("source line")[1].split()[0] for e in needed),
        "needed_all_flagged_by_static": all("flag=true" in e for e in needed),
    })
    print(f"\nResult: {len(needed)} of {len(candidates)} memory callbacks needed.")
    print(f"Wrote {workdir}/minimal.ll, {workdir}/minimize.log and {summary}")


if __name__ == "__main__":
    main()