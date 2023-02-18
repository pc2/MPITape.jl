# maybe use names(MPI; all=true) at some point
const MPIFunctions = [
    MPI.Init,
    MPI.send,
    MPI.Send,
    MPI.Isend,
    MPI.recv,
    MPI.Recv,
    MPI.Recv!,
    MPI.Irecv!,
    MPI.Sendrecv!,
    MPI.bcast,
    MPI.Bcast,
    MPI.Bcast!,
    MPI.Scatter,
    MPI.Scatter!,
    MPI.Scatterv,
    MPI.Scatterv!,
    MPI.Gather,
    MPI.Gather!,
    MPI.Gatherv,
    MPI.Gatherv!,
    MPI.Reduce,
    MPI.Reduce!,
    MPI.Wait,
    MPI.Wait!,
    MPI.Waitall,
    MPI.Waitall!,
    MPI.Barrier,
    MPI.Iprobe,
    MPI.Test,
    MPI.Put,
    MPI.Put!,
    MPI.Get,
    MPI.Get!,
    MPI.Win_create,
    MPI.Win_create_dynamic,
    MPI.Win_fence,
    MPI.Win_lock,
    MPI.Win_unlock,
    MPI.free,
    MPI.Dist_graph_create,
    MPI.Dist_graph_create_adjacent,
    MPI.Dist_graph_neighbors_count,
    MPI.Dist_graph_neighbors!,
    MPI.Dist_graph_neighbors,
    MPI.Neighbor_allgather!,
    MPI.Neighbor_allgatherv!,
    MPI.Neighbor_alltoall,
    MPI.Neighbor_alltoall!,
    MPI.Neighbor_alltoallv!,
    MPI.Finalize,
]

for mpifunc in MPIFunctions
    eval(quote
             function Cassette.overdub(ctx::MPITapeCtx, f::typeof($mpifunc), args...)
                 argtypes = typeof.(args)
                 verbose() && println("OVERDUBBING: ", f, argtypes)
                 push!(TAPE, MPIEvent(f, args, MPI.Wtime() - TIME_START[], getrank()))
                 # return Cassette.recurse(ctx, f, args...)
                 return f(args...)
             end
         end)
end
