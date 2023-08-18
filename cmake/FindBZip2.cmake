include_guard(GLOBAL)

include(cmodule)

option(ENABLE_LIB_ONLY "libbz2: build lib only" ON)
option(ENABLE_STATIC_LIB "libbz2: build static lib" ${CMODULE_STATIC_LIB})
option(ENABLE_SHARED_LIB "libbz2: build shared lib" ${CMODULE_SHARED_LIB})

cmodule_add(
  bzip2 1.0.7-p0
  URL "https://gitlab.com/federicomenaquintero/bzip2/-/archive/b7a672291188a6469f71dd13ad14f2f9a7344fc8/bzip2.tar.bz2"
  URL_HASH SHA256=739669956b2f7535f4ddaa62d030027785c28d6f9615e232eabb8afe1cc58a10
)

cmodule_select_target(bz2 bz2_static)
target_include_directories(${CMODULE_TARGET} INTERFACE ${bzip2_SOURCE_DIR})
add_library(BZip2::BZip2 ALIAS ${CMODULE_TARGET})
