include(${CMAKE_CURRENT_LIST_DIR}/cmodule.cmake)

set(scapix_bin_hash_Darwin-arm64  fdedbf0cd595fb902164086827fce6ac5be7c8b0a87f7ed8a5cc9cfc8330c3e1)
set(scapix_bin_hash_Darwin-x86_64 5e8cb570168b0a92b928e53e4bdb78ded9b4002a2e77962d87ec0ffd8337eed1)
set(scapix_bin_hash_Linux-x86_64  7a244f34d4d2540d54ac8996a911a775a2c6113037e5513ee458b8f8ab1f1eef)
set(scapix_bin_hash_Windows-AMD64 351bdc08cf11e6d49c6cac5fe1033f582aa0525f5fd64f16d06cbf147c7e40fb)

cmodule_add(
  scapix_bin 2.0.13
  URL "https://github.com/scapix-com/scapix-bin/archive/refs/tags/v2.0.13-${CMAKE_HOST_SYSTEM_NAME}-${CMAKE_HOST_SYSTEM_PROCESSOR}.tar.gz"
  URL_HASH SHA256=${scapix_bin_hash_${CMAKE_HOST_SYSTEM_NAME}-${CMAKE_HOST_SYSTEM_PROCESSOR}}
)

set(SCAPIX_EXE_DIR "${CMODULE_scapix_bin_SOURCE_DIR}" CACHE INTERNAL "")
