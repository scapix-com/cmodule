include_guard(GLOBAL)

include(cmodule)

cmodule_add(
  zlib 1.2.13
  URL      "https://github.com/madler/zlib/releases/download/v1.2.13/zlib-1.2.13.tar.xz"
  URL_HASH SHA256=d14c38e313afc35a9a8760dadf26042f51ea0f5d154b0630a31da0540107fb98
)

cmodule_select_target(zlib zlibstatic)
target_include_directories(${CMODULE_TARGET} INTERFACE ${zlib_SOURCE_DIR} ${zlib_BINARY_DIR})
add_library(ZLIB::ZLIB ALIAS ${CMODULE_TARGET})
