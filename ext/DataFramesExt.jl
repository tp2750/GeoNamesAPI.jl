module DataFramesExt

using GeoNamesAPI, DataFrames, JSON

function __init__()
    global GeoNamesAPI.rettype = DataFrame()
end

function GeoNamesAPI.search(::DataFrame ; kwargs...)
    b1 = GeoNamesAPI.search(JSON.Object(); kwargs...)
    @info "totalResultsCount = $(b1.totalResultsCount). Use keywords  `startRow` and `maxRows` to paginate result"
    reduce(vcat, DataFrames.DataFrame.(b1.geonames), cols=:union)
end


end
