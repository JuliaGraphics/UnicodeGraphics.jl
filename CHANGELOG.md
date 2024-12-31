# UnicodeGraphics.jl
## Version `v0.2.2`
* ![Feature][badge-feature] Added support for plotting via quadrants,
  sextants, and octants. Octants requires Unicode 16 font support and
  is in 2024 not yet widely available. Things will work but the result
  will look bad. ([#8][pr-8])

## Version `v0.2.1`
* ![Feature][badge-feature] Added support for multidimensional arrays ([#7][pr-7])

## Version `v0.2.0`
* ![Feature][badge-feature] Directly write to `stdout` using `uprint(A)` or to any IO using `uprint(io, A)` ([#5][pr-5])
* ![Feature][badge-feature] Added support for filtering functions to `uprint` and `ustring`. `uprint(f, A)` shows values of `A` for which `f` returns `true` ([#5][pr-5])
* ![Deprecation][badge-deprecation] Deprecated `brailize(A)`, use `ustring(A)` or `ustring(A, :braille)` instead ([#5][pr-5])
* ![Deprecation][badge-deprecation] Deprecated `blockize(A)`, use `ustring(A, :block)` instead ([#5][pr-5])

<!--
# Badges
![BREAKING][badge-breaking]
![Deprecation][badge-deprecation]
![Feature][badge-feature]
![Enhancement][badge-enhancement]
![Bugfix][badge-bugfix]
![Experimental][badge-experimental]
![Maintenance][badge-maintenance]
![Documentation][badge-docs]
-->

[pr-5]: https://github.com/JuliaGraphics/UnicodeGraphics.jl/pull/5
[pr-7]: https://github.com/JuliaGraphics/UnicodeGraphics.jl/pull/7
[pr-8]: https://github.com/JuliaGraphics/UnicodeGraphics.jl/pull/8

[badge-breaking]: https://img.shields.io/badge/BREAKING-red.svg
[badge-deprecation]: https://img.shields.io/badge/deprecation-orange.svg
[badge-feature]: https://img.shields.io/badge/feature-green.svg
[badge-enhancement]: https://img.shields.io/badge/enhancement-blue.svg
[badge-bugfix]: https://img.shields.io/badge/bugfix-purple.svg
[badge-security]: https://img.shields.io/badge/security-black.svg
[badge-experimental]: https://img.shields.io/badge/experimental-lightgrey.svg
[badge-maintenance]: https://img.shields.io/badge/maintenance-gray.svg
[badge-docs]: https://img.shields.io/badge/docs-orange.svg
