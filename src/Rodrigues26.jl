module Rodrigues26

export ObjectiveFunction
export SignalData
export @model

include("structs/base.jl")
include("period_estimation.jl")
include("extremum_detection.jl")
include("structs/cycles_experimental.jl")
include("structs/cycles_model.jl")
include("structs/objective_function.jl")
include("objective_function.jl")
include("macros.jl")

end
