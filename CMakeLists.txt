cmake_minimum_required(VERSION 3.14)

if(CMAKE_HOST_WIN32)
    set(CMODULE_USER_HOME_DIR "$ENV{USERPROFILE}")
else()
    set(CMODULE_USER_HOME_DIR "$ENV{HOME}")
endif()

if(NOT CMODULE_USER_HOME_DIR)
	set(CMODULE_USER_HOME_DIR "${CMAKE_SOURCE_DIR}")
endif()

set(CMODULE_CACHE_SOURCE_DIR ${CMODULE_USER_HOME_DIR}/.cmodule CACHE PATH "Folder to cache sources downloaded by cmodule, empty string to disable")
set(CMODULE_SHARED_LIBS NO CACHE BOOL "Prefer to build shared libs instead of static libs")
set(CMODULE_DISABLE_WARNINGS YES CACHE BOOL "Disable all compiler warnings for libs built by cmodule")

set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake" ${CMAKE_MODULE_PATH} PARENT_SCOPE)
