
#include <mpi.h>
#include <iostream>

int main(int argc, char** argv) {
    MPI_Init(&argc, &argv);

    int rank;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    int value = 0;

    if (rank == 0) {
        value = 42;
        MPI_Send(&value, 1, MPI_INT, 1, 0, MPI_COMM_WORLD);
    }
    else if (rank == 1) {
        MPI_Request request;
        MPI_Irecv(&value, 1, MPI_INT, 0, 0, MPI_COMM_WORLD, &request);

#ifdef BUGGY
        // invalid try, access buffer before completing
        std::cout << "Early read: " << value << '\n';
#endif

        MPI_Wait(&request, MPI_STATUS_IGNORE);
        std::cout << "Received: " << value << '\n';
    }

    MPI_Finalize();
    return 0;
}


