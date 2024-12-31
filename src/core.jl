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

# These are the 16 Unicode quadrant characters.
#
# The array is stored according to the octant bit pattern:
#     0 1
#     2 3
#     4 5
#     6 7
const QUADRANT_CHARS = Char[0x00A0, # NO-BREAK SPACE
                            0x2598, # QUADRANT UPPER LEFT
                            0x259D, # QUADRANT UPPER RIGHT
                            0x2580, # UPPER HALF BLOCK
                            0x2596, # QUADRANT LOWER LEFT
                            0x258C, # LEFT HALF BLOCK
                            0x259E, # QUADRANT UPPER RIGHT AND LOWER LEFT
                            0x259B, # QUADRANT UPPER LEFT AND UPPER RIGHT AND LOWER LEFT
                            0x2597, # QUADRANT LOWER RIGHT
                            0x259A, # QUADRANT UPPER LEFT AND LOWER RIGHT
                            0x2590, # RIGHT HALF BLOCK
                            0x259C, # QUADRANT UPPER LEFT AND UPPER RIGHT AND LOWER RIGHT
                            0x2584, # LOWER HALF BLOCK
                            0x2599, # QUADRANT UPPER LEFT AND LOWER LEFT AND LOWER RIGHT
                            0x259F, # QUADRANT UPPER RIGHT AND LOWER LEFT AND LOWER RIGHT
                            0x2588] # FULL BLOCK

function to_quadrant(io::IO, f::Function, A::AbstractMatrix)
    h, w = axes(A)
    yrange = first(h):2:last(h)
    xrange = first(w):2:last(w)
    for y in yrange
        for x in xrange
            index = 1
            for row in 0:1, col in 0:1
                if checkval(f, A, y + row, x + col, h, w)
                    bit = 1 << (col + 2 * row)
                    index += bit
                end
            end
            print(io, QUADRANT_CHARS[index])
        end
        println(io)
    end
    return nothing
end

# These are the 64 Unicode sextant characters. This needs to be an
# array because the character mapping is not regular.
#
# The array is stored according to this sextant bit pattern:
#     0 1
#     2 3
#     4 5
const SEXTANT_CHARS = Char[0x00000A0, # NO-BREAK SPACE
                           0x001FB00, # BLOCK SEXTANT-1
                           0x001FB01, # BLOCK SEXTANT-2
                           0x001FB02, # BLOCK SEXTANT-12
                           0x001FB03, # BLOCK SEXTANT-3
                           0x001FB04, # BLOCK SEXTANT-13
                           0x001FB05, # BLOCK SEXTANT-23
                           0x001FB06, # BLOCK SEXTANT-123
                           0x001FB07, # BLOCK SEXTANT-4
                           0x001FB08, # BLOCK SEXTANT-14
                           0x001FB09, # BLOCK SEXTANT-24
                           0x001FB0A, # BLOCK SEXTANT-124
                           0x001FB0B, # BLOCK SEXTANT-34
                           0x001FB0C, # BLOCK SEXTANT-134
                           0x001FB0D, # BLOCK SEXTANT-234
                           0x001FB0E, # BLOCK SEXTANT-1234
                           0x001FB0F, # BLOCK SEXTANT-5
                           0x001FB10, # BLOCK SEXTANT-15
                           0x001FB11, # BLOCK SEXTANT-25
                           0x001FB12, # BLOCK SEXTANT-125
                           0x001FB13, # BLOCK SEXTANT-35
                           0x000258C, # LEFT HALF BLOCK
                           0x001FB14, # BLOCK SEXTANT-235
                           0x001FB15, # BLOCK SEXTANT-1235
                           0x001FB16, # BLOCK SEXTANT-45
                           0x001FB17, # BLOCK SEXTANT-145
                           0x001FB18, # BLOCK SEXTANT-245
                           0x001FB19, # BLOCK SEXTANT-1245
                           0x001FB1A, # BLOCK SEXTANT-345
                           0x001FB1B, # BLOCK SEXTANT-1345
                           0x001FB1C, # BLOCK SEXTANT-2345
                           0x001FB1D, # BLOCK SEXTANT-12345
                           0x001FB1E, # BLOCK SEXTANT-6
                           0x001FB1F, # BLOCK SEXTANT-16
                           0x001FB20, # BLOCK SEXTANT-26
                           0x001FB21, # BLOCK SEXTANT-126
                           0x001FB22, # BLOCK SEXTANT-36
                           0x001FB23, # BLOCK SEXTANT-136
                           0x001FB24, # BLOCK SEXTANT-236
                           0x001FB25, # BLOCK SEXTANT-1236
                           0x001FB26, # BLOCK SEXTANT-46
                           0x001FB27, # BLOCK SEXTANT-146
                           0x0002590, # RIGHT HALF BLOCK
                           0x001FB28, # BLOCK SEXTANT-1246
                           0x001FB29, # BLOCK SEXTANT-346
                           0x001FB2A, # BLOCK SEXTANT-1346
                           0x001FB2B, # BLOCK SEXTANT-2346
                           0x001FB2C, # BLOCK SEXTANT-12346
                           0x001FB2D, # BLOCK SEXTANT-56
                           0x001FB2E, # BLOCK SEXTANT-156
                           0x001FB2F, # BLOCK SEXTANT-256
                           0x001FB30, # BLOCK SEXTANT-1256
                           0x001FB31, # BLOCK SEXTANT-356
                           0x001FB32, # BLOCK SEXTANT-1356
                           0x001FB33, # BLOCK SEXTANT-2356
                           0x001FB34, # BLOCK SEXTANT-12356
                           0x001FB35, # BLOCK SEXTANT-456
                           0x001FB36, # BLOCK SEXTANT-1456
                           0x001FB37, # BLOCK SEXTANT-2456
                           0x001FB38, # BLOCK SEXTANT-12456
                           0x001FB39, # BLOCK SEXTANT-3456
                           0x001FB3A, # BLOCK SEXTANT-13456
                           0x001FB3B, # BLOCK SEXTANT-23456
                           0x00002588] # FULL BLOCK

function to_sextant(io::IO, f::Function, A::AbstractMatrix)
    h, w = axes(A)
    yrange = first(h):3:last(h)
    xrange = first(w):2:last(w)
    for y in yrange
        for x in xrange
            index = 1
            for row in 0:2, col in 0:1
                if checkval(f, A, y + row, x + col, h, w)
                    bit = 1 << (col + 2 * row)
                    index += bit
                end
            end
            print(io, SEXTANT_CHARS[index])
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
const OCTANT_CHARS = Char[0x000000A0, # NO-BREAK SPACE
                          0x0001CEA8, # LEFT HALF UPPER ONE QUARTER BLOCK
                          0x0001CEAB, # RIGHT HALF UPPER ONE QUARTER BLOCK
                          0x0001FB82, # UPPER ONE QUARTER BLOCK
                          0x0001CD00, # BLOCK OCTANT-3
                          0x00002598, # QUADRANT UPPER LEFT
                          0x0001CD01, # BLOCK OCTANT-23
                          0x0001CD02, # BLOCK OCTANT-123
                          0x0001CD03, # BLOCK OCTANT-4
                          0x0001CD04, # BLOCK OCTANT-14
                          0x0000259D, # QUADRANT UPPER RIGHT
                          0x0001CD05, # BLOCK OCTANT-124
                          0x0001CD06, # BLOCK OCTANT-34
                          0x0001CD07, # BLOCK OCTANT-134
                          0x0001CD08, # BLOCK OCTANT-234
                          0x00002580, # UPPER HALF BLOCK
                          0x0001CD09, # BLOCK OCTANT-5
                          0x0001CD0A, # BLOCK OCTANT-15
                          0x0001CD0B, # BLOCK OCTANT-25
                          0x0001CD0C, # BLOCK OCTANT-125
                          0x0001FBE6, # MIDDLE LEFT ONE QUARTER BLOCK
                          0x0001CD0D, # BLOCK OCTANT-135
                          0x0001CD0E, # BLOCK OCTANT-235
                          0x0001CD0F, # BLOCK OCTANT-1235
                          0x0001CD10, # BLOCK OCTANT-45
                          0x0001CD11, # BLOCK OCTANT-145
                          0x0001CD12, # BLOCK OCTANT-245
                          0x0001CD13, # BLOCK OCTANT-1245
                          0x0001CD14, # BLOCK OCTANT-345
                          0x0001CD15, # BLOCK OCTANT-1345
                          0x0001CD16, # BLOCK OCTANT-2345
                          0x0001CD17, # BLOCK OCTANT-12345
                          0x0001CD18, # BLOCK OCTANT-6
                          0x0001CD19, # BLOCK OCTANT-16
                          0x0001CD1A, # BLOCK OCTANT-26
                          0x0001CD1B, # BLOCK OCTANT-126
                          0x0001CD1C, # BLOCK OCTANT-36
                          0x0001CD1D, # BLOCK OCTANT-136
                          0x0001CD1E, # BLOCK OCTANT-236
                          0x0001CD1F, # BLOCK OCTANT-1236
                          0x0001FBE7, # MIDDLE RIGHT ONE QUARTER BLOCK
                          0x0001CD20, # BLOCK OCTANT-146
                          0x0001CD21, # BLOCK OCTANT-246
                          0x0001CD22, # BLOCK OCTANT-1246
                          0x0001CD23, # BLOCK OCTANT-346
                          0x0001CD24, # BLOCK OCTANT-1346
                          0x0001CD25, # BLOCK OCTANT-2346
                          0x0001CD26, # BLOCK OCTANT-12346
                          0x0001CD27, # BLOCK OCTANT-56
                          0x0001CD28, # BLOCK OCTANT-156
                          0x0001CD29, # BLOCK OCTANT-256
                          0x0001CD2A, # BLOCK OCTANT-1256
                          0x0001CD2B, # BLOCK OCTANT-356
                          0x0001CD2C, # BLOCK OCTANT-1356
                          0x0001CD2D, # BLOCK OCTANT-2356
                          0x0001CD2E, # BLOCK OCTANT-12356
                          0x0001CD2F, # BLOCK OCTANT-456
                          0x0001CD30, # BLOCK OCTANT-1456
                          0x0001CD31, # BLOCK OCTANT-2456
                          0x0001CD32, # BLOCK OCTANT-12456
                          0x0001CD33, # BLOCK OCTANT-3456
                          0x0001CD34, # BLOCK OCTANT-13456
                          0x0001CD35, # BLOCK OCTANT-23456
                          0x0001FB85, # UPPER THREE QUARTERS BLOCK
                          0x0001CEA3, # LEFT HALF LOWER ONE QUARTER BLOCK
                          0x0001CD36, # BLOCK OCTANT-17
                          0x0001CD37, # BLOCK OCTANT-27
                          0x0001CD38, # BLOCK OCTANT-127
                          0x0001CD39, # BLOCK OCTANT-37
                          0x0001CD3A, # BLOCK OCTANT-137
                          0x0001CD3B, # BLOCK OCTANT-237
                          0x0001CD3C, # BLOCK OCTANT-1237
                          0x0001CD3D, # BLOCK OCTANT-47
                          0x0001CD3E, # BLOCK OCTANT-147
                          0x0001CD3F, # BLOCK OCTANT-247
                          0x0001CD40, # BLOCK OCTANT-1247
                          0x0001CD41, # BLOCK OCTANT-347
                          0x0001CD42, # BLOCK OCTANT-1347
                          0x0001CD43, # BLOCK OCTANT-2347
                          0x0001CD44, # BLOCK OCTANT-12347
                          0x00002596, # QUADRANT LOWER LEFT
                          0x0001CD45, # BLOCK OCTANT-157
                          0x0001CD46, # BLOCK OCTANT-257
                          0x0001CD47, # BLOCK OCTANT-1257
                          0x0001CD48, # BLOCK OCTANT-357
                          0x0000258C, # LEFT HALF BLOCK
                          0x0001CD49, # BLOCK OCTANT-2357
                          0x0001CD4A, # BLOCK OCTANT-12357
                          0x0001CD4B, # BLOCK OCTANT-457
                          0x0001CD4C, # BLOCK OCTANT-1457
                          0x0000259E, # QUADRANT UPPER RIGHT AND LOWER LEFT
                          0x0001CD4D, # BLOCK OCTANT-12457
                          0x0001CD4E, # BLOCK OCTANT-3457
                          0x0001CD4F, # BLOCK OCTANT-13457
                          0x0001CD50, # BLOCK OCTANT-23457
                          0x0000259B, # QUADRANT UPPER LEFT AND UPPER RIGHT AND LOWER LEFT
                          0x0001CD51, # BLOCK OCTANT-67
                          0x0001CD52, # BLOCK OCTANT-167
                          0x0001CD53, # BLOCK OCTANT-267
                          0x0001CD54, # BLOCK OCTANT-1267
                          0x0001CD55, # BLOCK OCTANT-367
                          0x0001CD56, # BLOCK OCTANT-1367
                          0x0001CD57, # BLOCK OCTANT-2367
                          0x0001CD58, # BLOCK OCTANT-12367
                          0x0001CD59, # BLOCK OCTANT-467
                          0x0001CD5A, # BLOCK OCTANT-1467
                          0x0001CD5B, # BLOCK OCTANT-2467
                          0x0001CD5C, # BLOCK OCTANT-12467
                          0x0001CD5D, # BLOCK OCTANT-3467
                          0x0001CD5E, # BLOCK OCTANT-13467
                          0x0001CD5F, # BLOCK OCTANT-23467
                          0x0001CD60, # BLOCK OCTANT-123467
                          0x0001CD61, # BLOCK OCTANT-567
                          0x0001CD62, # BLOCK OCTANT-1567
                          0x0001CD63, # BLOCK OCTANT-2567
                          0x0001CD64, # BLOCK OCTANT-12567
                          0x0001CD65, # BLOCK OCTANT-3567
                          0x0001CD66, # BLOCK OCTANT-13567
                          0x0001CD67, # BLOCK OCTANT-23567
                          0x0001CD68, # BLOCK OCTANT-123567
                          0x0001CD69, # BLOCK OCTANT-4567
                          0x0001CD6A, # BLOCK OCTANT-14567
                          0x0001CD6B, # BLOCK OCTANT-24567
                          0x0001CD6C, # BLOCK OCTANT-124567
                          0x0001CD6D, # BLOCK OCTANT-34567
                          0x0001CD6E, # BLOCK OCTANT-134567
                          0x0001CD6F, # BLOCK OCTANT-234567
                          0x0001CD70, # BLOCK OCTANT-1234567
                          0x0001CEA0, # RIGHT HALF LOWER ONE QUARTER BLOCK
                          0x0001CD71, # BLOCK OCTANT-18
                          0x0001CD72, # BLOCK OCTANT-28
                          0x0001CD73, # BLOCK OCTANT-128
                          0x0001CD74, # BLOCK OCTANT-38
                          0x0001CD75, # BLOCK OCTANT-138
                          0x0001CD76, # BLOCK OCTANT-238
                          0x0001CD77, # BLOCK OCTANT-1238
                          0x0001CD78, # BLOCK OCTANT-48
                          0x0001CD79, # BLOCK OCTANT-148
                          0x0001CD7A, # BLOCK OCTANT-248
                          0x0001CD7B, # BLOCK OCTANT-1248
                          0x0001CD7C, # BLOCK OCTANT-348
                          0x0001CD7D, # BLOCK OCTANT-1348
                          0x0001CD7E, # BLOCK OCTANT-2348
                          0x0001CD7F, # BLOCK OCTANT-12348
                          0x0001CD80, # BLOCK OCTANT-58
                          0x0001CD81, # BLOCK OCTANT-158
                          0x0001CD82, # BLOCK OCTANT-258
                          0x0001CD83, # BLOCK OCTANT-1258
                          0x0001CD84, # BLOCK OCTANT-358
                          0x0001CD85, # BLOCK OCTANT-1358
                          0x0001CD86, # BLOCK OCTANT-2358
                          0x0001CD87, # BLOCK OCTANT-12358
                          0x0001CD88, # BLOCK OCTANT-458
                          0x0001CD89, # BLOCK OCTANT-1458
                          0x0001CD8A, # BLOCK OCTANT-2458
                          0x0001CD8B, # BLOCK OCTANT-12458
                          0x0001CD8C, # BLOCK OCTANT-3458
                          0x0001CD8D, # BLOCK OCTANT-13458
                          0x0001CD8E, # BLOCK OCTANT-23458
                          0x0001CD8F, # BLOCK OCTANT-123458
                          0x00002597, # QUADRANT LOWER RIGHT
                          0x0001CD90, # BLOCK OCTANT-168
                          0x0001CD91, # BLOCK OCTANT-268
                          0x0001CD92, # BLOCK OCTANT-1268
                          0x0001CD93, # BLOCK OCTANT-368
                          0x0000259A, # QUADRANT UPPER LEFT AND LOWER RIGHT
                          0x0001CD94, # BLOCK OCTANT-2368
                          0x0001CD95, # BLOCK OCTANT-12368
                          0x0001CD96, # BLOCK OCTANT-468
                          0x0001CD97, # BLOCK OCTANT-1468
                          0x00002590, # RIGHT HALF BLOCK
                          0x0001CD98, # BLOCK OCTANT-12468
                          0x0001CD99, # BLOCK OCTANT-3468
                          0x0001CD9A, # BLOCK OCTANT-13468
                          0x0001CD9B, # BLOCK OCTANT-23468
                          0x0000259C, # QUADRANT UPPER LEFT AND UPPER RIGHT AND LOWER RIGHT
                          0x0001CD9C, # BLOCK OCTANT-568
                          0x0001CD9D, # BLOCK OCTANT-1568
                          0x0001CD9E, # BLOCK OCTANT-2568
                          0x0001CD9F, # BLOCK OCTANT-12568
                          0x0001CDA0, # BLOCK OCTANT-3568
                          0x0001CDA1, # BLOCK OCTANT-13568
                          0x0001CDA2, # BLOCK OCTANT-23568
                          0x0001CDA3, # BLOCK OCTANT-123568
                          0x0001CDA4, # BLOCK OCTANT-4568
                          0x0001CDA5, # BLOCK OCTANT-14568
                          0x0001CDA6, # BLOCK OCTANT-24568
                          0x0001CDA7, # BLOCK OCTANT-124568
                          0x0001CDA8, # BLOCK OCTANT-34568
                          0x0001CDA9, # BLOCK OCTANT-134568
                          0x0001CDAA, # BLOCK OCTANT-234568
                          0x0001CDAB, # BLOCK OCTANT-1234568
                          0x00002582, # LOWER ONE QUARTER BLOCK
                          0x0001CDAC, # BLOCK OCTANT-178
                          0x0001CDAD, # BLOCK OCTANT-278
                          0x0001CDAE, # BLOCK OCTANT-1278
                          0x0001CDAF, # BLOCK OCTANT-378
                          0x0001CDB0, # BLOCK OCTANT-1378
                          0x0001CDB1, # BLOCK OCTANT-2378
                          0x0001CDB2, # BLOCK OCTANT-12378
                          0x0001CDB3, # BLOCK OCTANT-478
                          0x0001CDB4, # BLOCK OCTANT-1478
                          0x0001CDB5, # BLOCK OCTANT-2478
                          0x0001CDB6, # BLOCK OCTANT-12478
                          0x0001CDB7, # BLOCK OCTANT-3478
                          0x0001CDB8, # BLOCK OCTANT-13478
                          0x0001CDB9, # BLOCK OCTANT-23478
                          0x0001CDBA, # BLOCK OCTANT-123478
                          0x0001CDBB, # BLOCK OCTANT-578
                          0x0001CDBC, # BLOCK OCTANT-1578
                          0x0001CDBD, # BLOCK OCTANT-2578
                          0x0001CDBE, # BLOCK OCTANT-12578
                          0x0001CDBF, # BLOCK OCTANT-3578
                          0x0001CDC0, # BLOCK OCTANT-13578
                          0x0001CDC1, # BLOCK OCTANT-23578
                          0x0001CDC2, # BLOCK OCTANT-123578
                          0x0001CDC3, # BLOCK OCTANT-4578
                          0x0001CDC4, # BLOCK OCTANT-14578
                          0x0001CDC5, # BLOCK OCTANT-24578
                          0x0001CDC6, # BLOCK OCTANT-124578
                          0x0001CDC7, # BLOCK OCTANT-34578
                          0x0001CDC8, # BLOCK OCTANT-134578
                          0x0001CDC9, # BLOCK OCTANT-234578
                          0x0001CDCA, # BLOCK OCTANT-1234578
                          0x0001CDCB, # BLOCK OCTANT-678
                          0x0001CDCC, # BLOCK OCTANT-1678
                          0x0001CDCD, # BLOCK OCTANT-2678
                          0x0001CDCE, # BLOCK OCTANT-12678
                          0x0001CDCF, # BLOCK OCTANT-3678
                          0x0001CDD0, # BLOCK OCTANT-13678
                          0x0001CDD1, # BLOCK OCTANT-23678
                          0x0001CDD2, # BLOCK OCTANT-123678
                          0x0001CDD3, # BLOCK OCTANT-4678
                          0x0001CDD4, # BLOCK OCTANT-14678
                          0x0001CDD5, # BLOCK OCTANT-24678
                          0x0001CDD6, # BLOCK OCTANT-124678
                          0x0001CDD7, # BLOCK OCTANT-34678
                          0x0001CDD8, # BLOCK OCTANT-134678
                          0x0001CDD9, # BLOCK OCTANT-234678
                          0x0001CDDA, # BLOCK OCTANT-1234678
                          0x00002584, # LOWER HALF BLOCK
                          0x0001CDDB, # BLOCK OCTANT-15678
                          0x0001CDDC, # BLOCK OCTANT-25678
                          0x0001CDDD, # BLOCK OCTANT-125678
                          0x0001CDDE, # BLOCK OCTANT-35678
                          0x00002599, # QUADRANT UPPER LEFT AND LOWER LEFT AND LOWER RIGHT
                          0x0001CDDF, # BLOCK OCTANT-235678
                          0x0001CDE0, # BLOCK OCTANT-1235678
                          0x0001CDE1, # BLOCK OCTANT-45678
                          0x0001CDE2, # BLOCK OCTANT-145678
                          0x0000259F, # QUADRANT UPPER RIGHT AND LOWER LEFT AND LOWER RIGHT
                          0x0001CDE3, # BLOCK OCTANT-1245678
                          0x00002586, # LOWER THREE QUARTERS BLOCK
                          0x0001CDE4, # BLOCK OCTANT-1345678
                          0x0001CDE5, # BLOCK OCTANT-2345678
                          0x00002588] # FULL BLOCK

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
