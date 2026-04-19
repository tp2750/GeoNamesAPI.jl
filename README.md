# GeoNamesAPI.jl

<!-- [![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://tp2750.github.io/GeoNamesAPI.jl/stable/)
<!-- [![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://tp2750.github.io/GeoNamesAPI.jl/dev/)
[![Build Status](https://github.com/tp2750/GeoNamesAPI.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/tp2750/GeoNamesAPI.jl/actions/workflows/CI.yml?query=branch%3Amain) -->
[![Aqua](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)

[GeoNames](https://www.geonames.org/) is a service to look up coordinates and other information of geographical locations based on their name.

GeoNamesAPI.jl provides a simple access to its [web service](https://www.geonames.org/export/web-services.html).


You need to [register a username](https://www.geonames.org/login) with GeoNames to use the service.
After you create the username, you need at activate it on the [account page](https://www.geonames.org/manageaccount).

It is recommended to store the username as an environment variable in your `~/.julia/config/startup.jl` file:

``` julia
ENV["GEONAMES_USER"]="yourusername"
```

Then you can access the service using the API as described in GeoNames [documentation](https://www.geonames.org/export/geonames-search.html).

``` julia
using GeoNamesAPI
search(q="paris", maxRows=2)
# JSON.Object{String, Any} with 2 entries:
#   "totalResultsCount" => 50623
#   "geonames"          => Any[Object{String, Any}("adminCode1"=>"11", "lng"=>"2.3488", "geonameId"=>2988507, "toponymName"=>"Paris", "countryId"=>"3017382", "fcl"=>"P", "population"=>2138551, "countryCode"=>"FR", "name"=>"Paris", "fclName"=>"city, village,…
```

If you do not store you username in the environment, you can give it as argument to the function

``` julia
search(q="paris", maxRows=2, username="yourusername")
```

Results are returned as JSON by default.
If you want to parse the result yourself, you can get it as String by giving a string as the first argument (dispaches on first argument).
You also need to specify the "type" keyword, as the default type from GeoNames is "xml". The options are `xml`, `json`, `rdf`, see https://www.geonames.org/export/geonames-search.html

``` julia
search("",q="paris", maxRows=2, type="json")
# "{\"totalResultsCount\":50623,\"geonames\":[{\"adminCode1\":\"11\",\"lng\":\"2.3488\",\"geonameId\":2988507,\"toponymName\":\"Paris\",\"countryId\":\"3017382\",\"fcl\":\"P\",\"population\":2138551,\"countryCode\":\"FR\",\"name\":\"Paris\",\"fclName\":\"city, village,...\",\"adminCodes1\":{\"ISO3166_2\":\"IDF\"},\"countryName\":\"France\",\"fcodeName\":\"capital of a political entity\",\"adminName1\":\"Île-de-France\",\"lat\":\"48.85341\",\"fcode\":\"PPLC\"},{\"adminCode1\":\"17\",\"lng\":\"-76.79358\",\"geonameId\":3489854,\"toponymName\":\"Kingston\",\"countryId\":\"3489940\",\"fcl\":\"P\",\"population\":937700,\"countryCode\":\"JM\",\"name\":\"Kingston\",\"fclName\":\"city, village,...\",\"adminCodes1\":{\"ISO3166_2\":\"01\"},\"countryName\":\"Jamaica\",\"fcodeName\":\"capital of a political entity\",\"adminName1\":\"Kingston\",\"lat\":\"17.99702\",\"fcode\":\"PPLC\"}]}"
```

There is a package extension to return [DataFrames](https://github.com/JuliaData/DataFrames.jl)

``` julia
using DataFrames
search(q="paris", maxRows=2)
# [ Info: totalResultsCount = 50623. Use keywords `startRow` and `maxRows` (max 1000) to paginate results
# 2×16 DataFrame
#  Row │ adminCode1  lng        geonameId  toponymName  countryId  fcl     population  countryCode  name      fclName            adminCodes1                        countryName  fcodeName                      adminName1     lat       fcode  
#      │ String      String     Int64      String       String     String  Int64       String       String    String             Object…                            String       String                         String         String    String 
# ─────┼────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
#    1 │ 11          2.3488       2988507  Paris        3017382    P          2138551  FR           Paris     city, village,...  Object{String, Any}("ISO3166_2"=…  France       capital of a political entity  Île-de-France  48.85341  PPLC
#    2 │ 17          -76.79358    3489854  Kingston     3489940    P           937700  JM           Kingston  city, village,...  Object{String, Any}("ISO3166_2"=…  Jamaica      capital of a political entity  Kingston       17.99702  PPLC

```

When loading DataFrames, the default return type is set to `DataFrame`. 
To set it back to JSON set the module variable `GeoNamesAPI.rettype`

``` julia
using JSON
GeoNamesAPI.rettype = JSON.Object()

search(q="paris", maxRows=2)
# JSON.Object{String, Any} with 2 entries:
#   "totalResultsCount" => 50623
#   "geonames"          => Any[Object{String, Any}("adminCode1"=>"11", "lng"=>"2.3488", "geonameId"=>2988507, "toponymName"=>"Paris", "countryId"=>"3017382", "fcl"=>"P", "population"=>2138551, "countryCode"=>"FR", "name"=>"Paris", "fclName"=>"city, village,…
```

There is also package extensions for [XML](https://github.com/JuliaComputing/XML.jl/) and [EzXML](https://github.com/JuliaIO/EzXML.jl)

``` julia
using GeoNamesAPI, EzXML
x1 = search(q="paris", maxRows=2)
# EzXML.Document(EzXML.Node(<DOCUMENT_NODE@0x0000000001d66290>))
string(x1)
# "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>\n<geonames style=\"MEDIUM\">\n    <totalResultsCount>50623</totalResultsCount>\n    <geoname>\n        <toponymName>Paris</toponymName>\n        <name>Paris</name>\n        <lat>48.85341</lat>\n        <lng>2.3488</lng>\n        <geonameId>2988507</geonameId>\n        <countryCode>FR</countryCode>\n        <countryName>France</countryName>\n        <fcl>P</fcl>\n        <fcode>PPLC</fcode>\n    </geoname>\n    <geoname>\n        <toponymName>Kingston</toponymName>\n        <name>Kingston</name>\n        <lat>17.99702</lat>\n        <lng>-76.79358</lng>\n        <geonameId>3489854</geonameId>\n        <countryCode>JM</countryCode>\n        <countryName>Jamaica</countryName>\n        <fcl>P</fcl>\n        <fcode>PPLC</fcode>\n    </geoname>\n</geonames>\n"
```

``` julia
using GeoNamesAPI, XML
x2 = search(q="paris", maxRows=2)
# LazyNode (depth=0) Document
collect(x2)
# 42-element Vector{LazyNode}:
#  LazyNode (depth=1) Declaration <?xml version="1.0" encoding="UTF-8" standalone="no"?>
#  LazyNode (depth=1) Element <geonames style="MEDIUM">
#  LazyNode (depth=2) Element <totalResultsCount>
#  LazyNode (depth=3) Text "50623"
#  LazyNode (depth=2) Element <geoname>
#  LazyNode (depth=3) Element <toponymName>
#  LazyNode (depth=4) Text "Paris"
#  LazyNode (depth=3) Element <name>
#  LazyNode (depth=4) Text "Paris"
#  LazyNode (depth=3) Element <lat>
#  LazyNode (depth=4) Text "48.85341"
#  LazyNode (depth=3) Element <lng>
#  LazyNode (depth=4) Text "2.3488"
#  LazyNode (depth=3) Element <geonameId>
#  LazyNode (depth=4) Text "2988507"
#  LazyNode (depth=3) Element <countryCode>
#  LazyNode (depth=4) Text "FR"
#  LazyNode (depth=3) Element <countryName>
#  LazyNode (depth=4) Text "France"
#  LazyNode (depth=3) Element <fcl>
#  LazyNode (depth=4) Text "P"
#  LazyNode (depth=3) Element <fcode>
#  LazyNode (depth=4) Text "PPLC"
#  LazyNode (depth=2) Element <geoname>
#  LazyNode (depth=3) Element <toponymName>
#  LazyNode (depth=4) Text "Kingston"
#  LazyNode (depth=3) Element <name>
#  LazyNode (depth=4) Text "Kingston"
#  LazyNode (depth=3) Element <lat>
#  LazyNode (depth=4) Text "17.99702"
#  LazyNode (depth=3) Element <lng>
#  LazyNode (depth=4) Text "-76.79358"
#  LazyNode (depth=3) Element <geonameId>
#  LazyNode (depth=4) Text "3489854"
#  LazyNode (depth=3) Element <countryCode>
#  LazyNode (depth=4) Text "JM"
#  LazyNode (depth=3) Element <countryName>
#  LazyNode (depth=4) Text "Jamaica"
#  LazyNode (depth=3) Element <fcl>
#  LazyNode (depth=4) Text "P"
#  LazyNode (depth=3) Element <fcode>
#  LazyNode (depth=4) Text "PPLC"
```

It uses the LazyNode, but you can aosl use the XML.Node type:

``` julia
global GeoNamesAPI.rettype = XML.Node(1)
x3 = search(q="paris", maxRows=2)
# Node Document (2 children)
```

Getting back to LazyNodes is a bit combersome:

``` julia
GeoNamesAPI.rettype = XML.LazyNode(XML.Raw([UInt8(1)]))
search(q="paris", maxRows=2)
# LazyNode (depth=0) Document
```

You can still get the xml string:

``` julia
search("",q="paris", maxRows=2, type="xml")
# "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>\n<geonames style=\"MEDIUM\">\n    <totalResultsCount>50623</totalResultsCount>\n    <geoname>\n        <toponymName>Paris</toponymName>\n        <name>Paris</name>\n        <lat>48.85341</lat>\n        <lng>2.3488</lng>\n        <geonameId>2988507</geonameId>\n        <countryCode>FR</countryCode>\n        <countryName>France</countryName>\n        <fcl>P</fcl>\n        <fcode>PPLC</fcode>\n    </geoname>\n    <geoname>\n        <toponymName>Kingston</toponymName>\n        <name>Kingston</name>\n        <lat>17.99702</lat>\n        <lng>-76.79358</lng>\n        <geonameId>3489854</geonameId>\n        <countryCode>JM</countryCode>\n        <countryName>Jamaica</countryName>\n        <fcl>P</fcl>\n        <fcode>PPLC</fcode>\n    </geoname>\n</geonames>\n"

```
