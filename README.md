## Cross-compiling for AVR8 with CMake and AVR-GCC

Cross-compiling C/C++ project for Microchip AVR8 platform with CMake and avr-gcc requires three ingredients:
 - tool chain for the target platform installed on the build host. In this case the platform is 8-bit Microchip AVR micro-controllers and the the tool chain is avr-gcc tools and avr-libc. The build system runs Ubuntu, but it can be any other Linux system. 
 - regular CMake configuration file *CMakeLists.txt*, that describes the build of the C/C++ project code
 - *CMake "tool chain file".*

### Toolchain

On Ubuntu as a build host, the tool chain for AVR8 is available in the standard repositories via: avr-libc, binutils-avr and gcc-avr packages:
```
#sudo apt install avr-libc binutils-avr gcc-avr
```

### CMake Toolchian File

Tool chain file tells CMake everything it needs to know about the target platform [^1]. It describes the target system and defines the C and C++ compiler from the target tool chain.
In this example, the tool chain file is called: avr8_toolchain.cmake
AVR8 target does not run any operating system and does not support loading shared objects at run time. CMake will be aware of this fact by setting CMAKE_SYSTEM_NAME variable to **_Generic_**[^1] in the tool chain file. 
```
set(CMAKE_SYSTEM_NAME Generic)
```
The next important configuration entries define the C/C++ compiler. avr-gcc and avr-g++ will be set as C and C++ compilers:
```
set(CMAKE_C_COMPILER /usr/bin/avr-gcc)
set(CMAKE_CXX_COMPILER /usr/bin/avr-g++)
```
AVR8 requires some special compiler flags that are not the same as a default flags for gcc on the host system. The flags are set with the following configuration directives:
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
### CMakeLists.txt File For Building The Project

This is a standard CMake configuration file that tells CMake how to build the project. The content is no different that any other _CMakeLists.txt_ file for building C/C++project.
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
#### Additional Build Arguments

There are two arguments defined in CMakeLists.txt:
 - __MCU__ - defines the value of the __-mmcu__ flag for avr-gcc compiler. It specifies the MCU type. If not  given, "atmega32" will be used set by default ([the complete list of supported -mmcu values](https://onlinedocs.microchip.com/pr/GUID-317042D4-BCCE-4065-BB05-AC4312DBC2C4-en-US-2/index.html)).
 - __CPU_FREQ__ - the frequency of the MCU system clock. Set to 16Mhz by default. It is required for some avr-libc like time delays for example.
  
## Building The Project with CMake

Create a build folder within the project folder and change to the new folder:
```
#mkdir build && cd build
```
Generate the build instructions with:
```
#cmake -DCMAKE_TOOLCHAIN_FILE=../avr8_toolchain.cmake -DMCU=attiny2313 -DCPU_FREQ=20000000L ..
```
Start the build:
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
