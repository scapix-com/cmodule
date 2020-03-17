include(${CMAKE_CURRENT_LIST_DIR}/cmodule.cmake)

# cpp-pm archive is smaller (no documentation, tests, etc.)

cmodule_add(
  boost 1.72.0
# URL      https://dl.bintray.com/boostorg/release/1.72.0/source/boost_1_72_0.7z
# URL_HASH SHA256=247a91dd7e4d9dd3c4b954b532fbc167ba62dc15ab834e5ad893d7c3f9eb5f0f
  URL      "https://github.com/cpp-pm/boost/archive/v1.72.0-p0.tar.gz"
  URL_HASH SHA256=5ef7cbf74f02d2bde5b80fce1ec05b6894492a2e47dc235580302fdc63c7afee
)

set(BOOST_SOURCE "${CMODULE_boost_SOURCE_DIR}")
set(BOOST_CMAKE_DIR "${CMAKE_CURRENT_LIST_DIR}/boost")
set(BOOST_COMPONENTS "${${CMAKE_FIND_PACKAGE_NAME}_FIND_COMPONENTS}")

if(NOT BOOST_COMPONENTS)
  set(BOOST_COMPONENTS "headers")
endif()

get_property(guard GLOBAL PROPERTY CMODULE_GUARD_BOOST)
if(NOT guard)
  set_property(GLOBAL PROPERTY CMODULE_GUARD_BOOST TRUE)
  add_subdirectory("${CMAKE_CURRENT_LIST_DIR}/boost" "${CMODULE_boost_BINARY_DIR}" EXCLUDE_FROM_ALL)
else()
  boost_add_components()
endif()

# Detect Boost version
file(STRINGS "${BOOST_SOURCE}/boost/version.hpp" boost_version_raw REGEX "define BOOST_VERSION ")
string(REGEX MATCH "[0-9]+" boost_version_raw "${boost_version_raw}")
math(EXPR BOOST_VERSION_MAJOR "${boost_version_raw} / 100000")
math(EXPR BOOST_VERSION_MINOR "${boost_version_raw} / 100 % 1000")
math(EXPR BOOST_VERSION_PATCH "${boost_version_raw} % 100")
set(BOOST_VERSION "${BOOST_VERSION_MAJOR}.${BOOST_VERSION_MINOR}.${BOOST_VERSION_PATCH}")
