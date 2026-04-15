estimated_period = Rodrigues26.period(data)
sampling_interval = t[2] - t[1]

# valleys
indices_valleys_expected = [10, 23, 36, 48, 61, 73, 86, 98]

@test iszero(
    sum(
        indices_valleys_expected - Rodrigues26.extremum_indices(data)
    )
)
@test iszero(
    sum(
        indices_valleys_expected - Rodrigues26.extremum_indices(y, sampling_interval, estimated_period)
    )
)

# peaks
indices_peaks_expected = [4, 17, 29, 42, 54, 67, 80, 92]
@test iszero(
    sum(
        indices_peaks_expected - Rodrigues26.extremum_indices(data; find_valleys = false)
    )
)
