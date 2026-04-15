@test isa(Rodrigues26.VerboseSignalData(Float64[1, 2], Float64[1, 2]), Rodrigues26.VerboseSignalData)

# single element vectors don't make sense
@test_throws ArgumentError Rodrigues26.VerboseSignalData(Float64[1], Float64[1])

# input data must represent time->signal pairs
@test_throws ArgumentError Rodrigues26.VerboseSignalData(Float64[1, 2, 3], Float64[1, 2])

# time vector must be strictly increasing
@test_throws ArgumentError Rodrigues26.VerboseSignalData(Float64[1, 1], Float64[1, 2])

# signal vector must have significant variance (i.e., can't be steady state)
@test_throws ArgumentError Rodrigues26.VerboseSignalData(Float64[1, 2], Float64[1, 1])
