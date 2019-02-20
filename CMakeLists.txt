# @brief: Cmake file for ZJUNlict Crazy
# @author: Wang Yunkai
# @email: w615349118@gmail.com
# @date: 2018.11.28

cmake_minimum_required (VERSION 3.0)

SET(PROJ_NAME "Crazy")
project (${PROJ_NAME})

# do not show the console window
if (WIN32)
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} /SUBSYSTEM:WINDOWS /ENTRY:mainCRTStartup")
endif()

# Find includes in corresponding build directories
set(CMAKE_INCLUDE_CURRENT_DIR ON)

# Instruct CMake to run moc automatically when needed.
set(CMAKE_AUTOMOC ON)

# find Qt5's components that this project need
find_package(Qt5 COMPONENTS QuickControls2)

# find qrc file which include qml files
qt5_add_resources(QML_QRC "Crazy.qrc")

set(RC_FILE Crazy.rc)

# some dirs
set(SRC "${CMAKE_CURRENT_LIST_DIR}/src")
set(OUTPUT "${CMAKE_CURRENT_LIST_DIR}/bin")

# all head files
file(GLOB HEAD	${SRC}/interaction.h
				${SRC}/radiopacket.h
	)

# all source files
file(GLOB SOURCE	${SRC}/main.cpp
					${SRC}/interaction.cpp
					${SRC}/radiopacket.cpp

	)

# include dirs
include_directories(${HEAD})

# need to add qrc file(which include the path of qml files) and rc file(which include the path of icon)
add_executable(${PROJ_NAME} ${SOURCE} ${QML_QRC} ${RC_FILE})

# link Qt5's components that this project need
target_link_libraries(${PROJ_NAME} Qt5::QuickControls2)

install(TARGETS ${PROJ_NAME} RUNTIME DESTINATION ${CMAKE_CURRENT_LIST_DIR}/bin)