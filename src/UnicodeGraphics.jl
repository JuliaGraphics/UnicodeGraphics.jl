"""
Block and braille rendering of julia arrays, for terminal graphics.
"""
module UnicodeGraphics

const DEFAULT_METHOD = :braille
include("api.jl")
include("core.jl")
include("deprecate.jl")

export uprint, ustring

end # module
