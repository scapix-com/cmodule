include_guard(GLOBAL)

include(cmodule)

set(CURL_ENABLE_EXPORT_TARGET OFF)

cmodule_add(
  curl 7.80.0
  URL "https://github.com/curl/curl/releases/download/curl-7_80_0/curl-7.80.0.tar.xz"
  URL_HASH SHA256=a132bd93188b938771135ac7c1f3ac1d3ce507c1fcbef8c471397639214ae2ab
)
