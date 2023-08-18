include_guard(GLOBAL)

include(cmodule)

set(CURL_ENABLE_EXPORT_TARGET OFF)

cmodule_add(
  curl 8.2.1
  URL "https://github.com/curl/curl/releases/download/curl-8_2_1/curl-8.2.1.tar.xz"
  URL_HASH SHA256=dd322f6bd0a20e6cebdfd388f69e98c3d183bed792cf4713c8a7ef498cba4894
)
