
cmake_minimum_required(VERSION 2.8)

if(NOT EXECUTABLE_OUTPUT_PATH)
	set(FIRST_RUN "TRUE")
endif()


# avoid having empty buildtype
set(CMAKE_BUILD_TYPE_INIT "Release")

set(EXECUTABLE_OUTPUT_PATH ${CMAKE_BINARY_DIR}/bin CACHE INTERNAL "" FORCE)

set(AUDACITY_LINK_LIBS)

#-----------------------------------------------------------------------------
# Set policy

# see "cmake --help-policy CMP0003"
# So library linking is more sane
cmake_policy(SET CMP0003 NEW)

# So build strings are automatically quoted
cmake_policy(SET CMP0005 NEW)

# So syntax problems are errors
cmake_policy(SET CMP0010 NEW)

# Input directories must have CMakeLists.txt
cmake_policy(SET CMP0014 NEW)


#-----------------------------------------------------------------------------
# Macros

# Nicer makefiles with -I/1/foo/ instead of -I/1/2/3/../../foo/
# use it instead of include_directories()
macro(audacity_include_dirs
	includes)
	set(_ALL_INCS "")
	foreach(_INC ${ARGV})
		get_filename_component(_ABS_INC ${_INC} ABSOLUTE)
		list(APPEND _ALL_INCS ${_ABS_INC})
		# for checking for invalid includes, disable for regular use
		##if(NOT EXISTS "${_ABS_INC}/")
		##	message(FATAL_ERROR "Include not found: ${_ABS_INC}/")
		##endif()
	endforeach()
	include_directories(${_ALL_INCS})
	unset(_INC)
	unset(_ABS_INC)
	unset(_ALL_INCS)
endmacro()

macro(audacity_include_dirs_sys
	includes)
	set(_ALL_INCS "")
	foreach(_INC ${ARGV})
		get_filename_component(_ABS_INC ${_INC} ABSOLUTE)
		list(APPEND _ALL_INCS ${_ABS_INC})
		##if(NOT EXISTS "${_ABS_INC}/")
		##	message(FATAL_ERROR "Include not found: ${_ABS_INC}/")
		##endif()
	endforeach()
	include_directories(SYSTEM ${_ALL_INCS})
	unset(_INC)
	unset(_ABS_INC)
	unset(_ALL_INCS)
endmacro()

macro(audacity_source_group
	sources)

	# Group by location on disk
	source_group("Source Files" FILES CMakeLists.txt)

	foreach(_SRC ${sources})
		get_filename_component(_SRC_EXT ${_SRC} EXT)
		if((${_SRC_EXT} MATCHES ".h") OR
		   (${_SRC_EXT} MATCHES ".hpp") OR
		   (${_SRC_EXT} MATCHES ".hh"))
			source_group("Header Files" FILES ${_SRC})
		else()
			source_group("Source Files" FILES ${_SRC})
		endif()
	endforeach()

	unset(_SRC)
	unset(_SRC_EXT)
endmacro()


# only MSVC uses SOURCE_GROUP
macro(audacity_add_lib_nolist
	name
	sources
	includes
	includes_sys)

	# message(STATUS "Configuring library ${name}")

	# include_directories(${includes})
	# include_directories(SYSTEM ${includes_sys})
	audacity_include_dirs("${includes}")
	audacity_include_dirs_sys("${includes_sys}")

	add_library(${name} ${sources})

	# works fine without having the includes
	# listed is helpful for IDE's (QtCreator/MSVC)
	audacity_source_group("${sources}")

endmacro()


macro(audacity_add_lib
	name
	sources
	includes
	includes_sys)

	audacity_add_lib_nolist(${name} "${sources}" "${includes}" "${includes_sys}")

	set_property(GLOBAL APPEND PROPERTY AUDACITY_LINK_LIBS ${name})
endmacro()


#-----------------------------------------------------------------------------
# Initialize project.

project(Audacity)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

# XXX, 
add_definitions(-DAUDACITY_DLL_API=)
add_definitions(-DAUDACITY_NAME="audacity")
add_definitions(-DLIBDIR="/usr/lib")  # XXX ?
add_definitions(-DHAVE_GTK)
add_definitions(-DUSE_LIBRESAMPLE) # XXX optional
add_definitions(-DINSTALL_PREFIX="${CMAKE_INSTALL_PREFIX}")


#-----------------------------------------------------------------------------
# Libraries

find_package(wxWidgets REQUIRED html adv core base net aui xrc qa richtext )
if(wxWidgets_FOUND)
	include(${wxWidgets_USE_FILE})
	# and for each of your dependent executable/library targets:
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${wxWidgets_CXX_FLAGS}")
	# note: 'wxWidgets_DEFINITIONS_DEBUG'
	#       should be usable but for some reason its not set.
	# set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -D_DEBUG -D__WXDEBUG__")
else()
	message(FATAL_ERROR "wxWidgets NOT FOUND!")
endif()

# XXX, linux only

if(UNIX AND NOT APPLE)
	find_package(GTK2 2.6 REQUIRED gtk)
	add_definitions(-D__WXGTK__)
elseif(WINDOWS)
	# pass
endif()

find_package(EXPAT REQUIRED)

find_package(SndFile)
find_package(Flac)
find_package(FlacXX)

# TODO, find package
find_library(PORTAUDIO_LIBRARY NAMES portaudio)
set(PORTAUDIO_LIBRARIES "${PORTAUDIO_LIBRARY}")

# find_library(RESAMPLE_LIBRARY NAMES samplerate)
# set(SAMPLERATE_LIBRARIES "${SAMPLERATE_LIBRARY}")

#-----------------------------------------------------------------------------
# Internal Libraries



# ----
# FileDialog

FILE(GLOB SRC
	lib-src/FileDialog/*.cpp
	lib-src/FileDialog/gtk/*.cpp
	)
set(INC
	lib-src/FileDialog
)
set(INC_SYS
)

if(GTK2_FOUND)
	list(APPEND INC_SYS ${GTK2_INCLUDE_DIRS})
endif()

audacity_add_lib(lib_src_file_dialog "${SRC}" "${INC}" "${INC_SYS}")

unset(SRC)
unset(INC)
unset(INC_SYS)




# ----
# lib-widget-extra

FILE(GLOB SRC
	lib-src/lib-widget-extra/*.cpp
	)
set(INC
	lib-src/lib-widget-extra
)
set(INC_SYS
)

audacity_add_lib(lib_src_lib_widget_extra "${SRC}" "${INC}" "${INC_SYS}")

unset(SRC)
unset(INC)
unset(INC_SYS)





# ----
# resample

FILE(GLOB SRC
	lib-src/libresample/src/*.c
	)
set(INC
	lib-src/libresample/include
)
set(INC_SYS
)

audacity_add_lib(lib_src_resample "${SRC}" "${INC}" "${INC_SYS}")

unset(SRC)
unset(INC)
unset(INC_SYS)





#-----------------------------------------------------------------------------
# Audacity Application

add_subdirectory(src)
