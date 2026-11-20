cmodule_recipe(bzip2
  VERSION 1.0.7                            # upstream git snapshot b7a6722 (1.0.7-p0)
  PACKAGES BZip2
  URL https://gitlab.com/federicomenaquintero/bzip2/-/archive/b7a672291188a6469f71dd13ad14f2f9a7344fc8/bzip2.tar.bz2
  SHA256 739669956b2f7535f4ddaa62d030027785c28d6f9615e232eabb8afe1cc58a10
  LICENSE bzip2-1.0.6
  OPTIONS
    ENABLE_LIB_ONLY=ON
    ENABLE_STATIC_LIB={static}
    ENABLE_SHARED_LIB={shared}
  VARIABLES                                # FindBZip2 compatibility
    BZIP2_LIBRARIES=BZip2::BZip2
    BZIP2_INCLUDE_DIR={source_dir}
    BZIP2_INCLUDE_DIRS={source_dir}
)

# Upstream targets don't export include directory and there's no namespaced target.

function(cmodule_bzip2_after)
  get_property(source_dir GLOBAL PROPERTY CMODULE_SOURCE_DIR_bzip2)
  foreach(target IN ITEMS bz2 bz2_static)
    if(TARGET ${target})
      target_include_directories(${target} INTERFACE "${source_dir}")
      if(NOT TARGET BZip2::BZip2)
        add_library(BZip2::BZip2 ALIAS ${target})
      endif()
    endif()
  endforeach()
endfunction()
