########################################################
#
# CMake toolchain file for cross-platform build of C/C++ source
# for AVR8  MCUs using CNU avr-gcc and avr-g++ compilers.
#
# Created: 22-Dec-2022
# Author: Goce Boshkovski
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License.
#
########################################################

set(MICROCHIP_XC8_COMPILER OFF CACHE BOOL "ON if Micorchip XC8 compiler defined in the toolchain file. OFF otherwise")

set(CMAKE_SYSTEM_NAME Generic)

# Specify GNU avr-gcc as AVR8 compiler
set(CMAKE_C_COMPILER   /usr/bin/avr-gcc)
set(CMAKE_CXX_COMPILER /usr/bin/avr-g++)

# Define a list of compiler flags for AVR8 platform
set(FLAGS "-Wall -Os -fpack-struct -fshort-enums -ffunction-sections -fdata-sections -std=gnu99 -funsigned-char -funsigned-bitfields")

# Clear all the compiler flags
unset(CMAKE_C_FLAGS CACHE)
unset(CMAKE_CXX_FLAGS CACHE)

# Set the flags for AVR8 platform
set(CMAKE_CXX_FLAGS ${FLAGS} CACHE STRING "" FORCE)
set(CMAKE_C_FLAGS ${FLAGS} CACHE STRING "" FORCE)
