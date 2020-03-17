# Define the header-only Boost target
add_library(Boost::boost INTERFACE IMPORTED GLOBAL)
target_include_directories(Boost::boost SYSTEM INTERFACE ${BOOST_SOURCE})

# Disable autolink
target_compile_definitions(Boost::boost INTERFACE BOOST_ALL_NO_LIB=1)

add_library(Boost::headers ALIAS Boost::boost)

# TODO: Move those to option() calls in the right file
if(NOT BOOST_STANDALONE)
  # Compilation options required by all platforms
  target_compile_definitions(Boost::boost INTERFACE
    $<$<CONFIG:Release>:BOOST_DISABLE_ASSERT>
    BOOST_SYSTEM_NO_DEPRECATED
    BOOST_THREAD_VERSION=4
    BOOST_THREAD_USES_CHRONO
    BOOST_THREAD_PROVIDES_EXECUTORS
  )
endif()

if(ANDROID)
  # Android doesn't support thread local storage through compiler intrinsics
  target_compile_definitions(Boost::boost INTERFACE BOOST_ASIO_DISABLE_THREAD_KEYWORD_EXTENSION)
endif()
