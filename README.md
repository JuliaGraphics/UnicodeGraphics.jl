# UnicodeGraphics

[![Build Status](https://travis-ci.org/rafaqz/UnicodeGraphics.jl.svg?branch=master)](https://travis-ci.org/rafaqz/UnicodeGraphics.jl)
[![codecov.io](http://codecov.io/github/rafaqz/UnicodeGraphics.jl/coverage.svg?branch=master)](http://codecov.io/github/rafaqz/UnicodeGraphics.jl?branch=master)

Convert any matrix into a braille or block Unicode string, real fast and dependency free.

## Installation 
This package supports Julia ≥1.6. To install it, open the Julia REPL and run 
```julia-repl
julia> ]add UnicodeGraphics
```

## Examples
By default, `uprint` prints all values greater than zero in an array:
```julia
julia> pac = [
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
];

julia> uprint(pac)  # same as uprint(pac, :braille)
⠀⣠⣴⣾⣿⣿⣷⣦⣄⠀
⣰⣿⣿⣿⣧⣼⣿⡿⠟⠃
⣿⣿⣿⣿⣿⣏⡁⠀⠀⠠
⠹⣿⣿⣿⣿⣿⣿⣷⣦⡄
⠀⠙⠻⢿⣿⣿⡿⠟⠋⠀

julia> uprint(pac, :block)
     ▄▄██████▄▄     
  ▄██████████████▄  
 ▄███████  ████████ 
▄██████████████▀▀   
███████████▀▀       
███████████▄▄      ▀
▀██████████████▄▄   
 ▀█████████████████ 
  ▀██████████████▀  
     ▀▀██████▀▀     
```

It is also possible to pass a filtering function, filling values for which the function returns `true`, e.g. even numbers in the following array:
```julia
julia> ghost = [
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
];

julia> uprint(iseven, ghost)
⢀⠴⣾⣿⠷⣦⡀
⣴⠆⣸⣷⠆⣸⣧
⣿⢿⣿⠿⣿⡿⣿
⠁⠀⠉⠀⠉⠀⠈
```

Higher order arrays and non-number types are also supported, 
as long as the filtering function returns boolean values:
```julia-repl
julia> A = rand("abc123", 4, 4, 1, 2)
4×4×1×2 Array{Char, 4}:
[:, :, 1, 1] =
 'a'  'b'  'c'  'a'
 'b'  '2'  'b'  '1'
 'a'  'b'  '1'  'a'
 '1'  'b'  'a'  'b'

[:, :, 1, 2] =
 'a'  '2'  '2'  '1'
 'a'  '2'  'a'  'c'
 '3'  '2'  'c'  'b'
 'c'  'c'  'c'  '1'

julia> uprint(isletter, A, :block)
[:, :, 1, 1] =
█▀█▀
▀█▄█

[:, :, 1, 2] =
█ ▄▄
▄▄█▀
```

`uprint` can be used to write into any `IO` stream, defaulting to `stdout`.
```julia-repl
julia> io = IOBuffer();

julia> uprint(io, pac)

julia> String(take!(io)) |> print
⠀⣠⣴⣾⣿⣿⣷⣦⣄⠀
⣰⣿⣿⣿⣧⣼⣿⡿⠟⠃
⣿⣿⣿⣿⣿⣏⡁⠀⠀⠠
⠹⣿⣿⣿⣿⣿⣿⣷⣦⡄
⠀⠙⠻⢿⣿⣿⡿⠟⠋⠀
```

To directly return a string instead of printing to IO, `ustring` can be used:
```julia-repl
julia> ustring(iseven, ghost)
"⢀⠴⣾⣿⠷⣦⡀\n⣴⠆⣸⣷⠆⣸⣧\n⣿⢿⣿⠿⣿⡿⣿\n⠁⠀⠉⠀⠉⠀⠈\n"

julia> ustring(iseven, ghost, :block)
"   ▄▄████▄▄   \n ▄▀▀████▀▀██▄ \n ▄▄  ██▄▄  ██ \n██▀ ▄███▀ ▄███\n██████████████\n██▀███▀▀███▀██\n▀   ▀▀  ▀▀   ▀\n"
```
