include_guard(GLOBAL)

cmodule_add(
  zlib 1.3.1
  URL      "https://github.com/madler/zlib/releases/download/v1.3.1/zlib-1.3.1.tar.xz"
  URL_HASH SHA256=38ef96b8dfe510d42707d9c781877914792541133e1870841463bfa73f883e32
)

target_include_directories(zlib INTERFACE ${CMODULE_zlib_SOURCE_DIR} ${CMODULE_zlib_BINARY_DIR})
target_include_directories(zlibstatic INTERFACE ${CMODULE_zlib_SOURCE_DIR} ${CMODULE_zlib_BINARY_DIR})

if(BUILD_SHARED_LIBS)
  add_library(ZLIB::ZLIB ALIAS zlib)
else()
  add_library(ZLIB::ZLIB ALIAS zlibstatic)
endif()
