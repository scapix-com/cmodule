include(${CMAKE_CURRENT_LIST_DIR}/cmodule.cmake)

set(scapix_bin_hash_Darwin-x86_64 ccce99886ee51e0fd2f505188cc1bae956f8a0b41fb4248d09c401e4720f6707)
set(scapix_bin_hash_Linux-x86_64  3567c5f267ce8100dd420f339e054e16dfde70cddc3621031c7f351c1d66dde2)
set(scapix_bin_hash_Windows-AMD64 a015ac3a03d52514a616be0e801610c388c9cd0fd965725e6d49ab19486800ad)

cmodule_add(
  scapix_bin 2.0.8
  URL "https://github.com/scapix-com/scapix-bin/archive/v2.0.8-${CMAKE_HOST_SYSTEM_NAME}-${CMAKE_HOST_SYSTEM_PROCESSOR}.tar.gz"
  URL_HASH SHA256=${scapix_bin_hash_${CMAKE_HOST_SYSTEM_NAME}-${CMAKE_HOST_SYSTEM_PROCESSOR}}
)

set(SCAPIX_EXE_DIR "${CMODULE_scapix_bin_SOURCE_DIR}" CACHE INTERNAL "")
