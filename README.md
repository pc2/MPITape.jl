# MPITape

```julia
using MPI
using MPITape

function your_mpi_code()
    # Your MPI Code...
end

@record your_mpi_code()
MPITape.print_tape()
```

See `example/` for an actual example.