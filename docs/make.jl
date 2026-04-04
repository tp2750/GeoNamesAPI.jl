using GeoNamesAPI
using Documenter

DocMeta.setdocmeta!(GeoNamesAPI, :DocTestSetup, :(using GeoNamesAPI); recursive=true)

makedocs(;
    modules=[GeoNamesAPI],
    authors="Thomas Poulsen <ta.poulsen@gmail.com> and contributors",
    sitename="GeoNamesAPI.jl",
    format=Documenter.HTML(;
        canonical="https://tp2750.github.io/GeoNamesAPI.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/tp2750/GeoNamesAPI.jl",
    devbranch="main",
)
