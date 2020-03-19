include(${CMAKE_CURRENT_LIST_DIR}/cmodule.cmake)

cmodule_add(
  pybind11 2.4.3-p0
  URL "https://github.com/pybind/pybind11/archive/v2.4.3.tar.gz"
  URL_HASH SHA256=1eed57bc6863190e35637290f97a20c81cfe4d9090ac0a24f3bbf08f265eb71d
)
