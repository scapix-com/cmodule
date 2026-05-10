include_guard(GLOBAL)

set(scapix_bin_hash_Darwin-arm64  d3b5e7f5d9195e3a19b8cfb25ad92cb5ec08d392e5148ee7b52d2ccf61519232)
set(scapix_bin_hash_Darwin-x86_64 eb7dbcfba11484d02628903ce5f4902d4b8896ae9921eb977b7986870457026b)
set(scapix_bin_hash_Linux-x86_64  e7a7af64120e44439835279b3df078932d97001a9a473b895cca282840c9a69f)
set(scapix_bin_hash_Windows-AMD64 9b53f28fec87bbd6aeec8670b12656fab66e6c7d4301ca32d32a1b6749d2312d)

cmodule_add(
  scapix_bin 2.2.0
  URL https://github.com/scapix-com/scapix-bin/archive/refs/tags/v2.2.0-${CMAKE_HOST_SYSTEM_NAME}-${CMAKE_HOST_SYSTEM_PROCESSOR}.tar.gz
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
