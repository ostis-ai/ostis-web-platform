cmake_minimum_required(VERSION 2.8.12)
cmake_policy(SET CMP0048 NEW)
project(ostis-web-platform)
set(PLATFORM_PATH ${CMAKE_CURRENT_LIST_DIR})

set(SC_MACHINE_PATH "${CMAKE_CURRENT_LIST_DIR}/sc-machine")
include("${SC_MACHINE_PATH}/CMakeLists.txt")
include(${SC_MACHINE_PATH}/macro/macros.cmake)

project_version(OSTIS_WEB_PLATFORM "0.7.0")

# platform doesn't support multi-extensions. Have to put project binaries to sc-machine extensions
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${SC_EXTENSIONS_DIRECTORY})

# for multi-config builds (e.g. msvc)
foreach(OUTPUT_CONFIG ${CMAKE_CONFIGURATION_TYPES})
	string(TOUPPER ${OUTPUT_CONFIG} OUTPUT_CONFIG)
	set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_${OUTPUT_CONFIG} ${SC_EXTENSIONS_DIRECTORY})
	set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_${OUTPUT_CONFIG} ${SC_EXTENSIONS_DIRECTORY})
endforeach(OUTPUT_CONFIG CMAKE_CONFIGURATION_TYPES)

option(SCL_MACHINE_BUILD "Flag to build scl-machine" OFF)

if(${SCL_MACHINE_BUILD})
	set(SCL_MACHINE_PATH "${CMAKE_CURRENT_LIST_DIR}/scl-machine")
	add_subdirectory(${SCL_MACHINE_PATH})
endif()

