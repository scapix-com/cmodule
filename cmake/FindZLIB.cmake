include(${CMAKE_CURRENT_LIST_DIR}/cmodule.cmake)

cmodule_add(
  zlib 1.2.12
  URL      "https://zlib.net/zlib-1.2.12.tar.xz"
  URL_HASH SHA256=7db46b8d7726232a621befaab4a1c870f00a90805511c0e0090441dac57def18
)

if(NOT TARGET ZLIB::ZLIB)

  cmodule_select_target(zlib zlibstatic)
  target_include_directories(${CMODULE_TARGET} INTERFACE ${zlib_SOURCE_DIR} ${zlib_BINARY_DIR})
  add_library(ZLIB::ZLIB ALIAS ${CMODULE_TARGET})

endif()
