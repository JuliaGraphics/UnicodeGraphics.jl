"""
Block and braille rendering of julia arrays, for terminal graphics.
"""
module UnicodeGraphics

export blockize, brailize

"""
    blockize(a, cutoff=0)

Convert an array to a block unicode string, filling values above the cutoff point.
"""
function blockize(A, cutoff=0)
    io = IOBuffer()
    h, w = axes(A)
    yrange = first(h):2:last(h)
    for y in yrange
        for x in w
            top = checkval(A, y, x, h, w, cutoff)
            bottom = checkval(A, y + 1, x, h, w, cutoff)
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
    brailize(a, cutoff=0)

Convert an array to a braille unicode string, filling values above the cutoff point.
"""
function brailize(A, cutoff=0)
    io = IOBuffer()
    h, w = axes(A)
    yrange = first(h):4:last(h)
    xrange = first(w):2:last(w)
    for y in yrange
        for x in xrange
            ch = 0x2800
            for j in 0:3, i in 0:1
                if checkval(A, y + j, x + i, h, w, cutoff)
                    @inbounds ch +=  BRAILLE_HEX[1 + j % 4 + 4 * (i % 2)]
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

@inline function checkval(a, y, x, yrange, xrange, cutoff)
    x > last(xrange) && return false
    y > last(yrange) && return false
    return @inbounds a[y, x] > cutoff
end

end # module
