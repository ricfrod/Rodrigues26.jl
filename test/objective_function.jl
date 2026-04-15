let
    tolerance = 1.0e-6
    expected_value = 176.72777297948744
    objective_function = Rodrigues26.ObjectiveFunction(
        exp_calculated,
        _ -> data,
        Rodrigues26.Fixed(),
    )
    alternative_dispatch = Rodrigues26.ObjectiveFunction(_ -> data, t, y_exp)
    steady_state_model = Rodrigues26.ObjectiveFunction(
        _ -> SignalData([0.0], [0.0], false), t, y_exp
    )

    @test isa(objective_function, Rodrigues26.ObjectiveFunction)
    @test isa(alternative_dispatch, Rodrigues26.ObjectiveFunction)
    @test isinf(steady_state_model([0.0]))
    @test abs(expected_value - objective_function(t, y_mod)) < tolerance
    @test abs(expected_value - objective_function([0.0])) < tolerance
    @test abs(expected_value - objective_function(data)) < tolerance
end
