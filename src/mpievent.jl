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
