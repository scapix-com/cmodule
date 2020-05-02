include(${CMAKE_CURRENT_LIST_DIR}/cmodule.cmake)

set(scapix_bin_hash_Darwin-x86_64 009981b0f053abae2bfc9ee92df071a6cfe3dd85a2953b19382274c580ca4ee6)
set(scapix_bin_hash_Linux-x86_64  ec343a81cd893b1339574cf9668c19bebd845febf34ca3d52717d009dd18c692)
set(scapix_bin_hash_Windows-AMD64 ea177d7b2cd8d351cc77089c13488ab0d4d5fba81af4dcb665c0ba8e32aacea0)

cmodule_add(
  scapix_bin 2.0.2
  URL "https://github.com/scapix-com/scapix-bin/archive/v2.0.2-${CMAKE_HOST_SYSTEM_NAME}-${CMAKE_HOST_SYSTEM_PROCESSOR}.tar.gz"
  URL_HASH SHA256=${scapix_bin_hash_${CMAKE_HOST_SYSTEM_NAME}-${CMAKE_HOST_SYSTEM_PROCESSOR}}
)

set(SCAPIX_EXE_DIR "${CMODULE_scapix_bin_SOURCE_DIR}" CACHE INTERNAL "")
