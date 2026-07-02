cmake_minimum_required(VERSION 3.10)
project(CppProject CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_library(cppproject SHARED src/mathutils.cpp)
target_include_directories(cppproject PUBLIC include)
