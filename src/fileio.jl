default_fprefix() = "rank"
default_fname() = default_fprefix() * string(getrank())
default_fext() = ".tape"
default_fname_full() = default_fname() * default_fext()

function save(fname = default_fname_full())
    serialize(fname, unsafe_gettape())
    return nothing
end

function read(fname = default_fname_full())
    tape_from_file = deserialize(fname)
    return tape_from_file
end

function load(fname = default_fname_full())
    unsafe_settape(read(fname))
    return nothing
end

"""
$(SIGNATURES)
Reads all tapes from disk and merges them into a single "merged tape".
"""
function readall_and_merge(dir = pwd(); prefix = default_fprefix())
    filenames = filter(x -> startswith(x, prefix) && endswith(x, default_fext()),
                       readdir(dir))
    tape_merged = MPIEvent[]
    for fn in filenames
        f = joinpath(dir, fn)
        append!(tape_merged, read(f))
    end
    sort!(tape_merged; by = x -> x.t_start)
    return tape_merged
end

# # Attempt to reduce tapes to master
# # (Doesn't work though because tape isn't isbitstype...)
# function merge()
#     mpi_check_not_finalized()
#     mpi_maybeinit()
#     MPI.Barrier(MPI.COMM_WORLD)
#     tape_merged = MPI.Reduce(MPITape.unsafe_gettape(), vcat, MPI.COMM_WORLD)
#     if getrank() == 0
#         # unsafe_settape(tape_merged)
#         return tape_merged
#     else
#         return nothing
#     end
# end
