########################################################
#
# CMake toolchain file for cross-platform build of C/C++ source
# for AVR8  MCUs using Microchip XC8 compiler.
#
# Created: 10-Jan-2023
# Author: Goce Boshkovski
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License.
#
########################################################

set(MICROCHIP_XC8_COMPILER ON CACHE BOOL "ON if Micorchip XC8 compiler defined in the toolchain file. OFF otherwise")
set(AVR8_MCU atmega32a)

set(CMAKE_SYSTEM_NAME Generic)

# Specify Microchip XC8 as C/C++ compiler for AVR8
set(CMAKE_C_COMPILER   /opt/microchip/xc8/v2.40/bin/xc8-cc)
set(CMAKE_CXX_COMPILER /opt/microchip/xc8/v2.40/bin/xc8-cc)

# Microchip XC8 is distributed with its own version of avr-objcopy tool
set(OBJ_COPY_TOOL /opt/microchip/xc8/v2.40/bin/avr-objcopy)

# Define a list of compiler flags for AVR8 platform
set(FLAGS "-mcpu=${AVR8_MCU} -Wall -O2 -fpack-struct -fshort-enums -ffunction-sections -fdata-sections -std=gnu99 -funsigned-char -funsigned-bitfields")

# Clear all the compiler flags
unset(CMAKE_C_FLAGS CACHE)
unset(CMAKE_CXX_FLAGS CACHE)

# Set the flags for AVR8 platform
set(CMAKE_CXX_FLAGS ${FLAGS} CACHE STRING "" FORCE)
set(CMAKE_C_FLAGS ${FLAGS} CACHE STRING "" FORCE)
