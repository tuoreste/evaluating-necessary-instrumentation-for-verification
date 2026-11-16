// Error class: Local Data Race - Local write
// Rank 0 overwrites the send buffer of a non-blocking MPI_Isend BEFORE MPI_Wait.
// Expected CoVer report: "Local Data Race - Local write".
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
        buf = 7;                                    // BUG: send may not be finished yet
        MPI_Wait(&req, MPI_STATUS_IGNORE);
    } else if (rank == 1) {
        MPI_Recv(&buf, 1, MPI_INT, 0, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        printf("rank 1 received: %d\n", buf);
    }

    MPI_Finalize();
    return 0;
}
