"""
Block and braile rendering of julia arrays, for terminal graphics.
"""
module UnicodeGraphics

export blockize, brailize

blockize(a, cutoff=0) = blockize(a, cutoff, 1:size(a, 1), 1:size(a, 2))
blockize(a, cutoff, yrange, xrange) = begin
    out = Array{Char,2}(undef, length(xrange) + 1, (length(yrange) - 1) ÷ 2 + 1)
    blockize!(out, a, cutoff, yrange, xrange) 
end

blockize!(out, a, cutoff, yrange, xrange) = join(block_array!(out, a, cutoff, yrange, xrange))

function block_array!(out, a, cutoff, yrange, xrange)
    for y in yrange.start:2:yrange.stop
        for x in xrange
            top = checkval(a, y, x, yrange, xrange, cutoff)
            bottom = checkval(a, y + 1, x, yrange, xrange, cutoff)
            if top
                ch = bottom ? '█' : '▀'
            else
                ch = bottom ? '▄' : ' '
            end
            out[x-xrange.start + 1, (y-yrange.start) ÷ 2 + 1] = Char(ch)
        end
        # Return after every column
        out[end, (y-yrange.start) ÷ 2 + 1] = Char('\n')
    end
    # The last character is null
    out[end, end] = 0x00
    out
end

const braile_hex = ((0x01, 0x08), (0x02, 0x10), (0x04, 0x20), (0x40, 0x80))

brailize(a, cutoff=0) = brailize(a, cutoff, 1:size(a, 1), 1:size(a, 2))
brailize(a, cutoff, yrange, xrange) = begin 
    out = Array{Char,2}(undef, (length(xrange) - 1) ÷ 2 + 2, (length(yrange) - 1) ÷ 4 + 1)
    brailize!(out, a, cutoff, yrange, xrange) 
end

brailize!(out, a, cutoff, yrange, xrange) = join(braile_array!(out, a, cutoff, yrange, xrange))

function braile_array!(out, a, cutoff, yrange, xrange)
    for y = yrange.start:4:yrange.stop
        for x = xrange.start:2:xrange.stop
            ch = 0x2800
            for j = 0:3, i = 0:1
                if checkval(a, y+j, x+i, yrange, xrange, cutoff)
                    ch += braile_hex[j % 4 + 1][i % 2 + 1]
                end
            end
            out[(x - xrange.start) ÷ 2 + 1, (y-yrange.start) ÷ 4 + 1] = ch
        end
        # Return after every column
        out[end, (y-yrange.start) ÷ 4 + 1] = Char('\n')
    end
    # The last character is null
    out[end, end] = 0x00
    out
end

checkval(a, y, x, yrange, xrange, cutoff) = begin
    if x <= xrange.stop && y <= yrange.stop
        a[y, x] > cutoff
    else
        false
    end
end

end # module
