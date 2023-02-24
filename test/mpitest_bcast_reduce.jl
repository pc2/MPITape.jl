using MPITape
using MPI
using Test

MPI.Init()
rank = MPI.Comm_rank(MPI.COMM_WORLD)

function basic_communication()
    MPI.Init()
    comm = MPI.COMM_WORLD
    rank = MPI.Comm_rank(comm)
    N = 5
    root = 0
    if rank == root
        A = [i * (1.0 + im * 2.0) for i in 1:N]
    else
        A = Array{ComplexF64}(undef, N)
    end
    MPI.Bcast!(A, root, comm)
    sum_local = sum(A)
    MPI.Reduce(sum_local, +, comm)
    MPI.Barrier(comm)
end

@test isnothing(@record basic_communication())
@test isnothing(MPITape.print_mytape())
tape_merged = MPITape.merge()
if rank == 0 # Master
    @test typeof(tape_merged) == Vector{MPITape.MPIEvent}
    @test isnothing(MPITape.print_merged(tape_merged))
else
    @test isnothing(tape_merged)
end
