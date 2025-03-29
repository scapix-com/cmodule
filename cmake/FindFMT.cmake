include_guard(GLOBAL)

option(FMT_INSTALL "" OFF)

cmodule_add(
  fmt 11.1.4
  URL "https://github.com/fmtlib/fmt/archive/refs/tags/11.1.4.tar.gz"
  URL_HASH SHA256=ac366b7b4c2e9f0dde63a59b3feb5ee59b67974b14ee5dc9ea8ad78aa2c1ee1e
)
