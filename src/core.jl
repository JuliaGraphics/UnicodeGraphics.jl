const BRAILLE_HEX = (0x01, 0x02, 0x04, 0x40, 0x08, 0x10, 0x20, 0x80)

function to_braille(io::IO, f::Function, A::AbstractMatrix)
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
        println(io)
    end
    return nothing
end

function to_block(io::IO, f::Function, A::AbstractMatrix)
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
        println(io)
    end
    return nothing
end

@inline function checkval(f, a, y, x, yrange, xrange)
    x > last(xrange) && return false
    y > last(yrange) && return false
    return @inbounds f(a[y, x])
end
