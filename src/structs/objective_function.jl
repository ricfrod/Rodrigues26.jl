abstract type SteadyStateHandler end

@kwdef struct Fixed <: SteadyStateHandler
    value::Float64 = Inf
end

@kwdef struct ObjectiveFunction{F}
    experimental_cycles::ExperimentalCycles
    get_model_results::F
    steady_state_handler::SteadyStateHandler = Fixed()
end
