cmake_minimum_required(VERSION 3.15)

project(ThirdParty VERSION 0.1.0 LANGUAGES C CXX)

find_package(Git)
if(GIT_FOUND)
    message(STATUS "Git found: ${GIT_EXECUTABLE}: ${GIT_VERSION_STRING}")
else()
    message(FATA_ERROR "Git not found")
endif()

include(ExternalProject)

set(CMAKE_INSTALL_PREFIX ${PROJECT_SOURCE_DIR}/thirdparty)

if(temporary_disabled_var)
ExternalProject_Add(fmt
    PREFIX "${CMAKE_INSTALL_PREFIX}"
    GIT_REPOSITORY "https://github.com/fmtlib/fmt.git"
    GIT_TAG "8.1.1"
    INSTALL_DIR "${CMAKE_INSTALL_PREFIX}"
    CMAKE_ARGS "-DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>"
)

ExternalProject_Add(yaml-cpp
    PREFIX "${CMAKE_INSTALL_PREFIX}"
    GIT_REPOSITORY "https://github.com/jbeder/yaml-cpp.git"
    GIT_TAG "yaml-cpp-0.7.0"
    CMAKE_ARGS "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}"
)

ExternalProject_Add(doctest
    PREFIX "${CMAKE_INSTALL_PREFIX}"
    GIT_REPOSITORY "https://github.com/doctest/doctest.git"
    GIT_TAG "v2.4.8"
    CMAKE_ARGS "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}"
)

set(SPDLOG_FMT_EXTERNAL ON CACHE BOOL "Override fmt library dependency" FORCE)
ExternalProject_Add(spdlog
    PREFIX "${CMAKE_INSTALL_PREFIX}"
    GIT_REPOSITORY "https://github.com/gabime/spdlog.git"
    GIT_TAG "v1.9.2"
    CMAKE_ARGS "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}"
)

ExternalProject_Add(protobuf
    PREFIX "${CMAKE_INSTALL_PREFIX}"
    GIT_REPOSITORY "https://github.com/protocolbuffers/protobuf.git"
    GIT_TAG "v3.3.2"
    SOURCE_SUBDIR "cmake"
    CMAKE_ARGS "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}"
    "-DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}"
    "-Dprotobuf_BUILD_TESTS:BOOL=OFF"
    "-Dprotobuf_BUILD_EXAMPLES:BOOL=OFF"
    "-Dprotobuf_WITH_ZLIB:BOOL=ON"
    "-DCMAKE_CXX_COMPILER:STRING=${CMAKE_CXX_COMPILER}"
)
endif() # temp disable

include(${CMAKE_CURRENT_LIST_DIR}/BoostBuilder.cmake)
