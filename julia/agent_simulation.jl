using Distributions, Plots, Random
using StatsBase

using Agents, Random, DataFrames, LightGraphs
using Distributions: Poisson, Normal, Uniform, DiscreteNonParametric
using DrWatson: @dict
using Plots

mutable struct Person
    id::Int
    x::Array{Float16,1}
    v::Array{Float16,1}
    days_infected::Int
    status::Symbol # 1: S, 2: I, 3:R
end

function init(population_size)
    population = []
    for i=1:population_size
        x = rand(Uniform(0, 10), 2)
        v = rand(Normal(0, 0.01), 2)
        joe = Person(i, x, v, 0, :S)
        push!(population, joe)
    end
    return population
end

function step!(population)
    for joe=population
        joe.x += joe.v
        if joe.x[1] >= 10
            joe.x[1] = 10
            joe.v[1] = -joe.v[1]
        end
        if joe.x[1] <= 0
            joe.x[1] = 0
            joe.v[1] = -joe.v[1]
        end
        if joe.x[2] >= 10
            joe.x[2] = 10
            joe.v[2] = -joe.v[2]
        end
        if joe.x[2] <= 0
            joe.x[2] = 0
            joe.v[2] = -joe.v[2]
        end
        if joe.status == :S
            joe.status = :I
        else
            joe.status = :S
        end
    end
end

population = init(10)
@gif for i=1:1000
    step!(population)
    p = plot()
    for joe in population
        joe.x += joe.v
        scatter!(p, [joe.x[1]], [joe.x[2]], lims=(0, 10))
        plot!(legend=false, grid=false, xticks=nothing, yticks=nothing)
        vline!(0:11:11,color=:black)
        hline!(0:11:11,color=:black)
    end
end
