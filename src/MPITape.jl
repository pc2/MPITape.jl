module MPITape

using MPI
using Cassette
using MacroTools
using Printf
import BSON
using DocStringExtensions

Cassette.@context MPITapeCtx

include("utils.jl")
include("mpievent.jl")
include("mpifuncs_overdubbing.jl")
include("printing.jl")
include("api.jl")
include("fileio.jl")

const TIME_START = Ref(0.0)
const TAPE = MPIEvent[]
const MYRANK = Ref(-1)

export @record

end
