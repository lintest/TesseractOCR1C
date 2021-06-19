cmake_minimum_required(VERSION 3.10)

project(TesseractOCR1C)
set(TARGET TesseractOCR1C)

add_library(${TARGET} SHARED
	version.h
	src/AddInNative.cpp
	src/AddInNative.def
	src/AddInNative.h
	src/AddInNative.rc
	src/Tesseract1C.cpp
	src/Tesseract1C.h
	src/stdafx.h)

target_compile_definitions(${TARGET} PRIVATE UNICODE _UNICODE)
target_include_directories(${TARGET} PRIVATE include)
set (LIBRARY_OUTPUT_PATH ${CMAKE_SOURCE_DIR}/bin)
set (EXECUTABLE_OUTPUT_PATH ${LIBRARY_OUTPUT_PATH})
set (CMAKE_COMPILE_PDB_OUTPUT_DIRECTORY ${LIBRARY_OUTPUT_PATH})

if (NOT MSVC)
	message(FATAL_ERROR "Must be compiled with MSVC on Windows")
endif(NOT MSVC)

set(MySuffix1 "Win")
set_target_properties( ${PROJECT_NAME} PROPERTIES
	   PREFIX ""
	   OUTPUT_NAME ${PROJECT_NAME}${MySuffix1}${MySuffix2} 
	   POSITION_INDEPENDENT_CODE ON 
	   CXX_STANDARD_REQUIRED ON
	   CXX_STANDARD 17
   )

set(BUILD_SHARED_LIBS OFF CACHE BOOL "" FORCE)
set(BUILD_CLAR OFF CACHE BOOL "" FORCE)
set(STATIC_CRT ON CACHE BOOL "" FORCE)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

add_definitions(/MT)
set(CMAKE_SUPPRESS_REGENERATION 1)
set(CMAKE_CONFIGURATION_TYPES "Debug;Release" CACHE STRING "" FORCE)
target_compile_definitions(${TARGET} PRIVATE _WINDOWS
		_SILENCE_CXX17_CODECVT_HEADER_DEPRECATION_WARNING)
target_compile_options(${TARGET} PRIVATE /utf-8)

if (MySuffix2 EQUAL "32")
	target_link_directories(${TARGET} PRIVATE "${CMAKE_SOURCE_DIR}/tesseract/Release")
else()
	target_link_directories(${TARGET} PRIVATE "${CMAKE_SOURCE_DIR}/tesseract/x64/Release")
endif()

target_link_libraries(${TARGET} giflib.lib libjpeg.lib liblept.lib libpng.lib  libtesseract.lib libtiff.lib libwebp.lib openjpeg.lib zlib.lib)
target_include_directories(${TARGET} PRIVATE "${CMAKE_SOURCE_DIR}/tesseract/tesseract")
target_include_directories(${TARGET} PRIVATE "${CMAKE_SOURCE_DIR}/tesseract/libtesseract")
target_include_directories(${TARGET} PRIVATE "${CMAKE_SOURCE_DIR}/tesseract/tesseract_4.1/src/arch")
target_include_directories(${TARGET} PRIVATE "${CMAKE_SOURCE_DIR}/tesseract/tesseract_4.1/src/api")
target_include_directories(${TARGET} PRIVATE "${CMAKE_SOURCE_DIR}/tesseract/tesseract_4.1/src/ccmain")
target_include_directories(${TARGET} PRIVATE "${CMAKE_SOURCE_DIR}/tesseract/tesseract_4.1/src/ccstruct")
target_include_directories(${TARGET} PRIVATE "${CMAKE_SOURCE_DIR}/tesseract/tesseract_4.1/src/ccutil")
target_include_directories(${TARGET} PRIVATE "${CMAKE_SOURCE_DIR}/tesseract/tesseract_4.1/src/classify")
target_include_directories(${TARGET} PRIVATE "${CMAKE_SOURCE_DIR}/tesseract/tesseract_4.1/src/cutil")
target_include_directories(${TARGET} PRIVATE "${CMAKE_SOURCE_DIR}/tesseract/tesseract_4.1/src/dict")
target_include_directories(${TARGET} PRIVATE "${CMAKE_SOURCE_DIR}/tesseract/tesseract_4.1/src/lstm")
target_include_directories(${TARGET} PRIVATE "${CMAKE_SOURCE_DIR}/tesseract/tesseract_4.1/src/opencl")
target_include_directories(${TARGET} PRIVATE "${CMAKE_SOURCE_DIR}/tesseract/tesseract_4.1/src/textord")
target_include_directories(${TARGET} PRIVATE "${CMAKE_SOURCE_DIR}/tesseract/tesseract_4.1/src/viewer")
target_include_directories(${TARGET} PRIVATE "${CMAKE_SOURCE_DIR}/tesseract/tesseract_4.1/src/wordrec")
target_include_directories(${TARGET} PRIVATE "${CMAKE_SOURCE_DIR}/tesseract/leptonica/src")
target_include_directories(${TARGET} PRIVATE "${CMAKE_SOURCE_DIR}/tesseract/liblept")
target_include_directories(${TARGET} PRIVATE "${CMAKE_SOURCE_DIR}/tesseract/libtiff")
