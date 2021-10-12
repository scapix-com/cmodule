include(${CMAKE_CURRENT_LIST_DIR}/cmodule.cmake)

cmodule_add(
  pybind11 2.8.0
  URL "https://github.com/pybind/pybind11/archive/refs/tags/v2.8.0.tar.gz"
  URL_HASH SHA256=9ca7770fc5453b10b00a4a2f99754d7a29af8952330be5f5602e7c2635fa3e79
)
