include(${CMAKE_CURRENT_LIST_DIR}/cmodule.cmake)

cmodule_add(
  pybind11 2.9.1
  URL "https://github.com/pybind/pybind11/archive/refs/tags/v2.9.1.tar.gz"
  URL_HASH SHA256=c6160321dc98e6e1184cc791fbeadd2907bb4a0ce0e447f2ea4ff8ab56550913
)
