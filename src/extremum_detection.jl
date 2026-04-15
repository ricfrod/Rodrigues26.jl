using Peaks: peakproms!, peakwidths!, findminima
using Statistics

function extremum_indices(
        y::AbstractVector{<:Real},
        ts::Real,
        τ̃::Real
    )::Vector{Int64}
    w::Float64 = floor(Int64, 0.2 * τ̃ / ts)
    Ã::Float64 = std(y)
    pks = findminima(y) |> peakproms!(; min = Ã) |> peakwidths!(; min = w)
    return pks.indices
end

function extremum_indices(data::AbstractSignalData; find_valleys::Bool = true)::Vector{Int64}
    (; t, y) = data

    if !find_valleys
        y = y .* (-1)
    end

    sampling_interval = t[2] - t[1]
    estimated_period::Float64 = period(data)

    return extremum_indices(y, sampling_interval, estimated_period)
end
