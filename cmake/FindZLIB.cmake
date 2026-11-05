include_guard(GLOBAL)

option(ZLIB_BUILD_TESTING "" OFF)
option(ZLIB_INSTALL "" OFF)

cmodule_add(
  zlib 1.4
  URL https://github.com/madler/zlib/releases/download/v1.4/zlib-1.4.tar.xz
  URL_HASH SHA256=4f11c512053d7bab8d9e9b89bde3575add3e4c50a383b42ef6cb837035fc5a7c
)
