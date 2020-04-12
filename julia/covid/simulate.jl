using Distributions, Plots, Random
using StatsBase, StatsPlots
using Distances


function init(size::Int, I₀=0.1)
    S₀ = 1 - I₀
    x = rand(Uniform(0, 10), size, 2)
    v = zeros(size, 2)
    status = sample([:S, :I, :R], Weights([S₀, I₀, 0]), size)
    x, v, status
end

function step!(x, v, status, infect_r::Float64=0.2, infect_p::Float64=0.1)
    distances = pairwise(Euclidean(), x, x, dims=1)
    for i = 1:size(x)[1]

        # infect
        if status[i] == :I
            for j = 1:size(x)[1]
                
                if (distances[i, j] <= infect_r) & (rand() < infect_p)
                    status[j] = :I
                end
            end
        end

        x[i,:] += v[i,:]
        v[i,:] += rand(Normal(0, 0.001), 2)
        for j=1:2
            if x[i,j] >= 10
                x[i,j] = 10
                v[i,j] = -v[i,j]
            end
            if x[i,j] <= 0
                x[i,j] = 0
                v[i,j] = -v[i,j]
            end
        end
    end
end

function sim!(x, v, status, steps::Int=100)
    population_size= length(status)    
    statistics = zeros(steps, 3)
    l = @layout[a; b]
    population_plot = scatter(x[:,1],x[:,2], lims=(-1, 10), markercolor=map(colorme, status),
                    markershape=:circle, alpha=0.7, grid=false, legend=false)
    stats_plot = groupedbar(statistics[1:5:end,:],
            bar_position = :stack, bar_width=0.8, 
            c=[colorant"#74C0E1" colorant"#2F2F2F"  colorant"#F5644F"])
    p = plot(population_plot, stats_plot, layout=l)
    
    @gif for i = 1:steps
        statistics[i,:] = [sum(status .== :S), sum(status.== :R), sum(status .== :I)]
        step!(x, v, status, 0.2, 0.2)
        l = @layout[a; b]
        p1 = scatter(x[:,1],x[:,2], lims=(-1, 10), markercolor=map(colorme, status),
                    markershape=:circle, alpha=0.7, grid=false, legend=false)
        p2 = groupedbar(statistics[1:3:end,:],
            bar_position = :stack, bar_width=0.8, 
            c=[colorant"#74EFE1" colorant"#2F2F2F"  colorant"#F5644F"])
        p = plot(p1, p2, layout=l)
        p
    end 
end

function colorme(a)
      if a == :S
          #return colorant"#27606B"
          return colorant"#74C0E1"
      elseif a == :I
          return colorant"#F5644F"
      else # == :R
          return colorant"#2F2F2F"
      end
end

theme(:juno)
gr(size=(1000,1500),legend=false,markerstrokewidth=0,markersize=5)

x, v, status = init(100, 0.2)
sim!(x, v, status, 500);

