function getrank(; comm = MPI.COMM_WORLD)
    if MYRANK[] == -1 # first time we run this
        MPI.Initialized() || MPI.Init()
        MYRANK[] = MPI.Comm_rank(comm)
    end
    return MYRANK[]
end
