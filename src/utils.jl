function getrank(; comm = MPI.COMM_WORLD)
    if MYRANK[] == -1 # first time we run this
        mpi_maybeinit()
        MYRANK[] = MPI.Comm_rank(comm)
    end
    return MYRANK[]
end

function getcommsize(; comm = MPI.COMM_WORLD)
    if GLOBAL_COMM_SIZE[] == -1 # first time we run this
        mpi_maybeinit()
        GLOBAL_COMM_SIZE[] = MPI.Comm_size(comm)
    end
    return GLOBAL_COMM_SIZE[]
end

function mpi_maybeinit()
    MPI.Initialized() || MPI.Init()
    return nothing
end

function mpi_check_not_finalized()
    !MPI.Finalized() || error("MPI already finalized.")
    return nothing
end
