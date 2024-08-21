include_guard(GLOBAL)

option(FMT_INSTALL "" OFF)

cmodule_add(
  fmt 11.0.2
  URL "https://github.com/fmtlib/fmt/archive/refs/tags/11.0.2.tar.gz"
  URL_HASH SHA256=6cb1e6d37bdcb756dbbe59be438790db409cdb4868c66e888d5df9f13f7c027f
)
