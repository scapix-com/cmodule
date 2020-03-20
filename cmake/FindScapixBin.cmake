include(${CMAKE_CURRENT_LIST_DIR}/cmodule.cmake)

set(scapix_bin_hash_Darwin-x86_64 6e75d3add67915a10faedf96699de498e0f35284fe96874ae86ba759f5c72a2f)
set(scapix_bin_hash_Linux-x86_64  286e3e2836a20624fb1afb7acdceb8ef351301ea76082f24ef81b4c767e4ce96)
set(scapix_bin_hash_Windows-AMD64 682a5567b8cd43559a717cd9376c49c06672c8b24cd9d8f8cf8121fc87c66b05)

cmodule_add(
  scapix_bin 2.0.1
  URL "https://github.com/scapix-com/scapix-bin/archive/v2.0.1-${CMAKE_HOST_SYSTEM_NAME}-${CMAKE_HOST_SYSTEM_PROCESSOR}.tar.gz"
  URL_HASH SHA256=${scapix_bin_hash_${CMAKE_HOST_SYSTEM_NAME}-${CMAKE_HOST_SYSTEM_PROCESSOR}}
)

set(SCAPIX_EXE_DIR "${CMODULE_scapix_bin_SOURCE_DIR}" CACHE INTERNAL "")
