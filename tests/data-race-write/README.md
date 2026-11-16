# data-race-write
MPI programs where a buffer is written before the non-blocking operation on it has completed (e.g. write after `MPI_Isend`, before `MPI_Wait`). Each test has a `.buggy.c` and a `.correct.c` version.
