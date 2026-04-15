let
    @model t y function limit_cycle_model(θ::Vector{Float64})
        t::Vector{Float64} = collect(LinRange(0, 50, 101))
        y::Vector{Float64} = θ[1] * sin.(t / θ[2])
    end

    obj = ObjectiveFunction(limit_cycle_model, t, y_exp)
    loss::Float64 = obj([1.0, 1.0])

    @test isapprox(loss, 176.7277729794872; atol=1e-6)
end
