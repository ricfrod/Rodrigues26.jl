let
    t = collect(LinRange(0, 100, 1001))
    y = sin.(t)
    data = Rodrigues26.SignalData(t, y)
    period_expected = 6.25625

    @test iszero(period_expected - Rodrigues26.period(data))
end
