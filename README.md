# GeoNamesAPI

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://tp2750.github.io/GeoNamesAPI.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://tp2750.github.io/GeoNamesAPI.jl/dev/)
[![Build Status](https://github.com/tp2750/GeoNamesAPI.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/tp2750/GeoNamesAPI.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Aqua](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)

GeoNamesAPI provides a simple access to the [GeoNames](https://www.geonames.org/) [web service](https://www.geonames.org/export/web-services.html).

You need to [register a username](https://www.geonames.org/login) with GeoNames to use the service.
After you create the username, you need at activate it on the [account page](https://www.geonames.org/manageaccount).

It is recommended to store the username as an environement variable in your `~/.julia/config/startup.jl` file:

``` julia
ENV["GEONAMES_USER"]="yourusername"
```

Then you can access the service using the API as described in GeoNames [documentation](https://www.geonames.org/export/geonames-search.html).

``` julia
using GeoNamesAPI
search(q="paris", maxRows=10)
# JSON.Object{String, Any} with 2 entries:
#   "totalResultsCount" => 13412672
#   "geonames"          => Any[Object{String, Any}("adminCode1"=>"11", "lng"=>"47.51667", "geonameId"=>1062605, "toponymName"=>"Mahamasina", "…

```

If you do not store you username in the environment, you can give it as argument to the function

``` julia
search(q="paris", maxRows=10, username="yourusername")
```

Results are returned as JSON by default.
If you want to parse the result yourself, you can get it as String

``` julia
search("String",q="paris", maxRows=10)
# "{\"totalResultsCount\":13412672,\"geonames\":[{\"adminCode1\":\"11\",\"lng\":\"47.51667\",\"geonameId\":1062605,\"toponymName\":\"Mahamasina\",\"countryId\":\"1062947\",\"fcl\":\"P\",\"population\":0,\"countryCode\":\"MG\",\"name\":\"Mahamasina\",\"fclName\":\"city, village,...\",\"countryName\":\"Madagascar\",\"fcodeName\":\"section of populated place\",\"adminName1\":\"Analamanga\",\"lat\":\"-18.9\",\"fcode\":\"PPLX\"},{\"adminCode1\":\"21\",\"lng\":\"46.9\",\"geonameId\":1062606,\"toponymName\":\"Mahamasina\",\"countryId\":\"1062947\",\"fcl\":\"P\",\"populat" ⋯ 2169 bytes ⋯ "e\":\"MG\",\"name\":\"Mahamanaha\",\"fclName\":\"city, village,...\",\"countryName\":\"Madagascar\",\"fcodeName\":\"populated place\",\"adminName1\":\"Alaotra Mangoro\",\"lat\":\"-18.91667\",\"fcode\":\"PPL\"},{\"adminCode1\":\"53\",\"lng\":\"46.13333\",\"geonameId\":1062614,\"toponymName\":\"Mahamana\",\"countryId\":\"1062947\",\"fcl\":\"P\",\"population\":0,\"countryCode\":\"MG\",\"name\":\"Mahamana\",\"fclName\":\"city, village,...\",\"countryName\":\"Madagascar\",\"fcodeName\":\"populated place\",\"adminName1\":\"Anosy\",\"lat\":\"-23.35\",\"fcode\":\"PPL\"}]}"

```

The API can also return xml or rdf (selected by keyword "type").
If that is set, the result is always returmed as String

``` julia
search(q="paris", maxRows=10, type="rdf")
# "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>\n<rdf:RDF xmlns:cc=\"http://creativecommons.org/ns#\" xmlns:dcterms=\"http://purl.org/dc/terms/\" xmlns:foaf=\"http://xmlns.com/foaf/0.1/\" xmlns:gn=\"http://www.geonames.org/ontology#\" xmlns:owl=\"http://www.w3.org/2002/07/owl#\" xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\" xmlns:rdfs=\"http://www.w3.org/2000/01/rdf-schema#\" xmlns:wgs84_pos=\"http://www.w3.org/2003/01/geo/wgs84_pos#\">\n    <gn:Feature rdf:about=\"https://sws.geo" ⋯ 7064 bytes ⋯ "n:featureCode rdf:resource=\"https://www.geonames.org/ontology#P.PPL\"/>\n        <gn:countryCode>MG</gn:countryCode>\n        <wgs84_pos:lat>-23.35</wgs84_pos:lat>\n        <wgs84_pos:long>46.13333</wgs84_pos:long>\n        <gn:parentCountry rdf:resource=\"https://sws.geonames.org/1062947/\"/>\n        <gn:nearbyFeatures rdf:resource=\"https://sws.geonames.org/1062614/nearby.rdf\"/>\n        <gn:locationMap rdf:resource=\"https://www.geonames.org/1062614/mahamana.html\"/>\n    </gn:Feature>\n</rdf:RDF>\n"

```

We can also parse the result to a dataframe

``` julia
using DataFrames
search("DataFrame",q="paris", maxRows=10)
# 10×15 DataFrame
#  Row │ adminCode1  lng       geonameId  toponymName      countryId  fcl     population  countryCode  name             fclName               ⋯
#      │ String      String    Int64      String           String     String  Int64       String       String           String                ⋯
# ─────┼───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
#    1 │ 11          47.51667    1062605  Mahamasina       1062947    P                0  MG           Mahamasina       city, village,...     ⋯
#    2 │ 21          46.9        1062606  Mahamasina       1062947    P                0  MG           Mahamasina       city, village,...
#    3 │ 13          46.26667    1062607  Mahamasina       1062947    P                0  MG           Mahamasina       city, village,...
#    4 │ 13          47.2        1062608  Mahamasina       1062947    T                0  MG           Mahamasina       mountain,hill,rock,..
#    5 │ 01          48.9        1062609  Baie Mahamanina  1062947    H                0  MG           Baie Mahamanina  stream, lake, ...     ⋯
#    6 │ 25          47.2        1062610  Mahamanina       1062947    P                0  MG           Mahamanina       city, village,...
#    7 │ 72          49.91667    1062611  Mahamanina       1062947    P                0  MG           Mahamanina       city, village,...
#    8 │ 42          47.61667    1062612  Mahamanina       1062947    T                0  MG           Mahamanina       mountain,hill,rock,..
#    9 │ 33          48.28333    1062613  Mahamanaha       1062947    P                0  MG           Mahamanaha       city, village,...     ⋯
#   10 │ 53          46.13333    1062614  Mahamana         1062947    P                0  MG           Mahamana         city, village,...
#                                                                                                                             6 columns omitted

```

To set the default to "DataFrame" set the module variable `GeoNames.rettype`

``` julia
GeoNames.rettype="DataFrame"
```

This should probably be a package extension.
