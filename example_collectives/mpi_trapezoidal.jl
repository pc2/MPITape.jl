using MPI
using MPITape
using Printf

struct Params
    a::Float64
    b::Float64
    n::Int64
end

function get_arguments(rank)
    if rank == 0
        a = parse(Float64, get(ARGS, 1, "0.0"))
        b = parse(Float64, get(ARGS, 2, "0.0"))
        n = parse(Int, get(ARGS, 3, "0"))
        p = Params(a, b, n)
    else
        p = Params(0, 0, -1)
    end
    buf = MPI.Bcast!(Ref(p), MPI.COMM_WORLD)
    return buf[]
end

f(x) = x * x

function integrate(left, right, count, len)
    estimate = (f(left) + f(right)) / 2.0
    for i in 1:(count - 1)
        x = left + i * len
        estimate += f(x)
    end
    return estimate * len
end

function main()
    MPI.Init()

    rank = MPI.Comm_rank(MPI.COMM_WORLD)
    com_size = MPI.Comm_size(MPI.COMM_WORLD)
    MPI.Barrier(MPI.COMM_WORLD)

    p = get_arguments(rank)
    a, b, n = p.a, p.b, p.n

    # h and local_n are the same for all processes
    h = (b - a) / n
    local_n = n / com_size

    # compute integration boundaries for each rank
    local_a = a + rank * local_n * h
    local_b = local_a + local_n * h

    # compute integral in bounds for each rank
    local_int = integrate(local_a, local_b, local_n, h)

    # reduce: sum up all results
    MPI.Barrier(MPI.COMM_WORLD)
    total_int = MPI.Reduce(local_int, +, MPI.COMM_WORLD)

    # Master: print result
    if rank == 0
        @printf("With n = %d trapezoids, our estimate of the integral from %f to %f = %.15e\n",
                n,
                a,
                b,
                total_int)
    end

    MPI.Barrier(MPI.COMM_WORLD)
    return nothing
end

@record main() # warmup
@record main() # actual recording

rank = MPI.Comm_rank(MPI.COMM_WORLD)
# delayed printing
sleep(rank)
MPITape.print_mytape()

# save local tapes to disk
MPITape.save()

MPI.Barrier(MPI.COMM_WORLD)
if rank == 0 # on master
    # read all tapes and merge them into one
    tape_merged = MPITape.readall_and_merge()
    # print the merged tape
    MPITape.print_merged(tape_merged)
    # plot the merged tape
    display(MPITape.plot_sequence_merged(tape_merged))
    MPITape.plot_merged(tape_merged)
end
