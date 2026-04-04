module GeoNamesAPI

import HTTP, JSON, DataFrames

export search

rettype = "JSON"


function search(type=rettype ; kwargs...)
    username=get(ENV,"GEONAMES_USER","")
    url = "http://api.geonames.org/search"
    @debug kwargs
    params = mk_params(;kwargs)
    ## Add type=json unless we explicitly set type.
    ## If type != json always return String
    if :type in keys(kwargs) && kwargs[:type] != "json"
        type = "String"
    else
        params = "$params&type=json"
    end
    if :username in keys(kwargs)
        username = kwargs[:username]
    end
    username == "" && error("You need to give GeoNames user. See README for details.")
    uri = "$url?$params&username=$username"
    @debug(uri)
    r1 = HTTP.get(uri)
    b1 = r1.body
    lowercase(type) == lowercase("String") && return String(b1)
    lowercase(type) == lowercase("JSON") && return JSON.parse(b1)
    lowercase(type) == lowercase("DataFrame") && return vcat(DataFrames.DataFrame.(JSON.parse(b1).geonames)..., cols=:union)
    error("Type $type not implemented")
end

function mk_params(;kwargs...)
    params = String[]
    foreach(kwargs) do (k, v)
        push!(params,"$(HTTP.escapeuri(k))=$(HTTP.escapeuri(v))")
    end
    join(params, "&")
end

search(::Type{JSON}, username=get(ENV,"GEONAMES_USER",""); kwargs...) = JSON.parse(search(String, username; kwargs...))

end
