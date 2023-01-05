include(${CMAKE_CURRENT_LIST_DIR}/cmodule.cmake)

cmodule_add(
  pybind11 2.10.3
  URL "https://github.com/pybind/pybind11/archive/refs/tags/v2.10.3.tar.gz"
  URL_HASH SHA256=5d8c4c5dda428d3a944ba3d2a5212cb988c2fae4670d58075a5a49075a6ca315
)
