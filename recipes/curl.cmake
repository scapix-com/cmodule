cmodule_recipe(curl
  VERSION 8.2.1
  PACKAGES CURL
  URL https://github.com/curl/curl/releases/download/curl-8_2_1/curl-{version}.tar.xz
  SHA256 dd322f6bd0a20e6cebdfd388f69e98c3d183bed792cf4713c8a7ef498cba4894
  LICENSE curl
  OPTIONS
    CURL_ENABLE_EXPORT_TARGET=OFF
    BUILD_CURL_EXE=OFF
    # Configure-time checks after zlib detection link CURL_LIBS (including ZLIB::ZLIB) in try_compile(),
    # which can't use targets built as part of the build. Answer them up front:
    HAVE_WLDAP32=ON                        # Windows only: part of Windows SDK
    HAVE_LIBLDAP=OFF                       # host system libraries, not usable when cross-compiling
    HAVE_LIBLBER=OFF
    HAVE_LIBIDN2=OFF
  VARIABLES                                # FindCURL compatibility
    CURL_LIBRARIES=CURL::libcurl
    CURL_INCLUDE_DIRS={source_dir}/include
)
