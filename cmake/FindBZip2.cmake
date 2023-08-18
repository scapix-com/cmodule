include_guard(GLOBAL)

option(ENABLE_LIB_ONLY "bz2" ON)

if(BUILD_SHARED_LIBS)
  option(ENABLE_STATIC_LIB "bz2" OFF)
  option(ENABLE_SHARED_LIB "bz2" ON)
else()
  option(ENABLE_STATIC_LIB "bz2" ON)
  option(ENABLE_SHARED_LIB "bz2" OFF)
endif()

cmodule_add(
  bzip2 1.0.7-p0
  URL "https://gitlab.com/federicomenaquintero/bzip2/-/archive/b7a672291188a6469f71dd13ad14f2f9a7344fc8/bzip2.tar.bz2"
  URL_HASH SHA256=739669956b2f7535f4ddaa62d030027785c28d6f9615e232eabb8afe1cc58a10
)

if(TARGET bz2)
  target_include_directories(bz2 INTERFACE ${bzip2_SOURCE_DIR})
endif()

if(TARGET bz2_static)
  target_include_directories(bz2_static INTERFACE ${bzip2_SOURCE_DIR})
endif()

if(BUILD_SHARED_LIBS)
  add_library(BZip2::BZip2 ALIAS bz2)
else()
  add_library(BZip2::BZip2 ALIAS bz2_static)
endif()
