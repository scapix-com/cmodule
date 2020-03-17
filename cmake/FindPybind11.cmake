include(${CMAKE_CURRENT_LIST_DIR}/cmodule.cmake)

cmodule_add(
  pybind11 2.4.3
  GIT_REPOSITORY https://github.com/pybind/pybind11.git
  GIT_TAG        v2.4.3
  GIT_SHALLOW    TRUE
)
