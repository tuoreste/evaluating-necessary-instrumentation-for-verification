cmake_minimum_required(VERSION 3.20)

project(RemoveCallbacks LANGUAGES CXX)

find_package(LLVM REQUIRED CONFIG)
message(STATUS "using LLVM ${LLVM_PACKAGE_VERSION}")

# Load LLVM's CMake helpers, including add_llvm_pass_plugin.
include(AddLLVM)
include_directories(${LLVM_INCLUDE_DIRS})
add_definitions(${LLVM_DEFINITIONS})

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Build RemoveCallbacks.so, which opt can load as an LLVM pass plugin.
add_llvm_pass_plugin(
    RemoveCallbacks
    src/RemoveCallbacks.cpp
)
