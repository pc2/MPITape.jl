# ] test seems to ignore the JULIA_LOAD_PATH environment
# variable :(
if haskey(ENV, "EBROOTJULIAHPC")
    push!(LOAD_PATH, ENV["EBROOTJULIAHPC"])
end
