include_guard(GLOBAL)

set(scapix_bin_hash_Darwin-arm64  db298dd91f8c6416cad7ca91e84e71c3e4bc7f8dcea0b13509363ffa14f4d4f8)
set(scapix_bin_hash_Darwin-x86_64 9b730501dee2dafe9cefc7f46f0d2a70655f44db6bacba3f6ccb716eaf7f9fcc)
set(scapix_bin_hash_Linux-x86_64  e959c764f0a1dea73b9d42ee23aeed44b66117cfa84b347daede16d6e69bc3af)
set(scapix_bin_hash_Windows-AMD64 e0a61c18a582d5c9e445121792c2b7c11d6058acdbd31276fda4d824ba5ef2a0)

cmodule_add(
  scapix_bin 2.4.0
  URL https://github.com/scapix-com/scapix-bin/archive/refs/tags/v2.4.0-${CMAKE_HOST_SYSTEM_NAME}-${CMAKE_HOST_SYSTEM_PROCESSOR}.tar.gz
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
