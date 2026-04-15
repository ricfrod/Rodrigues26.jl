using Statistics: mean
using FFTW: rfft, rfftfreq


function period(data::AbstractSignalData)::Float64
    (; t, y) = data

    ts = t[2] - t[1]
    fs = 1.0 / ts
    n = length(y)

    signal = rfft(y .- mean(y))

    index = argmax(i -> abs(signal[i]), keys(signal))

    main_signal_frequency = abs(rfftfreq(n, fs)[index])
    main_signal_period = 1.0 / main_signal_frequency

    return main_signal_period
end
