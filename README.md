# mpi-verification-instrumentation
A tool for evaluating and verifying necessary instrumentation in MPI applications.

# usage
(basic command structure)

run a CoVer container interactive terminal along with local files(or make shell)

```bash
    docker run --rm -it -v "$PWD:/workspace" -w /workspace cover-lab:latest bash
```

inside container run mpi

```bash
    mpicxx tests/mpi_smoke.cpp -o /tmp/mpi_smoke
    mpiexec -n 2 /tmp/mpi_smoke
```

the instrumentation

```bash
CoVerCXX --predefined-contracts --instrument-contracts=full tests/mpi_smoke.cpp -o /tmp/mpi_cover

mpiexec -n 2 /tmp/mpi_cover

```
