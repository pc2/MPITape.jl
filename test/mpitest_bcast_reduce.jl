using MPITape
using MPI
using Kroki
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
@test isnothing(MPITape.save())
if rank == 0 # Master
    tape_merged = MPITape.readall_and_merge()
    @test typeof(tape_merged) == Vector{MPITape.MPIEvent}
    @test isnothing(MPITape.print_merged(tape_merged))
    @test typeof(MPITape.plot_sequence_merged(tape_merged)) == Kroki.Diagram
    @test isnothing(MPITape.plot_merged(tape_merged))
end
