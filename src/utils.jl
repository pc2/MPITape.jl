function getrank(; comm = MPI.COMM_WORLD)
    if MYRANK[] == -1 # first time we run this
        MPI.Initialized() || MPI.Init()
        MYRANK[] = MPI.Comm_rank(comm)
    end
    return MYRANK[]
end

function getcommsize(; comm = MPI.COMM_WORLD)
    if GLOBAL_COMM_SIZE[] == -1 # first time we run this
        MPI.Initialized() || MPI.Init()
        GLOBAL_COMM_SIZE[] = MPI.Comm_size(comm)
    end
    return GLOBAL_COMM_SIZE[]
end