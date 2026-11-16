# data-race-read
MPI programs where a buffer is read before the non-blocking operation on it has completed (e.g. read after `MPI_Irecv`, before `MPI_Wait`). Each test has a `.buggy.c` and a `.correct.c` version.
