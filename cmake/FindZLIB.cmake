include_guard(GLOBAL)

option(ZLIB_BUILD_TESTING "" OFF)
option(ZLIB_INSTALL "" OFF)

cmodule_add(
  zlib 1.3.2
  URL https://github.com/madler/zlib/releases/download/v1.3.2/zlib-1.3.2.tar.xz
  URL_HASH SHA256=d7a0654783a4da529d1bb793b7ad9c3318020af77667bcae35f95d0e42a792f3
)
