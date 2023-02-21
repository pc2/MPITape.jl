# MPITape

```julia
using MPI
using MPITape

function your_mpi_code()
    # Your MPI Code...
end

@record your_mpi_code()

rank = MPI.Comm_rank(MPI.COMM_WORLD)
sleep(rank) # delayed printing
MPITape.print_mytape()

tape_merged = MPITape.merge()
if rank == 0 # Master
    MPITape.print_merged(tape_merged)
end
```

See `example/` for an actual example which leads to outputs like this:

```
Rank: 0
    Init                (Δt=1.37E-06)
    Barrier             (Δt=3.27E-06)
    Send -> 1           (Δt=2.30E-05)
    Send -> 1           (Δt=2.35E-05)
    Send -> 1           (Δt=2.36E-05)
    Send -> 2           (Δt=2.40E-05)
    Send -> 2           (Δt=2.40E-05)
    Send -> 2           (Δt=2.42E-05)
    Send -> 3           (Δt=2.44E-05)
    Send -> 3           (Δt=2.46E-05)
    Send -> 3           (Δt=2.47E-05)
    Send -> 4           (Δt=2.49E-05)
    Send -> 4           (Δt=2.51E-05)
    Send -> 4           (Δt=2.53E-05)
    Recv <- 1           (Δt=7.59E-05)
    Recv <- 2           (Δt=9.35E-05)
    Recv <- 3           (Δt=9.80E-05)
    Recv <- 4           (Δt=9.84E-05)
    Barrier             (Δt=1.30E-04)

Rank: 1
    Init                (Δt=7.99E-06)
    Barrier             (Δt=1.49E-05)
    Recv <- 0           (Δt=1.81E-05)
    Recv <- 0           (Δt=2.99E-05)
    Recv <- 0           (Δt=3.30E-05)
    Send -> 0           (Δt=9.19E-05)
    Barrier             (Δt=9.25E-05)

Rank: 2
    Init                (Δt=8.47E-06)
    Barrier             (Δt=1.59E-05)
    Recv <- 0           (Δt=1.78E-05)
    Recv <- 0           (Δt=3.18E-05)
    Recv <- 0           (Δt=3.48E-05)
    Send -> 0           (Δt=9.60E-05)
    Barrier             (Δt=9.67E-05)

Rank: 3
    Init                (Δt=8.79E-06)
    Barrier             (Δt=1.64E-05)
    Recv <- 0           (Δt=1.90E-05)
    Recv <- 0           (Δt=3.16E-05)
    Recv <- 0           (Δt=3.49E-05)
    Send -> 0           (Δt=9.23E-05)
    Barrier             (Δt=9.30E-05)

Rank: 4
    Init                (Δt=9.64E-06)
    Barrier             (Δt=1.64E-05)
    Recv <- 0           (Δt=1.81E-05)
    Recv <- 0           (Δt=3.09E-05)
    Recv <- 0           (Δt=3.39E-05)
    Send -> 0           (Δt=9.58E-05)
    Barrier             (Δt=9.63E-05)
```


![](https://raw.githubusercontent.com/carstenbauer/MPITape.jl/main/example/colored_output_combined.png)
