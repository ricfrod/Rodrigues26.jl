expected_t = [0.0, 0.2, 0.4, 0.6, 0.8, 1.0, 1.2, 1.4, 1.6, 1.8, 2.0, 2.2, 2.4, 2.6, 2.8, 3.0, 3.2, 3.4, 3.6, 3.8, 4.0, 4.2, 4.4, 4.6, 4.8, 5.0, 5.2, 5.4, 5.6, 5.8, 6.0, 6.2, 6.4, 6.6, 6.8, 7.0, 7.2, 7.4, 7.6, 7.8, 8.0, 8.2, 8.4, 8.6, 8.8, 9.0, 9.2, 9.4, 9.6, 9.8, 10.0]
expected_y = [0.0, 0.199, 0.389, 0.565, 0.717, 0.841, 0.932, 0.985, 1.0, 0.974, 0.909, 0.808, 0.675, 0.516, 0.335, 0.141, -0.058, -0.256, -0.443, -0.612, -0.757, -0.872, -0.952, -0.994, -0.996, -0.959, -0.883, -0.773, -0.631, -0.465, -0.279, -0.083, 0.117, 0.312, 0.494, 0.657, 0.794, 0.899, 0.968, 0.999, 0.989, 0.941, 0.855, 0.734, 0.585, 0.412, 0.223, 0.025, -0.174, -0.366, -0.544]

Rodrigues26.@model t y function test_for_macro_main()
    t = collect(LinRange(0, 10, 51))
    y = sin.(t)
end

Rodrigues26.@model t y function test_for_macro_explicit_return()
    t = collect(LinRange(0, 10, 51))
    y = sin.(t)
    return "foo"
end

let
    cases = (
        test_for_macro_main(),
        test_for_macro_explicit_return(),
    )
    for case ∈ cases
        (; t, y, has_limit_cycles) = case
        @test all(isapprox(a, b; atol = 1e-3) for (a, b) in zip(t, expected_t))
        @test all(isapprox(a, b; atol = 1e-3) for (a, b) in zip(y, expected_y))
        @test has_limit_cycles
    end
end

@test_throws ArgumentError @macroexpand(Rodrigues26.@model t y "foo")
