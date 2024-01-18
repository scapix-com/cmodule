include_guard(GLOBAL)

option(FMT_INSTALL "" OFF)

cmodule_add(
  fmt 10.2.1
  URL "https://github.com/fmtlib/fmt/archive/refs/tags/10.2.1.tar.gz"
  URL_HASH SHA256=1250e4cc58bf06ee631567523f48848dc4596133e163f02615c97f78bab6c811
)
