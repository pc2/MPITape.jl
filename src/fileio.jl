default_fprefix() = "tape_rank"
default_fname() = default_fprefix() * "$(getrank()).jld2"

function save(fname = default_fname())
    JLD2.save(fname, "tape", unsafe_gettape())
    return nothing
end

function _set_tape(new_tape)
    resize!(unsafe_gettape(), length(new_tape))
    copyto!(unsafe_gettape(), new_tape)
    return nothing
end

function load(fname = default_fname())
    tape_from_file = JLD2.load(fname, "tape")
    _set_tape(tape_from_file)
    return gettape()
end

function read_combine(dir = pwd(); prefix = default_fprefix())
    filenames = filter(x -> startswith(x, prefix) && endswith(x, ".jld2"), readdir(dir))
    tape_combined = MPIEvent[]
    for fn in filenames
        f = joinpath(dir, fn)
        tape_rank = JLD2.load(f, "tape")
        append!(tape_combined, tape_rank)
    end
    sort!(tape_combined; by = x -> x.t)
    return tape_combined
end
