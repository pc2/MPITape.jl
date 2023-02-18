const COLORS = [:white, :yellow, :blue, :green, :red, :magenta, :cyan]

_timestr(time) = @sprintf("%.2E", time)

function _print_tape_func(::Any, mpievent; showrank = false, prefix = "\t", color = :normal)
    tstr = "(Δt=" * _timestr(mpievent.t) * ")"
    fargsstr = _fargs_str(mpievent.f, mpievent)
    fstr = rpad(string(mpievent.f) * fargsstr, 20)
    rstr = showrank ? string(mpievent.rank, ": ") : ""
    # println(prefix, rstr, fstr, tstr)
    printstyled(prefix, rstr, fstr, tstr, "\n"; color)
end
_fargs_str(::Any, ::Any) = ""
function _fargs_str(::Union{typeof(MPI.Send), typeof(MPI.send), typeof(MPI.Isend)},
                    mpievent)
    src, dest = getsrcdest(mpievent)
    if !isnothing(dest) && !isnothing(src)
        return " -> $dest"
    end
    return ""
end
function _fargs_str(::Union{typeof(MPI.Recv), typeof(MPI.Recv!), typeof(MPI.recv)},
                    mpievent)
    src, dest = getsrcdest(mpievent)
    if !isnothing(dest) && !isnothing(src)
        return " <- $src"
    end
    return ""
end

function print_tape(; showrank = false)
    rank = getrank()
    println("Rank: ", rank)
    for mpievent in unsafe_gettape()
        _print_tape_func(mpievent.f, mpievent; showrank)
    end
    println()
    return nothing
end

function print_combined(tape = read_combine(); color = true)
    nranks = length(unique(ev.rank for ev in tape))
    printstyled("Combined Tape of ", nranks, " MPI Ranks: \n"; color = :white, bold = true)
    usecolors = color && nranks <= length(COLORS)
    for mpievent in tape
        _print_tape_func(mpievent.f, mpievent; showrank = true,
                         color = usecolors ? COLORS[mpievent.rank + 1] : :normal)
    end
    return nothing
end
