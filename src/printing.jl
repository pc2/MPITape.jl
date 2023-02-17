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
