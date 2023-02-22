# MPITape.jl

[docs-dev-img]: https://img.shields.io/badge/docs-dev-blue.svg
[docs-dev-url]: https://carstenbauer.github.io/MPITape.jl/dev

[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-stable-url]: https://carstenbauer.github.io/MPITape.jl/stable

[ci-img]: https://git.uni-paderborn.de/pc2-ci/julia/MPITape-jl/badges/main/pipeline.svg?key_text=CI@PC2
[ci-url]: https://git.uni-paderborn.de/pc2-ci/julia/MPITape-jl/-/pipelines

[cov-img]: https://codecov.io/gh/carstenbauer/MPITape.jl/branch/main/graph/badge.svg?token=Ze61CbGoO5
[cov-url]: https://codecov.io/gh/carstenbauer/MPITape.jl

[lifecycle-img]: https://img.shields.io/badge/lifecycle-experimental-orange.svg

[code-style-img]: https://img.shields.io/static/v1?label=code%20style&message=SciML&color=9558b2&labelColor=389826
[code-style-url]: https://github.com/SciML/SciMLStyle

[formatcheck-img]: https://github.com/carstenbauer/MPITape.jl/actions/workflows/FormatCheck.yml/badge.svg
[formatcheck-url]: https://github.com/carstenbauer/MPITape.jl/actions/workflows/FormatCheck.yml

<!--
![Lifecycle](https://img.shields.io/badge/lifecycle-maturing-blue.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-stable-green.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-retired-orange.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-archived-red.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-dormant-blue.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)
-->

*Record MPI Operations on Tape*

| **Documentation**                                                               | **Build Status**                                                                                |  **Quality**                                                                                |
|:-------------------------------------------------------------------------------:|:-----------------------------------------------------------------------------------------------:|:-----------------------------------------------------------------------------------------------:|
| [![][docs-stable-img]][docs-stable-url] [![][docs-dev-img]][docs-dev-url] | [![][ci-img]][ci-url] [![][cov-img]][cov-url] | ![][lifecycle-img] [![](formatcheck-img)][formatcheck-url] [![](code-style-img)][code-style-url] |

## Quick Demo

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

## Installation

The package is not registered. You can use
```
] add MPITape
```
to add the package to your Julia environment.

## Documentation

For more information, please find the [documentation](https://carstenbauer.github.io/MPITape.jl/stable) here.

## Acknowledgements

This package is an effort of the [Paderborn Center for Parallel Computing (PC²)](https://pc2.uni-paderborn.de/), a national HPC center in Germany.
