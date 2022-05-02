include(${CMAKE_CURRENT_LIST_DIR}/cmodule.cmake)

set(scapix_bin_hash_Darwin-arm64  7bb33cd873183c141ef4f6e8f6cb2cbab34d2520fa0bfe29773a3523a183e063)
set(scapix_bin_hash_Darwin-x86_64 06d0f63e0af2c19d02829d4302404bf701c98f026d98bebeee51fdc074e3b62f)
set(scapix_bin_hash_Linux-x86_64  645c61a096470357decea77fb6cb0dbcd8e20d120fbb4ddbe863566fdfd5d669)
set(scapix_bin_hash_Windows-AMD64 265b5d212e27a04d241c5fa6080c6558b6a26c27a765ec1f4f870f161de9d6f2)

cmodule_add(
  scapix_bin 2.0.12
  URL "https://github.com/scapix-com/scapix-bin/archive/refs/tags/v2.0.12-${CMAKE_HOST_SYSTEM_NAME}-${CMAKE_HOST_SYSTEM_PROCESSOR}.tar.gz"
  URL_HASH SHA256=${scapix_bin_hash_${CMAKE_HOST_SYSTEM_NAME}-${CMAKE_HOST_SYSTEM_PROCESSOR}}
)

set(SCAPIX_EXE_DIR "${CMODULE_scapix_bin_SOURCE_DIR}" CACHE INTERNAL "")
