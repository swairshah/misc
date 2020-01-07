export(𝒹)

𝒹(x::Number, y::Symbol) = 0

function 𝒹(x::Symbol, y::Symbol)
    if x == y
        return 1
    else
        return 0
    end
end

function 𝒹_add(ex::Expr, y::Symbol)
    n = length(ex.args)
    new_args = Array{Any}(nothing, n)
    new_args[1] = :+
    for i in 2:n
        new_args[i] = 𝒹(ex.args[i], y)
    end
    return Expr(:call, new_args...)
end

function 𝒹_subtract(ex::Expr, y::Symbol)
    n = length(ex.args)
    new_args = Array{Any}(nothing, n)
    new_args[1] = :-
    for i in 2:n
        new_args[i] = 𝒹(ex.args[i], y)
    end
    return Expr(:call, new_args...)
end

function 𝒹_multiply(ex::Expr, y::Symbol)
    n = length(ex.args)
    sum_args = Array{Any}(nothing, n)
    sum_args[1] = :+
    for i in 2:n
        prod_args = Array{Any}(nothing, n)
        prod_args[1] = :*
        for j in 2:n
            if j == i
                prod_args[j] = 𝒹(ex.args[j], y)
            else
                prod_args[j] = ex.args[j]
            end
        end
        sum_args[i] = Expr(:call, prod_args)
    end
    return Expr(:call, sum_args)
end

function 𝒹_divide(ex::Expr, y::Symbol)
    neg_args = Array{Any}(nothing, 3)
    neg_args[1] = :-

    neg_args[2] = Expr(:call, :/, 𝒹(ex.args[2], y), ex.args[3])

    neg_args[3] = Expr(:call, :/, (Expr(:call, :*, ex.args[2], 𝒹(ex.args[3], y))), Expr(:call, :*, ex.args[3], ex.args[3]))

    return Expr(:call, neg_args)
end

function 𝒹(ex::Expr, y::Symbol)
    if ex.head == :call
        if ex.args[1] == :+
            return 𝒹_add(ex, y)
        elseif ex.args[1] == :-
            return 𝒹_minus(ex, y)
        elseif ex.args[1] == :*
            return 𝒹_multiply(ex, y)
        elseif ex.args[1] == :/
            return 𝒹_divide(ex, y)
        end
    else
        return 𝒹(ex.head)
    end
end
