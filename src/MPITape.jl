module MPITape

using MPI
using Cassette
using MacroTools
using Printf
import JLD2

verbose() = false

Cassette.@context MPITapeCtx

struct MPIEvent{F, I}
    f::F        # function
    info::I     # extra information
    t::Float64  # time
end

functype(mpievent::MPIEvent{F, I}) where {F, I} = F

function Base.show(io::IO, ::MIME"text/plain", ev::MPIEvent)
    summary(io, ev)
    println(io)
    println(io, "├ Function: ", ev.f)
    println(io, "├ Args: ", isempty(ev.info) ? "none" : ev.info)
    print(io, "└ Time: ", ev.t)
end

function Base.show(io::IO, ev::MPIEvent)
    print(io, "MPITape.MPIEvent($(ev.f), ..., $(ev.t))")
end

const TIME_START = Ref(0.0)
const TAPE = MPIEvent[]

gettape() = copy(TAPE)
unsafe_gettape() = TAPE

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
                 push!(TAPE, MPIEvent(f, args, MPI.Wtime() - TIME_START[]))
                 # return Cassette.recurse(ctx, f, args...)
                 return f(args...)
             end
         end)
end

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

function getrank(; comm = MPI.COMM_WORLD)
    MPI.Initialized() || MPI.Init()
    MPI.Comm_rank(comm)
end

getsrcdest(ev::MPIEvent) = getsrcdest(ev.f, ev)
function getsrcdest(::Union{typeof(MPI.Send), typeof(MPI.send), typeof(MPI.Isend)},
                    mpievent)
    src = getrank()
    dest = nothing
    if mpievent.info isa Tuple
        dest = mpievent.info[2]
    elseif mpievent
        dest = mpievent.info[:dest]
    end
    return (; src, dest)
end
function getsrcdest(::Union{typeof(MPI.Recv), typeof(MPI.Recv!)},
                    mpievent)
    dest = getrank()
    src = nothing
    if mpievent.info isa Tuple
        src = mpievent.info[2]
    elseif mpievent
        src = mpievent.info[:dest]
    end
    return (; src, dest)
end

_timestr(time) = @sprintf("%.2E", time)
_funcstr(f) = rpad(f, 20)

function _print_tape_func(::Any, mpievent)
    tstr = _timestr(mpievent.t)
    fstr = _funcstr(mpievent.f)
    println("\t", fstr, "(Δt=", tstr, ")")
end
function _print_tape_func(::Union{typeof(MPI.Send), typeof(MPI.send), typeof(MPI.Isend)},
                          mpievent)
    src, dest = getsrcdest(mpievent)
    if isnothing(dest) || isnothing(src)
        fstr = _funcstr(mpievent.f)
    else
        fstr = _funcstr(string(mpievent.f) * " -> $dest")
    end
    tstr = _timestr(mpievent.t)
    println("\t", fstr, "(Δt=", tstr, ")")
end
function _print_tape_func(::Union{typeof(MPI.Recv), typeof(MPI.Recv!), typeof(MPI.recv)},
                          mpievent)
    src, dest = getsrcdest(mpievent)
    if isnothing(dest) || isnothing(src)
        fstr = _funcstr(mpievent.f)
    else
        fstr = _funcstr(string(mpievent.f) * " <- $src")
    end
    tstr = _timestr(mpievent.t)
    println("\t", fstr, "(Δt=", tstr, ")")
end

function print_tape()
    rank = getrank()
    println("Rank: ", rank)
    for mpievent in unsafe_gettape()
        _print_tape_func(mpievent.f, mpievent)
    end
    println()
    return nothing
end

default_fname() = "tape_rank$(getrank()).jld2"

function save(fname = default_fname())
    JLD2.save(fname, "tape", unsafe_gettape())
    return nothing
end

function load(fname = default_fname())
    tape_from_file = JLD2.load(fname, "tape")
    resize!(unsafe_gettape(), length(tape_from_file))
    copyto!(unsafe_gettape(), tape_from_file)
    return gettape()
end

export @record

end
