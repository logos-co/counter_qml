cmake_minimum_required(VERSION 3.16)
project(CounterQmlPlugin VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_add_library(counter_qml SHARED)

qt_add_qml_module(counter_qml
    URI "counter_qml"
    VERSION 1.0
    QML_FILES Main.qml
    PLUGIN_TARGET counter_qml
)

set_target_properties(counter_qml PROPERTIES
    PREFIX ""
    OUTPUT_NAME "counter_qml"
    LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/modules"
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/modules"
)

if(APPLE)
    set_target_properties(counter_qml PROPERTIES
        INSTALL_RPATH "@loader_path"
        INSTALL_NAME_DIR "@rpath"
        BUILD_WITH_INSTALL_NAME_DIR TRUE
    )
else()
    set_target_properties(counter_qml PROPERTIES
        INSTALL_RPATH "$ORIGIN"
        INSTALL_RPATH_USE_LINK_PATH FALSE
    )
endif()

install(TARGETS counter_qml
    LIBRARY DESTINATION lib
)
