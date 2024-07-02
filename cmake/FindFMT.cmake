include_guard(GLOBAL)

option(FMT_INSTALL "" OFF)

cmodule_add(
  fmt 11.0.0
  URL "https://github.com/fmtlib/fmt/archive/refs/tags/11.0.0.tar.gz"
  URL_HASH SHA256=8e20e2aacdd3f264fa5be9cba879fa3972c52bfd9d5310112250e7eaaf492f2c
)
