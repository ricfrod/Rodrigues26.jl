steady_state_value(x::Fixed)::Float64 = x.value


function update_objective_function_value(
        X::Matrix{Float64},
        x::Vector{Float64},
        σ²_x⁻¹::Vector{Float64},
    )::Float64
    v = 0.0
    for xᵉ in eachcol(X)
        for i in eachindex(xᵉ)
            v += (xᵉ[i] - x[i])^2 * σ²_x⁻¹[i]
        end
    end
    return v
end


function (self::ObjectiveFunction)(model_data::SignalData)::Float64
    if !model_data.has_limit_cycles
        return steady_state_value(self.steady_state_handler)
    end

    model_cycles = ModelCycles(model_data, self.experimental_cycles)

    (; X, Z, σ²_x⁻¹, σ²_z⁻¹) = self.experimental_cycles
    (; x, z) = model_cycles

    j = 0.0
    j += update_objective_function_value(X, x, σ²_x⁻¹)
    j += update_objective_function_value(Z, z, σ²_z⁻¹)

    return j
end


function (self::ObjectiveFunction)(
        t::AbstractVector{<:Real},
        y::AbstractVector{<:Real},
    )::Float64
    model_data = SignalData(t, y)
    return self(model_data)
end


function (self::ObjectiveFunction)(
        θ::AbstractVector{<:Real},
        args...;
        kwargs...
    )::Float64
    data::SignalData = self.get_model_results(θ, args...; kwargs...)
    return self(data)
end
