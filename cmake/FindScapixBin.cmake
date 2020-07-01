include(${CMAKE_CURRENT_LIST_DIR}/cmodule.cmake)

set(scapix_bin_hash_Darwin-x86_64 45b46b2cf65b22aa753aafb2f8fc2cf37880b40ba3e368e1160fc34ee71804e8)
set(scapix_bin_hash_Linux-x86_64  d6c12a4996d8bc101966ace95760a66a09f106a272f0ad1d129f015f15764f9f)
set(scapix_bin_hash_Windows-AMD64 54074c90ced08f83b3750728ebfd5945a678b1d3c7089ec255865053d25ba4fc)

cmodule_add(
  scapix_bin 2.0.6
  URL "https://github.com/scapix-com/scapix-bin/archive/v2.0.6-${CMAKE_HOST_SYSTEM_NAME}-${CMAKE_HOST_SYSTEM_PROCESSOR}.tar.gz"
  URL_HASH SHA256=${scapix_bin_hash_${CMAKE_HOST_SYSTEM_NAME}-${CMAKE_HOST_SYSTEM_PROCESSOR}}
)

set(SCAPIX_EXE_DIR "${CMODULE_scapix_bin_SOURCE_DIR}" CACHE INTERNAL "")
