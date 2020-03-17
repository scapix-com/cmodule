include(${CMAKE_CURRENT_LIST_DIR}/cmodule.cmake)

option(ENABLE_LIB_ONLY "libbz2: build lib only" ON)
option(ENABLE_STATIC_LIB "libbz2: build static lib" ${CMODULE_STATIC_LIB})
option(ENABLE_SHARED_LIB "libbz2: build shared lib" ${CMODULE_SHARED_LIB})

cmodule_add(
  bzip2 1.0.7
  GIT_REPOSITORY https://gitlab.com/federicomenaquintero/bzip2
  GIT_TAG        b7a672291188a6469f71dd13ad14f2f9a7344fc8
  GIT_SHALLOW    TRUE
)

if(NOT TARGET BZip2::BZip2)

  cmodule_select_target(bz2 bz2_static)
  target_include_directories(${CMODULE_TARGET} INTERFACE ${bzip2_SOURCE_DIR})
  add_library(BZip2::BZip2 ALIAS ${CMODULE_TARGET})

endif()
