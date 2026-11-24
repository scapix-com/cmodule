cmodule_recipe(zstd
  VERSION 1.6.0
  PACKAGES zstd
  URL https://github.com/facebook/zstd/releases/download/v{version}/zstd-{version}.tar.gz
  SHA256 2ba599ae2a257976278e7e71e998433a387bfd18aa7b78678229fd5d84f5e9b8
  LICENSE BSD-3-Clause
  SOURCE_SUBDIR build/cmake
  OPTIONS
    ZSTD_BUILD_STATIC={static}
    ZSTD_BUILD_SHARED={shared}
    ZSTD_LEGACY_SUPPORT=OFF
    ZSTD_BUILD_PROGRAMS=OFF
    ZSTD_BUILD_CONTRIB=OFF
    ZSTD_BUILD_TESTS=OFF
  TARGETS                                  # names used by upstream installed package
    zstd::libzstd=libzstd
)

function(cmodule_zstd_after)
  foreach(type IN ITEMS shared static)
    if(TARGET libzstd_${type} AND NOT TARGET zstd::libzstd_${type})
      add_library(zstd::libzstd_${type} ALIAS libzstd_${type})
    endif()
  endforeach()
endfunction()
