verbose() = false
gettape() = copy(TAPE)
unsafe_gettape() = TAPE
function unsafe_settape(tape::AbstractVector{<:MPIEvent})
    resize!(unsafe_gettape(), length(new_tape))
    copyto!(unsafe_gettape(), new_tape)
    return unsafe_gettape()
end

reset() = empty!(unsafe_gettape())

"""
Holding data that is required to be exchanged between `prehook` and `posthook` 
(i.e. the start time of the call)
"""
mutable struct MPIEventTrace
    start_time::Float64
    MPIEventTrace() = new(0.0)
end

function record(f, args...)
    MPITape.reset()
    mpi_maybeinit()
    MPI.Barrier(MPI.COMM_WORLD)
    TIME_START[] = MPI.Wtime()
    result = Cassette.overdub(MPITapeCtx(metadata = MPIEventTrace()), f, args...)
    return result
end

macro record(ex)
    @capture(ex, f_(args__))
    esc(quote
            MPITape.record($f, $(args)...)
        end)
end
