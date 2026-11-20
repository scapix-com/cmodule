cmodule_recipe(liblzma
  VERSION 5.8.4
  PACKAGES LibLZMA
  URL https://github.com/tukaani-project/xz/releases/download/v{version}/xz-{version}.tar.xz
  SHA256 4ce24038fd4221e0d13bc1a2de7a4db56e90b92b3bf75321f6c14be73f65de4b
  LICENSE 0BSD
  OPTIONS
    XZ_NLS=OFF
    XZ_DOC=OFF
    XZ_TOOL_XZ=OFF
    XZ_TOOL_XZDEC=OFF
    XZ_TOOL_LZMADEC=OFF
    XZ_TOOL_LZMAINFO=OFF
    XZ_TOOL_SCRIPTS=OFF
    XZ_TOOL_SYMLINKS=OFF
    XZ_TOOL_SYMLINKS_LZMA=OFF
  TARGETS
    LibLZMA::LibLZMA=liblzma
  VARIABLES                                # FindLibLZMA compatibility
    LIBLZMA_LIBRARIES=LibLZMA::LibLZMA
    LIBLZMA_INCLUDE_DIR={source_dir}/src/liblzma/api
    LIBLZMA_INCLUDE_DIRS={source_dir}/src/liblzma/api
    LIBLZMA_HAS_AUTO_DECODER=TRUE
    LIBLZMA_HAS_EASY_ENCODER=TRUE
    LIBLZMA_HAS_LZMA_PRESET=TRUE
)

# Upstream exports include directory only in installed package.

function(cmodule_liblzma_after)
  get_property(source_dir GLOBAL PROPERTY CMODULE_SOURCE_DIR_liblzma)
  target_include_directories(liblzma INTERFACE "${source_dir}/src/liblzma/api")
endfunction()
