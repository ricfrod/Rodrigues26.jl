let
    tolerance = 1.0e-6
    expected_value = 176.72777297948744
    objective_function = Rodrigues26.ObjectiveFunction(
        exp_calculated,
        _ -> data,
        Rodrigues26.Fixed(),
    )

    @test abs(expected_value - objective_function(t, y_mod)) < tolerance
    @test abs(expected_value - objective_function([0.0])) < tolerance
    @test abs(expected_value - objective_function(data)) < tolerance
end
