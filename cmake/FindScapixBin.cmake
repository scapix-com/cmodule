include(${CMAKE_CURRENT_LIST_DIR}/cmodule.cmake)

set(scapix_bin_hash_Darwin-arm64  2d0e460597f47f1ce3e062a05e1f7b9a80b7b3e9f7aec16476bfdfb7baa62004)
set(scapix_bin_hash_Darwin-x86_64 dc0689bf087edf705a73f3c73135d5e9b168bc02e4e4b899e0c2d0bb0fade82e)
set(scapix_bin_hash_Linux-x86_64  3a917f160e04f990684d531817adf1487b11487dd4458ad4ed4c895ad3a05868)
set(scapix_bin_hash_Windows-AMD64 7e6a4999c93693529def87d70e91e03144a5d8b60435fa57b714d0cf3191fec0)

cmodule_add(
  scapix_bin 2.0.9
  URL "https://github.com/scapix-com/scapix-bin/archive/v2.0.9-${CMAKE_HOST_SYSTEM_NAME}-${CMAKE_HOST_SYSTEM_PROCESSOR}.tar.gz"
  URL_HASH SHA256=${scapix_bin_hash_${CMAKE_HOST_SYSTEM_NAME}-${CMAKE_HOST_SYSTEM_PROCESSOR}}
)

set(SCAPIX_EXE_DIR "${CMODULE_scapix_bin_SOURCE_DIR}" CACHE INTERNAL "")
