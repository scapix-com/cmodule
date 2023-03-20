include(${CMAKE_CURRENT_LIST_DIR}/cmodule.cmake)

set(ZSTD_BUILD_SHARED ${CMODULE_SHARED_LIB})
set(ZSTD_BUILD_STATIC ${CMODULE_STATIC_LIB})

option(ZSTD_LEGACY_SUPPORT "LEGACY SUPPORT" OFF)
option(ZSTD_BUILD_PROGRAMS "BUILD PROGRAMS" OFF)
option(ZSTD_BUILD_CONTRIB "BUILD CONTRIB" OFF)
option(ZSTD_BUILD_TESTS "BUILD TESTS" OFF)

if(MSVC)
  option(ZSTD_USE_STATIC_RUNTIME "LINK TO STATIC RUN-TIME LIBRARIES" ON)
endif()

cmodule_add(
  zstd 1.5.4
  URL      "https://github.com/facebook/zstd/archive/refs/tags/v1.5.4.tar.gz"
  URL_HASH SHA256=35ad983197f8f8eb0c963877bf8be50490a0b3df54b4edeb8399ba8a8b2f60a4
)

cmodule_set_local_options()
add_subdirectory("${CMODULE_zstd_SOURCE_DIR}/build/cmake" "${CMODULE_zstd_BINARY_DIR}" EXCLUDE_FROM_ALL)
cmodule_restore_local_options()

cmodule_select_target(libzstd_shared libzstd_static)
target_include_directories(${CMODULE_TARGET} INTERFACE ${CMODULE_zstd_SOURCE_DIR}/lib ${CMODULE_zstd_SOURCE_DIR}/lib/common)
add_library(zstd::libzstd ALIAS ${CMODULE_TARGET})

if(NOT TARGET zstd::libzstd_shared AND TARGET libzstd_shared)
  add_library(zstd::libzstd_shared ALIAS libzstd_shared)
endif()

if(NOT TARGET zstd::libzstd_static AND TARGET libzstd_static)
  add_library(zstd::libzstd_static ALIAS libzstd_static)
endif()
