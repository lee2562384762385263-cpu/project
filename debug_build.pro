QT += quick qml core

CONFIG += c++17 debug

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

# Debug: Show what platform we're building for
message("Building for platform: $$QMAKESPEC")

# Platform-specific sources
android {
    message("Android build detected - adding Android sources")
    SOURCES += src/androidnotificationhandler.cpp
    HEADERS += src/androidnotificationhandler.h
    
    # Ensure Q_OS_ANDROID is defined
    DEFINES += Q_OS_ANDROID
    message("Added Q_OS_ANDROID define")
    
    OTHER_FILES += \
        android/AndroidManifest.xml \
        android/src/com/example/notificationapp/NotificationHelper.java
}

ios {
    message("iOS build detected - adding iOS sources")
    SOURCES += src/iosnotificationhandler.mm
    HEADERS += src/iosnotificationhandler.h
    
    OTHER_FILES += ios/Info.plist
    QMAKE_INFO_PLIST = ios/Info.plist
}

!android:!ios {
    message("Desktop build detected")
}

# Show all sources being compiled
message("Sources: $$SOURCES")
message("Headers: $$HEADERS")
message("Defines: $$DEFINES")