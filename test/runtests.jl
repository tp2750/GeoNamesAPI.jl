using GeoNamesAPI
using Test
using Aqua
using JET
using JSON
using DataFrames
using XML
using EzXML

@testset "GeoNamesAPI.jl" begin
    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(GeoNamesAPI)
    end
    @testset "Code linting (JET.jl)" begin
        JET.test_package(GeoNamesAPI; target_defined_modules = true)
    end
    @testset "JSON" begin
        r1 = search(JSON.Object(), q="paris", maxRows=1, username=get(ENV,"GEONAMES_USER",""))
        @test r1.geonames[1].countryCode == "FR"
    end
    @testset "DataFrame" begin
        r1 = search(DataFrames.DataFrame(), q="paris", maxRows=1, username=get(ENV,"GEONAMES_USER",""))
        @test r1[1,"countryCode"] == "FR"
    end
    @testset "EzXML" begin
        r1 = search(EzXML.XMLDocument(), q="paris", maxRows=1, username=get(ENV,"GEONAMES_USER",""))
        @test nodecontent(elements(elements(root(r1))[2])[6]) == "FR"
    end
    @testset "XML" begin
        r1 = search(XML.Node(1), q="paris", maxRows=1, username=get(ENV,"GEONAMES_USER",""))
        @test value((children(children(children(r1)[2])[2])[6])[1]) == "FR"
    end
    
end
