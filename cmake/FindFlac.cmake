# - Find Flac library
# Find the native Flac includes and library
# This module defines
#  FLAC_INCLUDE_DIRS, where to find lacfile.h, Set when
#                        FLAC_INCLUDE_DIR is found.
#  FLAC_LIBRARIES, libraries to link against to use Flac.
#  FLAC_ROOT_DIR, The base directory to search for Flac.
#                    This can also be an environment variable.
#  FLAC_FOUND, If false, do not try to use Flac.
#
# also defined, but not for general use are
#  FLAC_LIBRARY, where to find the Flac library.

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

# If FLAC_ROOT_DIR was defined in the environment, use it.
IF(NOT FLAC_ROOT_DIR AND NOT $ENV{FLAC_ROOT_DIR} STREQUAL "")
  SET(FLAC_ROOT_DIR $ENV{FLAC_ROOT_DIR})
ENDIF()

SET(_flac_SEARCH_DIRS
  ${FLAC_ROOT_DIR}
  /usr/local
  /sw # Fink
  /opt/local # DarwinPorts
  /opt/csw # Blastwave
)

FIND_PATH(FLAC_INCLUDE_DIR stream_decoder.h
  HINTS
    ${_flac_SEARCH_DIRS}
  PATH_SUFFIXES
    include FLAC
)

FIND_LIBRARY(FLAC_LIBRARY
  NAMES
    FLAC
  HINTS
    ${_flac_SEARCH_DIRS}
  PATH_SUFFIXES
    lib64 lib
  )

# handle the QUIETLY and REQUIRED arguments and set FLAC_FOUND to TRUE if 
# all listed variables are TRUE
INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(Flac DEFAULT_MSG
    FLAC_LIBRARY FLAC_INCLUDE_DIR)

IF(FLAC_FOUND)
  SET(FLAC_LIBRARIES ${FLAC_LIBRARY})
  SET(FLAC_INCLUDE_DIRS ${FLAC_INCLUDE_DIR})
ENDIF(FLAC_FOUND)

MARK_AS_ADVANCED(
  FLAC_INCLUDE_DIR
  FLAC_LIBRARY
)
