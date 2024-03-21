include_guard(GLOBAL)

set(scapix_bin_hash_Darwin-arm64  e4c981d3050d00c3f7fa57b2c1c4142685af5c5b38270b48079773b28ccd2a4d)
set(scapix_bin_hash_Darwin-x86_64 344ff09be14f7ec5b82b5be34046b40af5fd5c2dbec148116028eddc6c82406b)
set(scapix_bin_hash_Linux-x86_64  ce43736ad68b9bc6de300ff87ca1e1e44badf5d59f2076002cf0a3aa60088824)
set(scapix_bin_hash_Windows-AMD64 eccfa62d0cf74ae263235e5207afd1e9309af73945756462e02eea3e958a175e)

cmodule_add(
  scapix_bin 2.0.16
  URL "https://github.com/scapix-com/scapix-bin/archive/refs/tags/v2.0.16-${CMAKE_HOST_SYSTEM_NAME}-${CMAKE_HOST_SYSTEM_PROCESSOR}.tar.gz"
  URL_HASH SHA256=${scapix_bin_hash_${CMAKE_HOST_SYSTEM_NAME}-${CMAKE_HOST_SYSTEM_PROCESSOR}}
)

set(SCAPIX_EXE "${CMODULE_scapix_bin_SOURCE_DIR}/${CMAKE_HOST_SYSTEM_NAME}-${CMAKE_HOST_SYSTEM_PROCESSOR}/scapix" CACHE INTERNAL "")

if(NOT EXISTS "${SCAPIX_EXE}")
  set(SCAPIX_EXE "${SCAPIX_EXE}.exe" CACHE INTERNAL "")
endif()

set(SCAPIX_JAVA_EXE "${CMODULE_scapix_bin_SOURCE_DIR}/${CMAKE_HOST_SYSTEM_NAME}-${CMAKE_HOST_SYSTEM_PROCESSOR}/scapix_java" CACHE INTERNAL "")

if(NOT EXISTS "${SCAPIX_JAVA_EXE}")
  set(SCAPIX_JAVA_EXE "${SCAPIX_JAVA_EXE}.exe" CACHE INTERNAL "")
endif()
