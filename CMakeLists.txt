cmake_minimum_required(VERSION 3.10)
project(x86emu LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_compile_options(-Wall)
add_compile_options(-stdlib=libc++ -fno-exceptions)
add_link_options(-stdlib=libc++)

add_executable(x86emu src/main.cpp)
