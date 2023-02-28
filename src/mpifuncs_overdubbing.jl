# function get_mpi_functions()
#     syms = filter(x -> startswith(string(x), "MPI_"), names(MPI.API; all = true))
#     objs = getfield.(Ref(MPI.API), syms)
#     funcs = filter(x -> x isa Function, objs)
#     return funcs
# end
# const MPIFunctions = get_mpi_functions()

const MPIFunctions = [
    MPI.API.MPI_Init => (),
    MPI.API.MPI_Send => (:rank, :(args[4])),
    MPI.API.MPI_Isend => (:rank, :(args[4])),
    MPI.API.MPI_Recv => (:(args[4]), :rank),
    MPI.API.MPI_Irecv => (:(args[4]), :rank),
    MPI.API.MPI_Sendrecv => (:(args[9]), :(args[4])),
    MPI.API.MPI_Isendrecv => (:(args[9]), :(args[4])),
    MPI.API.MPI_Bcast => (:(args[4]), "all"),
    MPI.API.MPI_Ibcast => (:(args[4]), "all"),
    MPI.API.MPI_Gather => ("each", :(args[7])),
    MPI.API.MPI_Gatherv => ("each", :(args[8])),
    MPI.API.MPI_Igather => ("each", :(args[7])),
    MPI.API.MPI_Igatherv => ("each", :(args[8])),
    MPI.API.MPI_Scatter => (:(args[7]), "each"),
    MPI.API.MPI_Scatterv => (:(args[8]), "each"),
    MPI.API.MPI_Iscatter => (:(args[7]), "each"),
    MPI.API.MPI_Iscatterv => (:(args[8]), "each"),
    MPI.API.MPI_Allgather => ("each", "all"),
    MPI.API.MPI_Allgatherv => ("each", "all"),
    MPI.API.MPI_Iallgather => ("each", "all"),
    MPI.API.MPI_Iallgatherv => ("each", "all"),
    MPI.API.MPI_Alltoall => ("all", "all"),
    MPI.API.MPI_Ialltoall => ("all", "all"),
    MPI.API.MPI_Alltoallv => ("all", "all"),
    MPI.API.MPI_Ialltoallv => ("all", "all"),
    MPI.API.MPI_Reduce => ("all", :(args[6])),
    MPI.API.MPI_Ireduce => ("all", :(args[6])),
    MPI.API.MPI_Allreduce => ("all", "all"),
    MPI.API.MPI_Iallreduce => ("all", "all"),
    MPI.API.MPI_Scan => ("some", "all"),
    MPI.API.MPI_Iscan => ("some", "all"),
    MPI.API.MPI_Barrier => (),
    MPI.API.MPI_Wait => (),
    MPI.API.MPI_Waitall => (),
    MPI.API.MPI_Finalize => (),
    # MPI.API.MPI_Put,
    # MPI.API.MPI_Get,
    # MPI.API.MPI_Win_create,
    # MPI.API.MPI_Win_create_dynamic,
    # MPI.API.MPI_Win_fence,
    # MPI.API.MPI_Win_lock,
    # MPI.API.MPI_Win_unlock,
    # MPI.API.MPI_free,
    # MPI.API.MPI_Dist_graph_create,
    # MPI.API.MPI_Dist_graph_create_adjacent,
    # MPI.API.MPI_Dist_graph_neighbors_count,
    # MPI.API.MPI_Dist_graph_neighbors,
    # MPI.API.MPI_Neighbor_allgather!,
    # MPI.API.MPI_Neighbor_allgatherv!,
    # MPI.API.MPI_Neighbor_alltoall,
    # MPI.API.MPI_Neighbor_alltoall!,
    # MPI.API.MPI_Neighbor_alltoallv!,
]

for (mpifunc, srcdest) in MPIFunctions
    if isempty(srcdest)
        # fallback: no argvals
        args_quote = quote
            argvals = ()
        end
    else
        src = srcdest[1]
        dest = srcdest[2]
        args_quote = quote
            argvals = (; src = $(src), dest = $(dest))
        end
    end

    eval(quote
             function Cassette.overdub(ctx::MPITapeCtx, f::typeof($mpifunc), args...)
                 rank = getrank()
                 argtypes = typeof.(args)
                 $args_quote
                 verbose() && println("OVERDUBBING: ", f, argtypes)
                 start_time = MPI.Wtime() - TIME_START[]
                 ret = f(args...)
                 push!(TAPE,
                       MPIEvent(rank,
                                string(f),
                                argtypes,
                                argvals,
                                start_time,
                                MPI.Wtime() - TIME_START[]))
                 return ret
             end
         end)
end
