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
