QT += quick qml core

CONFIG += c++17

TARGET = NotificationApp
TEMPLATE = app

# Source files
SOURCES += \
    main.cpp \
    src/notificationmanager.cpp

HEADERS += \
    src/notificationmanager.h

# QML files
RESOURCES += qml.qrc

# Platform-specific sources
android {
    SOURCES += src/androidnotificationhandler.cpp
    HEADERS += src/androidnotificationhandler.h
    
    OTHER_FILES += \
        android/AndroidManifest.xml \
        android/src/org/qtproject/example/notification/NotificationHelper.java
}

ios {
    SOURCES += src/iosnotificationhandler.mm
    HEADERS += src/iosnotificationhandler.h
    
    OTHER_FILES += ios/Info.plist
    QMAKE_INFO_PLIST = ios/Info.plist
}

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =