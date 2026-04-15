using Interpolations: interpolate, Gridded, Linear
using Statistics: mean, var

const CACHE_SIZE::Int64 = 20


struct Cache
    X::Matrix{Float64}
    Z::Matrix{Float64}
end


struct ExperimentalCycles
    nz::Int64
    nc::Int64
    X::Matrix{Float64}
    Z::Matrix{Float64}
    σ²_x::Vector{Float64}
    σ²_z::Vector{Float64}
    σ²_x⁻¹::Vector{Float64}
    σ²_z⁻¹::Vector{Float64}
    cache::Cache
end

function ExperimentalCycles(nz, nc, X, Z, σ²_x, σ²_z)
    x = any(iszero, σ²_x[2:end])
    z = any(iszero, σ²_z)

    if x || z
        axis = [name for (ax, name) in zip((x, z), ("time", "signal")) if ax]
        throw(
            ArgumentError(
                "Experimental data has zero-valued variances for axis $(join(axis, ", "))"
            )
        )
    end

    σ²_x⁻¹ = [1.0, (1.0 ./ σ²_x[2:end])...]
    σ²_z⁻¹ = 1.0 ./ σ²_z
    cache = Cache(zeros(nz, CACHE_SIZE), zeros(nz, CACHE_SIZE))

    return ExperimentalCycles(
        nz, nc, X, Z, σ²_x, σ²_z, σ²_x⁻¹, σ²_z⁻¹, cache
    )
end


function ExperimentalCycles(data::AbstractSignalData)
    (; t, y) = data

    indices::Vector{Int64} = extremum_indices(data)
    nc::Int64 = length(indices) - 1

    if nc <= 1
        throw(AssertionError("Unable to detect cycles in experimental data"))
    end

    nz::Int64 = indices |> diff |> mean |> floor |> Int64

    X, Z = (
        zeros(nz, nc),
        zeros(nz, nc),
    )

    for (i, (j, k)) in enumerate(zip(indices, @view indices[2:end]))
        t̂ = view(t, j:k)
        ŷ = view(y, j:k)
        f = interpolate((t̂,), ŷ, Gridded(Linear()))
        t̃ = LinRange(t̂[1], t̂[end], nz)
        X[:, i] .= t̃ .- t̃[1]
        Z[:, i] .= f.(t̃)
    end

    σ²_x = var.(eachrow(X))
    σ²_z = var.(eachrow(Z))

    return ExperimentalCycles(nz, nc, X, Z, σ²_x, σ²_z)
end

function ExperimentalCycles(t::AbstractVector{<:Real}, y::AbstractVector{<:Real})
    return ExperimentalCycles(VerboseSignalData(t, y))
end
