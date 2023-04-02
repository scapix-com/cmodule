include(${CMAKE_CURRENT_LIST_DIR}/cmodule.cmake)

set(scapix_bin_hash_Darwin-arm64  db508da98c15d80addbd695c244245bbc6989f9e79982c55ae4141bb09188a2f)
set(scapix_bin_hash_Darwin-x86_64 bb02ff42d720114c783045f4c2516c6ee2956fbf229ba1e204ce6f6a2a11f643)
set(scapix_bin_hash_Linux-x86_64  fc6ef1e18e736d83501b4149ab20fe33960cf131515daa388ff492accacd01ce)
set(scapix_bin_hash_Windows-AMD64 72a2471b43398113170c2ec6ad3696df176dd0da0f8f6c3095eb2447cb37c109)

cmodule_add(
  scapix_bin 2.0.14
  URL "https://github.com/scapix-com/scapix-bin/archive/refs/tags/v2.0.14-${CMAKE_HOST_SYSTEM_NAME}-${CMAKE_HOST_SYSTEM_PROCESSOR}.tar.gz"
  URL_HASH SHA256=${scapix_bin_hash_${CMAKE_HOST_SYSTEM_NAME}-${CMAKE_HOST_SYSTEM_PROCESSOR}}
)

set(SCAPIX_EXE_DIR "${CMODULE_scapix_bin_SOURCE_DIR}" CACHE INTERNAL "")
