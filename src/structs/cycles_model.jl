using Interpolations: interpolate, Gridded, Linear
using Statistics: mean, var


struct ModelCycles
    x::Vector{Float64}
    z::Vector{Float64}
end


function update_model_matrices(
        f,
        X::SubArray,
        Z::SubArray,
        nz::Int64,
        nc::Int64,
        indices::Vector{Int64},
        t::Vector{Float64},
    )
    @views @inbounds for i in 1:nc
        j, k = indices[i], indices[i+1]
        t̂ = t[j:k]
        t̃ = LinRange(t̂[1], t̂[end], nz)
        @. X[:, i] = t̃ - t̃[1]
        @. Z[:, i] = f(t̃)
    end
    return nothing
end

function get_model_vectors(X::SubArray, Z::SubArray)
    return (;
        x = [mean(x) for x in eachrow(X)],
        z = [mean(z) for z in eachrow(Z)],
    )
end

function ModelCycles(data::AbstractSignalData, ℰ::ExperimentalCycles)
    (; t, y) = data
    (; nz, cache) = ℰ

    indices::Vector{Int64} = extremum_indices(data)

    nc::Int64 = min(length(indices) - 1, CACHE_SIZE)

    X, Z = view(cache.X, :, 1:nc), view(cache.Z, :, 1:nc)

    f = interpolate((t,), y, Gridded(Linear()))

    update_model_matrices(f, X, Z, nz, nc, indices, t)

    (; x, z) = get_model_vectors(X, Z)

    return ModelCycles(x, z)
end

function ModelCycles(
        t::AbstractVector{<:Real},
        y::AbstractVector{<:Real},
        ℰ::ExperimentalCycles,
    )
    return ModelCycles(VerboseSignalData(t, y), ℰ)
end
