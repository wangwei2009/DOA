#****************************This is Project Info****************************
PROJECT(DOA)
CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

#****************************This is Include File/Directories****************************
INCLUDE_DIRECTORIES( ${CMAKE_CURRENT_SOURCE_DIR}/)


#****************************This is Output Directory****************************
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/bin)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/bin)


if (WIN32)

     MESSAGE(STATUS "Now is windows")

    add_executable(DOA_SRP
        main_win32.cpp
        wave.c
        DelaySum.cpp
        kiss_fftr.c
        kiss_fft.c
        File.cpp
        Sort.cpp)
elseif (UNIX)
     MESSAGE(STATUS "Now is UNIX-like OS's.")
                    #****************************This is Compile Flag****************************
     if(DEBUG)
         message( STATUS "==============================debug==============================" )
         ADD_DEFINITIONS(-g)
         ADD_DEFINITIONS(-D AVX_DEBUG_LEVEL=AVX_DEBUG_DEBUG)
         SET(CMAKE_C_FLAGS "-lm")
         SET(CMAKE_CXX_FLAGS "-lm")
     else()
         message( STATUS "==============================release==============================" )

         ADD_DEFINITIONS(-O2)
         ADD_DEFINITIONS(-D AVX_DEBUG_LEVEL=AVX_DEBUG_INFO)
         SET(CMAKE_C_FLAGS "-lm")
         SET(CMAKE_CXX_FLAGS "-lm")

         ADD_DEFINITIONS("-Wall")
         ADD_DEFINITIONS("-fPIC")
         ADD_DEFINITIONS("-Wl,-Bsymbolic -lm")
         ADD_DEFINITIONS("-std=c++11")
         SET(CMAKE_CXX_FLAGS "-Wall -fPIC -s  -std=c++11 -Wl,-Bsymbolic -lm -lpthread -D__STDC_CONSTANT_MACROS -D__STDC_LIMIT_MACROS")
         SET(CMAKE_C_FLAGS "-Wall -fPIC -s -std=c99 -Wl,-Bsymbolic -lm -lpthread -D__STDC_CONSTANT_MACROS -D__STDC_LIMIT_MACROS")
    endif()
        add_executable(DOA_SRP main_linux.cpp wave.c DelaySum.cpp kiss_fftr.c kiss_fft.c File.cpp Sort.cpp)
        TARGET_LINK_LIBRARIES(DOA_SRP m pthread)

endif()
