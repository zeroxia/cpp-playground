cmake_minimum_required(VERSION 3.11)

project(FirstOne)

find_package(Threads REQUIRED)
find_package(Boost 1.71.0 REQUIRED COMPONENTS filesystem system chrono date_time)
find_package(fmt 8.1.1 REQUIRED)
find_package(yaml-cpp 0.7.0 REQUIRED)
find_package(spdlog 1.9.2 REQUIRED)
find_package(doctest 2.4.8 REQUIRED)

include(FindProtobuf)
find_package(protobuf REQUIRED)
message(STATUS "protobuf ${protobuf_VERSION}, protoc: ${Protobuf_PROTOC_EXECUTABLE}")

protobuf_generate_cpp(PROTO_SRCS PROTO_HDRS message.proto)
add_library(proto_first STATIC ${PROTO_SRCS} ${PROTO_HDRS})
target_include_directories(proto_first INTERFACE ${CMAKE_CURRENT_BINARY_DIR})
target_link_libraries(proto_first PRIVATE protobuf::libprotobuf)

if(MSVC)
    # None for now.
else()
    #add_compile_options(-Wno-builtin-macro-redefined)
    add_compile_options(-W -Wall -Wextra -Wformat=2 -Wconversion)
endif()
include_directories(${PROJECT_SOURCE_DIR}/include)

add_executable(first main.cpp)
target_link_libraries(first PUBLIC proto_first)
target_link_libraries(first PRIVATE Threads::Threads)
target_link_libraries(first PRIVATE Boost::filesystem Boost::system Boost::date_time)
target_link_libraries(first PRIVATE fmt::fmt)
target_link_libraries(first PRIVATE yaml-cpp)
target_link_libraries(first PRIVATE spdlog::spdlog)
target_link_libraries(first PRIVATE doctest::doctest)
#target_link_libraries(first PRIVATE protobuf::libprotobuf)
target_link_libraries(first PRIVATE ${CMAKE_DL_LIBS})
