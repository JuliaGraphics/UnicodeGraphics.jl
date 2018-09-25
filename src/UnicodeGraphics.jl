"""
Block and braile rendering of julia arrays, for terminal graphics.
"""
module UnicodeGraphics

export blockize, brailize, blockize!, brailize!

"""
    brailize(a, cutoff=0)
Convert an array to a block unicode string, filling values above the cutoff point.
"""
blockize(a, cutoff=0) = begin
    yrange, xrange = axes(a)
    out = Array{Char,2}(undef, length(xrange) + 1, (length(yrange) - 1) ÷ 2 + 1)
    blockize!(out, a, cutoff) 
end

"""
    blockize!(out, a, cutoff=0)
Convert an array to a braile unicode string, filling the `out` array.
Calculation of array dims is a little complicated:

```julia
yrange, xrange = axes(a)
out = Array{Char,2}(undef, length(xrange) + 1, (length(yrange) - 1) ÷ 2 + 1)
```
"""
blockize!(out, a, cutoff=0) = join(block_array!(out, a, cutoff))

function block_array!(out, a, cutoff)
    yrange, xrange = axes(a)
    for y in first(yrange):2:last(yrange)
        for x in xrange
            top = checkval(a, y, x, yrange, xrange, cutoff)
            bottom = checkval(a, y + 1, x, yrange, xrange, cutoff)
            if top
                ch = bottom ? '█' : '▀'
            else
                ch = bottom ? '▄' : ' '
            end
            out[x-first(xrange) + 1, (y-first(yrange)) ÷ 2 + 1] = Char(ch)
        end
        # Return after every column
        out[end, (y-first(yrange)) ÷ 2 + 1] = Char('\n')
    end
    # The last character is null
    out[end, end] = 0x00
    out
end

const braile_hex = ((0x01, 0x08), (0x02, 0x10), (0x04, 0x20), (0x40, 0x80))

"""
    brailize(a, cutoff=0)
Convert an array to a braile unicode string, filling values above the cutoff point.
"""
brailize(a, cutoff=0) = begin 
    yrange, xrange = axes(a)
    out = Array{Char,2}(undef, (length(xrange) - 1) ÷ 2 + 2, (length(yrange) - 1) ÷ 4 + 1)
    brailize!(out, a, cutoff) 
end

"""
    brailize!(out, a, cutoff=0)
Convert an array to a braile unicode string, filling the `out` array.
Calculation of array dims is a little complicated:

```julia
yrange, xrange = axes(a)
out = Array{Char,2}(undef, (length(xrange) - 1) ÷ 2 + 2, (length(yrange) - 1) ÷ 4 + 1)
```
"""
brailize!(out, a, cutoff=0) = join(braile_array!(out, a, cutoff))

function braile_array!(out, a, cutoff)
    yrange, xrange = axes(a)
    for y in first(yrange):4:last(yrange)
        for x in first(xrange):2:last(xrange)
            ch = 0x2800
            for j = 0:3, i = 0:1
                if checkval(a, y+j, x+i, yrange, xrange, cutoff)
                    ch += braile_hex[j % 4 + 1][i % 2 + 1]
                end
            end
            out[(x - first(xrange)) ÷ 2 + 1, (y-first(yrange)) ÷ 4 + 1] = ch
        end
        # Return after every column
        out[end, (y-first(yrange)) ÷ 4 + 1] = Char('\n')
    end
    # The last character is null
    out[end, end] = 0x00
    out
end

checkval(a, y, x, yrange, xrange, cutoff) = begin
    if x <= last(xrange) && y <= last(yrange)
        a[y, x] > cutoff
    else
        false
    end
end

end # module
