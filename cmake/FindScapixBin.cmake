include(${CMAKE_CURRENT_LIST_DIR}/cmodule.cmake)

set(scapix_bin_hash_Darwin-x86_64 a82a5058083fc8fc00c00a52cb32e236a674d8fea65b97384b4e4a2f3c6893c3)
set(scapix_bin_hash_Linux-x86_64  f0962613adfa0ca0c776be46df329212b136c38793f767e7e1dc7c590d28540e)
set(scapix_bin_hash_Windows-AMD64 3a02ba206f961369ce02f803ef68b01d3c2588ffbef309e811bafb4c8fa686ba)

cmodule_add(
  scapix_bin 2.0.5
  URL "https://github.com/scapix-com/scapix-bin/archive/v2.0.5-${CMAKE_HOST_SYSTEM_NAME}-${CMAKE_HOST_SYSTEM_PROCESSOR}.tar.gz"
  URL_HASH SHA256=${scapix_bin_hash_${CMAKE_HOST_SYSTEM_NAME}-${CMAKE_HOST_SYSTEM_PROCESSOR}}
)

set(SCAPIX_EXE_DIR "${CMODULE_scapix_bin_SOURCE_DIR}" CACHE INTERNAL "")
