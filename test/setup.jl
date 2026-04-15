using Random

Random.seed!(1)

n = 101
t = collect(LinRange(0, 50, n))
y_exp = sin.(t) + 0.3 * randn(n)
y_mod = y = sin.(t)

data = Rodrigues26.SignalData(t, y)

exp_calculated = Rodrigues26.ExperimentalCycles(t, y_exp)
mod_calculated = Rodrigues26.ModelCycles(t, y_mod, exp_calculated)
