cmake_minimum_required(VERSION 3.16)

project(NotificationApp VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.8 REQUIRED COMPONENTS Core Quick)

qt_standard_project_setup()

qt_add_executable(NotificationApp
    main.cpp
    src/notificationmanager.cpp
    src/notificationmanager.h
)

# Platform-specific sources
if(ANDROID)
    target_sources(NotificationApp PRIVATE
        src/androidnotificationhandler.cpp
        src/androidnotificationhandler.h
    )
endif()

if(IOS)
    target_sources(NotificationApp PRIVATE
        src/iosnotificationhandler.mm
        src/iosnotificationhandler.h
    )
endif()

qt_add_qml_module(NotificationApp
    URI NotificationApp
    VERSION 1.0
    QML_FILES
        Main.qml
)

target_link_libraries(NotificationApp
    Qt6::Core
    Qt6::Quick
)

# Platform-specific settings
if(ANDROID)
    set_target_properties(NotificationApp PROPERTIES
        QT_ANDROID_PACKAGE_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/android
    )
endif()

if(IOS)
    set_target_properties(NotificationApp PROPERTIES
        MACOSX_BUNDLE TRUE
        MACOSX_BUNDLE_INFO_PLIST ${CMAKE_CURRENT_SOURCE_DIR}/ios/Info.plist
    )
endif()