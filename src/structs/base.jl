using Statistics: var


abstract type AbstractSignalData end


struct VerboseSignalData <: AbstractSignalData
    t::Vector{Float64}
    y::Vector{Float64}

    function VerboseSignalData(t::Vector{Float64}, y::Vector{Float64})
        if length(t) ≠ length(y)
            throw(ArgumentError("Time vector and signal vector must have same length"))
        end

        if length(t) == 1
            throw(ArgumentError("Input data must have more than 1 time->signal pair"))
        end

        if !all(diff(t) .> 0)
            throw(ArgumentError("Time vector is not strictly increasing"))
        end

        tolerance = 1.0e-6
        if (σ² = var(y)) < tolerance
            throw(ArgumentError("Signal vector must have significant variance. Calculated variance: $σ²"))
        end

        return new(t, y)
    end
end


struct SignalData <: AbstractSignalData
    t::Vector{Float64}
    y::Vector{Float64}
    has_limit_cycles::Bool
end

function SignalData(t::Vector{Float64}, y::Vector{Float64})
    tolerance = 1.0e-6
    if length(t) ≠ length(y) || length(t) == 1 || !all(diff(t) .> 0) || var(y) < tolerance
        return SignalData([0.0], [0.0], false)
    else
        return SignalData(t, y, true)
    end
end
