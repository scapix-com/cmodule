include_guard(GLOBAL)

set(scapix_bin_hash_Darwin-arm64  da29759159a9b901d42ff8af82a8324af64bcc5a597c4d7a836fe8212ea7d54e)
set(scapix_bin_hash_Darwin-x86_64 140b142e9a5f963229c6514bd8fd7623903e4e555426cab4ae90df672a231f28)
set(scapix_bin_hash_Linux-x86_64  2bd049d9079b740a5de4023cceee69c6e90728d97d33ff7f6a043ba4f4859877)
set(scapix_bin_hash_Windows-AMD64 fd0bcb0a8612e205441ba4a2a4a15342b400868cd625f24259648e6ab3cc2928)

cmodule_add(
  scapix_bin 2.6.0
  URL https://github.com/scapix-com/scapix-bin/archive/refs/tags/v2.6.0-${CMAKE_HOST_SYSTEM_NAME}-${CMAKE_HOST_SYSTEM_PROCESSOR}.tar.gz
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
