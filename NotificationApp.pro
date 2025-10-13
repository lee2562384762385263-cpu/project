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
    # Ensure Q_OS_IOS is defined
    DEFINES += Q_OS_IOS
    
    # Add Objective-C++ source file
    SOURCES += src/iosnotificationhandler.mm
    
    # iOS frameworks required for notifications
    LIBS += -framework Foundation
    LIBS += -framework UIKit
    LIBS += -framework UserNotifications
    
    # iOS deployment target (minimum iOS 14.0 for modern notification APIs)
    QMAKE_IOS_DEPLOYMENT_TARGET = 14.0
    
    # Info.plist configuration
    OTHER_FILES += ios/Info.plist
    QMAKE_INFO_PLIST = ios/Info.plist
    
    # Enable Objective-C++ compilation
    CONFIG += objective_c
}

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =