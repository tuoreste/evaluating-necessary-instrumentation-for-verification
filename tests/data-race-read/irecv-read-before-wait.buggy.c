// Error class: Local Data Race - Local read
// Rank 1 reads the receive buffer of a non-blocking MPI_Irecv BEFORE MPI_Wait.
// Expected CoVer report: "Local Data Race - Local read".
#include <mpi.h>
#include <stdio.h>

int main(int argc, char **argv) {
    MPI_Init(&argc, &argv);
    int rank, buf = 0;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    if (rank == 0) {
        buf = 42;
        MPI_Send(&buf, 1, MPI_INT, 1, 0, MPI_COMM_WORLD);
    } else if (rank == 1) {
        MPI_Request req;
        MPI_Irecv(&buf, 1, MPI_INT, 0, 0, MPI_COMM_WORLD, &req);
        printf("rank 1 read: %d\n", buf);          // BUG: buf may not be received yet
        MPI_Wait(&req, MPI_STATUS_IGNORE);
    }

    MPI_Finalize();
    return 0;
}
