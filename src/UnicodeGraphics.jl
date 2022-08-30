"""
Block and braille rendering of julia arrays, for terminal graphics.
"""
module UnicodeGraphics

export to_block, to_braille, bprint

const DEFAULT_METHOD = :braille
"""
    bprint(A, [method])

Print array to a binary unicode string, filling values that are `true` or greater than zero.

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
bprint(A, method::Symbol=DEFAULT_METHOD) = bprint(>(zero(eltype(A))), A, method)

"""
    bprint(f, A, [method])

Print array to a binary unicode string, filling values for which `f` returns `true`.

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
function bprint(f, A::AbstractMatrix, method::Symbol=DEFAULT_METHOD)
    if method == :braille
        print(to_braille(f, A))
    elseif method == :block
        print(to_block(f, A))
    else
        throw(ArgumentError("Valid methods are :braille and :block, got :$method."))
    end
    return nothing
end

"""
    to_block(A, cutoff=0)

Convert an array to a block unicode string, filling values above the cutoff point.
"""
function to_block(A, cutoff::Real=0)
    cutoff = convert(eltype(A), cutoff)
    return to_block(>(cutoff), A)
end
"""
    to_block(f, A)

Convert an array to a block unicode string, filling values for which `f` returns `true`.

# Example
```julia-repl
julia> A = rand(1:9, 8, 8)
8×8 Matrix{Int64}:
 2  6  6  5  6  2  8  4
 7  9  7  7  9  3  8  2
 2  2  3  6  7  6  2  9
 3  5  8  8  6  7  4  2
 6  3  4  7  8  2  1  6
 5  5  3  9  5  4  5  2
 7  8  4  8  8  9  9  1
 1  1  4  1  5  7  6  6

julia> print(to_block(iseven, A))
▀▀▀ ▀▀██
▀▀▄█▄▀█▄
▀ ▀ ▀█ █
 ▀█▀▀ ▄▄
```
"""
function to_block(f, A::AbstractMatrix)
    io = IOBuffer()
    h, w = axes(A)
    yrange = first(h):2:last(h)
    for y in yrange
        for x in w
            top = checkval(f, A, y, x, h, w)
            bottom = checkval(f, A, y + 1, x, h, w)
            if top
                print(io, bottom ? '█' : '▀')
            else
                print(io, bottom ? '▄' : ' ')
            end
        end
        # Return after every column
        y != last(yrange) && println(io)
    end
    # The last character is null
    print(io, Char(0x00))
    return String(take!(io))
end

const BRAILLE_HEX = (0x01, 0x02, 0x04, 0x40, 0x08, 0x10, 0x20, 0x80)

"""
    to_braille(A, cutoff=0)

Convert an array to a braille unicode string, filling values above the cutoff point.
"""
function to_braille(A, cutoff::Real=0)
    cutoff = convert(eltype(A), cutoff)
    return to_braille(>(cutoff), A)
end
"""
    to_braille(f, A)

Convert an array to a braille unicode string, filling values for which `f` returns `true`.
# Example
```julia-repl
julia> A = rand(1:9, 8, 8)
8×8 Matrix{Int64}:
 2  6  6  5  6  2  8  4
 7  9  7  7  9  3  8  2
 2  2  3  6  7  6  2  9
 3  5  8  8  6  7  4  2
 6  3  4  7  8  2  1  6
 5  5  3  9  5  4  5  2
 7  8  4  8  8  9  9  1
 1  1  4  1  5  7  6  6

julia> print(to_braille(iseven, A))
⠭⣡⡩⣟
⠡⡥⠝⣘
```
"""
function to_braille(f, A::AbstractMatrix)
    io = IOBuffer()
    h, w = axes(A)
    yrange = first(h):4:last(h)
    xrange = first(w):2:last(w)
    for y in yrange
        for x in xrange
            ch = 0x2800
            for j in 0:3, i in 0:1
                if checkval(f, A, y + j, x + i, h, w)
                    @inbounds ch += BRAILLE_HEX[1 + j % 4 + 4 * (i % 2)]
                end
            end
            print(io, Char(ch))
        end
        # Return after every column
        y != last(yrange) && println(io)
    end
    # The last character is null
    print(io, Char(0x00))
    return String(take!(io))
end

@inline function checkval(f, a, y, x, yrange, xrange)
    x > last(xrange) && return false
    y > last(yrange) && return false
    return @inbounds f(a[y, x])
end

end # module
