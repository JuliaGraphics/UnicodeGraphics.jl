"""
    uprint([io::IO], A, [method])

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

julia> uprint(A)
⠜⠚⣘⣚
⣛⢆⣺⠩
julia> uprint(A, :block)
 █▄█ █▄█
▀   ▄▄▄▄
██▄ ▄█▀▀
▄▄▀▄▄█ ▀
```
"""
uprint(A::AbstractArray, method::Symbol=DEFAULT_METHOD) = uprint(stdout, A, method)
function uprint(io::IO, A::AbstractArray, method::Symbol=DEFAULT_METHOD)
    return uprint(io, >(zero(eltype(A))), A, method)
end

"""
    uprint([io::IO], f, A, [method])

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

julia> uprint(iseven, A)
⣂⢗⡫⣬
⢩⣏⣋⠢
julia> uprint(>(3), A, :block)
█ ▀▄▀▄█▀
██▀▄▄███
█ ▄▀▄▀▄▀
 ██ ██▀█
```
"""
function uprint(f::Function, A::AbstractArray, method::Symbol=DEFAULT_METHOD)
    return uprint(stdout, f, A, method)
end
function uprint(io::IO, f::Function, A::AbstractArray, method::Symbol=DEFAULT_METHOD)
    return _uprint_nd(io::IO, f::Function, A::AbstractArray, method::Symbol)
end

"""
    ustring(A, [method])

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

julia> ustring(A)
"⡏⡙⣞⣄\n⣐⣆⠢⣵\n"

julia> ustring(A, :block)
"█▀▀█▄█  \n█ ▄ █▄█▄\n ▄▄ ▄ ▀▄\n▄▄█▄ ▀██\n"
```
"""
function ustring(A::AbstractArray, method::Symbol=DEFAULT_METHOD)
    return ustring(>(zero(eltype(A))), A, method)
end

"""
    ustring(f, A, [method])

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

julia> ustring(iseven, A)
"⢡⡌⡈⢐\n⢞⠼⣡⡿\n"

julia> ustring(>(3), A, :block)
"██▀▀██ ▀\n▄██▄██ █\n▄██▄  ██\n█▀█▄▄▀██\n"
```
"""
function ustring(f::Function, A::AbstractArray, method::Symbol=DEFAULT_METHOD)
    io = IOBuffer()
    uprint(io, f, A, method)
    return String(take!(io))
end
