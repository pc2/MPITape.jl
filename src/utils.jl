function getrank(; comm = MPI.COMM_WORLD)
    if MYRANK[] == -1 # first time we run this
        mpi_maybeinit()
        MYRANK[] = MPI.Comm_rank(comm)
    end
    return MYRANK[]
end

function mpi_maybeinit()
    MPI.Initialized() || MPI.Init()
    return nothing
end

function mpi_check_not_finalized()
    !MPI.Finalized() || error("MPI already finalized.")
    return nothing
end
