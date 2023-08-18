include_guard(GLOBAL)

include(cmodule)

cmodule_add(
  zlib 1.3
  URL      "https://github.com/madler/zlib/releases/download/v1.3/zlib-1.3.tar.xz"
  URL_HASH SHA256=8a9ba2898e1d0d774eca6ba5b4627a11e5588ba85c8851336eb38de4683050a7
)

target_include_directories(zlib INTERFACE ${zlib_SOURCE_DIR} ${zlib_BINARY_DIR})
target_include_directories(zlibstatic INTERFACE ${zlib_SOURCE_DIR} ${zlib_BINARY_DIR})

if(BUILD_SHARED_LIBS)
  add_library(ZLIB::ZLIB ALIAS zlib)
else()
  add_library(ZLIB::ZLIB ALIAS zlibstatic)
endif()
