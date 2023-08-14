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
  zstd 1.5.5
  URL      "https://github.com/facebook/zstd/releases/download/v1.5.5/zstd-1.5.5.tar.gz"
  URL_HASH SHA256=9c4396cc829cfae319a6e2615202e82aad41372073482fce286fac78646d3ee4
  SOURCE_SUBDIR "build/cmake"
)

cmodule_select_target(libzstd_shared libzstd_static)
target_include_directories(${CMODULE_TARGET} INTERFACE ${CMODULE_zstd_SOURCE_DIR}/lib ${CMODULE_zstd_SOURCE_DIR}/lib/common)
add_library(zstd::libzstd ALIAS ${CMODULE_TARGET})

if(NOT TARGET zstd::libzstd_shared AND TARGET libzstd_shared)
  add_library(zstd::libzstd_shared ALIAS libzstd_shared)
endif()

if(NOT TARGET zstd::libzstd_static AND TARGET libzstd_static)
  add_library(zstd::libzstd_static ALIAS libzstd_static)
endif()
