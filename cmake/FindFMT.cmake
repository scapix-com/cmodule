include_guard(GLOBAL)

option(FMT_INSTALL "" OFF)

cmodule_add(
  fmt 12.0.0
  URL "https://github.com/fmtlib/fmt/archive/refs/tags/12.0.0.tar.gz"
  URL_HASH SHA256=aa3e8fbb6a0066c03454434add1f1fc23299e85758ceec0d7d2d974431481e40
)
