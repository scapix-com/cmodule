include(${CMAKE_CURRENT_LIST_DIR}/cmodule.cmake)

cmodule_add(
  scapix 1.0.0
  GIT_REPOSITORY https://github.com/scapix-com/scapix.git
  GIT_TAG        v1.0.0
  GIT_SHALLOW    TRUE
)
