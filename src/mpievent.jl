struct MPIEvent{S, A, D}
    rank::Int64    # ranks
    f::S           # function
    argtypes::A    # arguments or other extra information
    args_subset::D # subset of argument values
    t::Float64     # time
end

function Base.show(io::IO, ::MIME"text/plain", ev::MPIEvent)
    summary(io, ev)
    println(io)
    println(io, "├ Rank: ", ev.rank)
    println(io, "├ Function: ", ev.f)
    println(io, "├ Argument Types: ", ev.argtypes)
    println(io, "├ Arguments (subset): ", isempty(ev.args_subset) ? "none" : ev.args_subset)
    print(io, "└ Time: ", ev.t)
end

function Base.show(io::IO, ev::MPIEvent)
    print(io, "MPITape.MPIEvent($(ev.rank), $(ev.f), ..., $(ev.t))")
end

function getsrcdest(ev::MPIEvent)
    if isempty(ev.args_subset)
        return nothing
    end
    if haskey(ev.args_subset, :src) && haskey(ev.args_subset, :dest)
        return (; src = ev.args_subset[:src], dest = ev.args_subset[:dest])
    end
    return nothing
end
