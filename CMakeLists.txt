##########################################################
#
# Created: 22-Dec-2022
# Author: Goce Boshkovski
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License.
#
##########################################################

cmake_minimum_required(VERSION 3.1)

# Define the project name
project(cmake_test_avr8)

# Show the compiler commands during the build 
set(CMAKE_VERBOSE_MAKEFILE ON)

# Define the variables/command line arguments for target MCU and MCU clock frequency
set(MCU "atmega32" CACHE STRING "Target micro-controller with default value atmega32")
set(CPU_FREQ "16000000L" CACHE STRING "MCU CPU frequency")

# Define the extra include directories here
#include_directories(/usr/local/include/avr8)

# Add mmcu as compiler option
add_compile_options(-mmcu=${MCU})

# Define the F_CPU macro required for some avr-libc functions
add_definitions(-DF_CPU=${CPU_FREQ})

# Define the list of source files.
set (SOURCE_LIST
main.c
source_file1.c
source_file2.c
)

# Define the binary  
add_executable(${PROJECT_NAME}.elf ${SOURCE_LIST})

# Post build step for generating the firware in Intel HEX format
add_custom_command(
    TARGET ${PROJECT_NAME}.elf
    POST_BUILD
    COMMAND avr-objcopy -j .text -j .data -O ihex ${PROJECT_NAME}.elf ${PROJECT_NAME}.hex 
)