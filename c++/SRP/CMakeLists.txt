#****************************This is Project Info****************************
PROJECT(DOA)
CMAKE_MINIMUM_REQUIRED(VERSION 2.8)


IF (WIN32)
	MESSAGE(STATUS "Now is windows")

#****************************This is Include File/Directories****************************
INCLUDE_DIRECTORIES( ${CMAKE_CURRENT_SOURCE_DIR}/)
INCLUDE_DIRECTORIES(../eigen)


#****************************This is Source File/Directories****************************
#FILE(GLOB OpenMeta_SRCS "../../../OpenMeta/*.cpp")
#AUX_SOURCE_DIRECTORY(./ DIR_SRCS)


SET(DIR_SRCS ${eye_SRCS} 
             ${face_calib_SRCS}
 			 ${face_detect_SRCS}
			 ${face_recognition_SRCS}
			 ${human_detect_SRCS}
			 ${id_SRCS}
			 ${intrusion_SRCS}
			 ${sleep_monitor_SRCS})

#****************************This is Library Directories****************************
LINK_DIRECTORIES(lib/static)
# LINK_DIRECTORIES(../../../Library/ISVP/lib)

# #****************************This is 3Party Library****************************
# LINK_LIBRARIES(SKYHALSDK OpenAPISDK libeOkao.a libeOkaoCo.a libeOkaoDt.a libeOkaoFr.a libeOkaoPt.a libeOmcvBd.a avxcompat avxlog pthread imp alog rt dl)

#****************************This is Output Directory****************************
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/bin)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/bin)

# #****************************This is Output Library****************************
#ADD_LIBRARY(kiss_fft SHARED ${DIR_SRCS} kiss_fft.c)
#TARGET_LINK_LIBRARIES(VA_Lib libopencv_imgproc.a libopencv_core.a libopencv_highgui.a VA_Lib IlmImf libjasper libjpeg libpng libtiff zlib)

add_executable(DOA_SRP main.cpp wave.c DelaySum.cpp kiss_fftr.c kiss_fft.c File.cpp Sort.cpp)
TARGET_LINK_LIBRARIES(DOA_SRP)

ELSEIF (APPLE)
	MESSAGE(STATUS "Now is Apple systens.")
ELSEIF (UNIX)
	MESSAGE(STATUS "Now is UNIX-like OS's.")
		#****************************This is Compile Flag****************************
 if(DEBUG)
 message( STATUS "==============================debug==============================" )
 ADD_DEFINITIONS(-g)
 ADD_DEFINITIONS(-D AVX_DEBUG_LEVEL=AVX_DEBUG_DEBUG)
 SET(CMAKE_C_FLAGS "-lm")
 SET(CMAKE_CXX_FLAGS "-lm")
else(DEBUG)
 message( STATUS "==============================release==============================" )
if(WIN32)
else()
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
 endif()



#****************************This is Compiling environment Flag****************************
#SET(CMAKE_SYSTEM_NAME linux)
#SET(TOOLCHAIN_DIR "/opt/mips-gcc472-glibc216-64bit")
#SET(CMAKE_FIND_ROOT_PATH ${TOOLCHAIN_DIR})
#SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
#SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
#SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
#SET(CMAKE_C_COMPILER ${TOOLCHAIN_DIR}/bin/mips-linux-uclibc-gnu-gcc)
#SET(CMAKE_CXX_COMPILER ${TOOLCHAIN_DIR}/bin/mips-linux-uclibc-gnu-g++)

#****************************This is Include File/Directories****************************
INCLUDE_DIRECTORIES( ${CMAKE_CURRENT_SOURCE_DIR}/)
INCLUDE_DIRECTORIES(../eigen)


#****************************This is Source File/Directories****************************
#FILE(GLOB OpenMeta_SRCS "../../../OpenMeta/*.cpp")
#AUX_SOURCE_DIRECTORY(./ DIR_SRCS)


SET(DIR_SRCS ${eye_SRCS} 
             ${face_calib_SRCS}
 			 ${face_detect_SRCS}
			 ${face_recognition_SRCS}
			 ${human_detect_SRCS}
			 ${id_SRCS}
			 ${intrusion_SRCS}
			 ${sleep_monitor_SRCS})

#****************************This is Library Directories****************************
LINK_DIRECTORIES(lib/static)
# LINK_DIRECTORIES(../../../Library/ISVP/lib)

# #****************************This is 3Party Library****************************
# LINK_LIBRARIES(SKYHALSDK OpenAPISDK libeOkao.a libeOkaoCo.a libeOkaoDt.a libeOkaoFr.a libeOkaoPt.a libeOmcvBd.a avxcompat avxlog pthread imp alog rt dl)

#****************************This is Output Directory****************************
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/bin)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/bin)

# #****************************This is Output Library****************************
#ADD_LIBRARY(kiss_fft SHARED ${DIR_SRCS} kiss_fft.c)
#TARGET_LINK_LIBRARIES(VA_Lib libopencv_imgproc.a libopencv_core.a libopencv_highgui.a VA_Lib IlmImf libjasper libjpeg libpng libtiff zlib)

add_executable(DOA_SRP main.cpp wave.c DelaySum.cpp kiss_fftr.c kiss_fft.c File.cpp Sort.cpp)
TARGET_LINK_LIBRARIES(DOA_SRP m pthread)

ENDIF()
