using Test
using ReferenceTests
using Suppressor: @capture_out
using UnicodeGraphics, OffsetArrays

pac = [
    0 0 0 0 0 0 0 1 1 1 1 1 1 0 0 0 0 0 0 0
    0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0
    0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0
    0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0
    0 0 1 1 1 1 1 1 1 0 0 1 1 1 1 1 1 1 1 0
    0 1 1 1 1 1 1 1 1 0 0 1 1 1 1 1 1 1 1 0
    0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0
    1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0
    1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0
    1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0
    1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 1
    1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0
    1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0
    0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0
    0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0
    0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0
    0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0
    0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0
    0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0
    0 0 0 0 0 0 0 1 1 1 1 1 1 0 0 0 0 0 0 0
]

@test_reference "references/braille_pac.txt" ustring(pac)
@test_reference "references/block_pac.txt" ustring(pac, :block)
@test_reference "references/braille_pac.txt" @capture_out uprint(pac)
@test_reference "references/block_pac.txt" @capture_out uprint(pac, :block)
@test_throws ArgumentError ustring(pac, :foo)

ghost = [
    0.0 0.0 0.0 0.0 0.0 1.0 1.0 1.0 1.0 0.0 0.0 0.0 0.0 0.0
    0.0 0.0 0.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 0.0 0.0 0.0
    0.0 0.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 0.0 0.0
    0.0 1.0 0.0 0.0 1.0 1.0 1.0 1.0 0.0 0.0 1.0 1.0 1.0 0.0
    0.0 0.0 0.0 0.0 0.0 1.0 1.0 0.0 0.0 0.0 0.0 1.0 1.0 0.0
    0.0 1.0 1.0 0.0 0.0 1.0 1.0 1.0 1.0 0.0 0.0 1.0 1.0 0.0
    1.0 1.0 1.0 0.0 0.0 1.0 1.0 1.0 1.0 0.0 0.0 1.0 1.0 1.0
    1.0 1.0 0.0 0.0 1.0 1.0 1.0 1.0 0.0 0.0 1.0 1.0 1.0 1.0
    1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0
    1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0
    1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0
    1.0 1.0 0.0 1.0 1.0 1.0 0.0 0.0 1.0 1.0 1.0 0.0 1.0 1.0
    1.0 0.0 0.0 0.0 1.0 1.0 0.0 0.0 1.0 1.0 0.0 0.0 0.0 1.0
]

@test_reference "references/braille_ghost.txt" ustring(ghost)
@test_reference "references/block_ghost.txt" ustring(ghost, :block)

offset_ghost = OffsetArray(ghost, 3:15, 4:17)

@test_reference "references/braille_ghost.txt" ustring(offset_ghost)
@test_reference "references/block_ghost.txt" ustring(offset_ghost, :block)

ghost2 = [
    1 7 7 7 7 8 6 4 6 3 9 9 9 7
    1 5 3 6 6 8 2 8 2 2 2 9 3 7
    9 5 4 8 8 6 4 8 4 8 2 6 5 9
    5 2 5 1 8 8 6 8 3 3 6 8 6 9
    9 9 9 3 1 8 4 5 3 7 9 6 8 3
    3 8 8 7 5 6 4 4 2 5 5 6 4 1
    2 8 8 3 7 4 6 2 8 9 7 6 8 2
    2 4 9 7 2 6 2 4 1 5 6 4 8 8
    8 2 4 4 4 4 8 6 4 4 6 4 2 2
    6 8 2 6 4 4 8 6 4 2 4 4 2 8
    4 2 6 4 2 6 8 6 6 2 8 8 8 8
    8 2 3 6 6 8 9 1 2 4 8 5 4 8
    8 3 7 3 8 6 9 3 6 6 1 9 1 6
]

@test_reference "references/braille_ghost.txt" ustring(iseven, ghost2)
@test_reference "references/block_ghost.txt" ustring(iseven, ghost2, :block)
@test_reference "references/braille_ghost.txt" @capture_out uprint(iseven, ghost2)
@test_reference "references/block_ghost.txt" @capture_out uprint(iseven, ghost2, :block)

# Test vector and n-dimensional arrays
v = [0, 1, 0, 1, 1, 0, 0, 1]
@test ustring(v) == "⠈⠈⠁⠈\n"

A = reshape(v, 2, 2, 1, 1, 2)
@test ustring(A) == "[:, :, 1, 1, 1] =\n⠒\n\n[:, :, 1, 1, 2] =\n⠑\n"

# Remove deprecations before next breaking release:
@test_reference "references/braille_ghost.txt" (@test_deprecated brailize(ghost))
@test_reference "references/block_ghost.txt" (@test_deprecated blockize(ghost))
