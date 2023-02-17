verbose() = false
gettape() = copy(TAPE)
unsafe_gettape() = TAPE
reset() = empty!(unsafe_gettape())

function record(f, args...)
    MPITape.reset()
    MPI.Initialized() && MPI.Barrier(MPI.COMM_WORLD)
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
