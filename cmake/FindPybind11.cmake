include(${CMAKE_CURRENT_LIST_DIR}/cmodule.cmake)

cmodule_add(
  pybind11 2.9.0
  URL "https://github.com/pybind/pybind11/archive/refs/tags/v2.9.0.tar.gz"
  URL_HASH SHA256=057fb68dafd972bc13afb855f3b0d8cf0fa1a78ef053e815d9af79be7ff567cb
)
