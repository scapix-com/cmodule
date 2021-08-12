include(${CMAKE_CURRENT_LIST_DIR}/cmodule.cmake)

cmodule_add(
  pybind11 2.7.1
  URL "https://github.com/pybind/pybind11/archive/v2.7.1.tar.gz"
  URL_HASH SHA256=616d1c42e4cf14fa27b2a4ff759d7d7b33006fdc5ad8fd603bb2c22622f27020
)
