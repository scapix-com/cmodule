include_guard(GLOBAL)

include(cmodule)

if(BUILD_SHARED_LIBS)
  option(ZSTD_BUILD_STATIC "" OFF)
  option(ZSTD_BUILD_SHARED "" ON)
else()
  option(ZSTD_BUILD_STATIC "" ON)
  option(ZSTD_BUILD_SHARED "" OFF)
endif()

option(ZSTD_LEGACY_SUPPORT "" OFF)
option(ZSTD_BUILD_PROGRAMS "" OFF)
option(ZSTD_BUILD_CONTRIB "" OFF)
option(ZSTD_BUILD_TESTS "" OFF)

if(MSVC)
  option(ZSTD_USE_STATIC_RUNTIME "" ON)
endif()

cmodule_add(
  zstd 1.5.5
  URL      "https://github.com/facebook/zstd/releases/download/v1.5.5/zstd-1.5.5.tar.gz"
  URL_HASH SHA256=9c4396cc829cfae319a6e2615202e82aad41372073482fce286fac78646d3ee4
  SOURCE_SUBDIR "build/cmake"
)

if(TARGET libzstd_shared)
  target_include_directories(libzstd_shared INTERFACE ${CMODULE_zstd_SOURCE_DIR}/lib ${CMODULE_zstd_SOURCE_DIR}/lib/common)
endif()

if(TARGET libzstd_static)
  target_include_directories(libzstd_static INTERFACE ${CMODULE_zstd_SOURCE_DIR}/lib ${CMODULE_zstd_SOURCE_DIR}/lib/common)
endif()

if(BUILD_SHARED_LIBS)
  add_library(zstd::libzstd ALIAS libzstd_shared)
else()
  add_library(zstd::libzstd ALIAS libzstd_static)
endif()
