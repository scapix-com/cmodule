include(${CMAKE_CURRENT_LIST_DIR}/cmodule.cmake)

set(scapix_bin_hash_Darwin-x86_64 65325784f4e424216af2a11f2ed894e228602e20cb199b455d7c100f48d3829d)
set(scapix_bin_hash_Linux-x86_64  7ef2dde762bc430e1a588ad706aba552b846c445ef118563995e4d3a7678fdd6)
set(scapix_bin_hash_Windows-AMD64 7eda1cb56319d963788b2ab1b61b811e4a299216b1828217dbcc350ffa3f1595)

cmodule_add(
  scapix_bin 2.0.3
  URL "https://github.com/scapix-com/scapix-bin/archive/v2.0.3-${CMAKE_HOST_SYSTEM_NAME}-${CMAKE_HOST_SYSTEM_PROCESSOR}.tar.gz"
  URL_HASH SHA256=${scapix_bin_hash_${CMAKE_HOST_SYSTEM_NAME}-${CMAKE_HOST_SYSTEM_PROCESSOR}}
)

set(SCAPIX_EXE_DIR "${CMODULE_scapix_bin_SOURCE_DIR}" CACHE INTERNAL "")
