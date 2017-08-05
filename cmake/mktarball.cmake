include ( "${BINARY_DIR}/config/CPackOptions.cmake" )

set ( FNAME "${TARBALL_FILE_NAME}" )
set ( PACKDIR "${BINARY_DIR}/sources/${FNAME}" )

file (COPY ${SOURCE_DIR}/ DESTINATION ${PACKDIR}
		PATTERN "cmake-*" EXCLUDE
		PATTERN "build-*" EXCLUDE
		PATTERN "build" EXCLUDE
		PATTERN ".*" EXCLUDE
		)
configure_file ("${BINARY_DIR}/config/gen_sphinxversion.h"
		"${PACKDIR}/src/sphinxversion.h" COPYONLY )

macro (packbis src)
	if ( USE_BISON )
		configure_file ( "${BINARY_DIR}/config/bis${src}.c"
				"${PACKDIR}/src/yy${src}.c" COPYONLY )
		configure_file ( "${BINARY_DIR}/config/bis${src}.h"
				"${PACKDIR}/src/yy${src}.h" COPYONLY )
	endif()
endmacro()

macro( packflex src )
	if ( USE_FLEX )
		configure_file ( "${BINARY_DIR}/config/flex${src}.c"
				"${PACKDIR}/src/ll${src}.c" COPYONLY )
	endif ()
endmacro()

packbis ( sphinxexpr )
packbis ( sphinxjson )
packflex ( sphinxjson )
packbis ( sphinxql )
packflex ( sphinxql )
packbis ( sphinxquery )
packbis ( sphinxselect )

execute_process (
		COMMAND "${CMAKE_COMMAND}" -E tar cfz "${BINARY_DIR}/${FNAME}.tar.gz" "${FNAME}"
		WORKING_DIRECTORY "${BINARY_DIR}/sources" )
