# For matrices, directly call core.jl method matching method Symbol.
function _uprint_nd(io::IO, f::Function, A::AbstractMatrix, method::Symbol)
    if method == :braille
        to_braille(io, f, A)
    elseif method == :block
        to_block(io, f, A)
    elseif method == :octant
        to_octant(io, f, A)
    else
        throw(ArgumentError("Valid methods are :braille and :block, got :$method."))
    end
    return nothing
end
# View vectors as 1xn adjoints
function _uprint_nd(io::IO, f::Function, v::AbstractVector, method::Symbol)
    _uprint_nd(io, f, adjoint(v), method)
    return nothing
end

# For multi-dimensional arrays, iterate over tail-indices
function _uprint_nd(io::IO, f::Function, A::AbstractArray, method::Symbol)
    axs= axes(A)
    tailinds = Base.tail(Base.tail(axs))
    Is = CartesianIndices(tailinds)
    for I in Is
        idxs = I.I
        _show_nd_label(io, idxs)
        slice = view(A, axs[1], axs[2], idxs...) # matrix-shaped slice
        _uprint_nd(io, f, slice, method)
        print(io, idxs == map(last,tailinds) ? "" : "\n")
    end
    return nothing
end
# adapted from Base._show_nd_label
function _show_nd_label(io::IO, idxs)
    print(io, "[:, :, ")
    for i = 1:length(idxs)-1
        print(io, idxs[i], ", ")
    end
    println(io, idxs[end], "] =")
    return nothing
end
