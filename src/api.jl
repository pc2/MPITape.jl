verbose() = false
gettape() = copy(TAPE)
unsafe_gettape() = TAPE
function unsafe_settape(tape::AbstractVector{<:MPIEvent})
    resize!(unsafe_gettape(), length(new_tape))
    copyto!(unsafe_gettape(), new_tape)
    return unsafe_gettape()
end

reset() = empty!(unsafe_gettape())

function record(f, args...)
    MPITape.reset()
    mpi_maybeinit()
    MPI.Barrier(MPI.COMM_WORLD)
    TIME_START[] = MPI.Wtime()
    result = Cassette.overdub(MPITapeCtx(), f, args...)
    return result
end

macro record(ex)
    @capture(ex, f_(args__))
    esc(quote
            MPITape.record($f, $(args)...)
        end)
end
