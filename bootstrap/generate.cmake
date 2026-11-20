# Generate release bootstrap file:
#   cmake -DVERSION=<version> -DSHA256=<hash of release tarball> -DOUTPUT=<file> -P bootstrap/generate.cmake

foreach(var IN ITEMS VERSION SHA256 OUTPUT)
  if(NOT ${var})
    message(FATAL_ERROR "${var} is required")
  endif()
endforeach()

configure_file("${CMAKE_CURRENT_LIST_DIR}/cmodule.cmake.in" "${OUTPUT}" @ONLY)
