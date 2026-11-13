# mpi-verification-instrumentation
A tool for evaluating and verifying necessary instrumentation in MPI applications.

# setup
Everything runs inside a Docker container with LLVM 22, OpenMPI and CoVer, so the setup is the same on every system. The first build compiles OpenMPI and CoVer and takes about 30-60 minutes.

## requirements

**macOS**
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (Apple Silicon or Intel version)
- Git and Make: `xcode-select --install`

**Windows**
- WSL 2 with Ubuntu: in PowerShell (as admin) run `wsl --install -d Ubuntu-24.04`, then restart
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) with *WSL integration -> Ubuntu* turned on (under *Settings* or *Settings -> Resources*)
- In Ubuntu: `sudo apt install -y git make`
- Run **all** commands in the Ubuntu terminal, and keep the repo inside the Ubuntu home folder (e.g. `~/projects`), not under `/mnt/c/`. Builds are much faster there and line endings stay correct.

Docker Desktop must be running whenever you use the project.

## build the environment

```bash
    git clone https://github.com/tuoreste/evaluating-necessary-instrumentation-for-verification.git
    cd evaluating-necessary-instrumentation-for-verification

    make check              # checks Git, Docker and Buildx
    make sources            # checks CoVer and MPI-BugBench; prints the clone commands if missing
    make start BUILD_JOBS=4 # builds the Docker image "cover-lab"
```

- Run the two `git clone` commands that `make sources` prints, then run `make sources` again.
- `BUILD_JOBS` is the number of parallel build jobs. 4 works with ~16 GB of RAM available to Docker; if the build stops with `Killed`, use `BUILD_JOBS=2`.
- If the build fails, `make errors` shows the relevant lines of `cover-build.log`.

## check that it works

```bash
    make shell  # opens a terminal inside the container
    CoVerCXX --predefined-contracts --instrument-contracts=full -DBUGGY tests/mpi_smoke.cpp -o /tmp/smoke_bug
    mpiexec -n 2 /tmp/smoke_bug
```

CoVer should report `Local Data Race - Local read`. Without `-DBUGGY`, no violation is reported. Leave the container with `exit`.

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

