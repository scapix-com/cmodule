include_guard(GLOBAL)

option(FMT_INSTALL "" OFF)

cmodule_add(
  fmt 11.1.1
  URL "https://github.com/fmtlib/fmt/archive/refs/tags/11.1.1.tar.gz"
  URL_HASH SHA256=482eed9efbc98388dbaee5cb5f368be5eca4893456bb358c18b7ff71f835ae43
)
