cmake_minimum_required(VERSION 3.10)
project(x86emu LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

include(CheckCXXCompilerFlag)

set(USING_CLANG FALSE)
if(CMAKE_CXX_COMPILER_ID MATCHES "Clang|AppleClang")
  set(USING_CLANG TRUE)
endif()

find_program(LLD_EXECUTABLE lld)

check_cxx_compiler_flag("-stdlib=libc++" COMPILER_SUPPORTS_LIBCPP)
check_cxx_compiler_flag("-fuse-ld=lld" COMPILER_SUPPORTS_FUSE_LD)

if(USING_CLANG AND LLD_EXECUTABLE AND COMPILER_SUPPORTS_LIBCPP AND COMPILER_SUPPORTS_FUSE_LD)
  message(STATUS "Using clang + lld + libc++ specific options")
  add_compile_options(-Wall)
  add_compile_options(-stdlib=libc++ -fno-exceptions)
  add_link_options(-fuse-ld=lld)
  add_link_options(-stdlib=libc++)
else()
  message(STATUS "Not using clang+lld+libc++ options (clang: ${USING_CLANG}, lld: ${LLD_EXECUTABLE}, supports_libc++: ${COMPILER_SUPPORTS_LIBCPP}, supports_fuse_ld: ${COMPILER_SUPPORTS_FUSE_LD})")
endif()

set(SRC_DIR "${CMAKE_SOURCE_DIR}/src")

add_executable(x86emu
  "${SRC_DIR}/main.cpp"
)

set(BOOT_SRC "${SRC_DIR}/boot/boot.asm")
set(BOOT_BIN "${CMAKE_BINARY_DIR}/boot.bin")

find_program(NASM_EXECUTABLE nasm)
if(NOT NASM_EXECUTABLE)
  message(FATAL_ERROR "nasm not found.")
endif()

add_custom_command(
  OUTPUT "${BOOT_BIN}"
  COMMAND ${NASM_EXECUTABLE} -f bin -I "${SRC_DIR}" "${BOOT_SRC}" -o "${BOOT_BIN}"
  DEPENDS "${BOOT_SRC}"
  COMMENT "Assembling ${BOOT_SRC} -> ${BOOT_BIN}"
  VERBATIM
)

add_custom_target(boot_bin ALL
  DEPENDS "${BOOT_BIN}"
  VERBATIM
)

add_custom_target(run
  DEPENDS x86emu boot_bin
  COMMAND $<TARGET_FILE:x86emu> "${BOOT_BIN}"
  WORKING_DIRECTORY "${CMAKE_BINARY_DIR}"
  VERBATIM
)
