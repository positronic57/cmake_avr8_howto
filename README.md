## Cross-compiling for AVR8 with CMake and AVR-GCC/Microchip XC8

Cross-compiling C/C++ project for Microchip AVR8 platform with CMake requires three ingredients:
 - tool chain for the target platform installed on the build host. In this case the platform is 8-bit Microchip AVR micro-controllers and the tools are: avr-gcc or Microchip XC8 compiler. Both compilers are available on Linux. The build system runs Ubuntu, but it can be any other Linux system.
 - regular CMake configuration file *CMakeLists.txt*, that describes the build of the C/C++ project code
 - *CMake "tool chain file".*

### Toolchain

On Ubuntu as a build host, the tool chain for AVR8 is available in the standard repositories via: avr-libc, binutils-avr and gcc-avr packages which can be installed with:
```
#sudo apt install avr-libc binutils-avr gcc-avr
```
Microchip XC8 compiler is available for download from Microchip web site.

### CMake Toolchian File

Tool chain file tells CMake everything it needs to know about the target platform [^1]. It describes the target system and defines the C and C++ compiler from the target tool chain.
In this example, the tool chain files are called:
 - avr_gcc_toolchain.cmake for avr-gcc;
 - microchip_xc8_toolchain.cmake for Microchip XC8.

AVR8 target does not run any operating system and does not support loading shared objects at run time. CMake will be aware of this fact by setting CMAKE_SYSTEM_NAME variable to **_Generic_**[^1] in the tool chain file. 
```
set(CMAKE_SYSTEM_NAME Generic)
```
CMake variables from the toolchain file: CMAKE_C_COMPILER и CMAKE_CXX_COMPILER define the C/C++ compilers. Their values are the absolute paths of the compiler executables.

In case of GNU C/C++ compilers  the variables are defined as:
```
set(CMAKE_C_COMPILER /usr/bin/avr-gcc)
set(CMAKE_CXX_COMPILER /usr/bin/avr-g++)
```
or for Microchip XC8 case:
```
set(CMAKE_C_COMPILER  /opt/microchip/xc8/v2.40/bin/xc8-cc)
set(CMAKE_CXX_COMPILER  /opt/microchip/xc8/v2.40/bin/xc8-cc)
```

AVR8 requires some special compiler flags that are not the same as a default flags for the native C/C++ compiler on the host system. The flags are set with the following configuration directives:
```
#Define the compiler flags for AVR8 platform
set(FLAGS "-Wall -Os -fpack-struct -fshort-enums -ffunction-sections -fdata-sections -std=gnu99 -funsigned-char -funsigned-bitfields")

#Clear all the default flags set by CMake
unset(CMAKE_C_FLAGS CACHE)
unset(CMAKE_CXX_FLAGS CACHE)

#Apply the wanted flags for AVR8
set(CMAKE_CXX_FLAGS ${FLAGS} CACHE STRING "" FORCE)
set(CMAKE_C_FLAGS ${FLAGS} CACHE STRING "" FORCE)
```
Microchip XC8 compiler will report an error when the MCU type is not given as one of the compiler arguments. In order to verify the compiler, CMake will try to start the compiler form the toolchain file. Without MCU type provided in the toolchain file this test will fail and CMake will report an error. To prevent this, the MCU model is defined in the toolchain file as AVR8_MCU variable.

### CMakeLists.txt File For Building The Project

This is a standard CMake configuration file that tells CMake how to build the project. The content is no different that any other _CMakeLists.txt_ file for building C/C++ project. The provided CMakeLists.txt  supports  both toolchain files for GNU avr-gcc/g++ and Mcirochip XC8 compilers.
Additional example(s) for CMakeLists.txt can be found in _examples_ folder of this repository:
- [CMakeLists_static_lib.txt](examples/CMakeLists_static_lib.txt) represents CMakeLists.txt for building a static library for AVR8 MCU;
- [CMakeLists_link_with_static_lib.txt](examples/CMakeLists_link_with_static_lib.txt) is an example of linking a project to a static library.


#### Firmware File in Intel HEX format

A post build step is defined in _CMakeLists.txt_ file which will generate an object file in Intel HEX format from the resulting ELF file created by CMake. This is the firmware file that can be flashed on the target AVR MCU using avrdude or any other programming tool for AVR8 MCUs.
```
add_custom_command(
    TARGET ${PROJECT_NAME}.elf
    POST_BUILD
    COMMAND avr-objcopy -j .text -j .data -O ihex ${PROJECT_NAME}.elf ${PROJECT_NAME}.hex 
)
```
Microchip XC8 is distributed with  its own copy of avr-objcopy tool and its definition is part of microchip_xc8_toolchain.cmake as well.


#### Additional Build Arguments

There are two arguments defined in CMakeLists.txt:
 - __MCU__ - defines the value of the __-mmcu__ flag for avr-gcc compiler. It specifies the MCU type. If not  given, "atmega32" will be used set by default ([the complete list of supported -mmcu values](https://onlinedocs.microchip.com/pr/GUID-317042D4-BCCE-4065-BB05-AC4312DBC2C4-en-US-2/index.html)). This argument is ignored for Microchip XC8 compiler. The MCU model is defined within the toolchain file with the help of the AVR8_MCU variable.
  - __CPU_FREQ__ - the frequency of the MCU system clock. Set to 16Mhz by default. It is required for some standard library functions like time delays for example.
  
## Building The Project with CMake

Create a build folder within the project folder and change to the new folder:
```
#mkdir build && cd build
```
Generate the build instructions with:
```
#cmake -DCMAKE_TOOLCHAIN_FILE=../avr_gcc_toolchain.cmake -DMCU=attiny2313 -DCPU_FREQ=20000000L ..
```
for GNU avr-gcc compiler, or:
```
#cmake -DCMAKE_TOOLCHAIN_FILE=../microchip_xc8_toolchain.cmake -DCPU_FREQ=20000000L ..
```
for Microchip XC8 compiler, where the MCU model is defined in the microchip_xc8_toolchain file.

Start the build with:
```
#make
```
This will create two object files in the build folder: .elf and the firmware file .hex.

## Translations
- [Macedonian version of this text](translations/README_mk.md)

## WARNING:
The source is provided as is without any warranty. Use it on your own risk!
The author does not take any responsibility for the damage caused while using this software.

## DISCLAIMER: 
The code is a result of a hobby work and the author is not affiliated with any of the hardware/components/boards/tools manufacturers/creators mentioned in the code, documentation or the description of this project. All trademarks are the property of the respective owners.

[^1]: [Cross Compiling With CMake](https://cmake.org/cmake/help/book/mastering-cmake/chapter/Cross%20Compiling%20With%20CMake.html)
