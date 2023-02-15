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

See `example/` for an actual example which leads to an output like this:

```
With n = 100000 trapezoids, our estimate of the integral from 0.000000 to 1.000000 is 3.333333333500e-01 (exact: 0.333333)
With n = 100000 trapezoids, our estimate of the integral from 0.000000 to 1.000000 is 3.333333333500e-01 (exact: 0.333333)
Rank: 0
        Func: Init  Time: 2.86102294921875e-6
        Func: Send  Time: 2.09808349609375e-5
        Func: Send  Time: 3.1948089599609375e-5
        Func: Send  Time: 3.1948089599609375e-5
        Func: Send  Time: 3.2901763916015625e-5
        Func: Send  Time: 3.3855438232421875e-5
        Func: Send  Time: 3.3855438232421875e-5
        Func: Send  Time: 3.3855438232421875e-5
        Func: Send  Time: 3.504753112792969e-5
        Func: Send  Time: 3.504753112792969e-5
        Func: Send  Time: 3.504753112792969e-5
        Func: Send  Time: 3.600120544433594e-5
        Func: Send  Time: 3.600120544433594e-5
        Func: Recv  Time: 9.298324584960938e-5
        Func: Recv  Time: 0.00015687942504882812
        Func: Recv  Time: 0.00015807151794433594
        Func: Recv  Time: 0.00015807151794433594

Rank: 1
        Func: Init  Time: 5.9604644775390625e-6
        Func: Recv  Time: 8.106231689453125e-6
        Func: Recv  Time: 4.734178066253662
        Func: Recv  Time: 4.734209060668945
        Func: Send  Time: 4.734279155731201

Rank: 2
        Func: Init  Time: 4.0531158447265625e-6
        Func: Recv  Time: 5.9604644775390625e-6
        Func: Recv  Time: 4.735018968582153
        Func: Recv  Time: 4.73504900932312
        Func: Send  Time: 4.735116004943848

Rank: 3
        Func: Init  Time: 5.0067901611328125e-6
        Func: Recv  Time: 5.9604644775390625e-6
        Func: Recv  Time: 4.734997987747192
        Func: Recv  Time: 4.735026121139526
        Func: Send  Time: 4.735095024108887

Rank: 4
        Func: Init  Time: 5.9604644775390625e-6
        Func: Recv  Time: 7.867813110351562e-6
        Func: Recv  Time: 4.732148885726929
        Func: Recv  Time: 4.732177019119263
        Func: Send  Time: 4.732245922088623
```
