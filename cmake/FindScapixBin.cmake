include_guard(GLOBAL)

set(scapix_bin_hash_Darwin-arm64  0f2a94bba2645d9cdcc7621c7ee03a8e3776ed7308d83a774d518b600b889f20)
set(scapix_bin_hash_Darwin-x86_64 9261ee415275343ddd5f6df8bfdac67a8ab1715e881f699a7d0873dd06306367)
set(scapix_bin_hash_Linux-x86_64  25dd03d0d9c741bc2e4ae5a5aa40df8395e3c9bdd0f7c12cb8a7369bf2abc026)
set(scapix_bin_hash_Windows-AMD64 47bfe0ee76793bfeddb24548f960cda1450e57ec10cad8908092b947edbddc02)

cmodule_add(
  scapix_bin 2.0.15
  URL "https://github.com/scapix-com/scapix-bin/archive/refs/tags/v2.0.15-${CMAKE_HOST_SYSTEM_NAME}-${CMAKE_HOST_SYSTEM_PROCESSOR}.tar.gz"
  URL_HASH SHA256=${scapix_bin_hash_${CMAKE_HOST_SYSTEM_NAME}-${CMAKE_HOST_SYSTEM_PROCESSOR}}
)

set(SCAPIX_EXE_DIR "${CMODULE_scapix_bin_SOURCE_DIR}" CACHE INTERNAL "")
