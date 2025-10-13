QT += quick qml core

CONFIG += c++17

TARGET = NotificationApp
TEMPLATE = app

# Source files
SOURCES += \
    main.cpp \
    src/notificationmanager.cpp \
    src/androidnotificationhandler.cpp \
    src/iosnotificationhandler.cpp

HEADERS += \
    src/notificationmanager.h \
    src/androidnotificationhandler.h \
    src/iosnotificationhandler.h

# QML files
RESOURCES += qml.qrc

# Platform-specific configuration
android {
    # Ensure Q_OS_ANDROID is defined
    DEFINES += Q_OS_ANDROID
    
    # Android-specific configuration
    # Note: androidextras is not needed in Qt 6, JNI functionality is in core
    
    OTHER_FILES += \
        android/AndroidManifest.xml \
        android/src/com/example/notificationapp/NotificationHelper.java
}

ios {
    SOURCES += src/iosnotificationhandler.mm
    OTHER_FILES += ios/Info.plist
    QMAKE_INFO_PLIST = ios/Info.plist
}

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =