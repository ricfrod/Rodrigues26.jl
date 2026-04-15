# Rodrigues26.jl

[![Build Status](https://github.com/ricfrod/Rodrigues26.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/ricfrod/Rodrigues26.jl/actions/workflows/CI.yml?query=branch%3Amaster)
[![DOI:10.1007/s43153-025-00628-2](https://img.shields.io/badge/DOI-10.1007%2Fs43153--025--00628--2-blue)](https://doi.org/10.1007/s43153-025-00628-2)

## Overview

Rodrigues26 provides utilities for fitting limit cycle models to time-series periodic data. It exposes three primary APIs: `SignalData`, `@model`, and `ObjectiveFunction`.

## Quick examples

### Defining the target model

Use `SignalData` as the output of the model's time series

```julia
using Rodrigues26

function limit_cycle_model(θ::Vector{Float64})::SignalData
    t::Vector{Float64} = collect(LinRange(0, 50, 101))
    y::Vector{Float64} = θ[1] * sin(2π * t / θ[2])
    return SignalData(t, y)
end
```

Alternatively, the `@model` macro can do that automatically when provided 
with the time and signal vector symbols.

```julia
using Rodrigues26

@model t y function limit_cycle_model(θ::Vector{Float64})
    t::Vector{Float64} = collect(LinRange(0, 50, 101))
    y::Vector{Float64} = θ[1] * sin(2π * t / θ[2])
end
```

### Defining the objective function

```julia
using Rodrigues26

@model t y function limit_cycle_model(θ::Vector{Float64})
    t::Vector{Float64} = collect(LinRange(0, 50, 101))
    y::Vector{Float64} = θ[1] * sin(2π * t / θ[2])
end

t_exp::Vector{Float64} = collect(LinRange(0, 100, 1001))
y_exp::Vector{Float64} = sin.(t_exp) + 0.3 * randn(n)

obj = ObjectiveFunction(limit_cycle_model, t_exp, y_exp)
loss::Float64 = obj([1.0, 0.5])
```

## Citation

If you use this software or the underlying methodology in your work, please cite the following paper:

> Rodrigues, R.F., Trierweiler, J.O. & Farenzena, M. Parameter estimation and statistical analysis of limit cycle models using a local optimization algorithm: applications for simplified well models of slugging oil systems. *Braz. J. Chem. Eng.* (2026). https://doi.org/10.1007/s43153-025-00628-2

You can also use the **"Cite this repository"** button on the right sidebar to export the citation in BibTeX or APA formats.