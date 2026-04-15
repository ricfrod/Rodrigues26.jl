# 1. Helper to replace any return with the specified symbols
function inject_specific_returns(ex, sym1, sym2)
    if ex isa Expr
        if ex.head === :return
            # Overrides whatever was being returned with the specific symbols
            return :(return SignalData($sym1, $sym2))
        else
            return Expr(ex.head, map(x -> inject_specific_returns(x, sym1, sym2), ex.args)...)
        end
    end
    return ex
end

# 2. The macro taking symbols as arguments
macro model(sym1, sym2, ex)
    if !(ex isa Expr && (ex.head === :function || (ex.head === :(=) && ex.args[1] isa Expr && ex.args[1].head === :call)))
        throw(ArgumentError("The @model macro must be applied to a function definition."))
    end

    signature = ex.args[1]
    original_body = ex.args[2]

    # Replace explicit returns to return SignalData(sym1, sym2)
    modified_body = inject_specific_returns(original_body, sym1, sym2)

    # Wrap the final implicit return
    new_body = quote
        $modified_body
        # Implicitly returns the current runtime values of sym1 and sym2
        SignalData($sym1, $sym2)
    end

    return esc(Expr(ex.head, signature, new_body))
end
