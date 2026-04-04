using GeoNamesAPI
using Test
using Aqua
# using JET

@testset "GeoNamesAPI.jl" begin
    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(GeoNamesAPI)
    end
    # @testset "Code linting (JET.jl)" begin
    #     JET.test_package(GeoNamesAPI; target_defined_modules = true)
    # end
    # Write your tests here.
end
