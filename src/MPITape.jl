module MPITape

using MPI
using Cassette
using MacroTools
using Printf
import JLD2

Cassette.@context MPITapeCtx

include("utils.jl")
include("mpievent.jl")
include("mpifuncs_overdubbing.jl")
include("printing.jl")
include("api.jl")
include("fileio.jl")
include("communication_graph.jl")
include("plotting.jl")

const TIME_START = Ref(0.0)
const TAPE = MPIEvent[]
const MYRANK = Ref(-1)
const GLOBAL_COMM_SIZE = Ref(-1)

export @record

end
