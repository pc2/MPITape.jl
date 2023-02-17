# MPITape

```julia
using MPI
using MPITape

function your_mpi_code()
    # Your MPI Code...
end

@record your_mpi_code()
MPITape.print_tape()
# MPITape.save()
```

See `example/` for an actual example which leads to an output like this:

```
With n = 100000 trapezoids, our estimate of the integral from 0.000000 to 1.000000 is 3.333333333500e-01 (exact: 0.333333)
With n = 100000 trapezoids, our estimate of the integral from 0.000000 to 1.000000 is 3.333333333500e-01 (exact: 0.333333)
Rank: 0
	Init                (Δt=1.52E-06)
	Barrier             (Δt=3.03E-06)
	Send -> 1           (Δt=2.00E-05)
	Send -> 1           (Δt=2.05E-05)
	Send -> 1           (Δt=2.05E-05)
	Send -> 2           (Δt=2.10E-05)
	Send -> 2           (Δt=2.11E-05)
	Send -> 2           (Δt=2.12E-05)
	Send -> 3           (Δt=2.14E-05)
	Send -> 3           (Δt=2.15E-05)
	Send -> 3           (Δt=2.17E-05)
	Send -> 4           (Δt=2.18E-05)
	Send -> 4           (Δt=2.20E-05)
	Send -> 4           (Δt=2.21E-05)
	Recv <- 1           (Δt=7.89E-05)
	Recv <- 2           (Δt=9.94E-05)
	Recv <- 3           (Δt=9.98E-05)
	Recv <- 4           (Δt=1.00E-04)
	Barrier             (Δt=1.36E-04)

Rank: 1
	Init                (Δt=8.98E-06)
	Barrier             (Δt=1.13E-05)
	Recv <- 0           (Δt=1.60E-05)
	Recv <- 0           (Δt=2.85E-05)
	Recv <- 0           (Δt=3.13E-05)
	Send -> 0           (Δt=9.80E-05)
	Barrier             (Δt=9.85E-05)

Rank: 2
	Init                (Δt=1.07E-05)
	Barrier             (Δt=1.30E-05)
	Recv <- 0           (Δt=1.56E-05)
	Recv <- 0           (Δt=2.88E-05)
	Recv <- 0           (Δt=3.15E-05)
	Send -> 0           (Δt=9.65E-05)
	Barrier             (Δt=9.70E-05)

Rank: 3
	Init                (Δt=1.01E-05)
	Barrier             (Δt=1.27E-05)
	Recv <- 0           (Δt=1.59E-05)
	Recv <- 0           (Δt=2.82E-05)
	Recv <- 0           (Δt=3.12E-05)
	Send -> 0           (Δt=9.58E-05)
	Barrier             (Δt=9.62E-05)

Rank: 4
	Init                (Δt=1.07E-05)
	Barrier             (Δt=1.33E-05)
	Recv <- 0           (Δt=1.52E-05)
	Recv <- 0           (Δt=3.02E-05)
	Recv <- 0           (Δt=3.35E-05)
	Send -> 0           (Δt=1.00E-04)
	Barrier             (Δt=1.01E-04)
```
