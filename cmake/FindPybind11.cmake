include(${CMAKE_CURRENT_LIST_DIR}/cmodule.cmake)

cmodule_add(
  pybind11 2.9.2
  URL "https://github.com/pybind/pybind11/archive/refs/tags/v2.9.2.tar.gz"
  URL_HASH SHA256=6bd528c4dbe2276635dc787b6b1f2e5316cf6b49ee3e150264e455a0d68d19c1
)
