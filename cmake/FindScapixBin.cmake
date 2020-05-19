include(${CMAKE_CURRENT_LIST_DIR}/cmodule.cmake)

set(scapix_bin_hash_Darwin-x86_64 847c86a55847bb2cf529cd66d2b67fb608ca1c117a5142c5325437cd1aaf9fee)
set(scapix_bin_hash_Linux-x86_64  aa7324a7be6c79d1c00220a6b7b7b6069289d7b7bdd4c8e5192d60e73631851f)
set(scapix_bin_hash_Windows-AMD64 b94e31791a52d4734cb98c4cff7c991b485bd5a35c841802d70a2b4f53dfa7b7)

cmodule_add(
  scapix_bin 2.0.4
  URL "https://github.com/scapix-com/scapix-bin/archive/v2.0.4-${CMAKE_HOST_SYSTEM_NAME}-${CMAKE_HOST_SYSTEM_PROCESSOR}.tar.gz"
  URL_HASH SHA256=${scapix_bin_hash_${CMAKE_HOST_SYSTEM_NAME}-${CMAKE_HOST_SYSTEM_PROCESSOR}}
)

set(SCAPIX_EXE_DIR "${CMODULE_scapix_bin_SOURCE_DIR}" CACHE INTERNAL "")
