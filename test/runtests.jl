using MPITape
using MPI
using Test

testdir = @__DIR__
testfiles = sort(filter(startswith("mpitest_"), readdir(testdir)))
nprocs = clamp(Sys.CPU_THREADS, 2, 5)

atexit(MPITape.cleanup) # rm tape files

@testset "All Tests" begin
    # run all mpitest_* named files under MPI
    @testset "$f" for f in testfiles
        mpiexec() do mpirun
            function cmd(n = nprocs)
                `$mpirun -n $n --oversubscribe $(Base.julia_cmd()) --startup-file=no $(joinpath(testdir, f))`
            end
            run(cmd())
            @test true
        end
    end
end
