// Correct twin of isend-write-before-wait.buggy.c:
// the send buffer is only changed AFTER MPI_Wait. Expected CoVer report: none.
#include <mpi.h>
#include <stdio.h>

int main(int argc, char **argv) {
    MPI_Init(&argc, &argv);
    int rank, buf = 0;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    if (rank == 0) {
        MPI_Request req;
        buf = 42;
        MPI_Isend(&buf, 1, MPI_INT, 1, 0, MPI_COMM_WORLD, &req);
        MPI_Wait(&req, MPI_STATUS_IGNORE);
        buf = 7;                                    // OK: after MPI_Wait
    } else if (rank == 1) {
        MPI_Recv(&buf, 1, MPI_INT, 0, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        printf("rank 1 received: %d\n", buf);
    }

    MPI_Finalize();
    return 0;
}
