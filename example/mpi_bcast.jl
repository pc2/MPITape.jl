using MPI
using MPITape

function main()
    MPI.Init()

    d = rand(100)

    MPI.Barrier(MPI.COMM_WORLD)

    MPI.Bcast!(d,0,MPI.COMM_WORLD)

    MPI.Barrier(MPI.COMM_WORLD)
    return nothing
end

@record main() # warmup
@record main() # actual recording

rank = MPI.Comm_rank(MPI.COMM_WORLD)
MPITape.save()

MPI.Barrier(MPI.COMM_WORLD)
if rank == 0 # Master
    tape_combined = MPITape.read_combine()
    MPITape.print_combined(tape_combined)
    display(MPITape.plot_combined(tape_combined))
    readline()
end
