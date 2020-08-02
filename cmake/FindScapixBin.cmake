include(${CMAKE_CURRENT_LIST_DIR}/cmodule.cmake)

set(scapix_bin_hash_Darwin-x86_64 76173fb6bc9724cb768e974196b76ded45dcfc042374f9c3214ff4e813982066)
set(scapix_bin_hash_Linux-x86_64  d7f53efc1543f66468f4d3c55060ea28261b9be7a70eacb8fe55654dfeb24892)
set(scapix_bin_hash_Windows-AMD64 efa93c366aba1e97297963c595101869794ee5931a5ababa8d0f3614a7ee3a18)

cmodule_add(
  scapix_bin 2.0.7
  URL "https://github.com/scapix-com/scapix-bin/archive/v2.0.7-${CMAKE_HOST_SYSTEM_NAME}-${CMAKE_HOST_SYSTEM_PROCESSOR}.tar.gz"
  URL_HASH SHA256=${scapix_bin_hash_${CMAKE_HOST_SYSTEM_NAME}-${CMAKE_HOST_SYSTEM_PROCESSOR}}
)

set(SCAPIX_EXE_DIR "${CMODULE_scapix_bin_SOURCE_DIR}" CACHE INTERNAL "")
