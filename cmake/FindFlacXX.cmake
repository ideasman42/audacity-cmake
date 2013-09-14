# - Find FlacXX library
# Find the native FlacXX includes and library
# This module defines
#  FLACXX_INCLUDE_DIRS, where to find lacfile.h, Set when
#                        FLACXX_INCLUDE_DIR is found.
#  FLACXX_LIBRARIES, libraries to link against to use FlacXX.
#  FLACXX_ROOT_DIR, The base directory to search for FlacXX.
#                    This can also be an environment variable.
#  FLACXX_FOUND, If false, do not try to use Flac.
#
# also defined, but not for general use are
#  FLACXX_LIBRARY, where to find the FlacXX library.

#=============================================================================
# Copyright 2011 Blender Foundation.
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file Copyright.txt for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================

# If FLACXX_ROOT_DIR was defined in the environment, use it.
IF(NOT FLACXX_ROOT_DIR AND NOT $ENV{FLACXX_ROOT_DIR} STREQUAL "")
  SET(FLACXX_ROOT_DIR $ENV{FLACXX_ROOT_DIR})
ENDIF()

SET(_flacxx_SEARCH_DIRS
  ${FLACXX_ROOT_DIR}
  /usr/local
  /sw # Fink
  /opt/local # DarwinPorts
  /opt/csw # Blastwave
)

FIND_PATH(FLACXX_INCLUDE_DIR stream_decoder.h
  HINTS
    ${_flacxx_SEARCH_DIRS}
  PATH_SUFFIXES
    include FLAC
)

FIND_LIBRARY(FLACXX_LIBRARY
  NAMES
    FLAC++
  HINTS
    ${_flacxx_SEARCH_DIRS}
  PATH_SUFFIXES
    lib64 lib
  )

# handle the QUIETLY and REQUIRED arguments and set FLACXX_FOUND to TRUE if 
# all listed variables are TRUE
INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(FlacXX DEFAULT_MSG
    FLACXX_LIBRARY FLACXX_INCLUDE_DIR)

IF(FLACXX_FOUND)
  SET(FLACXX_LIBRARIES ${FLACXX_LIBRARY})
  SET(FLACXX_INCLUDE_DIRS ${FLACXX_INCLUDE_DIR})
ENDIF(FLACXX_FOUND)

MARK_AS_ADVANCED(
  FLACXX_INCLUDE_DIR
  FLACXX_LIBRARY
)
