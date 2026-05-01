cmake_minimum_required(VERSION 3.10)
project(x86emu LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_compile_options(-Wall)
add_compile_options(-stdlib=libc++ -fno-exceptions)
add_link_options(-stdlib=libc++)

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
