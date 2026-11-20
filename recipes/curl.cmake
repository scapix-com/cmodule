cmodule_recipe(curl
  VERSION 8.23.0
  PACKAGES CURL
  URL https://github.com/curl/curl/releases/download/curl-8_23_0/curl-{version}.tar.xz  # tag: update with VERSION
  SHA256 8dadd7d2536a314f982ad05a651b713f426bf7d02cc2c76cffb9796f2218e6c5
  LICENSE curl
  OPTIONS
    CURL_ENABLE_EXPORT_TARGET=OFF
    BUILD_CURL_EXE=OFF
    BUILD_EXAMPLES=OFF
    BUILD_LIBCURL_DOCS=OFF                 # docs need Perl
    BUILD_MISC_DOCS=OFF
    ENABLE_CURL_MANUAL=OFF
    PICKY_COMPILER=OFF                     # adds warning options
    CURL_USE_SCHANNEL=ON                   # Windows only: TLS from the OS
                                           # Other platforms: OpenSSL required by default, or set CURL_USE_OPENSSL=OFF
    # Optional dependencies without cmodule recipes (host system libraries, often missing when cross-compiling):
    CURL_USE_LIBPSL=OFF                    # required by default
    CURL_USE_LIBSSH2=OFF
    USE_LIBIDN2=OFF
    USE_NGHTTP2=OFF
    CURL_BROTLI=OFF
    CURL_ZSTD=OFF                          # curl's FindZstd target (CURL::zstd) isn't created with cmodule zstd
  VARIABLES                                # FindCURL compatibility
    CURL_LIBRARIES=CURL::libcurl
    CURL_INCLUDE_DIRS={source_dir}/include
)
