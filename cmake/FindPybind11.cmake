include(${CMAKE_CURRENT_LIST_DIR}/cmodule.cmake)

cmodule_add(
  pybind11 2.10.1
  URL "https://github.com/pybind/pybind11/archive/refs/tags/v2.10.1.tar.gz"
  URL_HASH SHA256=111014b516b625083bef701df7880f78c2243835abdb263065b6b59b960b6bad
)
