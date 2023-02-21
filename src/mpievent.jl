struct MPIEvent{F, I}
    f::F            # function
    args::I         # arguments or other extra information
    t::Float64      # start-time
    t_end::Float64  # end time
    rank::Int64     # ranks
end

functype(mpievent::MPIEvent{F, I}) where {F, I} = F

function Base.show(io::IO, ::MIME"text/plain", ev::MPIEvent)
    summary(io, ev)
    println(io)
    println(io, "├ Rank: ", ev.rank)
    println(io, "├ Function: ", ev.f)
    println(io, "├ Args: ", isempty(ev.args) ? "none" : ev.args)
    println(io, "└ Start Time: ", ev.t)
    print(io, "└ End Time: ", ev.t_end)
end

function Base.show(io::IO, ev::MPIEvent)
    print(io, "MPITape.MPIEvent($(ev.f), ..., $(ev.t), $(ev.t_end), $(ev.rank))")
end

getsrcdest(ev::MPIEvent) = getsrcdest(ev.f, ev)
function getsrcdest(::Union{typeof(MPI.Send), typeof(MPI.send), typeof(MPI.Isend)},
                    mpievent)
    src = mpievent.rank
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
    dest = mpievent.rank
    src = nothing
    if mpievent.args isa Tuple
        src = mpievent.args[2]
    elseif mpievent
        src = mpievent.args[:source]
    end
    return (; src, dest)
end
