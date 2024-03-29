include_guard(GLOBAL)

set(scapix_bin_hash_Darwin-arm64  bdbeb6b79e31c1088455b2f3cf99ce69149a6759fc01bc0e97e8b1edee34c1f1)
set(scapix_bin_hash_Darwin-x86_64 b9a6e59b711d05a78563aae47891beb16f22bde906718a2768d6f71420cfa8f3)
set(scapix_bin_hash_Linux-x86_64  709ee46992d65eb09c72169f78688dba407d4bd9e55740c54b59ee43b69c811c)
set(scapix_bin_hash_Windows-AMD64 ed19b2ecc3f48c6b25acdfe0c5f5c83ac7d76780ceb49ef3e8ed2f5fbbb6d024)

cmodule_add(
  scapix_bin 2.1.0
  URL "https://github.com/scapix-com/scapix-bin/archive/refs/tags/v2.1.0-${CMAKE_HOST_SYSTEM_NAME}-${CMAKE_HOST_SYSTEM_PROCESSOR}.tar.gz"
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
