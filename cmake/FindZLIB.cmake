include_guard(GLOBAL)

option(ZLIB_BUILD_EXAMPLES "" OFF)
option(SKIP_INSTALL_ALL "zlib" ON)

cmodule_add(
  zlib 1.3.1
  URL      "https://github.com/madler/zlib/releases/download/v1.3.1/zlib-1.3.1.tar.xz"
  URL_HASH SHA256=38ef96b8dfe510d42707d9c781877914792541133e1870841463bfa73f883e32
)

if(BUILD_SHARED_LIBS)
  add_library(ZLIB::ZLIB ALIAS zlib)
else()
  add_library(ZLIB::ZLIB ALIAS zlibstatic)
endif()
