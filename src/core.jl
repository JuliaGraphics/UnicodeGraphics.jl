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

# These are the 256 Unicode-16 octant characters. Some "octants" are
# taken from other character ranges, e.g. quandrants. This needs to be
# an array because the character mapping is not regular.
#
# The array is stored according to the octant bit pattern:
#     0 1
#     2 3
#     4 5
#     6 7
const OCTANT_CHARS = Char[
    Char(0x0020),Char(0x1CEA8),Char(0x1CEAB),Char(0x1FB82),Char(0x1CD00),Char(0x2598),Char(0x1CD01),Char(0x1CD02),
    Char(0x1CD03),Char(0x1CD04),Char(0x259D),Char(0x1CD05),Char(0x1CD06),Char(0x1CD07),Char(0x1CD08),Char(0x2580),
    Char(0x1CD09),Char(0x1CD0A),Char(0x1CD0B),Char(0x1CD0C),Char(0x1FBE6),Char(0x1CD0D),Char(0x1CD0E),Char(0x1CD0F),
    Char(0x1CD10),Char(0x1CD11),Char(0x1CD12),Char(0x1CD13),Char(0x1CD14),Char(0x1CD15),Char(0x1CD16),Char(0x1CD17),
    Char(0x1CD18),Char(0x1CD19),Char(0x1CD1A),Char(0x1CD1B),Char(0x1CD1C),Char(0x1CD1D),Char(0x1CD1E),Char(0x1CD1F),
    Char(0x1FBE7),Char(0x1CD20),Char(0x1CD21),Char(0x1CD22),Char(0x1CD23),Char(0x1CD24),Char(0x1CD25),Char(0x1CD26),
    Char(0x1CD27),Char(0x1CD28),Char(0x1CD29),Char(0x1CD2A),Char(0x1CD2B),Char(0x1CD2C),Char(0x1CD2D),Char(0x1CD2E),
    Char(0x1CD2F),Char(0x1CD30),Char(0x1CD31),Char(0x1CD32),Char(0x1CD33),Char(0x1CD34),Char(0x1CD35),Char(0x1FB85),
    Char(0x1CEA3),Char(0x1CD36),Char(0x1CD37),Char(0x1CD38),Char(0x1CD39),Char(0x1CD3A),Char(0x1CD3B),Char(0x1CD3C),
    Char(0x1CD3D),Char(0x1CD3E),Char(0x1CD3F),Char(0x1CD40),Char(0x1CD41),Char(0x1CD42),Char(0x1CD43),Char(0x1CD44),
    Char(0x2596),Char(0x1CD45),Char(0x1CD46),Char(0x1CD47),Char(0x1CD48),Char(0x258C),Char(0x1CD49),Char(0x1CD4A),
    Char(0x1CD4B),Char(0x1CD4C),Char(0x259E),Char(0x1CD4D),Char(0x1CD4E),Char(0x1CD4F),Char(0x1CD50),Char(0x259B),
    Char(0x1CD51),Char(0x1CD52),Char(0x1CD53),Char(0x1CD54),Char(0x1CD55),Char(0x1CD56),Char(0x1CD57),Char(0x1CD58),
    Char(0x1CD59),Char(0x1CD5A),Char(0x1CD5B),Char(0x1CD5C),Char(0x1CD5D),Char(0x1CD5E),Char(0x1CD5F),Char(0x1CD60),
    Char(0x1CD61),Char(0x1CD62),Char(0x1CD63),Char(0x1CD64),Char(0x1CD65),Char(0x1CD66),Char(0x1CD67),Char(0x1CD68),
    Char(0x1CD69),Char(0x1CD6A),Char(0x1CD6B),Char(0x1CD6C),Char(0x1CD6D),Char(0x1CD6E),Char(0x1CD6F),Char(0x1CD70),
    Char(0x1CEA0),Char(0x1CD71),Char(0x1CD72),Char(0x1CD73),Char(0x1CD74),Char(0x1CD75),Char(0x1CD76),Char(0x1CD77),
    Char(0x1CD78),Char(0x1CD79),Char(0x1CD7A),Char(0x1CD7B),Char(0x1CD7C),Char(0x1CD7D),Char(0x1CD7E),Char(0x1CD7F),
    Char(0x1CD80),Char(0x1CD81),Char(0x1CD82),Char(0x1CD83),Char(0x1CD84),Char(0x1CD85),Char(0x1CD86),Char(0x1CD87),
    Char(0x1CD88),Char(0x1CD89),Char(0x1CD8A),Char(0x1CD8B),Char(0x1CD8C),Char(0x1CD8D),Char(0x1CD8E),Char(0x1CD8F),
    Char(0x2597),Char(0x1CD90),Char(0x1CD91),Char(0x1CD92),Char(0x1CD93),Char(0x259A),Char(0x1CD94),Char(0x1CD95),
    Char(0x1CD96),Char(0x1CD97),Char(0x2590),Char(0x1CD98),Char(0x1CD99),Char(0x1CD9A),Char(0x1CD9B),Char(0x259C),
    Char(0x1CD9C),Char(0x1CD9D),Char(0x1CD9E),Char(0x1CD9F),Char(0x1CDA0),Char(0x1CDA1),Char(0x1CDA2),Char(0x1CDA3),
    Char(0x1CDA4),Char(0x1CDA5),Char(0x1CDA6),Char(0x1CDA7),Char(0x1CDA8),Char(0x1CDA9),Char(0x1CDAA),Char(0x1CDAB),
    Char(0x2582),Char(0x1CDAC),Char(0x1CDAD),Char(0x1CDAE),Char(0x1CDAF),Char(0x1CDB0),Char(0x1CDB1),Char(0x1CDB2),
    Char(0x1CDB3),Char(0x1CDB4),Char(0x1CDB5),Char(0x1CDB6),Char(0x1CDB7),Char(0x1CDB8),Char(0x1CDB9),Char(0x1CDBA),
    Char(0x1CDBB),Char(0x1CDBC),Char(0x1CDBD),Char(0x1CDBE),Char(0x1CDBF),Char(0x1CDC0),Char(0x1CDC1),Char(0x1CDC2),
    Char(0x1CDC3),Char(0x1CDC4),Char(0x1CDC5),Char(0x1CDC6),Char(0x1CDC7),Char(0x1CDC8),Char(0x1CDC9),Char(0x1CDCA),
    Char(0x1CDCB),Char(0x1CDCC),Char(0x1CDCD),Char(0x1CDCE),Char(0x1CDCF),Char(0x1CDD0),Char(0x1CDD1),Char(0x1CDD2),
    Char(0x1CDD3),Char(0x1CDD4),Char(0x1CDD5),Char(0x1CDD6),Char(0x1CDD7),Char(0x1CDD8),Char(0x1CDD9),Char(0x1CDDA),
    Char(0x2584),Char(0x1CDDB),Char(0x1CDDC),Char(0x1CDDD),Char(0x1CDDE),Char(0x2599),Char(0x1CDDF),Char(0x1CDE0),
    Char(0x1CDE1),Char(0x1CDE2),Char(0x259F),Char(0x1CDE3),Char(0x2586),Char(0x1CDE4),Char(0x1CDE5),Char(0x2588),
]

function to_octant(io::IO, f::Function, A::AbstractMatrix)
    h, w = axes(A)
    yrange = first(h):4:last(h)
    xrange = first(w):2:last(w)
    for y in yrange
        for x in xrange
            index = 1
            for row in 0:3, col in 0:1
                if checkval(f, A, y + row, x + col, h, w)
                    bit = 1 << (col + 2 * row)
                    index += bit
                end
            end
            print(io, OCTANT_CHARS[index])
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
