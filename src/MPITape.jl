module MPITape

using MPI
using Cassette
using MacroTools

verbose() = false

Cassette.@context MPITapeCtx

struct MPIEvent{F, I}
    t::Float64  # time
    f::F        # function
    info::I     # extra information
end

const t_start = Ref(0.0)
const tape = MPIEvent[]

# maybe use names(MPI; all=true) at some point
const MPIFunctions = [
    MPI.Init,
    MPI.Send,
    MPI.Recv,
    MPI.Recv!,
    MPI.Sendrecv!,
    MPI.Bcast,
    MPI.Bcast!,
    MPI.Reduce,
    MPI.Reduce!,
]

for mpifunc in MPIFunctions
    eval(quote
             function Cassette.overdub(ctx::MPITapeCtx, f::typeof($mpifunc), args...)
                 argtypes = typeof.(args)
                 verbose() && println("OVERDUBBING: ", f, argtypes)
                 push!(tape, MPIEvent(time() - t_start[], f, args))
                 # return Cassette.recurse(ctx, f, args...)
                 return f(args...)
             end
         end)
end

reset() = empty!(tape)

function record(f, args...)
    MPITape.reset()
    t_start[] = time()
    result = Cassette.overdub(MPITapeCtx(), f, args...)
    return result
end

macro record(ex)
    @capture(ex, f_(args__))
    esc(quote
            MPITape.record($f, $(args)...)
        end)
end

function print_tape()
    rank = MPI.Comm_rank(MPI.COMM_WORLD)
    println("Rank: ", rank)
    for mpievent in tape
        println("\t", "Func: ", mpievent.f, "  Time: ", mpievent.t)
    end
    println()
    return nothing
end

export @record

end
