include(${CMAKE_CURRENT_LIST_DIR}/cmodule.cmake)

cmodule_add(
  zlib 1.2.11
  URL      "https://zlib.net/zlib-1.2.11.tar.xz"
  URL_HASH SHA256=4ff941449631ace0d4d203e3483be9dbc9da454084111f97ea0a2114e19bf066
)

if(NOT TARGET ZLIB::ZLIB)

  cmodule_select_target(zlib zlibstatic)
  target_include_directories(${CMODULE_TARGET} INTERFACE ${zlib_SOURCE_DIR} ${zlib_BINARY_DIR})
  add_library(ZLIB::ZLIB ALIAS ${CMODULE_TARGET})

endif()
