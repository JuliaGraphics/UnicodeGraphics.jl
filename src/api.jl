"""
    bprint([io::IO], A, [method])

Write to `io` (or to the default output stream `stdout` if `io` is not given) a binary
unicode representation of `A` , filling values that are `true` or greater than zero.

The printing method can be specified by passing either `:braille` or `:block`.
The default is `:$DEFAULT_METHOD`.

# Example
```julia-repl
julia> A = rand(Bool, 8, 8)
8×8 Matrix{Bool}:
 0  1  0  1  0  1  0  1
 0  1  1  1  0  1  1  1
 1  0  0  0  0  0  0  0
 0  0  0  0  1  1  1  1
 1  1  0  0  0  1  1  1
 1  1  1  0  1  1  0  0
 0  0  1  0  0  1  0  1
 1  1  0  1  1  1  0  0

julia> bprint(A)
⠜⠚⣘⣚
⣛⢆⣺⠩
julia> bprint(A, :block)
 █▄█ █▄█
▀   ▄▄▄▄
██▄ ▄█▀▀
▄▄▀▄▄█ ▀
```
"""
bprint(A::AbstractMatrix, method::Symbol=DEFAULT_METHOD) = bprint(stdout, A, method)
function bprint(io::IO, A::AbstractMatrix, method::Symbol=DEFAULT_METHOD)
    return bprint(io, >(zero(eltype(A))), A, method)
end

"""
    bprint([io::IO], f, A, [method])

Write to `io` (or to the default output stream `stdout` if `io` is not given) a binary
unicode representation of `A` , filling values for which `f` returns `true`.

The printing method can be specified by passing either `:braille` or `:block`.
The default is `:$DEFAULT_METHOD`.

# Example
```julia-repl
julia> A = rand(1:9, 8, 8)
8×8 Matrix{Int64}:
 9  1  6  3  4  2  9  6
 4  1  2  8  2  5  9  1
 7  5  6  1  1  4  8  8
 4  8  3  4  8  7  8  8
 4  2  2  6  2  6  1  7
 9  1  4  1  8  1  6  1
 3  8  4  3  9  5  5  6
 1  4  4  2  8  6  3  9

julia> bprint(iseven, A)
⣂⢗⡫⣬
⢩⣏⣋⠢
julia> bprint(>(3), A, :block)
█ ▀▄▀▄█▀
██▀▄▄███
█ ▄▀▄▀▄▀
 ██ ██▀█
```
"""
function bprint(f::Function, A::AbstractMatrix, method::Symbol=DEFAULT_METHOD)
    return bprint(stdout, f, A, method)
end
function bprint(io::IO, f::Function, A::AbstractMatrix, method::Symbol=DEFAULT_METHOD)
    if method == :braille
        to_braille(io, f, A)
    elseif method == :block
        to_block(io, f, A)
    else
        throw(ArgumentError("Valid methods are :braille and :block, got :$method."))
    end
    return nothing
end

"""
    bstring(A, [method])

Return a string containing a binary unicode representation of `A` , filling values that are
`true` or greater than zero.

The printing method can be specified by passing either `:braille` or `:block`.
The default is `:$DEFAULT_METHOD`.

# Example
```julia-repl
julia> A = rand(Bool, 8, 8)
8×8 Matrix{Bool}:
 1  1  1  1  0  1  0  0
 1  0  0  1  1  1  0  0
 1  0  0  0  1  0  1  0
 1  0  1  0  1  1  1  1
 0  0  0  0  0  0  1  0
 0  1  1  0  1  0  0  1
 0  0  1  0  0  1  1  1
 1  1  1  1  0  0  1  1

julia> bstring(A)
"⡏⡙⣞⣄\n⣐⣆⠢⣵\n"

julia> bstring(A, :block)
"█▀▀█▄█  \n█ ▄ █▄█▄\n ▄▄ ▄ ▀▄\n▄▄█▄ ▀██\n"
```
"""
function bstring(A::AbstractMatrix, method::Symbol=DEFAULT_METHOD)
    return bstring(>(zero(eltype(A))), A, method)
end

"""
    bstring(f, A, [method])

Return a string containing a binary unicode representation of `A`, filling values for which
`f` returns `true`.

The printing method can be specified by passing either `:braille` or `:block`.
The default is `:$DEFAULT_METHOD`.

# Example
```julia-repl
julia> A = rand(1:9, 8, 8)
8×8 Matrix{Int64}:
 8  7  9  6  9  8  3  7
 9  9  3  3  5  5  3  2
 1  6  8  3  7  9  3  7
 9  4  4  7  8  7  3  4
 3  8  7  2  2  1  6  6
 4  8  9  4  1  3  4  6
 4  9  6  2  3  4  8  4
 7  2  7  9  8  2  6  7

julia> bstring(iseven, A)
"⢡⡌⡈⢐\n⢞⠼⣡⡿\n"

julia> bstring(>(3), A, :block)
"██▀▀██ ▀\n▄██▄██ █\n▄██▄  ██\n█▀█▄▄▀██\n"
```
"""
function bstring(f::Function, A::AbstractMatrix, method::Symbol=DEFAULT_METHOD)
    io = IOBuffer()
    bprint(io, f, A, method)
    return String(take!(io))
end
