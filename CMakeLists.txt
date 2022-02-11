cmake_minimum_required(VERSION 3.15)

set(THIRDPARTY_ROOT ${CMAKE_SOURCE_DIR}/thirdparty)
message(STATUS "THIRDPARTY_ROOT: ${THIRDPARTY_ROOT}")

if(THIRDPARTY)
    include(cmake/ThirdParty.cmake)
    return()
endif()

project(Playground VERSION 1.0 LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED YES)
set(CMAKE_CXX_EXTENSIONS OFF)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# make sure __cplusplus is defined when using msvc and enable parallel build
if(MSVC)
    string(APPEND CMAKE_CXX_FLAGS " /Zc:__cplusplus /MP /EHsc")
endif()

list(APPEND CMAKE_PREFIX_PATH ${THIRDPARTY_ROOT}/lib/cmake ${THIRDPARTY_ROOT}/share/cmake)

add_subdirectory(first)
