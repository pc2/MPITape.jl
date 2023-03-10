# MPITape.jl

[docs-dev-img]: https://img.shields.io/badge/docs-dev-blue.svg
[docs-dev-url]: https://pc2.github.io/MPITape.jl/dev

[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-stable-url]: https://pc2.github.io/MPITape.jl/stable

[ci-img]: https://git.uni-paderborn.de/pc2-ci/julia/MPITape-jl/badges/main/pipeline.svg?key_text=CI@PC2
[ci-url]: https://git.uni-paderborn.de/pc2-ci/julia/MPITape-jl/-/pipelines

<!-- [cov-img]: https://codecov.io/gh/pc2/MPITape.jl/branch/main/graph/badge.svg?token=Ze61CbGoO5 -->
[cov-img]: https://codecov.io/gh/pc2/MPITape.jl/branch/main/graph/badge.svg?token=9x4JGFEzzu
[cov-url]: https://codecov.io/gh/pc2/MPITape.jl

[lifecycle-img]: https://img.shields.io/badge/lifecycle-experimental-orange.svg

[code-style-img]: https://img.shields.io/static/v1?label=code%20style&message=SciML&color=9558b2&labelColor=389826
[code-style-url]: https://github.com/SciML/SciMLStyle

[formatcheck-img]: https://github.com/pc2/MPITape.jl/actions/workflows/FormatCheck.yml/badge.svg
[formatcheck-url]: https://github.com/pc2/MPITape.jl/actions/workflows/FormatCheck.yml

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
| [![][docs-stable-img]][docs-stable-url] [![][docs-dev-img]][docs-dev-url] | [![][ci-img]][ci-url] [![][cov-img]][cov-url] | ![][lifecycle-img] [![][formatcheck-img]][formatcheck-url] |

## Quick Demo

```julia
using MPI
using MPITape

function your_mpi_code()
    # Your MPI Code...
end

@record your_mpi_code()

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
    # plot the merged tape (beta)
    # display(MPITape.plot_sequence_merged(tape_merged))
    # MPITape.plot_merged(tape_merged)
end

```

See `example/` for an actual example which leads to outputs like this:

```
Rank: 0
    Init                (??t=1.37E-06)
    Barrier             (??t=3.27E-06)
    Send -> 1           (??t=2.30E-05)
    Send -> 1           (??t=2.35E-05)
    Send -> 1           (??t=2.36E-05)
    Send -> 2           (??t=2.40E-05)
    Send -> 2           (??t=2.40E-05)
    Send -> 2           (??t=2.42E-05)
    Send -> 3           (??t=2.44E-05)
    Send -> 3           (??t=2.46E-05)
    Send -> 3           (??t=2.47E-05)
    Send -> 4           (??t=2.49E-05)
    Send -> 4           (??t=2.51E-05)
    Send -> 4           (??t=2.53E-05)
    Recv <- 1           (??t=7.59E-05)
    Recv <- 2           (??t=9.35E-05)
    Recv <- 3           (??t=9.80E-05)
    Recv <- 4           (??t=9.84E-05)
    Barrier             (??t=1.30E-04)

Rank: 1
    Init                (??t=7.99E-06)
    Barrier             (??t=1.49E-05)
    Recv <- 0           (??t=1.81E-05)
    Recv <- 0           (??t=2.99E-05)
    Recv <- 0           (??t=3.30E-05)
    Send -> 0           (??t=9.19E-05)
    Barrier             (??t=9.25E-05)

Rank: 2
    Init                (??t=8.47E-06)
    Barrier             (??t=1.59E-05)
    Recv <- 0           (??t=1.78E-05)
    Recv <- 0           (??t=3.18E-05)
    Recv <- 0           (??t=3.48E-05)
    Send -> 0           (??t=9.60E-05)
    Barrier             (??t=9.67E-05)

Rank: 3
    Init                (??t=8.79E-06)
    Barrier             (??t=1.64E-05)
    Recv <- 0           (??t=1.90E-05)
    Recv <- 0           (??t=3.16E-05)
    Recv <- 0           (??t=3.49E-05)
    Send -> 0           (??t=9.23E-05)
    Barrier             (??t=9.30E-05)

Rank: 4
    Init                (??t=9.64E-06)
    Barrier             (??t=1.64E-05)
    Recv <- 0           (??t=1.81E-05)
    Recv <- 0           (??t=3.09E-05)
    Recv <- 0           (??t=3.39E-05)
    Send -> 0           (??t=9.58E-05)
    Barrier             (??t=9.63E-05)
```


![](https://raw.githubusercontent.com/pc2/MPITape.jl/main/example/colored_output_combined.png)

## Installation

The package is not registered. You can use
```
] add MPITape
```
to add the package to your Julia environment.

## Documentation

For more information, please find the [documentation](https://pc2.github.io/MPITape.jl/stable) here.

## Acknowledgements

This package is an effort of the [Paderborn Center for Parallel Computing (PC??)](https://pc2.uni-paderborn.de/), a national HPC center in Germany.
