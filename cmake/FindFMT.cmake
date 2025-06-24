include_guard(GLOBAL)

option(FMT_INSTALL "" OFF)

cmodule_add(
  fmt 11.2.0
  URL "https://github.com/fmtlib/fmt/archive/refs/tags/11.2.0.tar.gz"
  URL_HASH SHA256=bc23066d87ab3168f27cef3e97d545fa63314f5c79df5ea444d41d56f962c6af
)
