include(${CMAKE_CURRENT_LIST_DIR}/cmodule.cmake)

set(scapix_bin_hash_Darwin-x86_64 4a9c73cfddab018fac375729b166c506ae1ff09182671ac973d4751f51b8c1ea)
set(scapix_bin_hash_Linux-x86_64  2250f83a13a40a3e08b6f2ce4b9f91acd76e00520d3766ebc72ba0dfa911a975)
set(scapix_bin_hash_Windows-AMD64 16007ad2cb080768368e735d08f9079cf178d8627df81724de21eca8dcf71d3e)

cmodule_add(
  scapix_bin 2.0.0
  URL "https://github.com/scapix-com/scapix-bin/archive/v2.0.0-${CMAKE_HOST_SYSTEM_NAME}-${CMAKE_HOST_SYSTEM_PROCESSOR}.tar.gz"
  URL_HASH SHA256=${scapix_bin_hash_${CMAKE_HOST_SYSTEM_NAME}-${CMAKE_HOST_SYSTEM_PROCESSOR}}
)

set(SCAPIX_EXE_DIR "${CMODULE_scapix_bin_SOURCE_DIR}" CACHE INTERNAL "")
