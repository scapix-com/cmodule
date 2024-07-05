include_guard(GLOBAL)

option(FMT_INSTALL "" OFF)

cmodule_add(
  fmt 11.0.1
  URL "https://github.com/fmtlib/fmt/archive/refs/tags/11.0.1.tar.gz"
  URL_HASH SHA256=7d009f7f89ac84c0a83f79ed602463d092fbf66763766a907c97fd02b100f5e9
)
