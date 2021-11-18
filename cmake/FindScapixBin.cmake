include(${CMAKE_CURRENT_LIST_DIR}/cmodule.cmake)

set(scapix_bin_hash_Darwin-arm64  fe7918f94f8a01d137165a89cb4b8053ca10a119b9f55f46c5ad0917131246d3)
set(scapix_bin_hash_Darwin-x86_64 7d6027a73516d5de2f6b8901baecf8ef511f0a384857d0dcf0f9a948f5ce2deb)
set(scapix_bin_hash_Linux-x86_64  dfe82767335b2fa9dd2dca616ca78c408d26aff2276b0cdad7743b1a7893d3ea)
set(scapix_bin_hash_Windows-AMD64 96464838a58d51272a8c174392153afba0b3c93ab875ff34a54840d3dc7276b5)

cmodule_add(
  scapix_bin 2.0.11
  URL "https://github.com/scapix-com/scapix-bin/archive/refs/tags/v2.0.11-${CMAKE_HOST_SYSTEM_NAME}-${CMAKE_HOST_SYSTEM_PROCESSOR}.tar.gz"
  URL_HASH SHA256=${scapix_bin_hash_${CMAKE_HOST_SYSTEM_NAME}-${CMAKE_HOST_SYSTEM_PROCESSOR}}
)

set(SCAPIX_EXE_DIR "${CMODULE_scapix_bin_SOURCE_DIR}" CACHE INTERNAL "")
