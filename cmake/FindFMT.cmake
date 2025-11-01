include_guard(GLOBAL)

option(FMT_INSTALL "" OFF)

cmodule_add(
  fmt 12.1.0
  URL "https://github.com/fmtlib/fmt/archive/refs/tags/12.1.0.tar.gz"
  URL_HASH SHA256=ea7de4299689e12b6dddd392f9896f08fb0777ac7168897a244a6d6085043fea
)
