include_guard(GLOBAL)

set(scapix_bin_hash_Darwin-arm64  842a04ac02f93c4d77aa9343aa7ec66d1035c5ed3c3b346e450178ea24de31e0)
set(scapix_bin_hash_Darwin-x86_64 86b64fb7e63338c3d6b23d428247214e023b459ee5697e65ecf304210490d96e)
set(scapix_bin_hash_Linux-x86_64  be05e55be40029cbdc4c6997bbd9c8f243d102ce21513623cdd8d6761bea859f)
set(scapix_bin_hash_Windows-AMD64 de1ee9fc89c6ef6cf9ac1f741a4af4bcd5aee61f8f4eb6d60704cd37b067ccb9)

cmodule_add(
  scapix_bin 2.3.0
  URL https://github.com/scapix-com/scapix-bin/archive/refs/tags/v2.3.0-${CMAKE_HOST_SYSTEM_NAME}-${CMAKE_HOST_SYSTEM_PROCESSOR}.tar.gz
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
