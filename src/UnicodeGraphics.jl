"""
Block and braille rendering of julia arrays, for terminal graphics.
"""
module UnicodeGraphics

export blockize, brailize

"""
    blockize(A, cutoff=0)

Convert an array to a block unicode string, filling values above the cutoff point.
"""
function blockize(A, cutoff::Real=0)
    cutoff = convert(eltype(A), cutoff)
    return blockize(>(cutoff), A)
end
"""
    blockize(f, A)

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

julia> print(blockize(iseven, A))
▀▀▀ ▀▀██
▀▀▄█▄▀█▄
▀ ▀ ▀█ █
 ▀█▀▀ ▄▄
```
"""
function blockize(f, A::AbstractMatrix)
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
    brailize(A, cutoff=0)

Convert an array to a braille unicode string, filling values above the cutoff point.
"""
function brailize(A, cutoff::Real=0)
    cutoff = convert(eltype(A), cutoff)
    return brailize(>(cutoff), A)
end
"""
    brailize(f, A)

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

julia> print(brailize(iseven, A))
⠭⣡⡩⣟
⠡⡥⠝⣘
```
"""
function brailize(f, A::AbstractMatrix)
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
