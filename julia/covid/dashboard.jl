#  Pkg.add(PackageSpec(name="CSV", version="0.5.22"))
using CSV, DataFrames, Dates
using Plots, Interact

url = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv"
download(url , "/tmp/covid_data.csv")
csv_data = CSV.read("/tmp/covid_data.csv")

data = DataFrame(csv_data)
rename!(data, 1 => "province", 2=> "country")
countries = collect(data.country)

date_strings = String.(names(data))[5:end]
format = Dates.DateFormat("m/d/Y") 
dates = parse.(Date, date_strings, format) .+ Year(2000)

pretty_print(date) = string(Dates.dayofmonth(date), Dates.monthname(date)[1:3])

function extract_country(country, data)
    country_data = data[data.country .== country, 5:end]
    cases = [sum(col) for col in eachcol(country_data)]
    return cases
end

countries = ["China", "Japan", "Italy", "France", "United Kingdom", "India", "Spain", "US"]
colors = [:red, :pink, :blue, :violet, :white, :orange, :yellow, :purple]
colormap = Dict(zip(countries, colors))

function plot_country(plt, country, until_day=69)
    data_subset = extract_country(country, data)[1:until_day]
    dates_subset = pretty_print.(dates[1:until_day])
    print(dates_subset)
    inds = (data_subset .> 0)
    if length(data_subset[inds]) > 0
        plot!(plt, dates_subset[inds], data_subset[inds], xrotation=45,
             leg=:topleft, label=country, m=:o, c=colormap[country],
             yscale=:log10)
    end
    return plt
end

p = plot()
plot_country(p, "US")
plot_country(p, "United Kingdom")
plot_country(p, "India")
plot_country(p, "China")

@manipulate for day=1:length(dates)
    p = plot()
    xlabel!(p, "date")
    ylabel!(p, "confirmed cases")
    plot_country(p, "US", day)
    plot_country(p, "United Kingdom", day)
end

@manipulate for day=1:length(dates), country in countries
    p = plot()
    plot_country(p, country, day)
end

