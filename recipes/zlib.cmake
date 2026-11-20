cmodule_recipe(zlib
  VERSION 1.4
  PACKAGES ZLIB
  URL https://github.com/madler/zlib/releases/download/v{version}/zlib-{version}.tar.xz
  SHA256 4f11c512053d7bab8d9e9b89bde3575add3e4c50a383b42ef6cb837035fc5a7c
  LICENSE Zlib
  OPTIONS
    ZLIB_BUILD_TESTING=OFF
    ZLIB_INSTALL=OFF
    ZLIB_BUILD_SHARED={shared}
    ZLIB_BUILD_STATIC={static}
  TARGETS
    ZLIB::ZLIB=zlibstatic                  # upstream defines ZLIB::ZLIB only for shared library
  VARIABLES                                # FindZLIB compatibility
    ZLIB_LIBRARIES=ZLIB::ZLIB
    ZLIB_INCLUDE_DIR={source_dir}
    ZLIB_INCLUDE_DIRS={source_dir}
    ZLIB_INCLUDE_DIRS+={binary_dir}        # generated zconf.h
)
