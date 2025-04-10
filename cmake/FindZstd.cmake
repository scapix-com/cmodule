include_guard(GLOBAL)

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
  zstd 1.5.7
  URL      "https://github.com/facebook/zstd/releases/download/v1.5.7/zstd-1.5.7.tar.gz"
  URL_HASH SHA256=eb33e51f49a15e023950cd7825ca74a4a2b43db8354825ac24fc1b7ee09e6fa3
  SOURCE_SUBDIR "build/cmake"
)

if(TARGET libzstd_shared)
  target_include_directories(libzstd_shared INTERFACE ${CMODULE_zstd_SOURCE_DIR}/lib ${CMODULE_zstd_SOURCE_DIR}/lib/common)
  add_library(zstd::libzstd_shared ALIAS libzstd_shared)
endif()

if(TARGET libzstd_static)
  target_include_directories(libzstd_static INTERFACE ${CMODULE_zstd_SOURCE_DIR}/lib ${CMODULE_zstd_SOURCE_DIR}/lib/common)
  add_library(zstd::libzstd_static ALIAS libzstd_static)
endif()

if(BUILD_SHARED_LIBS)
  add_library(zstd::libzstd ALIAS libzstd_shared)
else()
  add_library(zstd::libzstd ALIAS libzstd_static)
endif()
