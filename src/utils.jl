function getrank(; comm = MPI.COMM_WORLD)
    MPI.Initialized() || MPI.Init()
    MPI.Comm_rank(comm)
end
