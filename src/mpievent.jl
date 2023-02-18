struct MPIEvent{F, I}
    f::F        # function
    args::I     # arguments or other extra information
    t::Float64  # time
    rank::Int64 # ranks
end

functype(mpievent::MPIEvent{F, I}) where {F, I} = F

function Base.show(io::IO, ::MIME"text/plain", ev::MPIEvent)
    summary(io, ev)
    println(io)
    println(io, "├ Rank: ", ev.rank)
    println(io, "├ Function: ", ev.f)
    println(io, "├ Args: ", isempty(ev.args) ? "none" : ev.args)
    print(io, "└ Time: ", ev.t)
end

function Base.show(io::IO, ev::MPIEvent)
    print(io, "MPITape.MPIEvent($(ev.f), ..., $(ev.t), $(ev.rank))")
end

getsrcdest(ev::MPIEvent) = getsrcdest(ev.f, ev)
function getsrcdest(::Union{typeof(MPI.Send), typeof(MPI.send), typeof(MPI.Isend)},
                    mpievent)
    src = getrank()
    dest = nothing
    if mpievent.args isa Tuple
        dest = mpievent.args[2]
    elseif mpievent
        dest = mpievent.args[:dest]
    end
    return (; src, dest)
end
function getsrcdest(::Union{typeof(MPI.Recv), typeof(MPI.Recv!)},
                    mpievent)
    dest = getrank()
    src = nothing
    if mpievent.args isa Tuple
        src = mpievent.args[2]
    elseif mpievent
        src = mpievent.args[:dest]
    end
    return (; src, dest)
end
