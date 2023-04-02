include(${CMAKE_CURRENT_LIST_DIR}/cmodule.cmake)

cmodule_add(
  scapix 1.0.32
  URL "https://github.com/scapix-com/scapix/archive/refs/tags/v1.0.32.tar.gz"
  URL_HASH SHA256=260d13c814139403de496b507825385241af2325a12a8728d9eecaae2537be87
)
