set(INC
	.
	./widgets

	${CMAKE_SOURCE_DIR}/include
)

set(INC_SYS
	../lib-src/FileDialog
	../lib-src/libmad
	../lib-src/portaudio-v19/include
	../lib-src/lib-widget-extra
	${wxWidgets_INCLUDE_DIRS}
)

if(GTK2_FOUND)
	list(APPEND INC_SYS ${GTK2_INCLUDE_DIRS})
endif()

# set(SRC
# )
FILE(GLOB SRC
	*.cpp
	prefs/*.cpp
	effects/*.cpp
	blockfile/*.cpp
	commands/*.cpp
	export/*.cpp
	ondemand/*.cpp
	import/*.cpp
	toolbars/*.cpp
	widgets/*.cpp
	xml/*.cpp
)

# infact nothing to compile!
# audacity_add_lib(bf_intern_ctr "${SRC}" "${INC}" "${INC_SYS}")

audacity_include_dirs(${INC})
audacity_include_dirs_sys(${INC_SYS})

add_executable(audacity ${SRC})

get_property(AUDACITY_LINK_LIBS GLOBAL PROPERTY AUDACITY_LINK_LIBS)

# message(FATAL_ERROR "Helloo: ${GTK2_LIBRARIES}")

target_link_libraries(audacity
		${CMAKE_DL_LIBS}
		${wxWidgets_LIBRARIES}
		${EXPAT_LIBRARIES}
		${SNDFILE_LIBRARIES}
		${FLACXX_LIBRARIES}
		${AUDACITY_LINK_LIBS}
		${PORTAUDIO_LIBRARIES}
		${GTK2_GLIB_LIBRARY}
		${GTK2_LIBRARIES}
		)
