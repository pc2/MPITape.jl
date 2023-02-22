using Documenter
using DocThemePC2
using MPITape

const ci = get(ENV, "CI", "") == "true"

@info "Preparing DocThemePC2"
DocThemePC2.install(@__DIR__)

@info "Generating Documenter.jl site"
makedocs(;
         sitename = "MPITape.jl",
         authors = "Carsten Bauer",
         modules = [MPITape],
         checkdocs = :exports,
         # doctest = ci,
         pages = [
             "MPITape" => "index.md",
             "Examples" => [
                 "TBD" => "examples/ex_basics.md",
             ],
             "References" => [
                 "API" => "refs/api.md",
             ],
         ],
         # assets = ["assets/custom.css", "assets/custom.js"]
         repo = "https://github.com/pc2/MPITape.jl/blob/{commit}{path}#{line}",
         format = Documenter.HTML(; collapselevel = 1))

if ci
    @info "Deploying documentation to GitHub"
    deploydocs(;
               repo = "github.com/pc2/MPITape.jl.git",
               devbranch = "main",
               push_preview = true
               # target = "site",
               )
end
