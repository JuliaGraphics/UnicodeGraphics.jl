# UnicodeGraphics

[![Build Status](https://travis-ci.org/rafaqz/UnicodeGraphics.jl.svg?branch=master)](https://travis-ci.org/rafaqz/UnicodeGraphics.jl)
[![codecov.io](http://codecov.io/github/rafaqz/UnicodeGraphics.jl/coverage.svg?branch=master)](http://codecov.io/github/rafaqz/UnicodeGraphics.jl?branch=master)

Convert any matrix into a braille or block Unicode string, real fast and dependency free.

## Installation 
This package supports Julia ≥1.6. To install it, open the Julia REPL and run 
```julia
julia> ]add UnicodeGraphics
```

## Examples
By default, `uprint` prints all values in an array that are true or greater than zero:
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

When passing a filtering function, 
UnicodeGraphics will fill all values for which the function returns `true`, 
e.g. all even numbers using `iseven`:
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
]; # a ghost is hidden in here

julia> uprint(iseven, ghost)
⢀⠴⣾⣿⠷⣦⡀
⣴⠆⣸⣷⠆⣸⣧
⣿⢿⣿⠿⣿⡿⣿
⠁⠀⠉⠀⠉⠀⠈
```

Non-number type inputs are supported, 
as long as the filtering function returns boolean values:
```julia
julia> A = rand("abc123", 4, 4)
4×4 Matrix{Char}:
 '3'  'c'  '3'  '1'
 'a'  'c'  '1'  'c'
 '1'  '1'  '2'  'a'
 'b'  'a'  '2'  'a'

julia> uprint(isletter, A, :block)
▄█ ▄
▄▄ █
```

Instead of passing a function directly, 
[do-block syntax](https://docs.julialang.org/en/v1/manual/functions/#Do-Block-Syntax-for-Function-Arguments) can be used:
```julia
julia> A = [x + y * im for y in 10:-1:1, x in 1:10]
10×10 Matrix{Complex{Int64}}:
 1+10im  2+10im  3+10im  …  8+10im  9+10im  10+10im
 1+9im   2+9im   3+9im      8+9im   9+9im   10+9im
 1+8im   2+8im   3+8im      8+8im   9+8im   10+8im
  ⋮                      ⋱
 1+3im   2+3im   3+3im      8+3im   9+3im   10+3im
 1+2im   2+2im   3+2im      8+2im   9+2im   10+2im
 1+1im   2+1im   3+1im      8+1im   9+1im   10+1im

julia> uprint(A) do x
           φ = angle(x)
           φ < π/4
       end
⠀⠀⠀⢀⣴
⠀⢀⣴⣿⣿
⠐⠛⠛⠛⠛
```

Multidimensional arrays are also supported:
```julia
julia> A = rand(Bool, 4, 4, 1, 2)
4×4×1×2 Array{Bool, 4}:
[:, :, 1, 1] =
 0  1  0  0
 1  0  1  0
 0  1  1  1
 0  0  1  1

[:, :, 1, 2] =
 1  1  0  0
 1  1  0  0
 0  0  1  0
 0  0  1  0

julia> uprint(A, :block)
[:, :, 1, 1] =
▄▀▄ 
 ▀██

[:, :, 1, 2] =
██  
  █ 
```

`uprint` can be used to write into any `IO` stream, defaulting to `stdout`.
```julia
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
```julia
julia> ustring(pac)
"⠀⣠⣴⣾⣿⣿⣷⣦⣄⠀\n⣰⣿⣿⣿⣧⣼⣿⡿⠟⠃\n⣿⣿⣿⣿⣿⣏⡁⠀⠀⠠\n⠹⣿⣿⣿⣿⣿⣿⣷⣦⡄\n⠀⠙⠻⢿⣿⣿⡿⠟⠋⠀\n"
```
