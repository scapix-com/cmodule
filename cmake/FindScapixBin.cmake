include_guard(GLOBAL)

set(scapix_bin_hash_Darwin-arm64  5c72aed9452d417af38fdad65b1cfee4b4ac7c6cf6efa2869f7229a3a984c514)
set(scapix_bin_hash_Darwin-x86_64 11b98dfde278d33bc1bc39c44f2720e852c341a987eec545eb3d5ae0947b63e6)
set(scapix_bin_hash_Linux-x86_64  604c3dde69248eff137654be90ee32728004fd4d1fd0f9bd4798983f20f2ebec)
set(scapix_bin_hash_Windows-AMD64 7ec2bb45adbc87283b5c1befbe785982cf35e3b5684308107242342620e1f177)

cmodule_add(
  scapix_bin 2.1.1
  URL "https://github.com/scapix-com/scapix-bin/archive/refs/tags/v2.1.1-${CMAKE_HOST_SYSTEM_NAME}-${CMAKE_HOST_SYSTEM_PROCESSOR}.tar.gz"
  URL_HASH SHA256=${scapix_bin_hash_${CMAKE_HOST_SYSTEM_NAME}-${CMAKE_HOST_SYSTEM_PROCESSOR}}
)

set(SCAPIX_EXE "${CMODULE_scapix_bin_SOURCE_DIR}/${CMAKE_HOST_SYSTEM_NAME}-${CMAKE_HOST_SYSTEM_PROCESSOR}/scapix" CACHE INTERNAL "")

if(NOT EXISTS "${SCAPIX_EXE}")
  set(SCAPIX_EXE "${SCAPIX_EXE}.exe" CACHE INTERNAL "")
endif()

set(SCAPIX_JAVA_EXE "${CMODULE_scapix_bin_SOURCE_DIR}/${CMAKE_HOST_SYSTEM_NAME}-${CMAKE_HOST_SYSTEM_PROCESSOR}/scapix_java" CACHE INTERNAL "")

if(NOT EXISTS "${SCAPIX_JAVA_EXE}")
  set(SCAPIX_JAVA_EXE "${SCAPIX_JAVA_EXE}.exe" CACHE INTERNAL "")
endif()
