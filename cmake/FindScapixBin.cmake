include(${CMAKE_CURRENT_LIST_DIR}/cmodule.cmake)

set(scapix_bin_hash_Darwin-arm64  0f050680fdc5414101ceae30ad45e11c826414143856ed3fbc595b32a2272807)
set(scapix_bin_hash_Darwin-x86_64 2f449c4b90e8db9be540a4f1a2f4ad0af29973068a1ebea2774d5d9c92fac5b9)
set(scapix_bin_hash_Linux-x86_64  41f91c7b02429773374cb08cf18e34566ef345797b209c040837ebfbc0982b05)
set(scapix_bin_hash_Windows-AMD64 cc8fbc361fe681fcd50a0f713ea6ce0c604bb0fdde4477abf81168d3d480d30c)

cmodule_add(
  scapix_bin 2.0.10
  URL "https://github.com/scapix-com/scapix-bin/archive/v2.0.10-${CMAKE_HOST_SYSTEM_NAME}-${CMAKE_HOST_SYSTEM_PROCESSOR}.tar.gz"
  URL_HASH SHA256=${scapix_bin_hash_${CMAKE_HOST_SYSTEM_NAME}-${CMAKE_HOST_SYSTEM_PROCESSOR}}
)

set(SCAPIX_EXE_DIR "${CMODULE_scapix_bin_SOURCE_DIR}" CACHE INTERNAL "")
