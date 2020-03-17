cmake_minimum_required(VERSION 3.14)

set(CMODULE_CACHE_SOURCE_DIR ${CMAKE_BINARY_DIR}/../.cmodule CACHE PATH "Folder to cache sources downloaded by cmodule, empty string to disable")
set(CMODULE_SHARED_LIBS NO CACHE BOOL "Prefer to build shared libs instead of static libs")
set(CMODULE_DISABLE_WARNINGS YES CACHE BOOL "Disable all compiler warnings for libs built by cmodule")

set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake" ${CMAKE_MODULE_PATH} PARENT_SCOPE)
