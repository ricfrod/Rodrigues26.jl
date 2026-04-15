using Statistics: mean
using FFTW: rfft, rfftfreq


function period(data::AbstractSignalData)::Float64
    (; t, y) = data

    ts = t[2] - t[1]

    tolerance = 1.0e-6
    if any(i -> abs((t[i] - t[i-1]) - ts) > tolerance, 2:length(t))
        throw(ArgumentError("Time vector must have constant sampling"))
    end

    fs = 1.0 / ts
    n = length(y)

    signal = rfft(y .- mean(y))

    index = argmax(i -> abs(signal[i]), keys(signal))

    f = abs(rfftfreq(n, fs)[index])

    return 1.0 / f
end
