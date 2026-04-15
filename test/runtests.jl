using Rodrigues26
using Test

include("setup.jl")

@testset "Rodrigues26.jl" begin

    @testset "Base structs" begin
        include("structs_base.jl")
    end

    @testset "Period estimation" begin
        include("period_estimation.jl")
    end

    @testset "Extremum detection" begin
        include("extremum_detection.jl")
    end

    @testset "Cycles structs" begin
        include("structs_cycles.jl")
    end

    @testset "Objective function" begin
        include("objective_function.jl")
    end

    @testset "Macros" begin
        include("macros.jl")
    end

end
